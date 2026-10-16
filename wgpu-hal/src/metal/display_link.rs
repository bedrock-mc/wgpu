//! FIFO drawable delivery on Metal's display schedule, independent of main-thread work.

mod queue;
use alloc::sync::Arc;
use core::time::Duration;
use objc2::{
    define_class, msg_send,
    rc::{autoreleasepool, Retained},
    runtime::{NSObject, ProtocolObject},
    AnyThread, DefinedClass,
};
use objc2_core_foundation::{kCFRunLoopDefaultMode, CFRetained, CFRunLoop};
use objc2_foundation::{
    NSObjectProtocol, NSQualityOfService, NSRunLoop, NSRunLoopCommonModes, NSThread,
};
use objc2_quartz_core::{
    CAFrameRateRange, CAMetalDisplayLink, CAMetalDisplayLinkDelegate, CAMetalDisplayLinkUpdate,
    CAMetalDrawable, CAMetalLayer,
};
use parking_lot::{Condvar, Mutex};
use queue::{Frame, Inbox};
use std::{thread::JoinHandle, time::Instant};

#[derive(Debug)]
pub(super) struct Drawable(pub Retained<ProtocolObject<dyn CAMetalDrawable>>);
// SAFETY: Metal drawables may be retained and transferred between encoding and presentation threads.
unsafe impl Send for Drawable {}

struct Layer(Retained<CAMetalLayer>);
// SAFETY: only Metal's display-link API uses this retained layer on the worker; AppKit stays on main.
unsafe impl Send for Layer {}

#[derive(Debug)]
struct Wake(CFRetained<CFRunLoop>);
// SAFETY: this handle is used only to stop/wake its run loop, which Core Foundation permits cross-thread.
unsafe impl Send for Wake {}
unsafe impl Sync for Wake {}

#[derive(Debug, Default)]
pub(super) struct Receiver {
    inbox: Mutex<Inbox<Drawable>>,
    ready: Condvar,
    wake: Mutex<Option<Wake>>,
}

impl Receiver {
    /// Waits for a bounded display update, releasing the lock while callbacks publish.
    pub fn take(
        &self,
        timeout: Duration,
    ) -> Option<(Retained<ProtocolObject<dyn CAMetalDrawable>>, f64)> {
        let until = Instant::now() + timeout;
        let mut inbox = self.inbox.lock();
        while !inbox.has_frame() && !inbox.is_stopped() {
            let remaining = until.saturating_duration_since(Instant::now());
            if remaining.is_zero() {
                return None;
            }
            self.ready.wait_for(&mut inbox, remaining);
        }
        inbox.take().map(|frame| (frame.drawable.0, frame.target))
    }

    /// Cancels acquisition and releases prefetched handles before surface reconfiguration.
    fn stop(&self) {
        let discarded = self.inbox.lock().stop();
        self.ready.notify_all();
        drop(discarded);
        if let Some(wake) = &*self.wake.lock() {
            wake.0.stop();
            wake.0.wake_up();
        }
    }
}

define_class!(
    // SAFETY: NSObject has no subclass requirements; the delegate owns its shared state.
    #[unsafe(super(NSObject))]
    #[name = "WgpuMetalDisplayFrameTarget"]
    #[thread_kind = AnyThread]
    #[ivars = Arc<Receiver>]
    struct Target;
    unsafe impl NSObjectProtocol for Target {}
    unsafe impl CAMetalDisplayLinkDelegate for Target {
        #[unsafe(method(metalDisplayLink:needsUpdate:))]
        fn display_update(&self, _link: &CAMetalDisplayLink, update: &CAMetalDisplayLinkUpdate) {
            let receiver = self.ivars();
            let discarded = receiver.inbox.lock().publish(Frame {
                drawable: Drawable(update.drawable()), target: update.targetPresentationTimestamp(),
            });
            receiver.ready.notify_one();
            drop(discarded);
        }
    }
);

impl Target {
    fn new(receiver: Arc<Receiver>) -> Retained<Self> {
        let object = Self::alloc().set_ivars(receiver);
        // SAFETY: NSObject initialization accepts the initialized delegate allocation.
        unsafe { msg_send![super(object), init] }
    }
}

#[derive(Debug)]
pub(super) struct DisplayLink {
    pub receiver: Arc<Receiver>,
    worker: Option<JoinHandle<()>>,
}

impl DisplayLink {
    /// Starts native callbacks at the hosting display's measured maximum rate.
    pub fn new(layer: Retained<CAMetalLayer>, hz: f32) -> Option<Self> {
        let receiver = Arc::new(Receiver::default());
        let shared = receiver.clone();
        let layer = Layer(layer);
        let worker = std::thread::Builder::new()
            .name("Metal display link".into())
            .spawn(move || {
                autoreleasepool(|_| {
                    NSThread::currentThread()
                        .setQualityOfService(NSQualityOfService::UserInteractive);
                    // Keep the wrapper intact so the closure transfers its Send owner, not the raw field.
                    run(layer, shared, hz);
                });
            })
            .ok()?;
        Some(Self {
            receiver,
            worker: Some(worker),
        })
    }
}

/// Owns the native link and registration on one run loop until cancellation.
fn run(layer: Layer, receiver: Arc<Receiver>, hz: f32) {
    let target = Target::new(receiver.clone());
    let link = CAMetalDisplayLink::initWithMetalLayer(CAMetalDisplayLink::alloc(), &layer.0);
    link.setDelegate(Some(ProtocolObject::from_ref(&*target)));
    link.setPreferredFrameLatency(2.0);
    link.setPreferredFrameRateRange(CAFrameRateRange {
        minimum: hz,
        maximum: hz,
        preferred: hz,
    });
    *receiver.wake.lock() = CFRunLoop::current().map(Wake);
    // SAFETY: creation, registration, callbacks and invalidation share this worker's run loop.
    unsafe {
        link.addToRunLoop_forMode(&NSRunLoop::currentRunLoop(), NSRunLoopCommonModes);
    }
    while !receiver.inbox.lock().is_stopped() {
        autoreleasepool(|_| {
            // SAFETY: the constant is supplied by Core Foundation; the worker runs its own loop.
            unsafe {
                CFRunLoop::run_in_mode(kCFRunLoopDefaultMode, 0.1, true);
            }
        });
    }
    link.invalidate();
    link.setDelegate(None);
    receiver.wake.lock().take();
}

impl Drop for DisplayLink {
    fn drop(&mut self) {
        self.receiver.stop();
        if let Some(worker) = self.worker.take() {
            let _ = worker.join();
        }
    }
}
