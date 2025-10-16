const helpers = @import("helpers.zig");
/// Voltage select. Per bank control
pub const VOLTAGE_SELECT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c000),
    const VOLTAGE_SELECT_e = enum(u1) {
        @"3v3" = 0,
        @"1v8" = 1,
    };
    pub fn write(self: @This(), v: VOLTAGE_SELECT_e) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(@intFromEnum(v)) << 0, mask);
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
pub const GPIO0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c004),
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
pub const GPIO1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c008),
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
pub const GPIO2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c00c),
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
pub const GPIO3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c010),
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
pub const GPIO4 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c014),
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
pub const GPIO5 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c018),
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
pub const GPIO6 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c01c),
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
pub const GPIO7 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c020),
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
pub const GPIO8 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c024),
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
pub const GPIO9 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c028),
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
pub const GPIO10 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c02c),
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
pub const GPIO11 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c030),
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
pub const GPIO12 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c034),
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
pub const GPIO13 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c038),
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
pub const GPIO14 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c03c),
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
pub const GPIO15 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c040),
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
pub const GPIO16 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c044),
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
pub const GPIO17 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c048),
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
pub const GPIO18 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c04c),
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
pub const GPIO19 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c050),
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
pub const GPIO20 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c054),
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
pub const GPIO21 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c058),
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
pub const GPIO22 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c05c),
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
pub const GPIO23 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c060),
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
pub const GPIO24 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c064),
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
pub const GPIO25 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c068),
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
pub const GPIO26 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c06c),
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
pub const GPIO27 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c070),
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
pub const GPIO28 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c074),
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
pub const GPIO29 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c078),
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
pub const SWCLK = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c07c),
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
pub const SWD = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001c080),
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
pub const PADS_BANK0_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x4001c000),

    /// Voltage select. Per bank control
    VOLTAGE_SELECT: VOLTAGE_SELECT = .{},
    /// Pad control register
    GPIO0: GPIO0 = .{},
    /// Pad control register
    GPIO1: GPIO1 = .{},
    /// Pad control register
    GPIO2: GPIO2 = .{},
    /// Pad control register
    GPIO3: GPIO3 = .{},
    /// Pad control register
    GPIO4: GPIO4 = .{},
    /// Pad control register
    GPIO5: GPIO5 = .{},
    /// Pad control register
    GPIO6: GPIO6 = .{},
    /// Pad control register
    GPIO7: GPIO7 = .{},
    /// Pad control register
    GPIO8: GPIO8 = .{},
    /// Pad control register
    GPIO9: GPIO9 = .{},
    /// Pad control register
    GPIO10: GPIO10 = .{},
    /// Pad control register
    GPIO11: GPIO11 = .{},
    /// Pad control register
    GPIO12: GPIO12 = .{},
    /// Pad control register
    GPIO13: GPIO13 = .{},
    /// Pad control register
    GPIO14: GPIO14 = .{},
    /// Pad control register
    GPIO15: GPIO15 = .{},
    /// Pad control register
    GPIO16: GPIO16 = .{},
    /// Pad control register
    GPIO17: GPIO17 = .{},
    /// Pad control register
    GPIO18: GPIO18 = .{},
    /// Pad control register
    GPIO19: GPIO19 = .{},
    /// Pad control register
    GPIO20: GPIO20 = .{},
    /// Pad control register
    GPIO21: GPIO21 = .{},
    /// Pad control register
    GPIO22: GPIO22 = .{},
    /// Pad control register
    GPIO23: GPIO23 = .{},
    /// Pad control register
    GPIO24: GPIO24 = .{},
    /// Pad control register
    GPIO25: GPIO25 = .{},
    /// Pad control register
    GPIO26: GPIO26 = .{},
    /// Pad control register
    GPIO27: GPIO27 = .{},
    /// Pad control register
    GPIO28: GPIO28 = .{},
    /// Pad control register
    GPIO29: GPIO29 = .{},
    /// Pad control register
    SWCLK: SWCLK = .{},
    /// Pad control register
    SWD: SWD = .{},
};
pub const PADS_BANK0 = PADS_BANK0_p{};
