const helpers = @import("helpers.zig");
/// Voltage select. Per bank control
pub const VOLTAGE_SELECT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40020000),
    const VOLTAGE_SELECT_e = enum(u1) {
        @"3v3" = 0,
        @"1v8" = 1,
    };
    pub fn write(self: @This(), v: VOLTAGE_SELECT_e) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(@intFromEnum(v)) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: VOLTAGE_SELECT_e) void {
        self.reg.* = (helpers.toU32(@intFromEnum(v)) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) VOLTAGE_SELECT_e {
        const mask = comptime helpers.generateMask(0, 1);
        return @enumFromInt((self.reg.* & mask) >> 0);
    }
};
/// Pad control register
pub const GPIO_QSPI_SCLK = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40020004),
    pub const FieldMasks = struct {
        pub const OD: u32 = helpers.generateMask(7, 8);
        pub const IE: u32 = helpers.generateMask(6, 7);
        pub const DRIVE: u32 = helpers.generateMask(4, 6);
        pub const PUE: u32 = helpers.generateMask(3, 4);
        pub const PDE: u32 = helpers.generateMask(2, 3);
        pub const SCHMITT: u32 = helpers.generateMask(1, 2);
        pub const SLEWFAST: u32 = helpers.generateMask(0, 1);
    };
    const DRIVE_e = enum(u2) {
        @"2mA" = 0,
        @"4mA" = 1,
        @"8mA" = 2,
        @"12mA" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Output disable. Has priority over output enable from peripherals
        pub fn OD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Input enable
        pub fn IE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// Drive strength.
        pub fn DRIVE(self: Value, v: DRIVE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 6),
            };
        }
        /// Pull up enable
        pub fn PUE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Pull down enable
        pub fn PDE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Enable schmitt trigger
        pub fn SCHMITT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Slew rate control. 1 = Fast, 0 = Slow
        pub fn SLEWFAST(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn OD(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn IE(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn DRIVE(self: Result) DRIVE_e {
            const mask = comptime helpers.generateMask(4, 6);
            const val: @typeInfo(DRIVE_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn PUE(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn PDE(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SCHMITT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn SLEWFAST(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Output disable. Has priority over output enable from peripherals
    pub fn OD(v: u1) Value {
        return Value.OD(.{}, v);
    }
    /// Input enable
    pub fn IE(v: u1) Value {
        return Value.IE(.{}, v);
    }
    /// Drive strength.
    pub fn DRIVE(v: DRIVE_e) Value {
        return Value.DRIVE(.{}, v);
    }
    /// Pull up enable
    pub fn PUE(v: u1) Value {
        return Value.PUE(.{}, v);
    }
    /// Pull down enable
    pub fn PDE(v: u1) Value {
        return Value.PDE(.{}, v);
    }
    /// Enable schmitt trigger
    pub fn SCHMITT(v: u1) Value {
        return Value.SCHMITT(.{}, v);
    }
    /// Slew rate control. 1 = Fast, 0 = Slow
    pub fn SLEWFAST(v: u1) Value {
        return Value.SLEWFAST(.{}, v);
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
/// Pad control register
pub const GPIO_QSPI_SD0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40020008),
    pub const FieldMasks = struct {
        pub const OD: u32 = helpers.generateMask(7, 8);
        pub const IE: u32 = helpers.generateMask(6, 7);
        pub const DRIVE: u32 = helpers.generateMask(4, 6);
        pub const PUE: u32 = helpers.generateMask(3, 4);
        pub const PDE: u32 = helpers.generateMask(2, 3);
        pub const SCHMITT: u32 = helpers.generateMask(1, 2);
        pub const SLEWFAST: u32 = helpers.generateMask(0, 1);
    };
    const DRIVE_e = enum(u2) {
        @"2mA" = 0,
        @"4mA" = 1,
        @"8mA" = 2,
        @"12mA" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Output disable. Has priority over output enable from peripherals
        pub fn OD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Input enable
        pub fn IE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// Drive strength.
        pub fn DRIVE(self: Value, v: DRIVE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 6),
            };
        }
        /// Pull up enable
        pub fn PUE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Pull down enable
        pub fn PDE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Enable schmitt trigger
        pub fn SCHMITT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Slew rate control. 1 = Fast, 0 = Slow
        pub fn SLEWFAST(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn OD(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn IE(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn DRIVE(self: Result) DRIVE_e {
            const mask = comptime helpers.generateMask(4, 6);
            const val: @typeInfo(DRIVE_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn PUE(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn PDE(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SCHMITT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn SLEWFAST(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Output disable. Has priority over output enable from peripherals
    pub fn OD(v: u1) Value {
        return Value.OD(.{}, v);
    }
    /// Input enable
    pub fn IE(v: u1) Value {
        return Value.IE(.{}, v);
    }
    /// Drive strength.
    pub fn DRIVE(v: DRIVE_e) Value {
        return Value.DRIVE(.{}, v);
    }
    /// Pull up enable
    pub fn PUE(v: u1) Value {
        return Value.PUE(.{}, v);
    }
    /// Pull down enable
    pub fn PDE(v: u1) Value {
        return Value.PDE(.{}, v);
    }
    /// Enable schmitt trigger
    pub fn SCHMITT(v: u1) Value {
        return Value.SCHMITT(.{}, v);
    }
    /// Slew rate control. 1 = Fast, 0 = Slow
    pub fn SLEWFAST(v: u1) Value {
        return Value.SLEWFAST(.{}, v);
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
/// Pad control register
pub const GPIO_QSPI_SD1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4002000c),
    pub const FieldMasks = struct {
        pub const OD: u32 = helpers.generateMask(7, 8);
        pub const IE: u32 = helpers.generateMask(6, 7);
        pub const DRIVE: u32 = helpers.generateMask(4, 6);
        pub const PUE: u32 = helpers.generateMask(3, 4);
        pub const PDE: u32 = helpers.generateMask(2, 3);
        pub const SCHMITT: u32 = helpers.generateMask(1, 2);
        pub const SLEWFAST: u32 = helpers.generateMask(0, 1);
    };
    const DRIVE_e = enum(u2) {
        @"2mA" = 0,
        @"4mA" = 1,
        @"8mA" = 2,
        @"12mA" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Output disable. Has priority over output enable from peripherals
        pub fn OD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Input enable
        pub fn IE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// Drive strength.
        pub fn DRIVE(self: Value, v: DRIVE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 6),
            };
        }
        /// Pull up enable
        pub fn PUE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Pull down enable
        pub fn PDE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Enable schmitt trigger
        pub fn SCHMITT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Slew rate control. 1 = Fast, 0 = Slow
        pub fn SLEWFAST(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn OD(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn IE(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn DRIVE(self: Result) DRIVE_e {
            const mask = comptime helpers.generateMask(4, 6);
            const val: @typeInfo(DRIVE_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn PUE(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn PDE(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SCHMITT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn SLEWFAST(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Output disable. Has priority over output enable from peripherals
    pub fn OD(v: u1) Value {
        return Value.OD(.{}, v);
    }
    /// Input enable
    pub fn IE(v: u1) Value {
        return Value.IE(.{}, v);
    }
    /// Drive strength.
    pub fn DRIVE(v: DRIVE_e) Value {
        return Value.DRIVE(.{}, v);
    }
    /// Pull up enable
    pub fn PUE(v: u1) Value {
        return Value.PUE(.{}, v);
    }
    /// Pull down enable
    pub fn PDE(v: u1) Value {
        return Value.PDE(.{}, v);
    }
    /// Enable schmitt trigger
    pub fn SCHMITT(v: u1) Value {
        return Value.SCHMITT(.{}, v);
    }
    /// Slew rate control. 1 = Fast, 0 = Slow
    pub fn SLEWFAST(v: u1) Value {
        return Value.SLEWFAST(.{}, v);
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
/// Pad control register
pub const GPIO_QSPI_SD2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40020010),
    pub const FieldMasks = struct {
        pub const OD: u32 = helpers.generateMask(7, 8);
        pub const IE: u32 = helpers.generateMask(6, 7);
        pub const DRIVE: u32 = helpers.generateMask(4, 6);
        pub const PUE: u32 = helpers.generateMask(3, 4);
        pub const PDE: u32 = helpers.generateMask(2, 3);
        pub const SCHMITT: u32 = helpers.generateMask(1, 2);
        pub const SLEWFAST: u32 = helpers.generateMask(0, 1);
    };
    const DRIVE_e = enum(u2) {
        @"2mA" = 0,
        @"4mA" = 1,
        @"8mA" = 2,
        @"12mA" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Output disable. Has priority over output enable from peripherals
        pub fn OD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Input enable
        pub fn IE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// Drive strength.
        pub fn DRIVE(self: Value, v: DRIVE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 6),
            };
        }
        /// Pull up enable
        pub fn PUE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Pull down enable
        pub fn PDE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Enable schmitt trigger
        pub fn SCHMITT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Slew rate control. 1 = Fast, 0 = Slow
        pub fn SLEWFAST(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn OD(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn IE(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn DRIVE(self: Result) DRIVE_e {
            const mask = comptime helpers.generateMask(4, 6);
            const val: @typeInfo(DRIVE_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn PUE(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn PDE(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SCHMITT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn SLEWFAST(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Output disable. Has priority over output enable from peripherals
    pub fn OD(v: u1) Value {
        return Value.OD(.{}, v);
    }
    /// Input enable
    pub fn IE(v: u1) Value {
        return Value.IE(.{}, v);
    }
    /// Drive strength.
    pub fn DRIVE(v: DRIVE_e) Value {
        return Value.DRIVE(.{}, v);
    }
    /// Pull up enable
    pub fn PUE(v: u1) Value {
        return Value.PUE(.{}, v);
    }
    /// Pull down enable
    pub fn PDE(v: u1) Value {
        return Value.PDE(.{}, v);
    }
    /// Enable schmitt trigger
    pub fn SCHMITT(v: u1) Value {
        return Value.SCHMITT(.{}, v);
    }
    /// Slew rate control. 1 = Fast, 0 = Slow
    pub fn SLEWFAST(v: u1) Value {
        return Value.SLEWFAST(.{}, v);
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
/// Pad control register
pub const GPIO_QSPI_SD3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40020014),
    pub const FieldMasks = struct {
        pub const OD: u32 = helpers.generateMask(7, 8);
        pub const IE: u32 = helpers.generateMask(6, 7);
        pub const DRIVE: u32 = helpers.generateMask(4, 6);
        pub const PUE: u32 = helpers.generateMask(3, 4);
        pub const PDE: u32 = helpers.generateMask(2, 3);
        pub const SCHMITT: u32 = helpers.generateMask(1, 2);
        pub const SLEWFAST: u32 = helpers.generateMask(0, 1);
    };
    const DRIVE_e = enum(u2) {
        @"2mA" = 0,
        @"4mA" = 1,
        @"8mA" = 2,
        @"12mA" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Output disable. Has priority over output enable from peripherals
        pub fn OD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Input enable
        pub fn IE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// Drive strength.
        pub fn DRIVE(self: Value, v: DRIVE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 6),
            };
        }
        /// Pull up enable
        pub fn PUE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Pull down enable
        pub fn PDE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Enable schmitt trigger
        pub fn SCHMITT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Slew rate control. 1 = Fast, 0 = Slow
        pub fn SLEWFAST(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn OD(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn IE(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn DRIVE(self: Result) DRIVE_e {
            const mask = comptime helpers.generateMask(4, 6);
            const val: @typeInfo(DRIVE_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn PUE(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn PDE(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SCHMITT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn SLEWFAST(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Output disable. Has priority over output enable from peripherals
    pub fn OD(v: u1) Value {
        return Value.OD(.{}, v);
    }
    /// Input enable
    pub fn IE(v: u1) Value {
        return Value.IE(.{}, v);
    }
    /// Drive strength.
    pub fn DRIVE(v: DRIVE_e) Value {
        return Value.DRIVE(.{}, v);
    }
    /// Pull up enable
    pub fn PUE(v: u1) Value {
        return Value.PUE(.{}, v);
    }
    /// Pull down enable
    pub fn PDE(v: u1) Value {
        return Value.PDE(.{}, v);
    }
    /// Enable schmitt trigger
    pub fn SCHMITT(v: u1) Value {
        return Value.SCHMITT(.{}, v);
    }
    /// Slew rate control. 1 = Fast, 0 = Slow
    pub fn SLEWFAST(v: u1) Value {
        return Value.SLEWFAST(.{}, v);
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
/// Pad control register
pub const GPIO_QSPI_SS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40020018),
    pub const FieldMasks = struct {
        pub const OD: u32 = helpers.generateMask(7, 8);
        pub const IE: u32 = helpers.generateMask(6, 7);
        pub const DRIVE: u32 = helpers.generateMask(4, 6);
        pub const PUE: u32 = helpers.generateMask(3, 4);
        pub const PDE: u32 = helpers.generateMask(2, 3);
        pub const SCHMITT: u32 = helpers.generateMask(1, 2);
        pub const SLEWFAST: u32 = helpers.generateMask(0, 1);
    };
    const DRIVE_e = enum(u2) {
        @"2mA" = 0,
        @"4mA" = 1,
        @"8mA" = 2,
        @"12mA" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Output disable. Has priority over output enable from peripherals
        pub fn OD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Input enable
        pub fn IE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// Drive strength.
        pub fn DRIVE(self: Value, v: DRIVE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 6),
            };
        }
        /// Pull up enable
        pub fn PUE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Pull down enable
        pub fn PDE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Enable schmitt trigger
        pub fn SCHMITT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Slew rate control. 1 = Fast, 0 = Slow
        pub fn SLEWFAST(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn OD(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn IE(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn DRIVE(self: Result) DRIVE_e {
            const mask = comptime helpers.generateMask(4, 6);
            const val: @typeInfo(DRIVE_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn PUE(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn PDE(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SCHMITT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn SLEWFAST(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Output disable. Has priority over output enable from peripherals
    pub fn OD(v: u1) Value {
        return Value.OD(.{}, v);
    }
    /// Input enable
    pub fn IE(v: u1) Value {
        return Value.IE(.{}, v);
    }
    /// Drive strength.
    pub fn DRIVE(v: DRIVE_e) Value {
        return Value.DRIVE(.{}, v);
    }
    /// Pull up enable
    pub fn PUE(v: u1) Value {
        return Value.PUE(.{}, v);
    }
    /// Pull down enable
    pub fn PDE(v: u1) Value {
        return Value.PDE(.{}, v);
    }
    /// Enable schmitt trigger
    pub fn SCHMITT(v: u1) Value {
        return Value.SCHMITT(.{}, v);
    }
    /// Slew rate control. 1 = Fast, 0 = Slow
    pub fn SLEWFAST(v: u1) Value {
        return Value.SLEWFAST(.{}, v);
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
pub const PADS_QSPI_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x40020000),

    /// Voltage select. Per bank control
    VOLTAGE_SELECT: VOLTAGE_SELECT = .{},
    /// Pad control register
    GPIO_QSPI_SCLK: GPIO_QSPI_SCLK = .{},
    /// Pad control register
    GPIO_QSPI_SD0: GPIO_QSPI_SD0 = .{},
    /// Pad control register
    GPIO_QSPI_SD1: GPIO_QSPI_SD1 = .{},
    /// Pad control register
    GPIO_QSPI_SD2: GPIO_QSPI_SD2 = .{},
    /// Pad control register
    GPIO_QSPI_SD3: GPIO_QSPI_SD3 = .{},
    /// Pad control register
    GPIO_QSPI_SS: GPIO_QSPI_SS = .{},
};
pub const PADS_QSPI = PADS_QSPI_p{};
