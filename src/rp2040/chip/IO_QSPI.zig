const helpers = @import("helpers.zig");
/// GPIO status
pub const GPIO_QSPI_SCLK_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40018000),
    pub const FieldMasks = struct {
        pub const IRQTOPROC: u32 = helpers.generateMask(26, 27);
        pub const IRQFROMPAD: u32 = helpers.generateMask(24, 25);
        pub const INTOPERI: u32 = helpers.generateMask(19, 20);
        pub const INFROMPAD: u32 = helpers.generateMask(17, 18);
        pub const OETOPAD: u32 = helpers.generateMask(13, 14);
        pub const OEFROMPERI: u32 = helpers.generateMask(12, 13);
        pub const OUTTOPAD: u32 = helpers.generateMask(9, 10);
        pub const OUTFROMPERI: u32 = helpers.generateMask(8, 9);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn IRQTOPROC(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn IRQFROMPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn INTOPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn INFROMPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn OETOPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn OEFROMPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn OUTTOPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn OUTFROMPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
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
/// GPIO control including function select and overrides.
pub const GPIO_QSPI_SCLK_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40018004),
    pub const FieldMasks = struct {
        pub const IRQOVER: u32 = helpers.generateMask(28, 30);
        pub const INOVER: u32 = helpers.generateMask(16, 18);
        pub const OEOVER: u32 = helpers.generateMask(12, 14);
        pub const OUTOVER: u32 = helpers.generateMask(8, 10);
        pub const FUNCSEL: u32 = helpers.generateMask(0, 5);
    };
    const IRQOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const INOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const OEOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        DISABLE = 2,
        ENABLE = 3,
    };
    const OUTOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const FUNCSEL_e = enum(u5) {
        xip_sclk = 0,
        sio_30 = 5,
        null = 31,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn IRQOVER(self: Value, v: IRQOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 30),
            };
        }
        pub fn INOVER(self: Value, v: INOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 18),
            };
        }
        pub fn OEOVER(self: Value, v: OEOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 14),
            };
        }
        pub fn OUTOVER(self: Value, v: OUTOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 10),
            };
        }
        /// 0-31 -&gt; selects pin function according to the gpio table
        /// 31 == NULL
        pub fn FUNCSEL(self: Value, v: FUNCSEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 5),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn IRQOVER(self: Result) IRQOVER_e {
            const mask = comptime helpers.generateMask(28, 30);
            const val: @typeInfo(IRQOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 28);
            return @enumFromInt(val);
        }
        pub fn INOVER(self: Result) INOVER_e {
            const mask = comptime helpers.generateMask(16, 18);
            const val: @typeInfo(INOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 16);
            return @enumFromInt(val);
        }
        pub fn OEOVER(self: Result) OEOVER_e {
            const mask = comptime helpers.generateMask(12, 14);
            const val: @typeInfo(OEOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 12);
            return @enumFromInt(val);
        }
        pub fn OUTOVER(self: Result) OUTOVER_e {
            const mask = comptime helpers.generateMask(8, 10);
            const val: @typeInfo(OUTOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 8);
            return @enumFromInt(val);
        }
        pub fn FUNCSEL(self: Result) FUNCSEL_e {
            const mask = comptime helpers.generateMask(0, 5);
            const val: @typeInfo(FUNCSEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
        }
    };
    pub fn IRQOVER(v: IRQOVER_e) Value {
        return Value.IRQOVER(.{}, v);
    }
    pub fn INOVER(v: INOVER_e) Value {
        return Value.INOVER(.{}, v);
    }
    pub fn OEOVER(v: OEOVER_e) Value {
        return Value.OEOVER(.{}, v);
    }
    pub fn OUTOVER(v: OUTOVER_e) Value {
        return Value.OUTOVER(.{}, v);
    }
    /// 0-31 -&gt; selects pin function according to the gpio table
    /// 31 == NULL
    pub fn FUNCSEL(v: FUNCSEL_e) Value {
        return Value.FUNCSEL(.{}, v);
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
/// GPIO status
pub const GPIO_QSPI_SS_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40018008),
    pub const FieldMasks = struct {
        pub const IRQTOPROC: u32 = helpers.generateMask(26, 27);
        pub const IRQFROMPAD: u32 = helpers.generateMask(24, 25);
        pub const INTOPERI: u32 = helpers.generateMask(19, 20);
        pub const INFROMPAD: u32 = helpers.generateMask(17, 18);
        pub const OETOPAD: u32 = helpers.generateMask(13, 14);
        pub const OEFROMPERI: u32 = helpers.generateMask(12, 13);
        pub const OUTTOPAD: u32 = helpers.generateMask(9, 10);
        pub const OUTFROMPERI: u32 = helpers.generateMask(8, 9);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn IRQTOPROC(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn IRQFROMPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn INTOPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn INFROMPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn OETOPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn OEFROMPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn OUTTOPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn OUTFROMPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
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
/// GPIO control including function select and overrides.
pub const GPIO_QSPI_SS_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001800c),
    pub const FieldMasks = struct {
        pub const IRQOVER: u32 = helpers.generateMask(28, 30);
        pub const INOVER: u32 = helpers.generateMask(16, 18);
        pub const OEOVER: u32 = helpers.generateMask(12, 14);
        pub const OUTOVER: u32 = helpers.generateMask(8, 10);
        pub const FUNCSEL: u32 = helpers.generateMask(0, 5);
    };
    const IRQOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const INOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const OEOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        DISABLE = 2,
        ENABLE = 3,
    };
    const OUTOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const FUNCSEL_e = enum(u5) {
        xip_ss_n = 0,
        sio_31 = 5,
        null = 31,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn IRQOVER(self: Value, v: IRQOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 30),
            };
        }
        pub fn INOVER(self: Value, v: INOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 18),
            };
        }
        pub fn OEOVER(self: Value, v: OEOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 14),
            };
        }
        pub fn OUTOVER(self: Value, v: OUTOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 10),
            };
        }
        /// 0-31 -&gt; selects pin function according to the gpio table
        /// 31 == NULL
        pub fn FUNCSEL(self: Value, v: FUNCSEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 5),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn IRQOVER(self: Result) IRQOVER_e {
            const mask = comptime helpers.generateMask(28, 30);
            const val: @typeInfo(IRQOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 28);
            return @enumFromInt(val);
        }
        pub fn INOVER(self: Result) INOVER_e {
            const mask = comptime helpers.generateMask(16, 18);
            const val: @typeInfo(INOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 16);
            return @enumFromInt(val);
        }
        pub fn OEOVER(self: Result) OEOVER_e {
            const mask = comptime helpers.generateMask(12, 14);
            const val: @typeInfo(OEOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 12);
            return @enumFromInt(val);
        }
        pub fn OUTOVER(self: Result) OUTOVER_e {
            const mask = comptime helpers.generateMask(8, 10);
            const val: @typeInfo(OUTOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 8);
            return @enumFromInt(val);
        }
        pub fn FUNCSEL(self: Result) FUNCSEL_e {
            const mask = comptime helpers.generateMask(0, 5);
            const val: @typeInfo(FUNCSEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
        }
    };
    pub fn IRQOVER(v: IRQOVER_e) Value {
        return Value.IRQOVER(.{}, v);
    }
    pub fn INOVER(v: INOVER_e) Value {
        return Value.INOVER(.{}, v);
    }
    pub fn OEOVER(v: OEOVER_e) Value {
        return Value.OEOVER(.{}, v);
    }
    pub fn OUTOVER(v: OUTOVER_e) Value {
        return Value.OUTOVER(.{}, v);
    }
    /// 0-31 -&gt; selects pin function according to the gpio table
    /// 31 == NULL
    pub fn FUNCSEL(v: FUNCSEL_e) Value {
        return Value.FUNCSEL(.{}, v);
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
/// GPIO status
pub const GPIO_QSPI_SD0_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40018010),
    pub const FieldMasks = struct {
        pub const IRQTOPROC: u32 = helpers.generateMask(26, 27);
        pub const IRQFROMPAD: u32 = helpers.generateMask(24, 25);
        pub const INTOPERI: u32 = helpers.generateMask(19, 20);
        pub const INFROMPAD: u32 = helpers.generateMask(17, 18);
        pub const OETOPAD: u32 = helpers.generateMask(13, 14);
        pub const OEFROMPERI: u32 = helpers.generateMask(12, 13);
        pub const OUTTOPAD: u32 = helpers.generateMask(9, 10);
        pub const OUTFROMPERI: u32 = helpers.generateMask(8, 9);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn IRQTOPROC(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn IRQFROMPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn INTOPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn INFROMPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn OETOPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn OEFROMPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn OUTTOPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn OUTFROMPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
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
/// GPIO control including function select and overrides.
pub const GPIO_QSPI_SD0_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40018014),
    pub const FieldMasks = struct {
        pub const IRQOVER: u32 = helpers.generateMask(28, 30);
        pub const INOVER: u32 = helpers.generateMask(16, 18);
        pub const OEOVER: u32 = helpers.generateMask(12, 14);
        pub const OUTOVER: u32 = helpers.generateMask(8, 10);
        pub const FUNCSEL: u32 = helpers.generateMask(0, 5);
    };
    const IRQOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const INOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const OEOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        DISABLE = 2,
        ENABLE = 3,
    };
    const OUTOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const FUNCSEL_e = enum(u5) {
        xip_sd0 = 0,
        sio_32 = 5,
        null = 31,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn IRQOVER(self: Value, v: IRQOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 30),
            };
        }
        pub fn INOVER(self: Value, v: INOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 18),
            };
        }
        pub fn OEOVER(self: Value, v: OEOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 14),
            };
        }
        pub fn OUTOVER(self: Value, v: OUTOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 10),
            };
        }
        /// 0-31 -&gt; selects pin function according to the gpio table
        /// 31 == NULL
        pub fn FUNCSEL(self: Value, v: FUNCSEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 5),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn IRQOVER(self: Result) IRQOVER_e {
            const mask = comptime helpers.generateMask(28, 30);
            const val: @typeInfo(IRQOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 28);
            return @enumFromInt(val);
        }
        pub fn INOVER(self: Result) INOVER_e {
            const mask = comptime helpers.generateMask(16, 18);
            const val: @typeInfo(INOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 16);
            return @enumFromInt(val);
        }
        pub fn OEOVER(self: Result) OEOVER_e {
            const mask = comptime helpers.generateMask(12, 14);
            const val: @typeInfo(OEOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 12);
            return @enumFromInt(val);
        }
        pub fn OUTOVER(self: Result) OUTOVER_e {
            const mask = comptime helpers.generateMask(8, 10);
            const val: @typeInfo(OUTOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 8);
            return @enumFromInt(val);
        }
        pub fn FUNCSEL(self: Result) FUNCSEL_e {
            const mask = comptime helpers.generateMask(0, 5);
            const val: @typeInfo(FUNCSEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
        }
    };
    pub fn IRQOVER(v: IRQOVER_e) Value {
        return Value.IRQOVER(.{}, v);
    }
    pub fn INOVER(v: INOVER_e) Value {
        return Value.INOVER(.{}, v);
    }
    pub fn OEOVER(v: OEOVER_e) Value {
        return Value.OEOVER(.{}, v);
    }
    pub fn OUTOVER(v: OUTOVER_e) Value {
        return Value.OUTOVER(.{}, v);
    }
    /// 0-31 -&gt; selects pin function according to the gpio table
    /// 31 == NULL
    pub fn FUNCSEL(v: FUNCSEL_e) Value {
        return Value.FUNCSEL(.{}, v);
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
/// GPIO status
pub const GPIO_QSPI_SD1_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40018018),
    pub const FieldMasks = struct {
        pub const IRQTOPROC: u32 = helpers.generateMask(26, 27);
        pub const IRQFROMPAD: u32 = helpers.generateMask(24, 25);
        pub const INTOPERI: u32 = helpers.generateMask(19, 20);
        pub const INFROMPAD: u32 = helpers.generateMask(17, 18);
        pub const OETOPAD: u32 = helpers.generateMask(13, 14);
        pub const OEFROMPERI: u32 = helpers.generateMask(12, 13);
        pub const OUTTOPAD: u32 = helpers.generateMask(9, 10);
        pub const OUTFROMPERI: u32 = helpers.generateMask(8, 9);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn IRQTOPROC(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn IRQFROMPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn INTOPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn INFROMPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn OETOPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn OEFROMPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn OUTTOPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn OUTFROMPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
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
/// GPIO control including function select and overrides.
pub const GPIO_QSPI_SD1_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001801c),
    pub const FieldMasks = struct {
        pub const IRQOVER: u32 = helpers.generateMask(28, 30);
        pub const INOVER: u32 = helpers.generateMask(16, 18);
        pub const OEOVER: u32 = helpers.generateMask(12, 14);
        pub const OUTOVER: u32 = helpers.generateMask(8, 10);
        pub const FUNCSEL: u32 = helpers.generateMask(0, 5);
    };
    const IRQOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const INOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const OEOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        DISABLE = 2,
        ENABLE = 3,
    };
    const OUTOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const FUNCSEL_e = enum(u5) {
        xip_sd1 = 0,
        sio_33 = 5,
        null = 31,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn IRQOVER(self: Value, v: IRQOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 30),
            };
        }
        pub fn INOVER(self: Value, v: INOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 18),
            };
        }
        pub fn OEOVER(self: Value, v: OEOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 14),
            };
        }
        pub fn OUTOVER(self: Value, v: OUTOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 10),
            };
        }
        /// 0-31 -&gt; selects pin function according to the gpio table
        /// 31 == NULL
        pub fn FUNCSEL(self: Value, v: FUNCSEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 5),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn IRQOVER(self: Result) IRQOVER_e {
            const mask = comptime helpers.generateMask(28, 30);
            const val: @typeInfo(IRQOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 28);
            return @enumFromInt(val);
        }
        pub fn INOVER(self: Result) INOVER_e {
            const mask = comptime helpers.generateMask(16, 18);
            const val: @typeInfo(INOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 16);
            return @enumFromInt(val);
        }
        pub fn OEOVER(self: Result) OEOVER_e {
            const mask = comptime helpers.generateMask(12, 14);
            const val: @typeInfo(OEOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 12);
            return @enumFromInt(val);
        }
        pub fn OUTOVER(self: Result) OUTOVER_e {
            const mask = comptime helpers.generateMask(8, 10);
            const val: @typeInfo(OUTOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 8);
            return @enumFromInt(val);
        }
        pub fn FUNCSEL(self: Result) FUNCSEL_e {
            const mask = comptime helpers.generateMask(0, 5);
            const val: @typeInfo(FUNCSEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
        }
    };
    pub fn IRQOVER(v: IRQOVER_e) Value {
        return Value.IRQOVER(.{}, v);
    }
    pub fn INOVER(v: INOVER_e) Value {
        return Value.INOVER(.{}, v);
    }
    pub fn OEOVER(v: OEOVER_e) Value {
        return Value.OEOVER(.{}, v);
    }
    pub fn OUTOVER(v: OUTOVER_e) Value {
        return Value.OUTOVER(.{}, v);
    }
    /// 0-31 -&gt; selects pin function according to the gpio table
    /// 31 == NULL
    pub fn FUNCSEL(v: FUNCSEL_e) Value {
        return Value.FUNCSEL(.{}, v);
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
/// GPIO status
pub const GPIO_QSPI_SD2_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40018020),
    pub const FieldMasks = struct {
        pub const IRQTOPROC: u32 = helpers.generateMask(26, 27);
        pub const IRQFROMPAD: u32 = helpers.generateMask(24, 25);
        pub const INTOPERI: u32 = helpers.generateMask(19, 20);
        pub const INFROMPAD: u32 = helpers.generateMask(17, 18);
        pub const OETOPAD: u32 = helpers.generateMask(13, 14);
        pub const OEFROMPERI: u32 = helpers.generateMask(12, 13);
        pub const OUTTOPAD: u32 = helpers.generateMask(9, 10);
        pub const OUTFROMPERI: u32 = helpers.generateMask(8, 9);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn IRQTOPROC(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn IRQFROMPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn INTOPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn INFROMPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn OETOPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn OEFROMPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn OUTTOPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn OUTFROMPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
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
/// GPIO control including function select and overrides.
pub const GPIO_QSPI_SD2_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40018024),
    pub const FieldMasks = struct {
        pub const IRQOVER: u32 = helpers.generateMask(28, 30);
        pub const INOVER: u32 = helpers.generateMask(16, 18);
        pub const OEOVER: u32 = helpers.generateMask(12, 14);
        pub const OUTOVER: u32 = helpers.generateMask(8, 10);
        pub const FUNCSEL: u32 = helpers.generateMask(0, 5);
    };
    const IRQOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const INOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const OEOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        DISABLE = 2,
        ENABLE = 3,
    };
    const OUTOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const FUNCSEL_e = enum(u5) {
        xip_sd2 = 0,
        sio_34 = 5,
        null = 31,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn IRQOVER(self: Value, v: IRQOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 30),
            };
        }
        pub fn INOVER(self: Value, v: INOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 18),
            };
        }
        pub fn OEOVER(self: Value, v: OEOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 14),
            };
        }
        pub fn OUTOVER(self: Value, v: OUTOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 10),
            };
        }
        /// 0-31 -&gt; selects pin function according to the gpio table
        /// 31 == NULL
        pub fn FUNCSEL(self: Value, v: FUNCSEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 5),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn IRQOVER(self: Result) IRQOVER_e {
            const mask = comptime helpers.generateMask(28, 30);
            const val: @typeInfo(IRQOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 28);
            return @enumFromInt(val);
        }
        pub fn INOVER(self: Result) INOVER_e {
            const mask = comptime helpers.generateMask(16, 18);
            const val: @typeInfo(INOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 16);
            return @enumFromInt(val);
        }
        pub fn OEOVER(self: Result) OEOVER_e {
            const mask = comptime helpers.generateMask(12, 14);
            const val: @typeInfo(OEOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 12);
            return @enumFromInt(val);
        }
        pub fn OUTOVER(self: Result) OUTOVER_e {
            const mask = comptime helpers.generateMask(8, 10);
            const val: @typeInfo(OUTOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 8);
            return @enumFromInt(val);
        }
        pub fn FUNCSEL(self: Result) FUNCSEL_e {
            const mask = comptime helpers.generateMask(0, 5);
            const val: @typeInfo(FUNCSEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
        }
    };
    pub fn IRQOVER(v: IRQOVER_e) Value {
        return Value.IRQOVER(.{}, v);
    }
    pub fn INOVER(v: INOVER_e) Value {
        return Value.INOVER(.{}, v);
    }
    pub fn OEOVER(v: OEOVER_e) Value {
        return Value.OEOVER(.{}, v);
    }
    pub fn OUTOVER(v: OUTOVER_e) Value {
        return Value.OUTOVER(.{}, v);
    }
    /// 0-31 -&gt; selects pin function according to the gpio table
    /// 31 == NULL
    pub fn FUNCSEL(v: FUNCSEL_e) Value {
        return Value.FUNCSEL(.{}, v);
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
/// GPIO status
pub const GPIO_QSPI_SD3_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40018028),
    pub const FieldMasks = struct {
        pub const IRQTOPROC: u32 = helpers.generateMask(26, 27);
        pub const IRQFROMPAD: u32 = helpers.generateMask(24, 25);
        pub const INTOPERI: u32 = helpers.generateMask(19, 20);
        pub const INFROMPAD: u32 = helpers.generateMask(17, 18);
        pub const OETOPAD: u32 = helpers.generateMask(13, 14);
        pub const OEFROMPERI: u32 = helpers.generateMask(12, 13);
        pub const OUTTOPAD: u32 = helpers.generateMask(9, 10);
        pub const OUTFROMPERI: u32 = helpers.generateMask(8, 9);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn IRQTOPROC(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn IRQFROMPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn INTOPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn INFROMPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn OETOPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn OEFROMPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn OUTTOPAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn OUTFROMPERI(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
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
/// GPIO control including function select and overrides.
pub const GPIO_QSPI_SD3_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001802c),
    pub const FieldMasks = struct {
        pub const IRQOVER: u32 = helpers.generateMask(28, 30);
        pub const INOVER: u32 = helpers.generateMask(16, 18);
        pub const OEOVER: u32 = helpers.generateMask(12, 14);
        pub const OUTOVER: u32 = helpers.generateMask(8, 10);
        pub const FUNCSEL: u32 = helpers.generateMask(0, 5);
    };
    const IRQOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const INOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const OEOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        DISABLE = 2,
        ENABLE = 3,
    };
    const OUTOVER_e = enum(u2) {
        NORMAL = 0,
        INVERT = 1,
        LOW = 2,
        HIGH = 3,
    };
    const FUNCSEL_e = enum(u5) {
        xip_sd3 = 0,
        sio_35 = 5,
        null = 31,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn IRQOVER(self: Value, v: IRQOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 30),
            };
        }
        pub fn INOVER(self: Value, v: INOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 18),
            };
        }
        pub fn OEOVER(self: Value, v: OEOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 14),
            };
        }
        pub fn OUTOVER(self: Value, v: OUTOVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 10),
            };
        }
        /// 0-31 -&gt; selects pin function according to the gpio table
        /// 31 == NULL
        pub fn FUNCSEL(self: Value, v: FUNCSEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 5),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn IRQOVER(self: Result) IRQOVER_e {
            const mask = comptime helpers.generateMask(28, 30);
            const val: @typeInfo(IRQOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 28);
            return @enumFromInt(val);
        }
        pub fn INOVER(self: Result) INOVER_e {
            const mask = comptime helpers.generateMask(16, 18);
            const val: @typeInfo(INOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 16);
            return @enumFromInt(val);
        }
        pub fn OEOVER(self: Result) OEOVER_e {
            const mask = comptime helpers.generateMask(12, 14);
            const val: @typeInfo(OEOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 12);
            return @enumFromInt(val);
        }
        pub fn OUTOVER(self: Result) OUTOVER_e {
            const mask = comptime helpers.generateMask(8, 10);
            const val: @typeInfo(OUTOVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 8);
            return @enumFromInt(val);
        }
        pub fn FUNCSEL(self: Result) FUNCSEL_e {
            const mask = comptime helpers.generateMask(0, 5);
            const val: @typeInfo(FUNCSEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
        }
    };
    pub fn IRQOVER(v: IRQOVER_e) Value {
        return Value.IRQOVER(.{}, v);
    }
    pub fn INOVER(v: INOVER_e) Value {
        return Value.INOVER(.{}, v);
    }
    pub fn OEOVER(v: OEOVER_e) Value {
        return Value.OEOVER(.{}, v);
    }
    pub fn OUTOVER(v: OUTOVER_e) Value {
        return Value.OUTOVER(.{}, v);
    }
    /// 0-31 -&gt; selects pin function according to the gpio table
    /// 31 == NULL
    pub fn FUNCSEL(v: FUNCSEL_e) Value {
        return Value.FUNCSEL(.{}, v);
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
    comptime reg: *volatile u32 = @ptrFromInt(0x40018030),
    pub const FieldMasks = struct {
        pub const GPIO_QSPI_SD3_EDGE_HIGH: u32 = helpers.generateMask(23, 24);
        pub const GPIO_QSPI_SD3_EDGE_LOW: u32 = helpers.generateMask(22, 23);
        pub const GPIO_QSPI_SD3_LEVEL_HIGH: u32 = helpers.generateMask(21, 22);
        pub const GPIO_QSPI_SD3_LEVEL_LOW: u32 = helpers.generateMask(20, 21);
        pub const GPIO_QSPI_SD2_EDGE_HIGH: u32 = helpers.generateMask(19, 20);
        pub const GPIO_QSPI_SD2_EDGE_LOW: u32 = helpers.generateMask(18, 19);
        pub const GPIO_QSPI_SD2_LEVEL_HIGH: u32 = helpers.generateMask(17, 18);
        pub const GPIO_QSPI_SD2_LEVEL_LOW: u32 = helpers.generateMask(16, 17);
        pub const GPIO_QSPI_SD1_EDGE_HIGH: u32 = helpers.generateMask(15, 16);
        pub const GPIO_QSPI_SD1_EDGE_LOW: u32 = helpers.generateMask(14, 15);
        pub const GPIO_QSPI_SD1_LEVEL_HIGH: u32 = helpers.generateMask(13, 14);
        pub const GPIO_QSPI_SD1_LEVEL_LOW: u32 = helpers.generateMask(12, 13);
        pub const GPIO_QSPI_SD0_EDGE_HIGH: u32 = helpers.generateMask(11, 12);
        pub const GPIO_QSPI_SD0_EDGE_LOW: u32 = helpers.generateMask(10, 11);
        pub const GPIO_QSPI_SD0_LEVEL_HIGH: u32 = helpers.generateMask(9, 10);
        pub const GPIO_QSPI_SD0_LEVEL_LOW: u32 = helpers.generateMask(8, 9);
        pub const GPIO_QSPI_SS_EDGE_HIGH: u32 = helpers.generateMask(7, 8);
        pub const GPIO_QSPI_SS_EDGE_LOW: u32 = helpers.generateMask(6, 7);
        pub const GPIO_QSPI_SS_LEVEL_HIGH: u32 = helpers.generateMask(5, 6);
        pub const GPIO_QSPI_SS_LEVEL_LOW: u32 = helpers.generateMask(4, 5);
        pub const GPIO_QSPI_SCLK_EDGE_HIGH: u32 = helpers.generateMask(3, 4);
        pub const GPIO_QSPI_SCLK_EDGE_LOW: u32 = helpers.generateMask(2, 3);
        pub const GPIO_QSPI_SCLK_LEVEL_HIGH: u32 = helpers.generateMask(1, 2);
        pub const GPIO_QSPI_SCLK_LEVEL_LOW: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO_QSPI_SD3_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO_QSPI_SD3_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO_QSPI_SD2_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO_QSPI_SD2_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO_QSPI_SD1_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO_QSPI_SD1_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO_QSPI_SD0_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO_QSPI_SD0_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO_QSPI_SS_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO_QSPI_SS_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO_QSPI_SCLK_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO_QSPI_SCLK_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO_QSPI_SD3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO_QSPI_SD3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO_QSPI_SD2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO_QSPI_SD2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO_QSPI_SD1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO_QSPI_SD1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO_QSPI_SD0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO_QSPI_SD0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO_QSPI_SS_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO_QSPI_SS_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO_QSPI_SS_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO_QSPI_SS_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO_QSPI_SD3_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD3_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD3_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD2_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD2_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD1_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD1_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD0_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD0_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SS_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SS_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SS_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SS_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_EDGE_LOW(.{}, v);
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
/// Interrupt Enable for proc0
pub const PROC0_INTE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40018034),
    pub const FieldMasks = struct {
        pub const GPIO_QSPI_SD3_EDGE_HIGH: u32 = helpers.generateMask(23, 24);
        pub const GPIO_QSPI_SD3_EDGE_LOW: u32 = helpers.generateMask(22, 23);
        pub const GPIO_QSPI_SD3_LEVEL_HIGH: u32 = helpers.generateMask(21, 22);
        pub const GPIO_QSPI_SD3_LEVEL_LOW: u32 = helpers.generateMask(20, 21);
        pub const GPIO_QSPI_SD2_EDGE_HIGH: u32 = helpers.generateMask(19, 20);
        pub const GPIO_QSPI_SD2_EDGE_LOW: u32 = helpers.generateMask(18, 19);
        pub const GPIO_QSPI_SD2_LEVEL_HIGH: u32 = helpers.generateMask(17, 18);
        pub const GPIO_QSPI_SD2_LEVEL_LOW: u32 = helpers.generateMask(16, 17);
        pub const GPIO_QSPI_SD1_EDGE_HIGH: u32 = helpers.generateMask(15, 16);
        pub const GPIO_QSPI_SD1_EDGE_LOW: u32 = helpers.generateMask(14, 15);
        pub const GPIO_QSPI_SD1_LEVEL_HIGH: u32 = helpers.generateMask(13, 14);
        pub const GPIO_QSPI_SD1_LEVEL_LOW: u32 = helpers.generateMask(12, 13);
        pub const GPIO_QSPI_SD0_EDGE_HIGH: u32 = helpers.generateMask(11, 12);
        pub const GPIO_QSPI_SD0_EDGE_LOW: u32 = helpers.generateMask(10, 11);
        pub const GPIO_QSPI_SD0_LEVEL_HIGH: u32 = helpers.generateMask(9, 10);
        pub const GPIO_QSPI_SD0_LEVEL_LOW: u32 = helpers.generateMask(8, 9);
        pub const GPIO_QSPI_SS_EDGE_HIGH: u32 = helpers.generateMask(7, 8);
        pub const GPIO_QSPI_SS_EDGE_LOW: u32 = helpers.generateMask(6, 7);
        pub const GPIO_QSPI_SS_LEVEL_HIGH: u32 = helpers.generateMask(5, 6);
        pub const GPIO_QSPI_SS_LEVEL_LOW: u32 = helpers.generateMask(4, 5);
        pub const GPIO_QSPI_SCLK_EDGE_HIGH: u32 = helpers.generateMask(3, 4);
        pub const GPIO_QSPI_SCLK_EDGE_LOW: u32 = helpers.generateMask(2, 3);
        pub const GPIO_QSPI_SCLK_LEVEL_HIGH: u32 = helpers.generateMask(1, 2);
        pub const GPIO_QSPI_SCLK_LEVEL_LOW: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO_QSPI_SD3_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO_QSPI_SD3_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO_QSPI_SD3_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO_QSPI_SD3_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO_QSPI_SD2_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO_QSPI_SD2_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO_QSPI_SD2_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO_QSPI_SD2_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO_QSPI_SD1_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO_QSPI_SD1_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO_QSPI_SD1_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO_QSPI_SD1_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO_QSPI_SD0_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO_QSPI_SD0_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO_QSPI_SD0_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO_QSPI_SD0_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO_QSPI_SS_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO_QSPI_SS_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO_QSPI_SS_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO_QSPI_SS_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO_QSPI_SCLK_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO_QSPI_SCLK_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO_QSPI_SD3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO_QSPI_SD3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO_QSPI_SD2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO_QSPI_SD2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO_QSPI_SD1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO_QSPI_SD1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO_QSPI_SD0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO_QSPI_SD0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO_QSPI_SS_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO_QSPI_SS_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO_QSPI_SS_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO_QSPI_SS_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO_QSPI_SD3_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD3_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD3_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD3_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD3_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD2_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD2_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD2_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD2_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD1_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD1_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD1_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD1_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD0_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD0_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD0_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD0_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SS_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SS_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SS_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SS_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SS_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SS_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SS_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SS_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_LEVEL_LOW(.{}, v);
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
/// Interrupt Force for proc0
pub const PROC0_INTF = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40018038),
    pub const FieldMasks = struct {
        pub const GPIO_QSPI_SD3_EDGE_HIGH: u32 = helpers.generateMask(23, 24);
        pub const GPIO_QSPI_SD3_EDGE_LOW: u32 = helpers.generateMask(22, 23);
        pub const GPIO_QSPI_SD3_LEVEL_HIGH: u32 = helpers.generateMask(21, 22);
        pub const GPIO_QSPI_SD3_LEVEL_LOW: u32 = helpers.generateMask(20, 21);
        pub const GPIO_QSPI_SD2_EDGE_HIGH: u32 = helpers.generateMask(19, 20);
        pub const GPIO_QSPI_SD2_EDGE_LOW: u32 = helpers.generateMask(18, 19);
        pub const GPIO_QSPI_SD2_LEVEL_HIGH: u32 = helpers.generateMask(17, 18);
        pub const GPIO_QSPI_SD2_LEVEL_LOW: u32 = helpers.generateMask(16, 17);
        pub const GPIO_QSPI_SD1_EDGE_HIGH: u32 = helpers.generateMask(15, 16);
        pub const GPIO_QSPI_SD1_EDGE_LOW: u32 = helpers.generateMask(14, 15);
        pub const GPIO_QSPI_SD1_LEVEL_HIGH: u32 = helpers.generateMask(13, 14);
        pub const GPIO_QSPI_SD1_LEVEL_LOW: u32 = helpers.generateMask(12, 13);
        pub const GPIO_QSPI_SD0_EDGE_HIGH: u32 = helpers.generateMask(11, 12);
        pub const GPIO_QSPI_SD0_EDGE_LOW: u32 = helpers.generateMask(10, 11);
        pub const GPIO_QSPI_SD0_LEVEL_HIGH: u32 = helpers.generateMask(9, 10);
        pub const GPIO_QSPI_SD0_LEVEL_LOW: u32 = helpers.generateMask(8, 9);
        pub const GPIO_QSPI_SS_EDGE_HIGH: u32 = helpers.generateMask(7, 8);
        pub const GPIO_QSPI_SS_EDGE_LOW: u32 = helpers.generateMask(6, 7);
        pub const GPIO_QSPI_SS_LEVEL_HIGH: u32 = helpers.generateMask(5, 6);
        pub const GPIO_QSPI_SS_LEVEL_LOW: u32 = helpers.generateMask(4, 5);
        pub const GPIO_QSPI_SCLK_EDGE_HIGH: u32 = helpers.generateMask(3, 4);
        pub const GPIO_QSPI_SCLK_EDGE_LOW: u32 = helpers.generateMask(2, 3);
        pub const GPIO_QSPI_SCLK_LEVEL_HIGH: u32 = helpers.generateMask(1, 2);
        pub const GPIO_QSPI_SCLK_LEVEL_LOW: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO_QSPI_SD3_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO_QSPI_SD3_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO_QSPI_SD3_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO_QSPI_SD3_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO_QSPI_SD2_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO_QSPI_SD2_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO_QSPI_SD2_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO_QSPI_SD2_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO_QSPI_SD1_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO_QSPI_SD1_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO_QSPI_SD1_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO_QSPI_SD1_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO_QSPI_SD0_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO_QSPI_SD0_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO_QSPI_SD0_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO_QSPI_SD0_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO_QSPI_SS_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO_QSPI_SS_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO_QSPI_SS_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO_QSPI_SS_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO_QSPI_SCLK_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO_QSPI_SCLK_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO_QSPI_SD3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO_QSPI_SD3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO_QSPI_SD2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO_QSPI_SD2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO_QSPI_SD1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO_QSPI_SD1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO_QSPI_SD0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO_QSPI_SD0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO_QSPI_SS_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO_QSPI_SS_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO_QSPI_SS_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO_QSPI_SS_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO_QSPI_SD3_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD3_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD3_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD3_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD3_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD2_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD2_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD2_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD2_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD1_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD1_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD1_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD1_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD0_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD0_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD0_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD0_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SS_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SS_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SS_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SS_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SS_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SS_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SS_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SS_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_LEVEL_LOW(.{}, v);
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
/// Interrupt status after masking &amp; forcing for proc0
pub const PROC0_INTS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001803c),
    pub const FieldMasks = struct {
        pub const GPIO_QSPI_SD3_EDGE_HIGH: u32 = helpers.generateMask(23, 24);
        pub const GPIO_QSPI_SD3_EDGE_LOW: u32 = helpers.generateMask(22, 23);
        pub const GPIO_QSPI_SD3_LEVEL_HIGH: u32 = helpers.generateMask(21, 22);
        pub const GPIO_QSPI_SD3_LEVEL_LOW: u32 = helpers.generateMask(20, 21);
        pub const GPIO_QSPI_SD2_EDGE_HIGH: u32 = helpers.generateMask(19, 20);
        pub const GPIO_QSPI_SD2_EDGE_LOW: u32 = helpers.generateMask(18, 19);
        pub const GPIO_QSPI_SD2_LEVEL_HIGH: u32 = helpers.generateMask(17, 18);
        pub const GPIO_QSPI_SD2_LEVEL_LOW: u32 = helpers.generateMask(16, 17);
        pub const GPIO_QSPI_SD1_EDGE_HIGH: u32 = helpers.generateMask(15, 16);
        pub const GPIO_QSPI_SD1_EDGE_LOW: u32 = helpers.generateMask(14, 15);
        pub const GPIO_QSPI_SD1_LEVEL_HIGH: u32 = helpers.generateMask(13, 14);
        pub const GPIO_QSPI_SD1_LEVEL_LOW: u32 = helpers.generateMask(12, 13);
        pub const GPIO_QSPI_SD0_EDGE_HIGH: u32 = helpers.generateMask(11, 12);
        pub const GPIO_QSPI_SD0_EDGE_LOW: u32 = helpers.generateMask(10, 11);
        pub const GPIO_QSPI_SD0_LEVEL_HIGH: u32 = helpers.generateMask(9, 10);
        pub const GPIO_QSPI_SD0_LEVEL_LOW: u32 = helpers.generateMask(8, 9);
        pub const GPIO_QSPI_SS_EDGE_HIGH: u32 = helpers.generateMask(7, 8);
        pub const GPIO_QSPI_SS_EDGE_LOW: u32 = helpers.generateMask(6, 7);
        pub const GPIO_QSPI_SS_LEVEL_HIGH: u32 = helpers.generateMask(5, 6);
        pub const GPIO_QSPI_SS_LEVEL_LOW: u32 = helpers.generateMask(4, 5);
        pub const GPIO_QSPI_SCLK_EDGE_HIGH: u32 = helpers.generateMask(3, 4);
        pub const GPIO_QSPI_SCLK_EDGE_LOW: u32 = helpers.generateMask(2, 3);
        pub const GPIO_QSPI_SCLK_LEVEL_HIGH: u32 = helpers.generateMask(1, 2);
        pub const GPIO_QSPI_SCLK_LEVEL_LOW: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn GPIO_QSPI_SD3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO_QSPI_SD3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO_QSPI_SD2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO_QSPI_SD2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO_QSPI_SD1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO_QSPI_SD1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO_QSPI_SD0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO_QSPI_SD0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO_QSPI_SS_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO_QSPI_SS_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO_QSPI_SS_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO_QSPI_SS_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_LOW(self: Result) u1 {
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
/// Interrupt Enable for proc1
pub const PROC1_INTE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40018040),
    pub const FieldMasks = struct {
        pub const GPIO_QSPI_SD3_EDGE_HIGH: u32 = helpers.generateMask(23, 24);
        pub const GPIO_QSPI_SD3_EDGE_LOW: u32 = helpers.generateMask(22, 23);
        pub const GPIO_QSPI_SD3_LEVEL_HIGH: u32 = helpers.generateMask(21, 22);
        pub const GPIO_QSPI_SD3_LEVEL_LOW: u32 = helpers.generateMask(20, 21);
        pub const GPIO_QSPI_SD2_EDGE_HIGH: u32 = helpers.generateMask(19, 20);
        pub const GPIO_QSPI_SD2_EDGE_LOW: u32 = helpers.generateMask(18, 19);
        pub const GPIO_QSPI_SD2_LEVEL_HIGH: u32 = helpers.generateMask(17, 18);
        pub const GPIO_QSPI_SD2_LEVEL_LOW: u32 = helpers.generateMask(16, 17);
        pub const GPIO_QSPI_SD1_EDGE_HIGH: u32 = helpers.generateMask(15, 16);
        pub const GPIO_QSPI_SD1_EDGE_LOW: u32 = helpers.generateMask(14, 15);
        pub const GPIO_QSPI_SD1_LEVEL_HIGH: u32 = helpers.generateMask(13, 14);
        pub const GPIO_QSPI_SD1_LEVEL_LOW: u32 = helpers.generateMask(12, 13);
        pub const GPIO_QSPI_SD0_EDGE_HIGH: u32 = helpers.generateMask(11, 12);
        pub const GPIO_QSPI_SD0_EDGE_LOW: u32 = helpers.generateMask(10, 11);
        pub const GPIO_QSPI_SD0_LEVEL_HIGH: u32 = helpers.generateMask(9, 10);
        pub const GPIO_QSPI_SD0_LEVEL_LOW: u32 = helpers.generateMask(8, 9);
        pub const GPIO_QSPI_SS_EDGE_HIGH: u32 = helpers.generateMask(7, 8);
        pub const GPIO_QSPI_SS_EDGE_LOW: u32 = helpers.generateMask(6, 7);
        pub const GPIO_QSPI_SS_LEVEL_HIGH: u32 = helpers.generateMask(5, 6);
        pub const GPIO_QSPI_SS_LEVEL_LOW: u32 = helpers.generateMask(4, 5);
        pub const GPIO_QSPI_SCLK_EDGE_HIGH: u32 = helpers.generateMask(3, 4);
        pub const GPIO_QSPI_SCLK_EDGE_LOW: u32 = helpers.generateMask(2, 3);
        pub const GPIO_QSPI_SCLK_LEVEL_HIGH: u32 = helpers.generateMask(1, 2);
        pub const GPIO_QSPI_SCLK_LEVEL_LOW: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO_QSPI_SD3_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO_QSPI_SD3_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO_QSPI_SD3_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO_QSPI_SD3_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO_QSPI_SD2_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO_QSPI_SD2_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO_QSPI_SD2_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO_QSPI_SD2_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO_QSPI_SD1_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO_QSPI_SD1_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO_QSPI_SD1_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO_QSPI_SD1_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO_QSPI_SD0_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO_QSPI_SD0_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO_QSPI_SD0_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO_QSPI_SD0_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO_QSPI_SS_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO_QSPI_SS_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO_QSPI_SS_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO_QSPI_SS_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO_QSPI_SCLK_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO_QSPI_SCLK_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO_QSPI_SD3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO_QSPI_SD3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO_QSPI_SD2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO_QSPI_SD2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO_QSPI_SD1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO_QSPI_SD1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO_QSPI_SD0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO_QSPI_SD0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO_QSPI_SS_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO_QSPI_SS_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO_QSPI_SS_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO_QSPI_SS_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO_QSPI_SD3_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD3_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD3_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD3_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD3_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD2_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD2_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD2_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD2_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD1_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD1_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD1_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD1_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD0_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD0_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD0_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD0_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SS_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SS_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SS_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SS_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SS_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SS_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SS_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SS_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_LEVEL_LOW(.{}, v);
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
/// Interrupt Force for proc1
pub const PROC1_INTF = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40018044),
    pub const FieldMasks = struct {
        pub const GPIO_QSPI_SD3_EDGE_HIGH: u32 = helpers.generateMask(23, 24);
        pub const GPIO_QSPI_SD3_EDGE_LOW: u32 = helpers.generateMask(22, 23);
        pub const GPIO_QSPI_SD3_LEVEL_HIGH: u32 = helpers.generateMask(21, 22);
        pub const GPIO_QSPI_SD3_LEVEL_LOW: u32 = helpers.generateMask(20, 21);
        pub const GPIO_QSPI_SD2_EDGE_HIGH: u32 = helpers.generateMask(19, 20);
        pub const GPIO_QSPI_SD2_EDGE_LOW: u32 = helpers.generateMask(18, 19);
        pub const GPIO_QSPI_SD2_LEVEL_HIGH: u32 = helpers.generateMask(17, 18);
        pub const GPIO_QSPI_SD2_LEVEL_LOW: u32 = helpers.generateMask(16, 17);
        pub const GPIO_QSPI_SD1_EDGE_HIGH: u32 = helpers.generateMask(15, 16);
        pub const GPIO_QSPI_SD1_EDGE_LOW: u32 = helpers.generateMask(14, 15);
        pub const GPIO_QSPI_SD1_LEVEL_HIGH: u32 = helpers.generateMask(13, 14);
        pub const GPIO_QSPI_SD1_LEVEL_LOW: u32 = helpers.generateMask(12, 13);
        pub const GPIO_QSPI_SD0_EDGE_HIGH: u32 = helpers.generateMask(11, 12);
        pub const GPIO_QSPI_SD0_EDGE_LOW: u32 = helpers.generateMask(10, 11);
        pub const GPIO_QSPI_SD0_LEVEL_HIGH: u32 = helpers.generateMask(9, 10);
        pub const GPIO_QSPI_SD0_LEVEL_LOW: u32 = helpers.generateMask(8, 9);
        pub const GPIO_QSPI_SS_EDGE_HIGH: u32 = helpers.generateMask(7, 8);
        pub const GPIO_QSPI_SS_EDGE_LOW: u32 = helpers.generateMask(6, 7);
        pub const GPIO_QSPI_SS_LEVEL_HIGH: u32 = helpers.generateMask(5, 6);
        pub const GPIO_QSPI_SS_LEVEL_LOW: u32 = helpers.generateMask(4, 5);
        pub const GPIO_QSPI_SCLK_EDGE_HIGH: u32 = helpers.generateMask(3, 4);
        pub const GPIO_QSPI_SCLK_EDGE_LOW: u32 = helpers.generateMask(2, 3);
        pub const GPIO_QSPI_SCLK_LEVEL_HIGH: u32 = helpers.generateMask(1, 2);
        pub const GPIO_QSPI_SCLK_LEVEL_LOW: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO_QSPI_SD3_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO_QSPI_SD3_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO_QSPI_SD3_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO_QSPI_SD3_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO_QSPI_SD2_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO_QSPI_SD2_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO_QSPI_SD2_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO_QSPI_SD2_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO_QSPI_SD1_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO_QSPI_SD1_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO_QSPI_SD1_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO_QSPI_SD1_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO_QSPI_SD0_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO_QSPI_SD0_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO_QSPI_SD0_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO_QSPI_SD0_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO_QSPI_SS_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO_QSPI_SS_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO_QSPI_SS_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO_QSPI_SS_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO_QSPI_SCLK_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO_QSPI_SCLK_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO_QSPI_SD3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO_QSPI_SD3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO_QSPI_SD2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO_QSPI_SD2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO_QSPI_SD1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO_QSPI_SD1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO_QSPI_SD0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO_QSPI_SD0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO_QSPI_SS_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO_QSPI_SS_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO_QSPI_SS_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO_QSPI_SS_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO_QSPI_SD3_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD3_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD3_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD3_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD3_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD2_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD2_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD2_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD2_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD1_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD1_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD1_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD1_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD0_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD0_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD0_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD0_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SS_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SS_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SS_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SS_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SS_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SS_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SS_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SS_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_LEVEL_LOW(.{}, v);
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
/// Interrupt status after masking &amp; forcing for proc1
pub const PROC1_INTS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40018048),
    pub const FieldMasks = struct {
        pub const GPIO_QSPI_SD3_EDGE_HIGH: u32 = helpers.generateMask(23, 24);
        pub const GPIO_QSPI_SD3_EDGE_LOW: u32 = helpers.generateMask(22, 23);
        pub const GPIO_QSPI_SD3_LEVEL_HIGH: u32 = helpers.generateMask(21, 22);
        pub const GPIO_QSPI_SD3_LEVEL_LOW: u32 = helpers.generateMask(20, 21);
        pub const GPIO_QSPI_SD2_EDGE_HIGH: u32 = helpers.generateMask(19, 20);
        pub const GPIO_QSPI_SD2_EDGE_LOW: u32 = helpers.generateMask(18, 19);
        pub const GPIO_QSPI_SD2_LEVEL_HIGH: u32 = helpers.generateMask(17, 18);
        pub const GPIO_QSPI_SD2_LEVEL_LOW: u32 = helpers.generateMask(16, 17);
        pub const GPIO_QSPI_SD1_EDGE_HIGH: u32 = helpers.generateMask(15, 16);
        pub const GPIO_QSPI_SD1_EDGE_LOW: u32 = helpers.generateMask(14, 15);
        pub const GPIO_QSPI_SD1_LEVEL_HIGH: u32 = helpers.generateMask(13, 14);
        pub const GPIO_QSPI_SD1_LEVEL_LOW: u32 = helpers.generateMask(12, 13);
        pub const GPIO_QSPI_SD0_EDGE_HIGH: u32 = helpers.generateMask(11, 12);
        pub const GPIO_QSPI_SD0_EDGE_LOW: u32 = helpers.generateMask(10, 11);
        pub const GPIO_QSPI_SD0_LEVEL_HIGH: u32 = helpers.generateMask(9, 10);
        pub const GPIO_QSPI_SD0_LEVEL_LOW: u32 = helpers.generateMask(8, 9);
        pub const GPIO_QSPI_SS_EDGE_HIGH: u32 = helpers.generateMask(7, 8);
        pub const GPIO_QSPI_SS_EDGE_LOW: u32 = helpers.generateMask(6, 7);
        pub const GPIO_QSPI_SS_LEVEL_HIGH: u32 = helpers.generateMask(5, 6);
        pub const GPIO_QSPI_SS_LEVEL_LOW: u32 = helpers.generateMask(4, 5);
        pub const GPIO_QSPI_SCLK_EDGE_HIGH: u32 = helpers.generateMask(3, 4);
        pub const GPIO_QSPI_SCLK_EDGE_LOW: u32 = helpers.generateMask(2, 3);
        pub const GPIO_QSPI_SCLK_LEVEL_HIGH: u32 = helpers.generateMask(1, 2);
        pub const GPIO_QSPI_SCLK_LEVEL_LOW: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn GPIO_QSPI_SD3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO_QSPI_SD3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO_QSPI_SD2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO_QSPI_SD2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO_QSPI_SD1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO_QSPI_SD1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO_QSPI_SD0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO_QSPI_SD0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO_QSPI_SS_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO_QSPI_SS_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO_QSPI_SS_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO_QSPI_SS_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_LOW(self: Result) u1 {
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
/// Interrupt Enable for dormant_wake
pub const DORMANT_WAKE_INTE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001804c),
    pub const FieldMasks = struct {
        pub const GPIO_QSPI_SD3_EDGE_HIGH: u32 = helpers.generateMask(23, 24);
        pub const GPIO_QSPI_SD3_EDGE_LOW: u32 = helpers.generateMask(22, 23);
        pub const GPIO_QSPI_SD3_LEVEL_HIGH: u32 = helpers.generateMask(21, 22);
        pub const GPIO_QSPI_SD3_LEVEL_LOW: u32 = helpers.generateMask(20, 21);
        pub const GPIO_QSPI_SD2_EDGE_HIGH: u32 = helpers.generateMask(19, 20);
        pub const GPIO_QSPI_SD2_EDGE_LOW: u32 = helpers.generateMask(18, 19);
        pub const GPIO_QSPI_SD2_LEVEL_HIGH: u32 = helpers.generateMask(17, 18);
        pub const GPIO_QSPI_SD2_LEVEL_LOW: u32 = helpers.generateMask(16, 17);
        pub const GPIO_QSPI_SD1_EDGE_HIGH: u32 = helpers.generateMask(15, 16);
        pub const GPIO_QSPI_SD1_EDGE_LOW: u32 = helpers.generateMask(14, 15);
        pub const GPIO_QSPI_SD1_LEVEL_HIGH: u32 = helpers.generateMask(13, 14);
        pub const GPIO_QSPI_SD1_LEVEL_LOW: u32 = helpers.generateMask(12, 13);
        pub const GPIO_QSPI_SD0_EDGE_HIGH: u32 = helpers.generateMask(11, 12);
        pub const GPIO_QSPI_SD0_EDGE_LOW: u32 = helpers.generateMask(10, 11);
        pub const GPIO_QSPI_SD0_LEVEL_HIGH: u32 = helpers.generateMask(9, 10);
        pub const GPIO_QSPI_SD0_LEVEL_LOW: u32 = helpers.generateMask(8, 9);
        pub const GPIO_QSPI_SS_EDGE_HIGH: u32 = helpers.generateMask(7, 8);
        pub const GPIO_QSPI_SS_EDGE_LOW: u32 = helpers.generateMask(6, 7);
        pub const GPIO_QSPI_SS_LEVEL_HIGH: u32 = helpers.generateMask(5, 6);
        pub const GPIO_QSPI_SS_LEVEL_LOW: u32 = helpers.generateMask(4, 5);
        pub const GPIO_QSPI_SCLK_EDGE_HIGH: u32 = helpers.generateMask(3, 4);
        pub const GPIO_QSPI_SCLK_EDGE_LOW: u32 = helpers.generateMask(2, 3);
        pub const GPIO_QSPI_SCLK_LEVEL_HIGH: u32 = helpers.generateMask(1, 2);
        pub const GPIO_QSPI_SCLK_LEVEL_LOW: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO_QSPI_SD3_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO_QSPI_SD3_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO_QSPI_SD3_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO_QSPI_SD3_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO_QSPI_SD2_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO_QSPI_SD2_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO_QSPI_SD2_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO_QSPI_SD2_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO_QSPI_SD1_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO_QSPI_SD1_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO_QSPI_SD1_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO_QSPI_SD1_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO_QSPI_SD0_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO_QSPI_SD0_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO_QSPI_SD0_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO_QSPI_SD0_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO_QSPI_SS_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO_QSPI_SS_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO_QSPI_SS_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO_QSPI_SS_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO_QSPI_SCLK_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO_QSPI_SCLK_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO_QSPI_SD3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO_QSPI_SD3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO_QSPI_SD2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO_QSPI_SD2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO_QSPI_SD1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO_QSPI_SD1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO_QSPI_SD0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO_QSPI_SD0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO_QSPI_SS_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO_QSPI_SS_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO_QSPI_SS_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO_QSPI_SS_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO_QSPI_SD3_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD3_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD3_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD3_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD3_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD2_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD2_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD2_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD2_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD1_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD1_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD1_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD1_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD0_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD0_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD0_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD0_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SS_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SS_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SS_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SS_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SS_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SS_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SS_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SS_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_LEVEL_LOW(.{}, v);
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
/// Interrupt Force for dormant_wake
pub const DORMANT_WAKE_INTF = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40018050),
    pub const FieldMasks = struct {
        pub const GPIO_QSPI_SD3_EDGE_HIGH: u32 = helpers.generateMask(23, 24);
        pub const GPIO_QSPI_SD3_EDGE_LOW: u32 = helpers.generateMask(22, 23);
        pub const GPIO_QSPI_SD3_LEVEL_HIGH: u32 = helpers.generateMask(21, 22);
        pub const GPIO_QSPI_SD3_LEVEL_LOW: u32 = helpers.generateMask(20, 21);
        pub const GPIO_QSPI_SD2_EDGE_HIGH: u32 = helpers.generateMask(19, 20);
        pub const GPIO_QSPI_SD2_EDGE_LOW: u32 = helpers.generateMask(18, 19);
        pub const GPIO_QSPI_SD2_LEVEL_HIGH: u32 = helpers.generateMask(17, 18);
        pub const GPIO_QSPI_SD2_LEVEL_LOW: u32 = helpers.generateMask(16, 17);
        pub const GPIO_QSPI_SD1_EDGE_HIGH: u32 = helpers.generateMask(15, 16);
        pub const GPIO_QSPI_SD1_EDGE_LOW: u32 = helpers.generateMask(14, 15);
        pub const GPIO_QSPI_SD1_LEVEL_HIGH: u32 = helpers.generateMask(13, 14);
        pub const GPIO_QSPI_SD1_LEVEL_LOW: u32 = helpers.generateMask(12, 13);
        pub const GPIO_QSPI_SD0_EDGE_HIGH: u32 = helpers.generateMask(11, 12);
        pub const GPIO_QSPI_SD0_EDGE_LOW: u32 = helpers.generateMask(10, 11);
        pub const GPIO_QSPI_SD0_LEVEL_HIGH: u32 = helpers.generateMask(9, 10);
        pub const GPIO_QSPI_SD0_LEVEL_LOW: u32 = helpers.generateMask(8, 9);
        pub const GPIO_QSPI_SS_EDGE_HIGH: u32 = helpers.generateMask(7, 8);
        pub const GPIO_QSPI_SS_EDGE_LOW: u32 = helpers.generateMask(6, 7);
        pub const GPIO_QSPI_SS_LEVEL_HIGH: u32 = helpers.generateMask(5, 6);
        pub const GPIO_QSPI_SS_LEVEL_LOW: u32 = helpers.generateMask(4, 5);
        pub const GPIO_QSPI_SCLK_EDGE_HIGH: u32 = helpers.generateMask(3, 4);
        pub const GPIO_QSPI_SCLK_EDGE_LOW: u32 = helpers.generateMask(2, 3);
        pub const GPIO_QSPI_SCLK_LEVEL_HIGH: u32 = helpers.generateMask(1, 2);
        pub const GPIO_QSPI_SCLK_LEVEL_LOW: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO_QSPI_SD3_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO_QSPI_SD3_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO_QSPI_SD3_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO_QSPI_SD3_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO_QSPI_SD2_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO_QSPI_SD2_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO_QSPI_SD2_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO_QSPI_SD2_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO_QSPI_SD1_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO_QSPI_SD1_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO_QSPI_SD1_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO_QSPI_SD1_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO_QSPI_SD0_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO_QSPI_SD0_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO_QSPI_SD0_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO_QSPI_SD0_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO_QSPI_SS_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO_QSPI_SS_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO_QSPI_SS_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO_QSPI_SS_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO_QSPI_SCLK_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO_QSPI_SCLK_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO_QSPI_SD3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO_QSPI_SD3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO_QSPI_SD2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO_QSPI_SD2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO_QSPI_SD1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO_QSPI_SD1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO_QSPI_SD0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO_QSPI_SD0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO_QSPI_SS_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO_QSPI_SS_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO_QSPI_SS_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO_QSPI_SS_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO_QSPI_SD3_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD3_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD3_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD3_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD3_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD3_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD2_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD2_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD2_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD2_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD2_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD1_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD1_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD1_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD1_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD1_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD0_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD0_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SD0_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SD0_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SD0_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SS_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SS_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SS_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SS_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SS_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SS_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SS_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SS_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_EDGE_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_EDGE_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_EDGE_LOW(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO_QSPI_SCLK_LEVEL_LOW(v: u1) Value {
        return Value.GPIO_QSPI_SCLK_LEVEL_LOW(.{}, v);
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
/// Interrupt status after masking &amp; forcing for dormant_wake
pub const DORMANT_WAKE_INTS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40018054),
    pub const FieldMasks = struct {
        pub const GPIO_QSPI_SD3_EDGE_HIGH: u32 = helpers.generateMask(23, 24);
        pub const GPIO_QSPI_SD3_EDGE_LOW: u32 = helpers.generateMask(22, 23);
        pub const GPIO_QSPI_SD3_LEVEL_HIGH: u32 = helpers.generateMask(21, 22);
        pub const GPIO_QSPI_SD3_LEVEL_LOW: u32 = helpers.generateMask(20, 21);
        pub const GPIO_QSPI_SD2_EDGE_HIGH: u32 = helpers.generateMask(19, 20);
        pub const GPIO_QSPI_SD2_EDGE_LOW: u32 = helpers.generateMask(18, 19);
        pub const GPIO_QSPI_SD2_LEVEL_HIGH: u32 = helpers.generateMask(17, 18);
        pub const GPIO_QSPI_SD2_LEVEL_LOW: u32 = helpers.generateMask(16, 17);
        pub const GPIO_QSPI_SD1_EDGE_HIGH: u32 = helpers.generateMask(15, 16);
        pub const GPIO_QSPI_SD1_EDGE_LOW: u32 = helpers.generateMask(14, 15);
        pub const GPIO_QSPI_SD1_LEVEL_HIGH: u32 = helpers.generateMask(13, 14);
        pub const GPIO_QSPI_SD1_LEVEL_LOW: u32 = helpers.generateMask(12, 13);
        pub const GPIO_QSPI_SD0_EDGE_HIGH: u32 = helpers.generateMask(11, 12);
        pub const GPIO_QSPI_SD0_EDGE_LOW: u32 = helpers.generateMask(10, 11);
        pub const GPIO_QSPI_SD0_LEVEL_HIGH: u32 = helpers.generateMask(9, 10);
        pub const GPIO_QSPI_SD0_LEVEL_LOW: u32 = helpers.generateMask(8, 9);
        pub const GPIO_QSPI_SS_EDGE_HIGH: u32 = helpers.generateMask(7, 8);
        pub const GPIO_QSPI_SS_EDGE_LOW: u32 = helpers.generateMask(6, 7);
        pub const GPIO_QSPI_SS_LEVEL_HIGH: u32 = helpers.generateMask(5, 6);
        pub const GPIO_QSPI_SS_LEVEL_LOW: u32 = helpers.generateMask(4, 5);
        pub const GPIO_QSPI_SCLK_EDGE_HIGH: u32 = helpers.generateMask(3, 4);
        pub const GPIO_QSPI_SCLK_EDGE_LOW: u32 = helpers.generateMask(2, 3);
        pub const GPIO_QSPI_SCLK_LEVEL_HIGH: u32 = helpers.generateMask(1, 2);
        pub const GPIO_QSPI_SCLK_LEVEL_LOW: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn GPIO_QSPI_SD3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO_QSPI_SD3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO_QSPI_SD3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO_QSPI_SD2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO_QSPI_SD2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO_QSPI_SD2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO_QSPI_SD1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO_QSPI_SD1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO_QSPI_SD1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO_QSPI_SD0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO_QSPI_SD0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO_QSPI_SD0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO_QSPI_SS_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO_QSPI_SS_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO_QSPI_SS_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO_QSPI_SS_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO_QSPI_SCLK_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO_QSPI_SCLK_LEVEL_LOW(self: Result) u1 {
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
pub const IO_QSPI_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x40018000),

    /// GPIO status
    GPIO_QSPI_SCLK_STATUS: GPIO_QSPI_SCLK_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO_QSPI_SCLK_CTRL: GPIO_QSPI_SCLK_CTRL = .{},
    /// GPIO status
    GPIO_QSPI_SS_STATUS: GPIO_QSPI_SS_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO_QSPI_SS_CTRL: GPIO_QSPI_SS_CTRL = .{},
    /// GPIO status
    GPIO_QSPI_SD0_STATUS: GPIO_QSPI_SD0_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO_QSPI_SD0_CTRL: GPIO_QSPI_SD0_CTRL = .{},
    /// GPIO status
    GPIO_QSPI_SD1_STATUS: GPIO_QSPI_SD1_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO_QSPI_SD1_CTRL: GPIO_QSPI_SD1_CTRL = .{},
    /// GPIO status
    GPIO_QSPI_SD2_STATUS: GPIO_QSPI_SD2_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO_QSPI_SD2_CTRL: GPIO_QSPI_SD2_CTRL = .{},
    /// GPIO status
    GPIO_QSPI_SD3_STATUS: GPIO_QSPI_SD3_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO_QSPI_SD3_CTRL: GPIO_QSPI_SD3_CTRL = .{},
    /// Raw Interrupts
    INTR: INTR = .{},
    /// Interrupt Enable for proc0
    PROC0_INTE: PROC0_INTE = .{},
    /// Interrupt Force for proc0
    PROC0_INTF: PROC0_INTF = .{},
    /// Interrupt status after masking &amp; forcing for proc0
    PROC0_INTS: PROC0_INTS = .{},
    /// Interrupt Enable for proc1
    PROC1_INTE: PROC1_INTE = .{},
    /// Interrupt Force for proc1
    PROC1_INTF: PROC1_INTF = .{},
    /// Interrupt status after masking &amp; forcing for proc1
    PROC1_INTS: PROC1_INTS = .{},
    /// Interrupt Enable for dormant_wake
    DORMANT_WAKE_INTE: DORMANT_WAKE_INTE = .{},
    /// Interrupt Force for dormant_wake
    DORMANT_WAKE_INTF: DORMANT_WAKE_INTF = .{},
    /// Interrupt status after masking &amp; forcing for dormant_wake
    DORMANT_WAKE_INTS: DORMANT_WAKE_INTS = .{},
};
pub const IO_QSPI = IO_QSPI_p{};
