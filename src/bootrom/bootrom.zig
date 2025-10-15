const std = @import("std");

// force zig to create the variable at comptime so it gets put in the elf
comptime {
    _ = bootrom;
}

// Add checksum to last 4 bytes of bootloader
fn addCrc(comptime stage2: []const u8) [256]u8 {
    var data: [256]u8 = @splat(0);
    @memcpy(data[0..stage2.len], stage2);

    // Checksum parameters from 2.8.1.3.1
    const Hash = std.hash.crc.Crc(u32, .{
        .polynomial = 0x04c11db7,
        .initial = 0xffffffff,
        .reflect_input = false,
        .reflect_output = false,
        .xor_output = 0x00000000,
    });

    std.mem.writeInt(u32, data[252..256], Hash.hash(data[0..252]), .little);

    return data;
}

export const bootrom: [256]u8 linksection(".boot2") = addCrc(@embedFile("bootloader"));
