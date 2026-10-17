use super::super::*;
use crate::{Adapter as _, CommandEncoder as _, Device as _, Instance as _, Queue as _};

/// Exercises native submission, including the empty buffer that carries the fence signal.
#[test]
fn empty_transition_buffers_skip_submission_and_release_their_budget_once() {
    unsafe {
        let Some(crate::OpenDevice { device, queue }) = open_device() else {
            eprintln!("skipping command buffer test: missing Metal adapter");
            return;
        };
        let mut encoder = device
            .create_command_encoder(&crate::CommandEncoderDescriptor {
                label: Some("empty buffer regression"),
                queue: &queue,
            })
            .unwrap();
        let mut fence = device.create_fence().unwrap();
        let buffer = device
            .create_buffer(&crate::BufferDescriptor {
                label: Some("clear regression"),
                size: 64,
                usage: wgt::BufferUses::COPY_DST | wgt::BufferUses::MAP_READ,
                memory_flags: crate::MemoryFlags::empty(),
            })
            .unwrap();
        let mut retained = Vec::new();
        for value in 1..=128 {
            if value == 65 {
                queue.enable_strict_event_sync().unwrap();
            }
            let mut commands = Vec::new();
            for index in 0..4 {
                encoder.begin_encoding(Some("transition or work")).unwrap();
                if index == 1 {
                    encoder.clear_buffer(&buffer, 0..64);
                }
                commands.push(encoder.end_encoding().unwrap());
            }
            queue
                .submit(
                    &commands.iter().collect::<Vec<_>>(),
                    &[],
                    (&mut fence, value),
                )
                .unwrap();
            assert!(device
                .wait(&fence, value, Some(core::time::Duration::from_secs(10)))
                .unwrap());
            assert_eq!(
                commands[0].raw.status(),
                MTLCommandBufferStatus::NotEnqueued
            );
            assert_eq!(commands[1].raw.status(), MTLCommandBufferStatus::Completed);
            assert_eq!(
                commands[2].raw.status(),
                MTLCommandBufferStatus::NotEnqueued
            );
            assert_eq!(commands[3].raw.status(), MTLCommandBufferStatus::Completed);
            retained.push(commands);
            assert_eq!(
                queue
                    .shared
                    .command_buffer_created_not_submitted
                    .load(atomic::Ordering::Acquire),
                2 * value as usize
            );
        }
        drop(retained);
        assert_eq!(
            queue
                .shared
                .command_buffer_created_not_submitted
                .load(atomic::Ordering::Acquire),
            0
        );
        let mapping = device.map_buffer(&buffer, 0..64).unwrap();
        assert!(core::slice::from_raw_parts(mapping.ptr.as_ptr(), 64)
            .iter()
            .all(|byte| *byte == 0));
        device.unmap_buffer(&buffer);
        device.destroy_buffer(buffer);
        device.destroy_fence(fence);
    }
}

/// Native interop may record commands invisible to HAL, so exposing the buffer retains it.
#[test]
fn exposed_raw_command_buffers_are_submitted() {
    unsafe {
        let Some(crate::OpenDevice { device, queue }) = open_device() else {
            eprintln!("skipping command buffer test: missing Metal adapter");
            return;
        };
        let mut encoder = device
            .create_command_encoder(&crate::CommandEncoderDescriptor {
                label: None,
                queue: &queue,
            })
            .unwrap();
        encoder.begin_encoding(None).unwrap();
        assert!(encoder.raw_command_buffer().is_some());
        let command = encoder.end_encoding().unwrap();
        encoder.begin_encoding(None).unwrap();
        let signal = encoder.end_encoding().unwrap();
        let mut fence = device.create_fence().unwrap();
        queue
            .submit(&[&command, &signal], &[], (&mut fence, 1))
            .unwrap();
        assert!(device
            .wait(&fence, 1, Some(core::time::Duration::from_secs(10)))
            .unwrap());
        assert_eq!(command.raw.status(), MTLCommandBufferStatus::Completed);
        drop((command, signal));
        assert_eq!(
            queue
                .shared
                .command_buffer_created_not_submitted
                .load(atomic::Ordering::Acquire),
            0
        );
        device.destroy_fence(fence);
    }
}

/// Opens a Metal device for native tests, or skips when no adapter is available.
fn open_device() -> Option<crate::OpenDevice<Api>> {
    let instance = unsafe {
        Instance::init(&crate::InstanceDescriptor {
            name: "metal tests",
            flags: wgt::InstanceFlags::VALIDATION,
            memory_budget_thresholds: Default::default(),
            backend_options: Default::default(),
            telemetry: None,
            display: None,
        })
    }
    .unwrap();
    let adapter = unsafe { instance.enumerate_adapters(None) }
        .into_iter()
        .next()?
        .adapter;
    Some(
        unsafe {
            adapter.open(
                wgt::Features::empty(),
                &wgt::Limits::default(),
                &wgt::MemoryHints::default(),
            )
        }
        .unwrap(),
    )
}

/// Returns the number of native allocations still charged to the queue.
fn outstanding_command_buffers(queue: &Queue) -> usize {
    queue
        .shared
        .command_buffer_created_not_submitted
        .load(atomic::Ordering::Acquire)
}

/// Retained skipped buffers must reach the allocation guard before exhausting the native pool.
#[test]
fn retained_skipped_buffers_gate_native_allocation() {
    let Some(crate::OpenDevice { device, queue }) = open_device() else {
        eprintln!("skipping allocation budget test: missing Metal adapter");
        return;
    };
    unsafe {
        let mut encoder = device
            .create_command_encoder(&crate::CommandEncoderDescriptor {
                label: None,
                queue: &queue,
            })
            .unwrap();
        let mut fence = device.create_fence().unwrap();
        let mut retained = Vec::new();
        let mut value = 0;
        while retained.len() < adapter::MAX_COMMAND_BUFFERS {
            // Leave a slot for the committed fence buffer until the last batch.
            let remaining = adapter::MAX_COMMAND_BUFFERS - retained.len();
            if remaining == 1 {
                encoder.begin_encoding(None).unwrap();
                retained.push(encoder.end_encoding().unwrap());
                break;
            }
            let count = remaining.min(128);
            let mut commands = (0..count)
                .map(|_| {
                    encoder.begin_encoding(None).unwrap();
                    encoder.end_encoding().unwrap()
                })
                .collect::<Vec<_>>();
            value += 1;
            queue
                .submit(
                    &commands.iter().collect::<Vec<_>>(),
                    &[],
                    (&mut fence, value),
                )
                .unwrap();
            assert!(device.wait(&fence, value, None).unwrap());
            // Keep the skipped buffers alive after all committed work has finished.
            drop(commands.pop());
            retained.extend(commands);
            assert_eq!(outstanding_command_buffers(&queue), retained.len());
        }
        assert!(matches!(
            encoder.begin_encoding(None),
            Err(crate::DeviceError::Lost)
        ));
        assert_eq!(
            outstanding_command_buffers(&queue),
            adapter::MAX_COMMAND_BUFFERS
        );
        drop(retained);
        assert_eq!(outstanding_command_buffers(&queue), 0);
        encoder.begin_encoding(None).unwrap();
        encoder.discard_encoding();
        assert_eq!(outstanding_command_buffers(&queue), 0);
        device.destroy_fence(fence);
    }
}
