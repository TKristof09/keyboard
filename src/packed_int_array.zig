const std = @import("std");

pub fn writePacked(comptime T: type, bytes: []u8, v: T, bit_offset: usize) void {
    const bit_size = @bitSizeOf(T);
    comptime {
        if (bit_size > 8) @compileError("only smaller than 8 bit integers supported for now");
    }
    const start_byte = bit_offset / 8;
    // const end_byte = start_byte + @divFloor(bit_size, 8);
    const start_keep_bits: u3 = @intCast(bit_offset % 8);
    // const end_keep_bits = 16 - start_keep_bits - bit_size;

    const Container = comptime switch (bit_size) {
        1 => u8,
        else => u16,
    };
    const upcasted = @as(Container, @intCast(v));
    const ptr: *align(1) Container = @ptrCast(&bytes[start_byte]);
    const mask = ~(@as(Container, std.math.maxInt(T)) << start_keep_bits);

    const new_val: Container = ((ptr.* & mask) | (upcasted << start_keep_bits));
    ptr.* = new_val;
}
pub fn writePackedSlice(comptime T: type, bytes: []u8, s: []const T, bit_offset: usize) void {
    for (s, 0..) |v, i| {
        const offset = bit_offset + i * @bitSizeOf(T);
        writePacked(T, bytes, v, offset);
    }
}

test "u1" {
    var bytes = [_]u8{ 0, 0 };

    // Fill 16 bits with pattern
    for (0..16) |i| {
        writePacked(u1, &bytes, @intCast(i % 2), i);
    }

    try std.testing.expectEqual(@as(u8, 0b10101010), bytes[0]);
    try std.testing.expectEqual(@as(u8, 0b10101010), bytes[1]);
}

test "boundary" {
    var bytes = [_]u8{ 0, 0, 0 };

    writePacked(u6, &bytes, 1, 0);
    writePacked(u6, &bytes, 2, 6);
    writePacked(u6, &bytes, 3, 12);
    writePacked(u6, &bytes, 4, 18);

    try std.testing.expectEqual(@as(u8, 0b10000001), bytes[0]);
    try std.testing.expectEqual(@as(u8, 0b00110000), bytes[1]);
    try std.testing.expectEqual(@as(u8, 0b00010000), bytes[2]);
}

test "leftover" {
    var bytes = [_]u8{ 0, 0, 0 };

    writePacked(u6, &bytes, 1, 0);
    writePacked(u6, &bytes, 2, 6);
    writePacked(u6, &bytes, 3, 12);

    try std.testing.expectEqual(@as(u8, 0b10000001), bytes[0]);
    try std.testing.expectEqual(@as(u8, 0b00110000), bytes[1]);
    try std.testing.expectEqual(@as(u8, 0b00000000), bytes[2]);
}

test "skip" {
    var bytes = [_]u8{ 0, 0, 0 };

    writePacked(u6, &bytes, 1, 0);
    writePacked(u6, &bytes, 2, 8);
    writePacked(u6, &bytes, 3, 14);

    try std.testing.expectEqual(@as(u8, 0b00000001), bytes[0]);
    try std.testing.expectEqual(@as(u8, 0b11000010), bytes[1]);
    try std.testing.expectEqual(@as(u8, 0b00000000), bytes[2]);
}

test "mix" {
    var bytes = [_]u8{ 0, 0, 0 };

    writePacked(u6, &bytes, 1, 0);
    writePacked(u6, &bytes, 2, 8);
    writePacked(u6, &bytes, 3, 14);
    writePacked(u4, &bytes, 4, 20);

    try std.testing.expectEqual(@as(u8, 0b00000001), bytes[0]);
    try std.testing.expectEqual(@as(u8, 0b11000010), bytes[1]);
    try std.testing.expectEqual(@as(u8, 0b01000000), bytes[2]);
}

test "slice" {
    var bytes = [_]u8{ 0, 0, 0 };
    const arr = [_]u5{ 2, 3, 4, 5 };

    writePackedSlice(u5, &bytes, &arr, 2);

    try std.testing.expectEqual(@as(u8, 0b10001000), bytes[0]);
    try std.testing.expectEqual(@as(u8, 0b01000001), bytes[1]);
    try std.testing.expectEqual(@as(u8, 0b00001010), bytes[2]);
}
