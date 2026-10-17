//! Immediate windowed rendering, decoupled from display-owned drawable availability.

mod pool;
use pool::{Key, Pool, SLOTS};

use alloc::{sync::Arc, vec::Vec};
use core::time::Duration;
use objc2::{
    rc::{autoreleasepool, Retained},
    runtime::{NSObject, ProtocolObject},
    MainThreadMarker,
};
use objc2_foundation::{ns_string, NSQualityOfService, NSThread};
use objc2_metal::{
    MTLBlitCommandEncoder, MTLCommandBuffer, MTLCommandBufferStatus, MTLCommandEncoder,
    MTLCommandQueue, MTLDevice, MTLDrawable, MTLOrigin, MTLSize, MTLStorageMode, MTLTexture,
    MTLTextureDescriptor, MTLTextureType, MTLTextureUsage,
};
use objc2_quartz_core::{CAMetalDrawable, CAMetalLayer};
use parking_lot::{Condvar, Mutex};
use std::{thread::JoinHandle, time::Instant};

#[derive(Debug)]
pub(super) struct Shared {
    textures: [Retained<ProtocolObject<dyn MTLTexture>>; SLOTS],
    pool: Mutex<Pool>,
    available: Condvar,
}

// SAFETY: Metal textures support multiple threads; slot ownership and completion order all access.
unsafe impl Send for Shared {}
unsafe impl Sync for Shared {}

impl Shared {
    /// Waits only for bounded rendering/copy work, never for a free display drawable.
    pub(super) fn acquire(self: &Arc<Self>, timeout: Option<Duration>) -> Option<Frame> {
        let until = timeout.map(|timeout| Instant::now() + timeout);
        let mut pool = self.pool.lock();
        loop {
            if let Some(key) = pool.acquire() {
                return Some(Frame {
                    shared: self.clone(),
                    key,
                    submitted: false,
                });
            }
            let remaining = until.map(|until| until.saturating_duration_since(Instant::now()));
            if pool.stopped || remaining.is_some_and(|remaining| remaining.is_zero()) {
                return None;
            }
            match remaining {
                Some(remaining) => {
                    self.available.wait_for(&mut pool, remaining);
                }
                None => self.available.wait(&mut pool),
            }
        }
    }

    /// Sleeps until an image is ready before asking the display link for a drawable.
    fn wait_for_image(&self) -> bool {
        let mut pool = self.pool.lock();
        while !pool.has_ready() && !pool.stopped {
            self.available.wait(&mut pool);
        }
        !pool.stopped
    }

    /// Returns an image only after the presenter has finished reading it.
    fn release(&self, key: Key) {
        self.pool.lock().release(key);
        self.available.notify_all();
    }
}

#[derive(Debug)]
pub(super) struct Frame {
    shared: Arc<Shared>,
    key: Key,
    submitted: bool,
}

impl Frame {
    /// The exact surface-format render target owned by this acquisition.
    pub(super) fn texture(&self) -> &Retained<ProtocolObject<dyn MTLTexture>> {
        &self.shared.textures[self.key.index]
    }

    /// Publishes after all preceding render submissions complete on their native queue.
    pub(super) fn submit(
        mut self,
        queue: &ProtocolObject<dyn MTLCommandQueue>,
    ) -> Result<(), crate::SurfaceError> {
        let buffer = queue.commandBuffer().ok_or(crate::SurfaceError::Lost)?;
        if !self.shared.pool.lock().submit(self.key) {
            return Ok(());
        }
        self.submitted = true;
        buffer.setLabel(Some(ns_string!("(wgpu internal) Image ready")));
        let shared = self.shared.clone();
        let key = self.key;
        let completed = block2::RcBlock::new(move |buffer: NonNullCommandBuffer| {
            // SAFETY: Metal passes the live command buffer to its completion handler.
            let success = unsafe { buffer.as_ref() }.status() == MTLCommandBufferStatus::Completed;
            shared.pool.lock().complete(key, success);
            shared.available.notify_all();
            if !success {
                log::error!("Metal frame image failed before presentation");
            }
        });
        // SAFETY: Metal copies the block and invokes it while its command buffer is alive.
        unsafe {
            buffer.addCompletedHandler(block2::RcBlock::as_ptr(&completed));
        }
        buffer.commit();
        Ok(())
    }
}

type NonNullCommandBuffer = core::ptr::NonNull<ProtocolObject<dyn MTLCommandBuffer>>;

impl Drop for Frame {
    fn drop(&mut self) {
        if !self.submitted {
            self.shared.release(self.key);
        }
    }
}

#[derive(Debug)]
struct PresentQueue(Retained<ProtocolObject<dyn MTLCommandQueue>>);
// SAFETY: Metal command queues support encoding and submission from any thread.
unsafe impl Send for PresentQueue {}

#[derive(Debug)]
pub(super) struct Mailbox {
    pub shared: Arc<Shared>,
    link: Option<super::display_link::DisplayLink>,
    worker: Option<JoinHandle<()>>,
}

impl Mailbox {
    /// Starts bounded image ownership and an independently cancellable display consumer.
    pub(super) fn new(
        layer: Retained<CAMetalLayer>,
        window: &NSObject,
        device: &ProtocolObject<dyn MTLDevice>,
        config: &crate::SurfaceConfiguration,
        main: MainThreadMarker,
    ) -> Option<Self> {
        let descriptor = MTLTextureDescriptor::new();
        descriptor.setTextureType(MTLTextureType::Type2D);
        unsafe {
            descriptor.setWidth(config.extent.width as usize);
            descriptor.setHeight(config.extent.height as usize);
        }
        descriptor.setPixelFormat(layer.pixelFormat());
        descriptor.setStorageMode(MTLStorageMode::Private);
        descriptor.setUsage(
            super::conv::map_texture_usage(config.format, config.usage)
                | MTLTextureUsage::PixelFormatView,
        );
        let textures = (0..SLOTS)
            .map(|_| device.newTextureWithDescriptor(&descriptor))
            .collect::<Option<Vec<_>>>()?;
        let shared = Arc::new(Shared {
            textures: textures.try_into().ok()?,
            pool: Mutex::new(Pool::default()),
            available: Condvar::new(),
        });
        let link = super::display_link::DisplayLink::new(
            layer,
            window,
            config.maximum_frame_latency,
            main,
        )?;
        let receiver = link.receiver.clone();
        let queue = PresentQueue(device.newCommandQueue()?);
        let images = shared.clone();
        let worker = std::thread::Builder::new()
            .name("Metal image presentation".into())
            .spawn(move || {
                run(images, receiver, queue);
            })
            .ok()?;
        Some(Self {
            shared,
            link: Some(link),
            worker: Some(worker),
        })
    }
}

/// Copies the freshest completed image; a slow display never queues historical images.
fn run(shared: Arc<Shared>, receiver: Arc<super::display_link::Receiver>, queue: PresentQueue) {
    autoreleasepool(|_| {
        NSThread::currentThread().setQualityOfService(NSQualityOfService::UserInteractive);
    });
    while shared.wait_for_image() {
        autoreleasepool(|_| {
            let Some(drawable) = receiver.take(None) else {
                return;
            };
            let Some(key) = shared.pool.lock().take() else {
                return;
            };
            let source = &shared.textures[key.index];
            let target = drawable.texture();
            if source.width() != target.width() || source.height() != target.height() {
                shared.release(key);
                return;
            }
            let Some(buffer) = queue.0.commandBuffer() else {
                shared.release(key);
                return;
            };
            buffer.setLabel(Some(ns_string!("(wgpu internal) Latest image present")));
            let Some(blit) = buffer.blitCommandEncoder() else {
                shared.release(key);
                return;
            };
            unsafe {
                blit.copyFromTexture_sourceSlice_sourceLevel_sourceOrigin_sourceSize_toTexture_destinationSlice_destinationLevel_destinationOrigin(
                    source, 0, 0, MTLOrigin { x: 0, y: 0, z: 0 }, MTLSize { width: source.width(), height: source.height(), depth: 1 },
                    &target, 0, 0, MTLOrigin { x: 0, y: 0, z: 0 });
            }
            blit.endEncoding();
            let receipt = shared.clone();
            let completed =
                block2::RcBlock::new(move |_buffer: NonNullCommandBuffer| receipt.release(key));
            // SAFETY: Metal copies this block; retained state outlives its completion callback.
            unsafe {
                buffer.addCompletedHandler(block2::RcBlock::as_ptr(&completed));
            }
            let drawable: Retained<ProtocolObject<dyn MTLDrawable>> =
                ProtocolObject::from_retained(drawable);
            buffer.presentDrawable(&drawable);
            buffer.commit();
        });
    }
}

impl Drop for Mailbox {
    fn drop(&mut self) {
        self.shared.pool.lock().stop();
        self.shared.available.notify_all();
        drop(self.link.take());
        if let Some(worker) = self.worker.take() {
            let _ = worker.join();
        }
    }
}
