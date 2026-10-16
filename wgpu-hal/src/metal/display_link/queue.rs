//! One pending display update; replacing stale work cannot grow presentation latency.

#[derive(Debug)]
pub(super) struct Frame<T> {
    pub drawable: T,
    pub target: f64,
}

#[derive(Debug)]
pub(super) struct Inbox<T> {
    pending: Option<Frame<T>>,
    stopped: bool,
}

impl<T> Default for Inbox<T> {
    fn default() -> Self {
        Self {
            pending: None,
            stopped: false,
        }
    }
}

impl<T> Inbox<T> {
    /// Returns displaced ownership so native handles are released outside the inbox lock.
    pub fn publish(&mut self, frame: Frame<T>) -> Option<Frame<T>> {
        if self.stopped {
            Some(frame)
        } else {
            self.pending.replace(frame)
        }
    }

    pub fn take(&mut self) -> Option<Frame<T>> {
        self.pending.take()
    }
    pub fn is_stopped(&self) -> bool {
        self.stopped
    }
    pub fn has_frame(&self) -> bool {
        self.pending.is_some()
    }

    /// Rejects late callbacks and returns any prefetched drawable for release.
    pub fn stop(&mut self) -> Option<Frame<T>> {
        self.stopped = true;
        self.pending.take()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn slow_consumers_receive_the_latest_target_without_a_backlog() {
        let mut inbox = Inbox::default();
        assert!(inbox
            .publish(Frame {
                drawable: 1,
                target: 10.0
            })
            .is_none());
        assert_eq!(
            inbox
                .publish(Frame {
                    drawable: 2,
                    target: 20.0
                })
                .unwrap()
                .drawable,
            1
        );
        let frame = inbox.take().unwrap();
        assert_eq!((frame.drawable, frame.target), (2, 20.0));
        assert!(!inbox.has_frame());
    }

    #[test]
    fn stopping_releases_prefetch_and_rejects_late_callbacks() {
        let mut inbox = Inbox::default();
        inbox.publish(Frame {
            drawable: 1,
            target: 10.0,
        });
        assert_eq!(inbox.stop().unwrap().drawable, 1);
        assert!(inbox.is_stopped());
        assert_eq!(
            inbox
                .publish(Frame {
                    drawable: 2,
                    target: 20.0
                })
                .unwrap()
                .drawable,
            2
        );
        assert!(inbox.take().is_none());
        assert!(inbox.stop().is_none());
    }
}
