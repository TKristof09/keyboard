const helpers = @import("helpers.zig");
/// Control and status register
pub const CH0_CSR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050000),
    pub const FieldMasks = struct {
        pub const PH_ADV: u32 = helpers.generateMask(7, 8);
        pub const PH_RET: u32 = helpers.generateMask(6, 7);
        pub const DIVMODE: u32 = helpers.generateMask(4, 6);
        pub const B_INV: u32 = helpers.generateMask(3, 4);
        pub const A_INV: u32 = helpers.generateMask(2, 3);
        pub const PH_CORRECT: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const DIVMODE_e = enum(u2) {
        div = 0,
        level = 1,
        rise = 2,
        fall = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Advance the phase of the counter by 1 count, while it is running.
        /// Self-clearing. Write a 1, and poll until low. Counter must be running
        /// at less than full speed (div_int + div_frac / 16 &gt; 1)
        pub fn PH_ADV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Retard the phase of the counter by 1 count, while it is running.
        /// Self-clearing. Write a 1, and poll until low. Counter must be running.
        pub fn PH_RET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn DIVMODE(self: Value, v: DIVMODE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 6),
            };
        }
        /// Invert output B
        pub fn B_INV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Invert output A
        pub fn A_INV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// 1: Enable phase-correct modulation. 0: Trailing-edge
        pub fn PH_CORRECT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Enable the PWM channel.
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn DIVMODE(self: Result) DIVMODE_e {
            const mask = comptime helpers.generateMask(4, 6);
            const val: @typeInfo(DIVMODE_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn B_INV(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn A_INV(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn PH_CORRECT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Advance the phase of the counter by 1 count, while it is running.
    /// Self-clearing. Write a 1, and poll until low. Counter must be running
    /// at less than full speed (div_int + div_frac / 16 &gt; 1)
    pub fn PH_ADV(v: u1) Value {
        return Value.PH_ADV(.{}, v);
    }
    /// Retard the phase of the counter by 1 count, while it is running.
    /// Self-clearing. Write a 1, and poll until low. Counter must be running.
    pub fn PH_RET(v: u1) Value {
        return Value.PH_RET(.{}, v);
    }
    pub fn DIVMODE(v: DIVMODE_e) Value {
        return Value.DIVMODE(.{}, v);
    }
    /// Invert output B
    pub fn B_INV(v: u1) Value {
        return Value.B_INV(.{}, v);
    }
    /// Invert output A
    pub fn A_INV(v: u1) Value {
        return Value.A_INV(.{}, v);
    }
    /// 1: Enable phase-correct modulation. 0: Trailing-edge
    pub fn PH_CORRECT(v: u1) Value {
        return Value.PH_CORRECT(.{}, v);
    }
    /// Enable the PWM channel.
    pub fn EN(v: u1) Value {
        return Value.EN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// INT and FRAC form a fixed-point fractional number.
/// Counting rate is system clock frequency divided by this number.
/// Fractional division uses simple 1st-order sigma-delta.
pub const CH0_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050004),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(4, 12);
        pub const FRAC: u32 = helpers.generateMask(0, 4);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn INT(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 12),
            };
        }
        pub fn FRAC(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 4),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u8 {
            const mask = comptime helpers.generateMask(4, 12);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn FRAC(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn INT(v: u8) Value {
        return Value.INT(.{}, v);
    }
    pub fn FRAC(v: u4) Value {
        return Value.FRAC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Direct access to the PWM counter
pub const CH0_CTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050008),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u16) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Counter compare values
pub const CH0_CC = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005000c),
    pub const FieldMasks = struct {
        pub const B: u32 = helpers.generateMask(16, 32);
        pub const A: u32 = helpers.generateMask(0, 16);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn B(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        pub fn A(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn B(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn A(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn B(v: u16) Value {
        return Value.B(.{}, v);
    }
    pub fn A(v: u16) Value {
        return Value.A(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Counter wrap value
pub const CH0_TOP = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050010),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u16) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Control and status register
pub const CH1_CSR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050014),
    pub const FieldMasks = struct {
        pub const PH_ADV: u32 = helpers.generateMask(7, 8);
        pub const PH_RET: u32 = helpers.generateMask(6, 7);
        pub const DIVMODE: u32 = helpers.generateMask(4, 6);
        pub const B_INV: u32 = helpers.generateMask(3, 4);
        pub const A_INV: u32 = helpers.generateMask(2, 3);
        pub const PH_CORRECT: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const DIVMODE_e = enum(u2) {
        div = 0,
        level = 1,
        rise = 2,
        fall = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Advance the phase of the counter by 1 count, while it is running.
        /// Self-clearing. Write a 1, and poll until low. Counter must be running
        /// at less than full speed (div_int + div_frac / 16 &gt; 1)
        pub fn PH_ADV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Retard the phase of the counter by 1 count, while it is running.
        /// Self-clearing. Write a 1, and poll until low. Counter must be running.
        pub fn PH_RET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn DIVMODE(self: Value, v: DIVMODE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 6),
            };
        }
        /// Invert output B
        pub fn B_INV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Invert output A
        pub fn A_INV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// 1: Enable phase-correct modulation. 0: Trailing-edge
        pub fn PH_CORRECT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Enable the PWM channel.
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn DIVMODE(self: Result) DIVMODE_e {
            const mask = comptime helpers.generateMask(4, 6);
            const val: @typeInfo(DIVMODE_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn B_INV(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn A_INV(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn PH_CORRECT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Advance the phase of the counter by 1 count, while it is running.
    /// Self-clearing. Write a 1, and poll until low. Counter must be running
    /// at less than full speed (div_int + div_frac / 16 &gt; 1)
    pub fn PH_ADV(v: u1) Value {
        return Value.PH_ADV(.{}, v);
    }
    /// Retard the phase of the counter by 1 count, while it is running.
    /// Self-clearing. Write a 1, and poll until low. Counter must be running.
    pub fn PH_RET(v: u1) Value {
        return Value.PH_RET(.{}, v);
    }
    pub fn DIVMODE(v: DIVMODE_e) Value {
        return Value.DIVMODE(.{}, v);
    }
    /// Invert output B
    pub fn B_INV(v: u1) Value {
        return Value.B_INV(.{}, v);
    }
    /// Invert output A
    pub fn A_INV(v: u1) Value {
        return Value.A_INV(.{}, v);
    }
    /// 1: Enable phase-correct modulation. 0: Trailing-edge
    pub fn PH_CORRECT(v: u1) Value {
        return Value.PH_CORRECT(.{}, v);
    }
    /// Enable the PWM channel.
    pub fn EN(v: u1) Value {
        return Value.EN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// INT and FRAC form a fixed-point fractional number.
/// Counting rate is system clock frequency divided by this number.
/// Fractional division uses simple 1st-order sigma-delta.
pub const CH1_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050018),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(4, 12);
        pub const FRAC: u32 = helpers.generateMask(0, 4);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn INT(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 12),
            };
        }
        pub fn FRAC(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 4),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u8 {
            const mask = comptime helpers.generateMask(4, 12);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn FRAC(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn INT(v: u8) Value {
        return Value.INT(.{}, v);
    }
    pub fn FRAC(v: u4) Value {
        return Value.FRAC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Direct access to the PWM counter
pub const CH1_CTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005001c),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u16) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Counter compare values
pub const CH1_CC = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050020),
    pub const FieldMasks = struct {
        pub const B: u32 = helpers.generateMask(16, 32);
        pub const A: u32 = helpers.generateMask(0, 16);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn B(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        pub fn A(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn B(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn A(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn B(v: u16) Value {
        return Value.B(.{}, v);
    }
    pub fn A(v: u16) Value {
        return Value.A(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Counter wrap value
pub const CH1_TOP = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050024),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u16) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Control and status register
pub const CH2_CSR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050028),
    pub const FieldMasks = struct {
        pub const PH_ADV: u32 = helpers.generateMask(7, 8);
        pub const PH_RET: u32 = helpers.generateMask(6, 7);
        pub const DIVMODE: u32 = helpers.generateMask(4, 6);
        pub const B_INV: u32 = helpers.generateMask(3, 4);
        pub const A_INV: u32 = helpers.generateMask(2, 3);
        pub const PH_CORRECT: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const DIVMODE_e = enum(u2) {
        div = 0,
        level = 1,
        rise = 2,
        fall = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Advance the phase of the counter by 1 count, while it is running.
        /// Self-clearing. Write a 1, and poll until low. Counter must be running
        /// at less than full speed (div_int + div_frac / 16 &gt; 1)
        pub fn PH_ADV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Retard the phase of the counter by 1 count, while it is running.
        /// Self-clearing. Write a 1, and poll until low. Counter must be running.
        pub fn PH_RET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn DIVMODE(self: Value, v: DIVMODE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 6),
            };
        }
        /// Invert output B
        pub fn B_INV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Invert output A
        pub fn A_INV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// 1: Enable phase-correct modulation. 0: Trailing-edge
        pub fn PH_CORRECT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Enable the PWM channel.
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn DIVMODE(self: Result) DIVMODE_e {
            const mask = comptime helpers.generateMask(4, 6);
            const val: @typeInfo(DIVMODE_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn B_INV(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn A_INV(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn PH_CORRECT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Advance the phase of the counter by 1 count, while it is running.
    /// Self-clearing. Write a 1, and poll until low. Counter must be running
    /// at less than full speed (div_int + div_frac / 16 &gt; 1)
    pub fn PH_ADV(v: u1) Value {
        return Value.PH_ADV(.{}, v);
    }
    /// Retard the phase of the counter by 1 count, while it is running.
    /// Self-clearing. Write a 1, and poll until low. Counter must be running.
    pub fn PH_RET(v: u1) Value {
        return Value.PH_RET(.{}, v);
    }
    pub fn DIVMODE(v: DIVMODE_e) Value {
        return Value.DIVMODE(.{}, v);
    }
    /// Invert output B
    pub fn B_INV(v: u1) Value {
        return Value.B_INV(.{}, v);
    }
    /// Invert output A
    pub fn A_INV(v: u1) Value {
        return Value.A_INV(.{}, v);
    }
    /// 1: Enable phase-correct modulation. 0: Trailing-edge
    pub fn PH_CORRECT(v: u1) Value {
        return Value.PH_CORRECT(.{}, v);
    }
    /// Enable the PWM channel.
    pub fn EN(v: u1) Value {
        return Value.EN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// INT and FRAC form a fixed-point fractional number.
/// Counting rate is system clock frequency divided by this number.
/// Fractional division uses simple 1st-order sigma-delta.
pub const CH2_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005002c),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(4, 12);
        pub const FRAC: u32 = helpers.generateMask(0, 4);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn INT(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 12),
            };
        }
        pub fn FRAC(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 4),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u8 {
            const mask = comptime helpers.generateMask(4, 12);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn FRAC(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn INT(v: u8) Value {
        return Value.INT(.{}, v);
    }
    pub fn FRAC(v: u4) Value {
        return Value.FRAC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Direct access to the PWM counter
pub const CH2_CTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050030),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u16) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Counter compare values
pub const CH2_CC = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050034),
    pub const FieldMasks = struct {
        pub const B: u32 = helpers.generateMask(16, 32);
        pub const A: u32 = helpers.generateMask(0, 16);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn B(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        pub fn A(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn B(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn A(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn B(v: u16) Value {
        return Value.B(.{}, v);
    }
    pub fn A(v: u16) Value {
        return Value.A(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Counter wrap value
pub const CH2_TOP = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050038),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u16) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Control and status register
pub const CH3_CSR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005003c),
    pub const FieldMasks = struct {
        pub const PH_ADV: u32 = helpers.generateMask(7, 8);
        pub const PH_RET: u32 = helpers.generateMask(6, 7);
        pub const DIVMODE: u32 = helpers.generateMask(4, 6);
        pub const B_INV: u32 = helpers.generateMask(3, 4);
        pub const A_INV: u32 = helpers.generateMask(2, 3);
        pub const PH_CORRECT: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const DIVMODE_e = enum(u2) {
        div = 0,
        level = 1,
        rise = 2,
        fall = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Advance the phase of the counter by 1 count, while it is running.
        /// Self-clearing. Write a 1, and poll until low. Counter must be running
        /// at less than full speed (div_int + div_frac / 16 &gt; 1)
        pub fn PH_ADV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Retard the phase of the counter by 1 count, while it is running.
        /// Self-clearing. Write a 1, and poll until low. Counter must be running.
        pub fn PH_RET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn DIVMODE(self: Value, v: DIVMODE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 6),
            };
        }
        /// Invert output B
        pub fn B_INV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Invert output A
        pub fn A_INV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// 1: Enable phase-correct modulation. 0: Trailing-edge
        pub fn PH_CORRECT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Enable the PWM channel.
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn DIVMODE(self: Result) DIVMODE_e {
            const mask = comptime helpers.generateMask(4, 6);
            const val: @typeInfo(DIVMODE_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn B_INV(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn A_INV(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn PH_CORRECT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Advance the phase of the counter by 1 count, while it is running.
    /// Self-clearing. Write a 1, and poll until low. Counter must be running
    /// at less than full speed (div_int + div_frac / 16 &gt; 1)
    pub fn PH_ADV(v: u1) Value {
        return Value.PH_ADV(.{}, v);
    }
    /// Retard the phase of the counter by 1 count, while it is running.
    /// Self-clearing. Write a 1, and poll until low. Counter must be running.
    pub fn PH_RET(v: u1) Value {
        return Value.PH_RET(.{}, v);
    }
    pub fn DIVMODE(v: DIVMODE_e) Value {
        return Value.DIVMODE(.{}, v);
    }
    /// Invert output B
    pub fn B_INV(v: u1) Value {
        return Value.B_INV(.{}, v);
    }
    /// Invert output A
    pub fn A_INV(v: u1) Value {
        return Value.A_INV(.{}, v);
    }
    /// 1: Enable phase-correct modulation. 0: Trailing-edge
    pub fn PH_CORRECT(v: u1) Value {
        return Value.PH_CORRECT(.{}, v);
    }
    /// Enable the PWM channel.
    pub fn EN(v: u1) Value {
        return Value.EN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// INT and FRAC form a fixed-point fractional number.
/// Counting rate is system clock frequency divided by this number.
/// Fractional division uses simple 1st-order sigma-delta.
pub const CH3_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050040),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(4, 12);
        pub const FRAC: u32 = helpers.generateMask(0, 4);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn INT(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 12),
            };
        }
        pub fn FRAC(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 4),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u8 {
            const mask = comptime helpers.generateMask(4, 12);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn FRAC(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn INT(v: u8) Value {
        return Value.INT(.{}, v);
    }
    pub fn FRAC(v: u4) Value {
        return Value.FRAC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Direct access to the PWM counter
pub const CH3_CTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050044),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u16) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Counter compare values
pub const CH3_CC = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050048),
    pub const FieldMasks = struct {
        pub const B: u32 = helpers.generateMask(16, 32);
        pub const A: u32 = helpers.generateMask(0, 16);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn B(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        pub fn A(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn B(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn A(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn B(v: u16) Value {
        return Value.B(.{}, v);
    }
    pub fn A(v: u16) Value {
        return Value.A(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Counter wrap value
pub const CH3_TOP = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005004c),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u16) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Control and status register
pub const CH4_CSR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050050),
    pub const FieldMasks = struct {
        pub const PH_ADV: u32 = helpers.generateMask(7, 8);
        pub const PH_RET: u32 = helpers.generateMask(6, 7);
        pub const DIVMODE: u32 = helpers.generateMask(4, 6);
        pub const B_INV: u32 = helpers.generateMask(3, 4);
        pub const A_INV: u32 = helpers.generateMask(2, 3);
        pub const PH_CORRECT: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const DIVMODE_e = enum(u2) {
        div = 0,
        level = 1,
        rise = 2,
        fall = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Advance the phase of the counter by 1 count, while it is running.
        /// Self-clearing. Write a 1, and poll until low. Counter must be running
        /// at less than full speed (div_int + div_frac / 16 &gt; 1)
        pub fn PH_ADV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Retard the phase of the counter by 1 count, while it is running.
        /// Self-clearing. Write a 1, and poll until low. Counter must be running.
        pub fn PH_RET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn DIVMODE(self: Value, v: DIVMODE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 6),
            };
        }
        /// Invert output B
        pub fn B_INV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Invert output A
        pub fn A_INV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// 1: Enable phase-correct modulation. 0: Trailing-edge
        pub fn PH_CORRECT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Enable the PWM channel.
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn DIVMODE(self: Result) DIVMODE_e {
            const mask = comptime helpers.generateMask(4, 6);
            const val: @typeInfo(DIVMODE_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn B_INV(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn A_INV(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn PH_CORRECT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Advance the phase of the counter by 1 count, while it is running.
    /// Self-clearing. Write a 1, and poll until low. Counter must be running
    /// at less than full speed (div_int + div_frac / 16 &gt; 1)
    pub fn PH_ADV(v: u1) Value {
        return Value.PH_ADV(.{}, v);
    }
    /// Retard the phase of the counter by 1 count, while it is running.
    /// Self-clearing. Write a 1, and poll until low. Counter must be running.
    pub fn PH_RET(v: u1) Value {
        return Value.PH_RET(.{}, v);
    }
    pub fn DIVMODE(v: DIVMODE_e) Value {
        return Value.DIVMODE(.{}, v);
    }
    /// Invert output B
    pub fn B_INV(v: u1) Value {
        return Value.B_INV(.{}, v);
    }
    /// Invert output A
    pub fn A_INV(v: u1) Value {
        return Value.A_INV(.{}, v);
    }
    /// 1: Enable phase-correct modulation. 0: Trailing-edge
    pub fn PH_CORRECT(v: u1) Value {
        return Value.PH_CORRECT(.{}, v);
    }
    /// Enable the PWM channel.
    pub fn EN(v: u1) Value {
        return Value.EN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// INT and FRAC form a fixed-point fractional number.
/// Counting rate is system clock frequency divided by this number.
/// Fractional division uses simple 1st-order sigma-delta.
pub const CH4_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050054),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(4, 12);
        pub const FRAC: u32 = helpers.generateMask(0, 4);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn INT(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 12),
            };
        }
        pub fn FRAC(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 4),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u8 {
            const mask = comptime helpers.generateMask(4, 12);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn FRAC(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn INT(v: u8) Value {
        return Value.INT(.{}, v);
    }
    pub fn FRAC(v: u4) Value {
        return Value.FRAC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Direct access to the PWM counter
pub const CH4_CTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050058),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u16) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Counter compare values
pub const CH4_CC = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005005c),
    pub const FieldMasks = struct {
        pub const B: u32 = helpers.generateMask(16, 32);
        pub const A: u32 = helpers.generateMask(0, 16);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn B(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        pub fn A(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn B(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn A(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn B(v: u16) Value {
        return Value.B(.{}, v);
    }
    pub fn A(v: u16) Value {
        return Value.A(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Counter wrap value
pub const CH4_TOP = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050060),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u16) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Control and status register
pub const CH5_CSR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050064),
    pub const FieldMasks = struct {
        pub const PH_ADV: u32 = helpers.generateMask(7, 8);
        pub const PH_RET: u32 = helpers.generateMask(6, 7);
        pub const DIVMODE: u32 = helpers.generateMask(4, 6);
        pub const B_INV: u32 = helpers.generateMask(3, 4);
        pub const A_INV: u32 = helpers.generateMask(2, 3);
        pub const PH_CORRECT: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const DIVMODE_e = enum(u2) {
        div = 0,
        level = 1,
        rise = 2,
        fall = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Advance the phase of the counter by 1 count, while it is running.
        /// Self-clearing. Write a 1, and poll until low. Counter must be running
        /// at less than full speed (div_int + div_frac / 16 &gt; 1)
        pub fn PH_ADV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Retard the phase of the counter by 1 count, while it is running.
        /// Self-clearing. Write a 1, and poll until low. Counter must be running.
        pub fn PH_RET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn DIVMODE(self: Value, v: DIVMODE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 6),
            };
        }
        /// Invert output B
        pub fn B_INV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Invert output A
        pub fn A_INV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// 1: Enable phase-correct modulation. 0: Trailing-edge
        pub fn PH_CORRECT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Enable the PWM channel.
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn DIVMODE(self: Result) DIVMODE_e {
            const mask = comptime helpers.generateMask(4, 6);
            const val: @typeInfo(DIVMODE_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn B_INV(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn A_INV(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn PH_CORRECT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Advance the phase of the counter by 1 count, while it is running.
    /// Self-clearing. Write a 1, and poll until low. Counter must be running
    /// at less than full speed (div_int + div_frac / 16 &gt; 1)
    pub fn PH_ADV(v: u1) Value {
        return Value.PH_ADV(.{}, v);
    }
    /// Retard the phase of the counter by 1 count, while it is running.
    /// Self-clearing. Write a 1, and poll until low. Counter must be running.
    pub fn PH_RET(v: u1) Value {
        return Value.PH_RET(.{}, v);
    }
    pub fn DIVMODE(v: DIVMODE_e) Value {
        return Value.DIVMODE(.{}, v);
    }
    /// Invert output B
    pub fn B_INV(v: u1) Value {
        return Value.B_INV(.{}, v);
    }
    /// Invert output A
    pub fn A_INV(v: u1) Value {
        return Value.A_INV(.{}, v);
    }
    /// 1: Enable phase-correct modulation. 0: Trailing-edge
    pub fn PH_CORRECT(v: u1) Value {
        return Value.PH_CORRECT(.{}, v);
    }
    /// Enable the PWM channel.
    pub fn EN(v: u1) Value {
        return Value.EN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// INT and FRAC form a fixed-point fractional number.
/// Counting rate is system clock frequency divided by this number.
/// Fractional division uses simple 1st-order sigma-delta.
pub const CH5_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050068),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(4, 12);
        pub const FRAC: u32 = helpers.generateMask(0, 4);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn INT(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 12),
            };
        }
        pub fn FRAC(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 4),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u8 {
            const mask = comptime helpers.generateMask(4, 12);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn FRAC(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn INT(v: u8) Value {
        return Value.INT(.{}, v);
    }
    pub fn FRAC(v: u4) Value {
        return Value.FRAC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Direct access to the PWM counter
pub const CH5_CTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005006c),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u16) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Counter compare values
pub const CH5_CC = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050070),
    pub const FieldMasks = struct {
        pub const B: u32 = helpers.generateMask(16, 32);
        pub const A: u32 = helpers.generateMask(0, 16);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn B(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        pub fn A(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn B(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn A(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn B(v: u16) Value {
        return Value.B(.{}, v);
    }
    pub fn A(v: u16) Value {
        return Value.A(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Counter wrap value
pub const CH5_TOP = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050074),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u16) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Control and status register
pub const CH6_CSR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050078),
    pub const FieldMasks = struct {
        pub const PH_ADV: u32 = helpers.generateMask(7, 8);
        pub const PH_RET: u32 = helpers.generateMask(6, 7);
        pub const DIVMODE: u32 = helpers.generateMask(4, 6);
        pub const B_INV: u32 = helpers.generateMask(3, 4);
        pub const A_INV: u32 = helpers.generateMask(2, 3);
        pub const PH_CORRECT: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const DIVMODE_e = enum(u2) {
        div = 0,
        level = 1,
        rise = 2,
        fall = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Advance the phase of the counter by 1 count, while it is running.
        /// Self-clearing. Write a 1, and poll until low. Counter must be running
        /// at less than full speed (div_int + div_frac / 16 &gt; 1)
        pub fn PH_ADV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Retard the phase of the counter by 1 count, while it is running.
        /// Self-clearing. Write a 1, and poll until low. Counter must be running.
        pub fn PH_RET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn DIVMODE(self: Value, v: DIVMODE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 6),
            };
        }
        /// Invert output B
        pub fn B_INV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Invert output A
        pub fn A_INV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// 1: Enable phase-correct modulation. 0: Trailing-edge
        pub fn PH_CORRECT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Enable the PWM channel.
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn DIVMODE(self: Result) DIVMODE_e {
            const mask = comptime helpers.generateMask(4, 6);
            const val: @typeInfo(DIVMODE_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn B_INV(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn A_INV(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn PH_CORRECT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Advance the phase of the counter by 1 count, while it is running.
    /// Self-clearing. Write a 1, and poll until low. Counter must be running
    /// at less than full speed (div_int + div_frac / 16 &gt; 1)
    pub fn PH_ADV(v: u1) Value {
        return Value.PH_ADV(.{}, v);
    }
    /// Retard the phase of the counter by 1 count, while it is running.
    /// Self-clearing. Write a 1, and poll until low. Counter must be running.
    pub fn PH_RET(v: u1) Value {
        return Value.PH_RET(.{}, v);
    }
    pub fn DIVMODE(v: DIVMODE_e) Value {
        return Value.DIVMODE(.{}, v);
    }
    /// Invert output B
    pub fn B_INV(v: u1) Value {
        return Value.B_INV(.{}, v);
    }
    /// Invert output A
    pub fn A_INV(v: u1) Value {
        return Value.A_INV(.{}, v);
    }
    /// 1: Enable phase-correct modulation. 0: Trailing-edge
    pub fn PH_CORRECT(v: u1) Value {
        return Value.PH_CORRECT(.{}, v);
    }
    /// Enable the PWM channel.
    pub fn EN(v: u1) Value {
        return Value.EN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// INT and FRAC form a fixed-point fractional number.
/// Counting rate is system clock frequency divided by this number.
/// Fractional division uses simple 1st-order sigma-delta.
pub const CH6_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005007c),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(4, 12);
        pub const FRAC: u32 = helpers.generateMask(0, 4);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn INT(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 12),
            };
        }
        pub fn FRAC(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 4),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u8 {
            const mask = comptime helpers.generateMask(4, 12);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn FRAC(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn INT(v: u8) Value {
        return Value.INT(.{}, v);
    }
    pub fn FRAC(v: u4) Value {
        return Value.FRAC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Direct access to the PWM counter
pub const CH6_CTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050080),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u16) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Counter compare values
pub const CH6_CC = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050084),
    pub const FieldMasks = struct {
        pub const B: u32 = helpers.generateMask(16, 32);
        pub const A: u32 = helpers.generateMask(0, 16);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn B(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        pub fn A(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn B(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn A(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn B(v: u16) Value {
        return Value.B(.{}, v);
    }
    pub fn A(v: u16) Value {
        return Value.A(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Counter wrap value
pub const CH6_TOP = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050088),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u16) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Control and status register
pub const CH7_CSR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005008c),
    pub const FieldMasks = struct {
        pub const PH_ADV: u32 = helpers.generateMask(7, 8);
        pub const PH_RET: u32 = helpers.generateMask(6, 7);
        pub const DIVMODE: u32 = helpers.generateMask(4, 6);
        pub const B_INV: u32 = helpers.generateMask(3, 4);
        pub const A_INV: u32 = helpers.generateMask(2, 3);
        pub const PH_CORRECT: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const DIVMODE_e = enum(u2) {
        div = 0,
        level = 1,
        rise = 2,
        fall = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Advance the phase of the counter by 1 count, while it is running.
        /// Self-clearing. Write a 1, and poll until low. Counter must be running
        /// at less than full speed (div_int + div_frac / 16 &gt; 1)
        pub fn PH_ADV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Retard the phase of the counter by 1 count, while it is running.
        /// Self-clearing. Write a 1, and poll until low. Counter must be running.
        pub fn PH_RET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn DIVMODE(self: Value, v: DIVMODE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 6),
            };
        }
        /// Invert output B
        pub fn B_INV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Invert output A
        pub fn A_INV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// 1: Enable phase-correct modulation. 0: Trailing-edge
        pub fn PH_CORRECT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Enable the PWM channel.
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn DIVMODE(self: Result) DIVMODE_e {
            const mask = comptime helpers.generateMask(4, 6);
            const val: @typeInfo(DIVMODE_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn B_INV(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn A_INV(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn PH_CORRECT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Advance the phase of the counter by 1 count, while it is running.
    /// Self-clearing. Write a 1, and poll until low. Counter must be running
    /// at less than full speed (div_int + div_frac / 16 &gt; 1)
    pub fn PH_ADV(v: u1) Value {
        return Value.PH_ADV(.{}, v);
    }
    /// Retard the phase of the counter by 1 count, while it is running.
    /// Self-clearing. Write a 1, and poll until low. Counter must be running.
    pub fn PH_RET(v: u1) Value {
        return Value.PH_RET(.{}, v);
    }
    pub fn DIVMODE(v: DIVMODE_e) Value {
        return Value.DIVMODE(.{}, v);
    }
    /// Invert output B
    pub fn B_INV(v: u1) Value {
        return Value.B_INV(.{}, v);
    }
    /// Invert output A
    pub fn A_INV(v: u1) Value {
        return Value.A_INV(.{}, v);
    }
    /// 1: Enable phase-correct modulation. 0: Trailing-edge
    pub fn PH_CORRECT(v: u1) Value {
        return Value.PH_CORRECT(.{}, v);
    }
    /// Enable the PWM channel.
    pub fn EN(v: u1) Value {
        return Value.EN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// INT and FRAC form a fixed-point fractional number.
/// Counting rate is system clock frequency divided by this number.
/// Fractional division uses simple 1st-order sigma-delta.
pub const CH7_DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050090),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(4, 12);
        pub const FRAC: u32 = helpers.generateMask(0, 4);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn INT(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 12),
            };
        }
        pub fn FRAC(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 4),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u8 {
            const mask = comptime helpers.generateMask(4, 12);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn FRAC(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn INT(v: u8) Value {
        return Value.INT(.{}, v);
    }
    pub fn FRAC(v: u4) Value {
        return Value.FRAC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Direct access to the PWM counter
pub const CH7_CTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050094),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u16) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Counter compare values
pub const CH7_CC = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40050098),
    pub const FieldMasks = struct {
        pub const B: u32 = helpers.generateMask(16, 32);
        pub const A: u32 = helpers.generateMask(0, 16);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn B(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        pub fn A(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn B(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn A(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn B(v: u16) Value {
        return Value.B(.{}, v);
    }
    pub fn A(v: u16) Value {
        return Value.A(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Counter wrap value
pub const CH7_TOP = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005009c),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u16) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// This register aliases the CSR_EN bits for all channels.
/// Writing to this register allows multiple channels to be enabled
/// or disabled simultaneously, so they can run in perfect sync.
/// For each channel, there is only one physical EN register bit,
/// which can be accessed through here or CHx_CSR.
pub const EN = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400500a0),
    pub const FieldMasks = struct {
        pub const CH7: u32 = helpers.generateMask(7, 8);
        pub const CH6: u32 = helpers.generateMask(6, 7);
        pub const CH5: u32 = helpers.generateMask(5, 6);
        pub const CH4: u32 = helpers.generateMask(4, 5);
        pub const CH3: u32 = helpers.generateMask(3, 4);
        pub const CH2: u32 = helpers.generateMask(2, 3);
        pub const CH1: u32 = helpers.generateMask(1, 2);
        pub const CH0: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn CH7(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn CH6(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn CH5(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn CH4(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn CH3(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn CH2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn CH1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn CH0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn CH7(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn CH6(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn CH5(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn CH4(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn CH3(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn CH2(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn CH1(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn CH0(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn CH7(v: u1) Value {
        return Value.CH7(.{}, v);
    }
    pub fn CH6(v: u1) Value {
        return Value.CH6(.{}, v);
    }
    pub fn CH5(v: u1) Value {
        return Value.CH5(.{}, v);
    }
    pub fn CH4(v: u1) Value {
        return Value.CH4(.{}, v);
    }
    pub fn CH3(v: u1) Value {
        return Value.CH3(.{}, v);
    }
    pub fn CH2(v: u1) Value {
        return Value.CH2(.{}, v);
    }
    pub fn CH1(v: u1) Value {
        return Value.CH1(.{}, v);
    }
    pub fn CH0(v: u1) Value {
        return Value.CH0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Raw Interrupts
pub const INTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400500a4),
    pub const FieldMasks = struct {
        pub const CH7: u32 = helpers.generateMask(7, 8);
        pub const CH6: u32 = helpers.generateMask(6, 7);
        pub const CH5: u32 = helpers.generateMask(5, 6);
        pub const CH4: u32 = helpers.generateMask(4, 5);
        pub const CH3: u32 = helpers.generateMask(3, 4);
        pub const CH2: u32 = helpers.generateMask(2, 3);
        pub const CH1: u32 = helpers.generateMask(1, 2);
        pub const CH0: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn CH7(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn CH6(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn CH5(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn CH4(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn CH3(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn CH2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn CH1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn CH0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn CH7(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn CH6(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn CH5(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn CH4(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn CH3(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn CH2(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn CH1(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn CH0(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn CH7(v: u1) Value {
        return Value.CH7(.{}, v);
    }
    pub fn CH6(v: u1) Value {
        return Value.CH6(.{}, v);
    }
    pub fn CH5(v: u1) Value {
        return Value.CH5(.{}, v);
    }
    pub fn CH4(v: u1) Value {
        return Value.CH4(.{}, v);
    }
    pub fn CH3(v: u1) Value {
        return Value.CH3(.{}, v);
    }
    pub fn CH2(v: u1) Value {
        return Value.CH2(.{}, v);
    }
    pub fn CH1(v: u1) Value {
        return Value.CH1(.{}, v);
    }
    pub fn CH0(v: u1) Value {
        return Value.CH0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Enable
pub const INTE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400500a8),
    pub const FieldMasks = struct {
        pub const CH7: u32 = helpers.generateMask(7, 8);
        pub const CH6: u32 = helpers.generateMask(6, 7);
        pub const CH5: u32 = helpers.generateMask(5, 6);
        pub const CH4: u32 = helpers.generateMask(4, 5);
        pub const CH3: u32 = helpers.generateMask(3, 4);
        pub const CH2: u32 = helpers.generateMask(2, 3);
        pub const CH1: u32 = helpers.generateMask(1, 2);
        pub const CH0: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn CH7(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn CH6(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn CH5(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn CH4(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn CH3(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn CH2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn CH1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn CH0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn CH7(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn CH6(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn CH5(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn CH4(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn CH3(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn CH2(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn CH1(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn CH0(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn CH7(v: u1) Value {
        return Value.CH7(.{}, v);
    }
    pub fn CH6(v: u1) Value {
        return Value.CH6(.{}, v);
    }
    pub fn CH5(v: u1) Value {
        return Value.CH5(.{}, v);
    }
    pub fn CH4(v: u1) Value {
        return Value.CH4(.{}, v);
    }
    pub fn CH3(v: u1) Value {
        return Value.CH3(.{}, v);
    }
    pub fn CH2(v: u1) Value {
        return Value.CH2(.{}, v);
    }
    pub fn CH1(v: u1) Value {
        return Value.CH1(.{}, v);
    }
    pub fn CH0(v: u1) Value {
        return Value.CH0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Force
pub const INTF = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400500ac),
    pub const FieldMasks = struct {
        pub const CH7: u32 = helpers.generateMask(7, 8);
        pub const CH6: u32 = helpers.generateMask(6, 7);
        pub const CH5: u32 = helpers.generateMask(5, 6);
        pub const CH4: u32 = helpers.generateMask(4, 5);
        pub const CH3: u32 = helpers.generateMask(3, 4);
        pub const CH2: u32 = helpers.generateMask(2, 3);
        pub const CH1: u32 = helpers.generateMask(1, 2);
        pub const CH0: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn CH7(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn CH6(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn CH5(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn CH4(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn CH3(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn CH2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn CH1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn CH0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn CH7(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn CH6(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn CH5(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn CH4(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn CH3(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn CH2(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn CH1(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn CH0(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn CH7(v: u1) Value {
        return Value.CH7(.{}, v);
    }
    pub fn CH6(v: u1) Value {
        return Value.CH6(.{}, v);
    }
    pub fn CH5(v: u1) Value {
        return Value.CH5(.{}, v);
    }
    pub fn CH4(v: u1) Value {
        return Value.CH4(.{}, v);
    }
    pub fn CH3(v: u1) Value {
        return Value.CH3(.{}, v);
    }
    pub fn CH2(v: u1) Value {
        return Value.CH2(.{}, v);
    }
    pub fn CH1(v: u1) Value {
        return Value.CH1(.{}, v);
    }
    pub fn CH0(v: u1) Value {
        return Value.CH0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt status after masking &amp; forcing
pub const INTS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400500b0),
    pub const FieldMasks = struct {
        pub const CH7: u32 = helpers.generateMask(7, 8);
        pub const CH6: u32 = helpers.generateMask(6, 7);
        pub const CH5: u32 = helpers.generateMask(5, 6);
        pub const CH4: u32 = helpers.generateMask(4, 5);
        pub const CH3: u32 = helpers.generateMask(3, 4);
        pub const CH2: u32 = helpers.generateMask(2, 3);
        pub const CH1: u32 = helpers.generateMask(1, 2);
        pub const CH0: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn CH7(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn CH6(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn CH5(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn CH4(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn CH3(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn CH2(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn CH1(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn CH0(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Simple PWM
pub const PWM_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x40050000),

    /// Control and status register
    CH0_CSR: CH0_CSR = .{},
    /// INT and FRAC form a fixed-point fractional number.
    /// Counting rate is system clock frequency divided by this number.
    /// Fractional division uses simple 1st-order sigma-delta.
    CH0_DIV: CH0_DIV = .{},
    /// Direct access to the PWM counter
    CH0_CTR: CH0_CTR = .{},
    /// Counter compare values
    CH0_CC: CH0_CC = .{},
    /// Counter wrap value
    CH0_TOP: CH0_TOP = .{},
    /// Control and status register
    CH1_CSR: CH1_CSR = .{},
    /// INT and FRAC form a fixed-point fractional number.
    /// Counting rate is system clock frequency divided by this number.
    /// Fractional division uses simple 1st-order sigma-delta.
    CH1_DIV: CH1_DIV = .{},
    /// Direct access to the PWM counter
    CH1_CTR: CH1_CTR = .{},
    /// Counter compare values
    CH1_CC: CH1_CC = .{},
    /// Counter wrap value
    CH1_TOP: CH1_TOP = .{},
    /// Control and status register
    CH2_CSR: CH2_CSR = .{},
    /// INT and FRAC form a fixed-point fractional number.
    /// Counting rate is system clock frequency divided by this number.
    /// Fractional division uses simple 1st-order sigma-delta.
    CH2_DIV: CH2_DIV = .{},
    /// Direct access to the PWM counter
    CH2_CTR: CH2_CTR = .{},
    /// Counter compare values
    CH2_CC: CH2_CC = .{},
    /// Counter wrap value
    CH2_TOP: CH2_TOP = .{},
    /// Control and status register
    CH3_CSR: CH3_CSR = .{},
    /// INT and FRAC form a fixed-point fractional number.
    /// Counting rate is system clock frequency divided by this number.
    /// Fractional division uses simple 1st-order sigma-delta.
    CH3_DIV: CH3_DIV = .{},
    /// Direct access to the PWM counter
    CH3_CTR: CH3_CTR = .{},
    /// Counter compare values
    CH3_CC: CH3_CC = .{},
    /// Counter wrap value
    CH3_TOP: CH3_TOP = .{},
    /// Control and status register
    CH4_CSR: CH4_CSR = .{},
    /// INT and FRAC form a fixed-point fractional number.
    /// Counting rate is system clock frequency divided by this number.
    /// Fractional division uses simple 1st-order sigma-delta.
    CH4_DIV: CH4_DIV = .{},
    /// Direct access to the PWM counter
    CH4_CTR: CH4_CTR = .{},
    /// Counter compare values
    CH4_CC: CH4_CC = .{},
    /// Counter wrap value
    CH4_TOP: CH4_TOP = .{},
    /// Control and status register
    CH5_CSR: CH5_CSR = .{},
    /// INT and FRAC form a fixed-point fractional number.
    /// Counting rate is system clock frequency divided by this number.
    /// Fractional division uses simple 1st-order sigma-delta.
    CH5_DIV: CH5_DIV = .{},
    /// Direct access to the PWM counter
    CH5_CTR: CH5_CTR = .{},
    /// Counter compare values
    CH5_CC: CH5_CC = .{},
    /// Counter wrap value
    CH5_TOP: CH5_TOP = .{},
    /// Control and status register
    CH6_CSR: CH6_CSR = .{},
    /// INT and FRAC form a fixed-point fractional number.
    /// Counting rate is system clock frequency divided by this number.
    /// Fractional division uses simple 1st-order sigma-delta.
    CH6_DIV: CH6_DIV = .{},
    /// Direct access to the PWM counter
    CH6_CTR: CH6_CTR = .{},
    /// Counter compare values
    CH6_CC: CH6_CC = .{},
    /// Counter wrap value
    CH6_TOP: CH6_TOP = .{},
    /// Control and status register
    CH7_CSR: CH7_CSR = .{},
    /// INT and FRAC form a fixed-point fractional number.
    /// Counting rate is system clock frequency divided by this number.
    /// Fractional division uses simple 1st-order sigma-delta.
    CH7_DIV: CH7_DIV = .{},
    /// Direct access to the PWM counter
    CH7_CTR: CH7_CTR = .{},
    /// Counter compare values
    CH7_CC: CH7_CC = .{},
    /// Counter wrap value
    CH7_TOP: CH7_TOP = .{},
    /// This register aliases the CSR_EN bits for all channels.
    /// Writing to this register allows multiple channels to be enabled
    /// or disabled simultaneously, so they can run in perfect sync.
    /// For each channel, there is only one physical EN register bit,
    /// which can be accessed through here or CHx_CSR.
    EN: EN = .{},
    /// Raw Interrupts
    INTR: INTR = .{},
    /// Interrupt Enable
    INTE: INTE = .{},
    /// Interrupt Force
    INTF: INTF = .{},
    /// Interrupt status after masking &amp; forcing
    INTS: INTS = .{},
};
pub const PWM = PWM_p{};
