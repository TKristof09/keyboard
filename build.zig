const std = @import("std");
pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .thumb,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m0plus },
        .os_tag = .freestanding,
        .abi = .eabi,
    });

    const rom_exe = b.addExecutable(.{
        .name = "stage2-bootloader",
        .root_module = b.createModule(.{
            .optimize = .ReleaseSmall,
            .target = target,
        }),
    });

    //rom_exe.linkage = .static;
    rom_exe.build_id = .none;
    rom_exe.setLinkerScript(b.path("src/link.ld"));
    rom_exe.addAssemblyFile(b.path("src/bootrom/boot2.S"));
    rom_exe.entry = .{ .symbol_name = "_stage2_boot" };

    const rom_objcopy = b.addObjCopy(rom_exe.getEmittedBin(), .{
        .basename = "stage2.bin",
        .format = .bin,
        .only_section = ".boot2",
    });

    const output = rom_objcopy.getOutput();

    const exe = b.addExecutable(.{
        .name = "main",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = .Debug,
            .strip = false,
        }),
    });
    exe.bundle_ubsan_rt = false;

    exe.root_module.addImport(
        "bootloader",
        b.createModule(.{ .root_source_file = output }),
    );
    // exe.root_module.addImport(
    //     "chip",
    //     b.createModule(.{ .root_source_file = b.path("src/rp2040/chip/rp2040.zig") }),
    // );
    exe.setLinkerScript(b.path("src/link.ld"));
    const s = b.step("main", "my build");
    const b_install = b.addInstallArtifact(exe, .{});
    s.dependOn(&b_install.step);
}
