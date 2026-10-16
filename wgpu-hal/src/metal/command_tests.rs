use super::super::*;
use crate::{Adapter as _, CommandEncoder as _, Device as _, Instance as _, Queue as _};

/// Exercises native submission, including the empty buffer that carries the fence signal.
#[test]
fn empty_transition_buffers_skip_submission_and_release_their_budget_once() {
    unsafe {
        let instance = Instance::init(&crate::InstanceDescriptor {
            name: "empty Metal command buffers",
            flags: wgt::InstanceFlags::VALIDATION,
            memory_budget_thresholds: Default::default(),
            backend_options: Default::default(),
            telemetry: None,
            display: None,
        })
        .unwrap();
        let Some(exposed) = instance.enumerate_adapters(None).into_iter().next() else {
            eprintln!("skipping empty command buffers: missing Metal adapter");
            return;
        };
        let crate::OpenDevice { device, queue } = exposed
            .adapter
            .open(
                wgt::Features::empty(),
                &wgt::Limits::default(),
                &wgt::MemoryHints::default(),
            )
            .unwrap();
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
            drop(commands);
            assert_eq!(
                queue
                    .shared
                    .command_buffer_created_not_submitted
                    .load(atomic::Ordering::Acquire),
                0
            );
        }
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
        let instance = Instance::init(&crate::InstanceDescriptor {
            name: "raw Metal command buffers",
            flags: wgt::InstanceFlags::VALIDATION,
            memory_budget_thresholds: Default::default(),
            backend_options: Default::default(),
            telemetry: None,
            display: None,
        })
        .unwrap();
        let Some(exposed) = instance.enumerate_adapters(None).into_iter().next() else {
            eprintln!("skipping raw command buffers: missing Metal adapter");
            return;
        };
        let crate::OpenDevice { device, queue } = exposed
            .adapter
            .open(
                wgt::Features::empty(),
                &wgt::Limits::default(),
                &wgt::MemoryHints::default(),
            )
            .unwrap();
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
