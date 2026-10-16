//! Ownership of three images, including asynchronous and out-of-order completion callbacks.

pub(super) const SLOTS: usize = 3;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(super) struct Key {
    pub index: usize,
    pub serial: u64,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum Slot {
    Free,
    Acquired(u64),
    Pending(u64),
    Ready(u64),
    Reading(u64),
}

#[derive(Debug)]
pub(super) struct Pool {
    slots: [Slot; SLOTS],
    next: u64,
    newest: u64,
    ready: Option<Key>,
    pub stopped: bool,
}

impl Default for Pool {
    fn default() -> Self {
        Self {
            slots: [Slot::Free; SLOTS],
            next: 0,
            newest: 0,
            ready: None,
            stopped: false,
        }
    }
}

impl Pool {
    /// Reserves an unused image; a stopped or busy pool admits no rendering.
    pub fn acquire(&mut self) -> Option<Key> {
        if self.stopped {
            return None;
        }
        let index = self.slots.iter().position(|slot| *slot == Slot::Free)?;
        self.next = self.next.checked_add(1)?;
        self.slots[index] = Slot::Acquired(self.next);
        Some(Key {
            index,
            serial: self.next,
        })
    }

    /// Transfers the acquired image to its producer-completion callback.
    pub fn submit(&mut self, key: Key) -> bool {
        if self.slots[key.index] != Slot::Acquired(key.serial) {
            return false;
        }
        if self.stopped {
            self.slots[key.index] = Slot::Free;
            return false;
        }
        self.slots[key.index] = Slot::Pending(key.serial);
        true
    }

    /// Publishes only the newest successfully completed image, freeing superseded work.
    pub fn complete(&mut self, key: Key, success: bool) {
        if self.slots[key.index] != Slot::Pending(key.serial) {
            return;
        }
        if self.stopped || !success || key.serial <= self.newest {
            self.slots[key.index] = Slot::Free;
            return;
        }
        self.newest = key.serial;
        if let Some(previous) = self.ready.replace(key) {
            self.slots[previous.index] = Slot::Free;
        }
        self.slots[key.index] = Slot::Ready(key.serial);
    }

    /// Reserves the latest completed image until its presentation copy completes.
    pub fn take(&mut self) -> Option<Key> {
        let key = self.ready.take()?;
        self.slots[key.index] = Slot::Reading(key.serial);
        Some(key)
    }

    /// Releases an unused acquisition or a completed copy, ignoring stale callbacks.
    pub fn release(&mut self, key: Key) {
        if matches!(self.slots[key.index], Slot::Acquired(serial) | Slot::Reading(serial) if serial == key.serial)
        {
            self.slots[key.index] = Slot::Free;
        }
    }

    /// Cancels admission and queued images; GPU-owned slots retire through their callbacks.
    pub fn stop(&mut self) {
        self.stopped = true;
        if let Some(key) = self.ready.take() {
            self.slots[key.index] = Slot::Free;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn newest_completed_image_wins_without_reusing_pending_or_reading_images() {
        let mut pool = Pool::default();
        let first = pool.acquire().unwrap();
        let second = pool.acquire().unwrap();
        let third = pool.acquire().unwrap();
        assert!(pool.acquire().is_none());
        for key in [first, second, third] {
            assert!(pool.submit(key));
        }
        pool.complete(first, true);
        assert_eq!(pool.take(), Some(first));
        pool.complete(second, true);
        pool.complete(third, true);
        assert_eq!(pool.take(), Some(third));
        let reused = pool.acquire().unwrap();
        assert_eq!(reused.index, second.index);
        assert!(pool.acquire().is_none());
        pool.release(first);
        assert_eq!(pool.acquire().unwrap().index, first.index);
    }

    #[test]
    fn late_completion_never_replaces_a_newer_displayed_image() {
        let mut pool = Pool::default();
        let old = pool.acquire().unwrap();
        let new = pool.acquire().unwrap();
        pool.submit(old);
        pool.submit(new);
        pool.complete(new, true);
        assert_eq!(pool.take(), Some(new));
        pool.complete(old, true);
        assert_eq!(pool.take(), None);
        let reused = pool.acquire().unwrap();
        assert_eq!(reused.index, old.index);
        pool.release(old);
        assert!(
            pool.submit(reused),
            "old handles cannot release a new acquisition"
        );
    }

    #[test]
    fn cancellation_and_errors_release_work_without_publishing_it() {
        let mut pool = Pool::default();
        let failed = pool.acquire().unwrap();
        pool.submit(failed);
        pool.complete(failed, false);
        assert_eq!(pool.take(), None);
        let acquired = pool.acquire().unwrap();
        let pending = pool.acquire().unwrap();
        pool.submit(pending);
        pool.stop();
        assert!(!pool.submit(acquired));
        pool.complete(pending, true);
        assert_eq!(pool.take(), None);
        assert_eq!(pool.acquire(), None);
        assert!(pool.slots.iter().all(|slot| *slot == Slot::Free));
    }
}
