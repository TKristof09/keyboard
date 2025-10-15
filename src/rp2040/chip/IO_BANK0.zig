const helpers = @import("helpers.zig");
/// GPIO status
pub const GPIO0_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014000),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO0_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014004),
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
        jtag_tck = 0,
        spi0_rx = 1,
        uart0_tx = 2,
        i2c0_sda = 3,
        pwm_a_0 = 4,
        sio_0 = 5,
        pio0_0 = 6,
        pio1_0 = 7,
        usb_muxing_overcurr_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO1_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014008),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO1_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001400c),
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
        jtag_tms = 0,
        spi0_ss_n = 1,
        uart0_rx = 2,
        i2c0_scl = 3,
        pwm_b_0 = 4,
        sio_1 = 5,
        pio0_1 = 6,
        pio1_1 = 7,
        usb_muxing_vbus_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO2_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014010),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO2_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014014),
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
        jtag_tdi = 0,
        spi0_sclk = 1,
        uart0_cts = 2,
        i2c1_sda = 3,
        pwm_a_1 = 4,
        sio_2 = 5,
        pio0_2 = 6,
        pio1_2 = 7,
        usb_muxing_vbus_en = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO3_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014018),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO3_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001401c),
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
        jtag_tdo = 0,
        spi0_tx = 1,
        uart0_rts = 2,
        i2c1_scl = 3,
        pwm_b_1 = 4,
        sio_3 = 5,
        pio0_3 = 6,
        pio1_3 = 7,
        usb_muxing_overcurr_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO4_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014020),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO4_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014024),
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
        spi0_rx = 1,
        uart1_tx = 2,
        i2c0_sda = 3,
        pwm_a_2 = 4,
        sio_4 = 5,
        pio0_4 = 6,
        pio1_4 = 7,
        usb_muxing_vbus_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO5_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014028),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO5_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001402c),
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
        spi0_ss_n = 1,
        uart1_rx = 2,
        i2c0_scl = 3,
        pwm_b_2 = 4,
        sio_5 = 5,
        pio0_5 = 6,
        pio1_5 = 7,
        usb_muxing_vbus_en = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO6_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014030),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO6_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014034),
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
        spi0_sclk = 1,
        uart1_cts = 2,
        i2c1_sda = 3,
        pwm_a_3 = 4,
        sio_6 = 5,
        pio0_6 = 6,
        pio1_6 = 7,
        usb_muxing_extphy_softcon = 8,
        usb_muxing_overcurr_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO7_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014038),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO7_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001403c),
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
        spi0_tx = 1,
        uart1_rts = 2,
        i2c1_scl = 3,
        pwm_b_3 = 4,
        sio_7 = 5,
        pio0_7 = 6,
        pio1_7 = 7,
        usb_muxing_extphy_oe_n = 8,
        usb_muxing_vbus_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO8_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014040),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO8_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014044),
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
        spi1_rx = 1,
        uart1_tx = 2,
        i2c0_sda = 3,
        pwm_a_4 = 4,
        sio_8 = 5,
        pio0_8 = 6,
        pio1_8 = 7,
        usb_muxing_extphy_rcv = 8,
        usb_muxing_vbus_en = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO9_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014048),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO9_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001404c),
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
        spi1_ss_n = 1,
        uart1_rx = 2,
        i2c0_scl = 3,
        pwm_b_4 = 4,
        sio_9 = 5,
        pio0_9 = 6,
        pio1_9 = 7,
        usb_muxing_extphy_vp = 8,
        usb_muxing_overcurr_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO10_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014050),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO10_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014054),
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
        spi1_sclk = 1,
        uart1_cts = 2,
        i2c1_sda = 3,
        pwm_a_5 = 4,
        sio_10 = 5,
        pio0_10 = 6,
        pio1_10 = 7,
        usb_muxing_extphy_vm = 8,
        usb_muxing_vbus_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO11_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014058),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO11_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001405c),
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
        spi1_tx = 1,
        uart1_rts = 2,
        i2c1_scl = 3,
        pwm_b_5 = 4,
        sio_11 = 5,
        pio0_11 = 6,
        pio1_11 = 7,
        usb_muxing_extphy_suspnd = 8,
        usb_muxing_vbus_en = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO12_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014060),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO12_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014064),
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
        spi1_rx = 1,
        uart0_tx = 2,
        i2c0_sda = 3,
        pwm_a_6 = 4,
        sio_12 = 5,
        pio0_12 = 6,
        pio1_12 = 7,
        usb_muxing_extphy_speed = 8,
        usb_muxing_overcurr_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO13_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014068),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO13_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001406c),
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
        spi1_ss_n = 1,
        uart0_rx = 2,
        i2c0_scl = 3,
        pwm_b_6 = 4,
        sio_13 = 5,
        pio0_13 = 6,
        pio1_13 = 7,
        usb_muxing_extphy_vpo = 8,
        usb_muxing_vbus_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO14_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014070),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO14_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014074),
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
        spi1_sclk = 1,
        uart0_cts = 2,
        i2c1_sda = 3,
        pwm_a_7 = 4,
        sio_14 = 5,
        pio0_14 = 6,
        pio1_14 = 7,
        usb_muxing_extphy_vmo = 8,
        usb_muxing_vbus_en = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO15_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014078),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO15_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001407c),
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
        spi1_tx = 1,
        uart0_rts = 2,
        i2c1_scl = 3,
        pwm_b_7 = 4,
        sio_15 = 5,
        pio0_15 = 6,
        pio1_15 = 7,
        usb_muxing_digital_dp = 8,
        usb_muxing_overcurr_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO16_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014080),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO16_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014084),
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
        spi0_rx = 1,
        uart0_tx = 2,
        i2c0_sda = 3,
        pwm_a_0 = 4,
        sio_16 = 5,
        pio0_16 = 6,
        pio1_16 = 7,
        usb_muxing_digital_dm = 8,
        usb_muxing_vbus_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO17_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014088),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO17_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001408c),
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
        spi0_ss_n = 1,
        uart0_rx = 2,
        i2c0_scl = 3,
        pwm_b_0 = 4,
        sio_17 = 5,
        pio0_17 = 6,
        pio1_17 = 7,
        usb_muxing_vbus_en = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO18_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014090),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO18_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014094),
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
        spi0_sclk = 1,
        uart0_cts = 2,
        i2c1_sda = 3,
        pwm_a_1 = 4,
        sio_18 = 5,
        pio0_18 = 6,
        pio1_18 = 7,
        usb_muxing_overcurr_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO19_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014098),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO19_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001409c),
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
        spi0_tx = 1,
        uart0_rts = 2,
        i2c1_scl = 3,
        pwm_b_1 = 4,
        sio_19 = 5,
        pio0_19 = 6,
        pio1_19 = 7,
        usb_muxing_vbus_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO20_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140a0),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO20_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140a4),
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
        spi0_rx = 1,
        uart1_tx = 2,
        i2c0_sda = 3,
        pwm_a_2 = 4,
        sio_20 = 5,
        pio0_20 = 6,
        pio1_20 = 7,
        clocks_gpin_0 = 8,
        usb_muxing_vbus_en = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO21_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140a8),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO21_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140ac),
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
        spi0_ss_n = 1,
        uart1_rx = 2,
        i2c0_scl = 3,
        pwm_b_2 = 4,
        sio_21 = 5,
        pio0_21 = 6,
        pio1_21 = 7,
        clocks_gpout_0 = 8,
        usb_muxing_overcurr_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO22_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140b0),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO22_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140b4),
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
        spi0_sclk = 1,
        uart1_cts = 2,
        i2c1_sda = 3,
        pwm_a_3 = 4,
        sio_22 = 5,
        pio0_22 = 6,
        pio1_22 = 7,
        clocks_gpin_1 = 8,
        usb_muxing_vbus_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO23_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140b8),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO23_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140bc),
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
        spi0_tx = 1,
        uart1_rts = 2,
        i2c1_scl = 3,
        pwm_b_3 = 4,
        sio_23 = 5,
        pio0_23 = 6,
        pio1_23 = 7,
        clocks_gpout_1 = 8,
        usb_muxing_vbus_en = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO24_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140c0),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO24_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140c4),
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
        spi1_rx = 1,
        uart1_tx = 2,
        i2c0_sda = 3,
        pwm_a_4 = 4,
        sio_24 = 5,
        pio0_24 = 6,
        pio1_24 = 7,
        clocks_gpout_2 = 8,
        usb_muxing_overcurr_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO25_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140c8),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO25_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140cc),
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
        spi1_ss_n = 1,
        uart1_rx = 2,
        i2c0_scl = 3,
        pwm_b_4 = 4,
        sio_25 = 5,
        pio0_25 = 6,
        pio1_25 = 7,
        clocks_gpout_3 = 8,
        usb_muxing_vbus_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO26_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140d0),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO26_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140d4),
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
        spi1_sclk = 1,
        uart1_cts = 2,
        i2c1_sda = 3,
        pwm_a_5 = 4,
        sio_26 = 5,
        pio0_26 = 6,
        pio1_26 = 7,
        usb_muxing_vbus_en = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO27_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140d8),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO27_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140dc),
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
        spi1_tx = 1,
        uart1_rts = 2,
        i2c1_scl = 3,
        pwm_b_5 = 4,
        sio_27 = 5,
        pio0_27 = 6,
        pio1_27 = 7,
        usb_muxing_overcurr_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO28_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140e0),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO28_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140e4),
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
        spi1_rx = 1,
        uart0_tx = 2,
        i2c0_sda = 3,
        pwm_a_6 = 4,
        sio_28 = 5,
        pio0_28 = 6,
        pio1_28 = 7,
        usb_muxing_vbus_detect = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO status
pub const GPIO29_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140e8),
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// GPIO control including function select and overrides.
pub const GPIO29_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140ec),
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
        spi1_ss_n = 1,
        uart0_rx = 2,
        i2c0_scl = 3,
        pwm_b_6 = 4,
        sio_29 = 5,
        pio0_29 = 6,
        pio1_29 = 7,
        usb_muxing_vbus_en = 9,
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
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Raw Interrupts
pub const INTR0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140f0),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO7_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO7_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO6_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO6_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO5_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO5_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO4_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO4_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO3_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO3_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO2_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO2_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO1_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO1_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO0_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO0_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO7_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO7_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO7_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO7_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO6_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO6_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO6_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO6_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO5_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO5_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO5_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO5_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO4_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO4_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO4_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO4_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO7_EDGE_HIGH(v: u1) Value {
        return Value.GPIO7_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO7_EDGE_LOW(v: u1) Value {
        return Value.GPIO7_EDGE_LOW(.{}, v);
    }
    pub fn GPIO6_EDGE_HIGH(v: u1) Value {
        return Value.GPIO6_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO6_EDGE_LOW(v: u1) Value {
        return Value.GPIO6_EDGE_LOW(.{}, v);
    }
    pub fn GPIO5_EDGE_HIGH(v: u1) Value {
        return Value.GPIO5_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO5_EDGE_LOW(v: u1) Value {
        return Value.GPIO5_EDGE_LOW(.{}, v);
    }
    pub fn GPIO4_EDGE_HIGH(v: u1) Value {
        return Value.GPIO4_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO4_EDGE_LOW(v: u1) Value {
        return Value.GPIO4_EDGE_LOW(.{}, v);
    }
    pub fn GPIO3_EDGE_HIGH(v: u1) Value {
        return Value.GPIO3_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO3_EDGE_LOW(v: u1) Value {
        return Value.GPIO3_EDGE_LOW(.{}, v);
    }
    pub fn GPIO2_EDGE_HIGH(v: u1) Value {
        return Value.GPIO2_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO2_EDGE_LOW(v: u1) Value {
        return Value.GPIO2_EDGE_LOW(.{}, v);
    }
    pub fn GPIO1_EDGE_HIGH(v: u1) Value {
        return Value.GPIO1_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO1_EDGE_LOW(v: u1) Value {
        return Value.GPIO1_EDGE_LOW(.{}, v);
    }
    pub fn GPIO0_EDGE_HIGH(v: u1) Value {
        return Value.GPIO0_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO0_EDGE_LOW(v: u1) Value {
        return Value.GPIO0_EDGE_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Raw Interrupts
pub const INTR1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140f4),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO15_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO15_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO14_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO14_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO13_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO13_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO12_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO12_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO11_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO11_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO10_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO10_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO9_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO9_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO8_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO8_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO15_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO15_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO15_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO15_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO14_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO14_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO14_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO14_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO13_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO13_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO13_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO13_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO12_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO12_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO12_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO12_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO11_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO11_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO11_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO11_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO10_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO10_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO10_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO10_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO9_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO9_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO9_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO9_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO8_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO8_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO8_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO8_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO15_EDGE_HIGH(v: u1) Value {
        return Value.GPIO15_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO15_EDGE_LOW(v: u1) Value {
        return Value.GPIO15_EDGE_LOW(.{}, v);
    }
    pub fn GPIO14_EDGE_HIGH(v: u1) Value {
        return Value.GPIO14_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO14_EDGE_LOW(v: u1) Value {
        return Value.GPIO14_EDGE_LOW(.{}, v);
    }
    pub fn GPIO13_EDGE_HIGH(v: u1) Value {
        return Value.GPIO13_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO13_EDGE_LOW(v: u1) Value {
        return Value.GPIO13_EDGE_LOW(.{}, v);
    }
    pub fn GPIO12_EDGE_HIGH(v: u1) Value {
        return Value.GPIO12_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO12_EDGE_LOW(v: u1) Value {
        return Value.GPIO12_EDGE_LOW(.{}, v);
    }
    pub fn GPIO11_EDGE_HIGH(v: u1) Value {
        return Value.GPIO11_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO11_EDGE_LOW(v: u1) Value {
        return Value.GPIO11_EDGE_LOW(.{}, v);
    }
    pub fn GPIO10_EDGE_HIGH(v: u1) Value {
        return Value.GPIO10_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO10_EDGE_LOW(v: u1) Value {
        return Value.GPIO10_EDGE_LOW(.{}, v);
    }
    pub fn GPIO9_EDGE_HIGH(v: u1) Value {
        return Value.GPIO9_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO9_EDGE_LOW(v: u1) Value {
        return Value.GPIO9_EDGE_LOW(.{}, v);
    }
    pub fn GPIO8_EDGE_HIGH(v: u1) Value {
        return Value.GPIO8_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO8_EDGE_LOW(v: u1) Value {
        return Value.GPIO8_EDGE_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Raw Interrupts
pub const INTR2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140f8),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO23_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO23_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO22_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO22_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO21_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO21_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO20_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO20_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO19_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO19_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO18_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO18_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO17_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO17_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO16_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO16_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO23_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO23_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO23_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO23_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO22_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO22_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO22_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO22_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO21_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO21_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO21_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO21_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO20_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO20_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO20_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO20_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO19_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO19_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO19_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO19_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO18_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO18_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO18_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO18_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO17_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO17_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO17_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO17_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO16_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO16_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO16_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO16_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO23_EDGE_HIGH(v: u1) Value {
        return Value.GPIO23_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO23_EDGE_LOW(v: u1) Value {
        return Value.GPIO23_EDGE_LOW(.{}, v);
    }
    pub fn GPIO22_EDGE_HIGH(v: u1) Value {
        return Value.GPIO22_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO22_EDGE_LOW(v: u1) Value {
        return Value.GPIO22_EDGE_LOW(.{}, v);
    }
    pub fn GPIO21_EDGE_HIGH(v: u1) Value {
        return Value.GPIO21_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO21_EDGE_LOW(v: u1) Value {
        return Value.GPIO21_EDGE_LOW(.{}, v);
    }
    pub fn GPIO20_EDGE_HIGH(v: u1) Value {
        return Value.GPIO20_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO20_EDGE_LOW(v: u1) Value {
        return Value.GPIO20_EDGE_LOW(.{}, v);
    }
    pub fn GPIO19_EDGE_HIGH(v: u1) Value {
        return Value.GPIO19_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO19_EDGE_LOW(v: u1) Value {
        return Value.GPIO19_EDGE_LOW(.{}, v);
    }
    pub fn GPIO18_EDGE_HIGH(v: u1) Value {
        return Value.GPIO18_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO18_EDGE_LOW(v: u1) Value {
        return Value.GPIO18_EDGE_LOW(.{}, v);
    }
    pub fn GPIO17_EDGE_HIGH(v: u1) Value {
        return Value.GPIO17_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO17_EDGE_LOW(v: u1) Value {
        return Value.GPIO17_EDGE_LOW(.{}, v);
    }
    pub fn GPIO16_EDGE_HIGH(v: u1) Value {
        return Value.GPIO16_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO16_EDGE_LOW(v: u1) Value {
        return Value.GPIO16_EDGE_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Raw Interrupts
pub const INTR3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400140fc),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO29_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO29_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO28_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO28_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO27_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO27_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO26_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO26_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO25_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO25_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO24_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO24_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO29_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO29_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO29_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO29_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO28_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO28_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO28_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO28_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO27_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO27_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO27_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO27_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO26_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO26_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO26_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO26_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO25_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO25_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO25_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO25_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO24_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO24_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO24_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO24_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO29_EDGE_HIGH(v: u1) Value {
        return Value.GPIO29_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO29_EDGE_LOW(v: u1) Value {
        return Value.GPIO29_EDGE_LOW(.{}, v);
    }
    pub fn GPIO28_EDGE_HIGH(v: u1) Value {
        return Value.GPIO28_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO28_EDGE_LOW(v: u1) Value {
        return Value.GPIO28_EDGE_LOW(.{}, v);
    }
    pub fn GPIO27_EDGE_HIGH(v: u1) Value {
        return Value.GPIO27_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO27_EDGE_LOW(v: u1) Value {
        return Value.GPIO27_EDGE_LOW(.{}, v);
    }
    pub fn GPIO26_EDGE_HIGH(v: u1) Value {
        return Value.GPIO26_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO26_EDGE_LOW(v: u1) Value {
        return Value.GPIO26_EDGE_LOW(.{}, v);
    }
    pub fn GPIO25_EDGE_HIGH(v: u1) Value {
        return Value.GPIO25_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO25_EDGE_LOW(v: u1) Value {
        return Value.GPIO25_EDGE_LOW(.{}, v);
    }
    pub fn GPIO24_EDGE_HIGH(v: u1) Value {
        return Value.GPIO24_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO24_EDGE_LOW(v: u1) Value {
        return Value.GPIO24_EDGE_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Enable for proc0
pub const PROC0_INTE0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014100),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO7_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO7_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO7_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO7_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO6_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO6_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO6_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO6_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO5_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO5_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO5_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO5_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO4_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO4_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO4_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO4_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO3_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO3_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO3_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO3_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO2_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO2_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO2_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO2_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO1_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO1_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO1_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO1_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO0_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO0_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO0_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO0_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO7_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO7_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO7_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO7_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO6_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO6_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO6_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO6_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO5_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO5_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO5_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO5_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO4_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO4_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO4_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO4_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO7_EDGE_HIGH(v: u1) Value {
        return Value.GPIO7_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO7_EDGE_LOW(v: u1) Value {
        return Value.GPIO7_EDGE_LOW(.{}, v);
    }
    pub fn GPIO7_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO7_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO7_LEVEL_LOW(v: u1) Value {
        return Value.GPIO7_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO6_EDGE_HIGH(v: u1) Value {
        return Value.GPIO6_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO6_EDGE_LOW(v: u1) Value {
        return Value.GPIO6_EDGE_LOW(.{}, v);
    }
    pub fn GPIO6_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO6_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO6_LEVEL_LOW(v: u1) Value {
        return Value.GPIO6_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO5_EDGE_HIGH(v: u1) Value {
        return Value.GPIO5_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO5_EDGE_LOW(v: u1) Value {
        return Value.GPIO5_EDGE_LOW(.{}, v);
    }
    pub fn GPIO5_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO5_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO5_LEVEL_LOW(v: u1) Value {
        return Value.GPIO5_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO4_EDGE_HIGH(v: u1) Value {
        return Value.GPIO4_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO4_EDGE_LOW(v: u1) Value {
        return Value.GPIO4_EDGE_LOW(.{}, v);
    }
    pub fn GPIO4_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO4_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO4_LEVEL_LOW(v: u1) Value {
        return Value.GPIO4_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO3_EDGE_HIGH(v: u1) Value {
        return Value.GPIO3_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO3_EDGE_LOW(v: u1) Value {
        return Value.GPIO3_EDGE_LOW(.{}, v);
    }
    pub fn GPIO3_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO3_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO3_LEVEL_LOW(v: u1) Value {
        return Value.GPIO3_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO2_EDGE_HIGH(v: u1) Value {
        return Value.GPIO2_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO2_EDGE_LOW(v: u1) Value {
        return Value.GPIO2_EDGE_LOW(.{}, v);
    }
    pub fn GPIO2_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO2_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO2_LEVEL_LOW(v: u1) Value {
        return Value.GPIO2_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO1_EDGE_HIGH(v: u1) Value {
        return Value.GPIO1_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO1_EDGE_LOW(v: u1) Value {
        return Value.GPIO1_EDGE_LOW(.{}, v);
    }
    pub fn GPIO1_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO1_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO1_LEVEL_LOW(v: u1) Value {
        return Value.GPIO1_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO0_EDGE_HIGH(v: u1) Value {
        return Value.GPIO0_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO0_EDGE_LOW(v: u1) Value {
        return Value.GPIO0_EDGE_LOW(.{}, v);
    }
    pub fn GPIO0_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO0_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO0_LEVEL_LOW(v: u1) Value {
        return Value.GPIO0_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Enable for proc0
pub const PROC0_INTE1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014104),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO15_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO15_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO15_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO15_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO14_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO14_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO14_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO14_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO13_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO13_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO13_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO13_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO12_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO12_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO12_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO12_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO11_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO11_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO11_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO11_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO10_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO10_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO10_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO10_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO9_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO9_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO9_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO9_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO8_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO8_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO8_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO8_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO15_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO15_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO15_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO15_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO14_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO14_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO14_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO14_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO13_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO13_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO13_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO13_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO12_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO12_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO12_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO12_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO11_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO11_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO11_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO11_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO10_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO10_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO10_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO10_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO9_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO9_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO9_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO9_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO8_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO8_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO8_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO8_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO15_EDGE_HIGH(v: u1) Value {
        return Value.GPIO15_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO15_EDGE_LOW(v: u1) Value {
        return Value.GPIO15_EDGE_LOW(.{}, v);
    }
    pub fn GPIO15_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO15_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO15_LEVEL_LOW(v: u1) Value {
        return Value.GPIO15_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO14_EDGE_HIGH(v: u1) Value {
        return Value.GPIO14_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO14_EDGE_LOW(v: u1) Value {
        return Value.GPIO14_EDGE_LOW(.{}, v);
    }
    pub fn GPIO14_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO14_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO14_LEVEL_LOW(v: u1) Value {
        return Value.GPIO14_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO13_EDGE_HIGH(v: u1) Value {
        return Value.GPIO13_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO13_EDGE_LOW(v: u1) Value {
        return Value.GPIO13_EDGE_LOW(.{}, v);
    }
    pub fn GPIO13_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO13_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO13_LEVEL_LOW(v: u1) Value {
        return Value.GPIO13_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO12_EDGE_HIGH(v: u1) Value {
        return Value.GPIO12_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO12_EDGE_LOW(v: u1) Value {
        return Value.GPIO12_EDGE_LOW(.{}, v);
    }
    pub fn GPIO12_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO12_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO12_LEVEL_LOW(v: u1) Value {
        return Value.GPIO12_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO11_EDGE_HIGH(v: u1) Value {
        return Value.GPIO11_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO11_EDGE_LOW(v: u1) Value {
        return Value.GPIO11_EDGE_LOW(.{}, v);
    }
    pub fn GPIO11_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO11_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO11_LEVEL_LOW(v: u1) Value {
        return Value.GPIO11_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO10_EDGE_HIGH(v: u1) Value {
        return Value.GPIO10_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO10_EDGE_LOW(v: u1) Value {
        return Value.GPIO10_EDGE_LOW(.{}, v);
    }
    pub fn GPIO10_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO10_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO10_LEVEL_LOW(v: u1) Value {
        return Value.GPIO10_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO9_EDGE_HIGH(v: u1) Value {
        return Value.GPIO9_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO9_EDGE_LOW(v: u1) Value {
        return Value.GPIO9_EDGE_LOW(.{}, v);
    }
    pub fn GPIO9_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO9_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO9_LEVEL_LOW(v: u1) Value {
        return Value.GPIO9_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO8_EDGE_HIGH(v: u1) Value {
        return Value.GPIO8_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO8_EDGE_LOW(v: u1) Value {
        return Value.GPIO8_EDGE_LOW(.{}, v);
    }
    pub fn GPIO8_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO8_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO8_LEVEL_LOW(v: u1) Value {
        return Value.GPIO8_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Enable for proc0
pub const PROC0_INTE2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014108),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO23_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO23_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO23_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO23_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO22_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO22_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO22_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO22_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO21_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO21_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO21_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO21_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO20_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO20_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO20_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO20_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO19_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO19_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO19_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO19_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO18_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO18_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO18_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO18_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO17_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO17_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO17_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO17_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO16_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO16_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO16_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO16_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO23_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO23_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO23_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO23_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO22_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO22_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO22_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO22_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO21_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO21_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO21_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO21_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO20_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO20_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO20_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO20_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO19_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO19_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO19_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO19_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO18_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO18_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO18_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO18_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO17_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO17_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO17_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO17_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO16_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO16_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO16_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO16_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO23_EDGE_HIGH(v: u1) Value {
        return Value.GPIO23_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO23_EDGE_LOW(v: u1) Value {
        return Value.GPIO23_EDGE_LOW(.{}, v);
    }
    pub fn GPIO23_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO23_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO23_LEVEL_LOW(v: u1) Value {
        return Value.GPIO23_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO22_EDGE_HIGH(v: u1) Value {
        return Value.GPIO22_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO22_EDGE_LOW(v: u1) Value {
        return Value.GPIO22_EDGE_LOW(.{}, v);
    }
    pub fn GPIO22_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO22_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO22_LEVEL_LOW(v: u1) Value {
        return Value.GPIO22_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO21_EDGE_HIGH(v: u1) Value {
        return Value.GPIO21_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO21_EDGE_LOW(v: u1) Value {
        return Value.GPIO21_EDGE_LOW(.{}, v);
    }
    pub fn GPIO21_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO21_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO21_LEVEL_LOW(v: u1) Value {
        return Value.GPIO21_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO20_EDGE_HIGH(v: u1) Value {
        return Value.GPIO20_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO20_EDGE_LOW(v: u1) Value {
        return Value.GPIO20_EDGE_LOW(.{}, v);
    }
    pub fn GPIO20_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO20_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO20_LEVEL_LOW(v: u1) Value {
        return Value.GPIO20_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO19_EDGE_HIGH(v: u1) Value {
        return Value.GPIO19_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO19_EDGE_LOW(v: u1) Value {
        return Value.GPIO19_EDGE_LOW(.{}, v);
    }
    pub fn GPIO19_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO19_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO19_LEVEL_LOW(v: u1) Value {
        return Value.GPIO19_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO18_EDGE_HIGH(v: u1) Value {
        return Value.GPIO18_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO18_EDGE_LOW(v: u1) Value {
        return Value.GPIO18_EDGE_LOW(.{}, v);
    }
    pub fn GPIO18_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO18_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO18_LEVEL_LOW(v: u1) Value {
        return Value.GPIO18_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO17_EDGE_HIGH(v: u1) Value {
        return Value.GPIO17_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO17_EDGE_LOW(v: u1) Value {
        return Value.GPIO17_EDGE_LOW(.{}, v);
    }
    pub fn GPIO17_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO17_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO17_LEVEL_LOW(v: u1) Value {
        return Value.GPIO17_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO16_EDGE_HIGH(v: u1) Value {
        return Value.GPIO16_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO16_EDGE_LOW(v: u1) Value {
        return Value.GPIO16_EDGE_LOW(.{}, v);
    }
    pub fn GPIO16_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO16_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO16_LEVEL_LOW(v: u1) Value {
        return Value.GPIO16_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Enable for proc0
pub const PROC0_INTE3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001410c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO29_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO29_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO29_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO29_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO28_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO28_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO28_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO28_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO27_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO27_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO27_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO27_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO26_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO26_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO26_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO26_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO25_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO25_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO25_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO25_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO24_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO24_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO24_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO24_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO29_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO29_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO29_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO29_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO28_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO28_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO28_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO28_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO27_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO27_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO27_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO27_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO26_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO26_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO26_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO26_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO25_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO25_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO25_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO25_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO24_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO24_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO24_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO24_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO29_EDGE_HIGH(v: u1) Value {
        return Value.GPIO29_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO29_EDGE_LOW(v: u1) Value {
        return Value.GPIO29_EDGE_LOW(.{}, v);
    }
    pub fn GPIO29_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO29_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO29_LEVEL_LOW(v: u1) Value {
        return Value.GPIO29_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO28_EDGE_HIGH(v: u1) Value {
        return Value.GPIO28_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO28_EDGE_LOW(v: u1) Value {
        return Value.GPIO28_EDGE_LOW(.{}, v);
    }
    pub fn GPIO28_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO28_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO28_LEVEL_LOW(v: u1) Value {
        return Value.GPIO28_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO27_EDGE_HIGH(v: u1) Value {
        return Value.GPIO27_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO27_EDGE_LOW(v: u1) Value {
        return Value.GPIO27_EDGE_LOW(.{}, v);
    }
    pub fn GPIO27_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO27_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO27_LEVEL_LOW(v: u1) Value {
        return Value.GPIO27_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO26_EDGE_HIGH(v: u1) Value {
        return Value.GPIO26_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO26_EDGE_LOW(v: u1) Value {
        return Value.GPIO26_EDGE_LOW(.{}, v);
    }
    pub fn GPIO26_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO26_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO26_LEVEL_LOW(v: u1) Value {
        return Value.GPIO26_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO25_EDGE_HIGH(v: u1) Value {
        return Value.GPIO25_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO25_EDGE_LOW(v: u1) Value {
        return Value.GPIO25_EDGE_LOW(.{}, v);
    }
    pub fn GPIO25_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO25_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO25_LEVEL_LOW(v: u1) Value {
        return Value.GPIO25_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO24_EDGE_HIGH(v: u1) Value {
        return Value.GPIO24_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO24_EDGE_LOW(v: u1) Value {
        return Value.GPIO24_EDGE_LOW(.{}, v);
    }
    pub fn GPIO24_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO24_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO24_LEVEL_LOW(v: u1) Value {
        return Value.GPIO24_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Force for proc0
pub const PROC0_INTF0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014110),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO7_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO7_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO7_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO7_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO6_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO6_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO6_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO6_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO5_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO5_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO5_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO5_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO4_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO4_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO4_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO4_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO3_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO3_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO3_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO3_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO2_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO2_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO2_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO2_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO1_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO1_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO1_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO1_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO0_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO0_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO0_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO0_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO7_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO7_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO7_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO7_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO6_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO6_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO6_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO6_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO5_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO5_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO5_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO5_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO4_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO4_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO4_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO4_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO7_EDGE_HIGH(v: u1) Value {
        return Value.GPIO7_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO7_EDGE_LOW(v: u1) Value {
        return Value.GPIO7_EDGE_LOW(.{}, v);
    }
    pub fn GPIO7_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO7_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO7_LEVEL_LOW(v: u1) Value {
        return Value.GPIO7_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO6_EDGE_HIGH(v: u1) Value {
        return Value.GPIO6_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO6_EDGE_LOW(v: u1) Value {
        return Value.GPIO6_EDGE_LOW(.{}, v);
    }
    pub fn GPIO6_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO6_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO6_LEVEL_LOW(v: u1) Value {
        return Value.GPIO6_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO5_EDGE_HIGH(v: u1) Value {
        return Value.GPIO5_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO5_EDGE_LOW(v: u1) Value {
        return Value.GPIO5_EDGE_LOW(.{}, v);
    }
    pub fn GPIO5_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO5_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO5_LEVEL_LOW(v: u1) Value {
        return Value.GPIO5_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO4_EDGE_HIGH(v: u1) Value {
        return Value.GPIO4_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO4_EDGE_LOW(v: u1) Value {
        return Value.GPIO4_EDGE_LOW(.{}, v);
    }
    pub fn GPIO4_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO4_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO4_LEVEL_LOW(v: u1) Value {
        return Value.GPIO4_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO3_EDGE_HIGH(v: u1) Value {
        return Value.GPIO3_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO3_EDGE_LOW(v: u1) Value {
        return Value.GPIO3_EDGE_LOW(.{}, v);
    }
    pub fn GPIO3_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO3_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO3_LEVEL_LOW(v: u1) Value {
        return Value.GPIO3_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO2_EDGE_HIGH(v: u1) Value {
        return Value.GPIO2_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO2_EDGE_LOW(v: u1) Value {
        return Value.GPIO2_EDGE_LOW(.{}, v);
    }
    pub fn GPIO2_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO2_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO2_LEVEL_LOW(v: u1) Value {
        return Value.GPIO2_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO1_EDGE_HIGH(v: u1) Value {
        return Value.GPIO1_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO1_EDGE_LOW(v: u1) Value {
        return Value.GPIO1_EDGE_LOW(.{}, v);
    }
    pub fn GPIO1_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO1_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO1_LEVEL_LOW(v: u1) Value {
        return Value.GPIO1_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO0_EDGE_HIGH(v: u1) Value {
        return Value.GPIO0_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO0_EDGE_LOW(v: u1) Value {
        return Value.GPIO0_EDGE_LOW(.{}, v);
    }
    pub fn GPIO0_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO0_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO0_LEVEL_LOW(v: u1) Value {
        return Value.GPIO0_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Force for proc0
pub const PROC0_INTF1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014114),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO15_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO15_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO15_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO15_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO14_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO14_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO14_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO14_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO13_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO13_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO13_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO13_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO12_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO12_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO12_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO12_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO11_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO11_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO11_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO11_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO10_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO10_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO10_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO10_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO9_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO9_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO9_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO9_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO8_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO8_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO8_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO8_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO15_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO15_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO15_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO15_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO14_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO14_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO14_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO14_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO13_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO13_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO13_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO13_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO12_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO12_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO12_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO12_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO11_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO11_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO11_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO11_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO10_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO10_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO10_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO10_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO9_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO9_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO9_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO9_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO8_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO8_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO8_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO8_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO15_EDGE_HIGH(v: u1) Value {
        return Value.GPIO15_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO15_EDGE_LOW(v: u1) Value {
        return Value.GPIO15_EDGE_LOW(.{}, v);
    }
    pub fn GPIO15_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO15_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO15_LEVEL_LOW(v: u1) Value {
        return Value.GPIO15_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO14_EDGE_HIGH(v: u1) Value {
        return Value.GPIO14_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO14_EDGE_LOW(v: u1) Value {
        return Value.GPIO14_EDGE_LOW(.{}, v);
    }
    pub fn GPIO14_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO14_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO14_LEVEL_LOW(v: u1) Value {
        return Value.GPIO14_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO13_EDGE_HIGH(v: u1) Value {
        return Value.GPIO13_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO13_EDGE_LOW(v: u1) Value {
        return Value.GPIO13_EDGE_LOW(.{}, v);
    }
    pub fn GPIO13_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO13_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO13_LEVEL_LOW(v: u1) Value {
        return Value.GPIO13_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO12_EDGE_HIGH(v: u1) Value {
        return Value.GPIO12_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO12_EDGE_LOW(v: u1) Value {
        return Value.GPIO12_EDGE_LOW(.{}, v);
    }
    pub fn GPIO12_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO12_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO12_LEVEL_LOW(v: u1) Value {
        return Value.GPIO12_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO11_EDGE_HIGH(v: u1) Value {
        return Value.GPIO11_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO11_EDGE_LOW(v: u1) Value {
        return Value.GPIO11_EDGE_LOW(.{}, v);
    }
    pub fn GPIO11_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO11_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO11_LEVEL_LOW(v: u1) Value {
        return Value.GPIO11_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO10_EDGE_HIGH(v: u1) Value {
        return Value.GPIO10_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO10_EDGE_LOW(v: u1) Value {
        return Value.GPIO10_EDGE_LOW(.{}, v);
    }
    pub fn GPIO10_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO10_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO10_LEVEL_LOW(v: u1) Value {
        return Value.GPIO10_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO9_EDGE_HIGH(v: u1) Value {
        return Value.GPIO9_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO9_EDGE_LOW(v: u1) Value {
        return Value.GPIO9_EDGE_LOW(.{}, v);
    }
    pub fn GPIO9_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO9_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO9_LEVEL_LOW(v: u1) Value {
        return Value.GPIO9_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO8_EDGE_HIGH(v: u1) Value {
        return Value.GPIO8_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO8_EDGE_LOW(v: u1) Value {
        return Value.GPIO8_EDGE_LOW(.{}, v);
    }
    pub fn GPIO8_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO8_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO8_LEVEL_LOW(v: u1) Value {
        return Value.GPIO8_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Force for proc0
pub const PROC0_INTF2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014118),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO23_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO23_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO23_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO23_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO22_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO22_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO22_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO22_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO21_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO21_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO21_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO21_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO20_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO20_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO20_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO20_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO19_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO19_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO19_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO19_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO18_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO18_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO18_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO18_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO17_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO17_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO17_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO17_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO16_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO16_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO16_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO16_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO23_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO23_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO23_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO23_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO22_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO22_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO22_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO22_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO21_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO21_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO21_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO21_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO20_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO20_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO20_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO20_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO19_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO19_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO19_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO19_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO18_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO18_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO18_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO18_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO17_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO17_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO17_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO17_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO16_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO16_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO16_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO16_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO23_EDGE_HIGH(v: u1) Value {
        return Value.GPIO23_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO23_EDGE_LOW(v: u1) Value {
        return Value.GPIO23_EDGE_LOW(.{}, v);
    }
    pub fn GPIO23_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO23_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO23_LEVEL_LOW(v: u1) Value {
        return Value.GPIO23_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO22_EDGE_HIGH(v: u1) Value {
        return Value.GPIO22_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO22_EDGE_LOW(v: u1) Value {
        return Value.GPIO22_EDGE_LOW(.{}, v);
    }
    pub fn GPIO22_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO22_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO22_LEVEL_LOW(v: u1) Value {
        return Value.GPIO22_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO21_EDGE_HIGH(v: u1) Value {
        return Value.GPIO21_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO21_EDGE_LOW(v: u1) Value {
        return Value.GPIO21_EDGE_LOW(.{}, v);
    }
    pub fn GPIO21_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO21_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO21_LEVEL_LOW(v: u1) Value {
        return Value.GPIO21_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO20_EDGE_HIGH(v: u1) Value {
        return Value.GPIO20_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO20_EDGE_LOW(v: u1) Value {
        return Value.GPIO20_EDGE_LOW(.{}, v);
    }
    pub fn GPIO20_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO20_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO20_LEVEL_LOW(v: u1) Value {
        return Value.GPIO20_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO19_EDGE_HIGH(v: u1) Value {
        return Value.GPIO19_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO19_EDGE_LOW(v: u1) Value {
        return Value.GPIO19_EDGE_LOW(.{}, v);
    }
    pub fn GPIO19_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO19_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO19_LEVEL_LOW(v: u1) Value {
        return Value.GPIO19_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO18_EDGE_HIGH(v: u1) Value {
        return Value.GPIO18_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO18_EDGE_LOW(v: u1) Value {
        return Value.GPIO18_EDGE_LOW(.{}, v);
    }
    pub fn GPIO18_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO18_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO18_LEVEL_LOW(v: u1) Value {
        return Value.GPIO18_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO17_EDGE_HIGH(v: u1) Value {
        return Value.GPIO17_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO17_EDGE_LOW(v: u1) Value {
        return Value.GPIO17_EDGE_LOW(.{}, v);
    }
    pub fn GPIO17_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO17_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO17_LEVEL_LOW(v: u1) Value {
        return Value.GPIO17_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO16_EDGE_HIGH(v: u1) Value {
        return Value.GPIO16_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO16_EDGE_LOW(v: u1) Value {
        return Value.GPIO16_EDGE_LOW(.{}, v);
    }
    pub fn GPIO16_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO16_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO16_LEVEL_LOW(v: u1) Value {
        return Value.GPIO16_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Force for proc0
pub const PROC0_INTF3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001411c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO29_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO29_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO29_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO29_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO28_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO28_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO28_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO28_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO27_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO27_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO27_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO27_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO26_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO26_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO26_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO26_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO25_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO25_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO25_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO25_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO24_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO24_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO24_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO24_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO29_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO29_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO29_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO29_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO28_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO28_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO28_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO28_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO27_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO27_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO27_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO27_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO26_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO26_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO26_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO26_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO25_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO25_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO25_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO25_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO24_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO24_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO24_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO24_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO29_EDGE_HIGH(v: u1) Value {
        return Value.GPIO29_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO29_EDGE_LOW(v: u1) Value {
        return Value.GPIO29_EDGE_LOW(.{}, v);
    }
    pub fn GPIO29_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO29_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO29_LEVEL_LOW(v: u1) Value {
        return Value.GPIO29_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO28_EDGE_HIGH(v: u1) Value {
        return Value.GPIO28_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO28_EDGE_LOW(v: u1) Value {
        return Value.GPIO28_EDGE_LOW(.{}, v);
    }
    pub fn GPIO28_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO28_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO28_LEVEL_LOW(v: u1) Value {
        return Value.GPIO28_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO27_EDGE_HIGH(v: u1) Value {
        return Value.GPIO27_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO27_EDGE_LOW(v: u1) Value {
        return Value.GPIO27_EDGE_LOW(.{}, v);
    }
    pub fn GPIO27_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO27_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO27_LEVEL_LOW(v: u1) Value {
        return Value.GPIO27_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO26_EDGE_HIGH(v: u1) Value {
        return Value.GPIO26_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO26_EDGE_LOW(v: u1) Value {
        return Value.GPIO26_EDGE_LOW(.{}, v);
    }
    pub fn GPIO26_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO26_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO26_LEVEL_LOW(v: u1) Value {
        return Value.GPIO26_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO25_EDGE_HIGH(v: u1) Value {
        return Value.GPIO25_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO25_EDGE_LOW(v: u1) Value {
        return Value.GPIO25_EDGE_LOW(.{}, v);
    }
    pub fn GPIO25_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO25_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO25_LEVEL_LOW(v: u1) Value {
        return Value.GPIO25_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO24_EDGE_HIGH(v: u1) Value {
        return Value.GPIO24_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO24_EDGE_LOW(v: u1) Value {
        return Value.GPIO24_EDGE_LOW(.{}, v);
    }
    pub fn GPIO24_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO24_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO24_LEVEL_LOW(v: u1) Value {
        return Value.GPIO24_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt status after masking &amp; forcing for proc0
pub const PROC0_INTS0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014120),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn GPIO7_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO7_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO7_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO7_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO6_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO6_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO6_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO6_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO5_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO5_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO5_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO5_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO4_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO4_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO4_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO4_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt status after masking &amp; forcing for proc0
pub const PROC0_INTS1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014124),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn GPIO15_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO15_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO15_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO15_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO14_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO14_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO14_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO14_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO13_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO13_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO13_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO13_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO12_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO12_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO12_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO12_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO11_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO11_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO11_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO11_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO10_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO10_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO10_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO10_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO9_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO9_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO9_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO9_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO8_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO8_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO8_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO8_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt status after masking &amp; forcing for proc0
pub const PROC0_INTS2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014128),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn GPIO23_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO23_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO23_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO23_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO22_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO22_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO22_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO22_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO21_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO21_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO21_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO21_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO20_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO20_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO20_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO20_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO19_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO19_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO19_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO19_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO18_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO18_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO18_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO18_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO17_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO17_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO17_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO17_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO16_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO16_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO16_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO16_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt status after masking &amp; forcing for proc0
pub const PROC0_INTS3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001412c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn GPIO29_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO29_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO29_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO29_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO28_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO28_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO28_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO28_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO27_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO27_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO27_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO27_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO26_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO26_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO26_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO26_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO25_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO25_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO25_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO25_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO24_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO24_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO24_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO24_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Enable for proc1
pub const PROC1_INTE0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014130),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO7_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO7_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO7_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO7_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO6_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO6_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO6_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO6_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO5_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO5_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO5_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO5_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO4_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO4_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO4_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO4_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO3_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO3_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO3_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO3_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO2_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO2_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO2_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO2_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO1_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO1_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO1_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO1_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO0_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO0_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO0_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO0_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO7_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO7_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO7_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO7_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO6_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO6_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO6_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO6_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO5_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO5_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO5_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO5_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO4_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO4_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO4_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO4_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO7_EDGE_HIGH(v: u1) Value {
        return Value.GPIO7_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO7_EDGE_LOW(v: u1) Value {
        return Value.GPIO7_EDGE_LOW(.{}, v);
    }
    pub fn GPIO7_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO7_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO7_LEVEL_LOW(v: u1) Value {
        return Value.GPIO7_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO6_EDGE_HIGH(v: u1) Value {
        return Value.GPIO6_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO6_EDGE_LOW(v: u1) Value {
        return Value.GPIO6_EDGE_LOW(.{}, v);
    }
    pub fn GPIO6_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO6_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO6_LEVEL_LOW(v: u1) Value {
        return Value.GPIO6_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO5_EDGE_HIGH(v: u1) Value {
        return Value.GPIO5_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO5_EDGE_LOW(v: u1) Value {
        return Value.GPIO5_EDGE_LOW(.{}, v);
    }
    pub fn GPIO5_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO5_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO5_LEVEL_LOW(v: u1) Value {
        return Value.GPIO5_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO4_EDGE_HIGH(v: u1) Value {
        return Value.GPIO4_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO4_EDGE_LOW(v: u1) Value {
        return Value.GPIO4_EDGE_LOW(.{}, v);
    }
    pub fn GPIO4_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO4_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO4_LEVEL_LOW(v: u1) Value {
        return Value.GPIO4_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO3_EDGE_HIGH(v: u1) Value {
        return Value.GPIO3_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO3_EDGE_LOW(v: u1) Value {
        return Value.GPIO3_EDGE_LOW(.{}, v);
    }
    pub fn GPIO3_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO3_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO3_LEVEL_LOW(v: u1) Value {
        return Value.GPIO3_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO2_EDGE_HIGH(v: u1) Value {
        return Value.GPIO2_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO2_EDGE_LOW(v: u1) Value {
        return Value.GPIO2_EDGE_LOW(.{}, v);
    }
    pub fn GPIO2_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO2_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO2_LEVEL_LOW(v: u1) Value {
        return Value.GPIO2_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO1_EDGE_HIGH(v: u1) Value {
        return Value.GPIO1_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO1_EDGE_LOW(v: u1) Value {
        return Value.GPIO1_EDGE_LOW(.{}, v);
    }
    pub fn GPIO1_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO1_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO1_LEVEL_LOW(v: u1) Value {
        return Value.GPIO1_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO0_EDGE_HIGH(v: u1) Value {
        return Value.GPIO0_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO0_EDGE_LOW(v: u1) Value {
        return Value.GPIO0_EDGE_LOW(.{}, v);
    }
    pub fn GPIO0_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO0_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO0_LEVEL_LOW(v: u1) Value {
        return Value.GPIO0_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Enable for proc1
pub const PROC1_INTE1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014134),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO15_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO15_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO15_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO15_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO14_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO14_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO14_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO14_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO13_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO13_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO13_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO13_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO12_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO12_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO12_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO12_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO11_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO11_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO11_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO11_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO10_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO10_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO10_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO10_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO9_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO9_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO9_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO9_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO8_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO8_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO8_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO8_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO15_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO15_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO15_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO15_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO14_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO14_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO14_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO14_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO13_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO13_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO13_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO13_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO12_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO12_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO12_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO12_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO11_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO11_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO11_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO11_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO10_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO10_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO10_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO10_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO9_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO9_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO9_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO9_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO8_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO8_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO8_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO8_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO15_EDGE_HIGH(v: u1) Value {
        return Value.GPIO15_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO15_EDGE_LOW(v: u1) Value {
        return Value.GPIO15_EDGE_LOW(.{}, v);
    }
    pub fn GPIO15_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO15_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO15_LEVEL_LOW(v: u1) Value {
        return Value.GPIO15_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO14_EDGE_HIGH(v: u1) Value {
        return Value.GPIO14_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO14_EDGE_LOW(v: u1) Value {
        return Value.GPIO14_EDGE_LOW(.{}, v);
    }
    pub fn GPIO14_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO14_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO14_LEVEL_LOW(v: u1) Value {
        return Value.GPIO14_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO13_EDGE_HIGH(v: u1) Value {
        return Value.GPIO13_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO13_EDGE_LOW(v: u1) Value {
        return Value.GPIO13_EDGE_LOW(.{}, v);
    }
    pub fn GPIO13_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO13_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO13_LEVEL_LOW(v: u1) Value {
        return Value.GPIO13_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO12_EDGE_HIGH(v: u1) Value {
        return Value.GPIO12_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO12_EDGE_LOW(v: u1) Value {
        return Value.GPIO12_EDGE_LOW(.{}, v);
    }
    pub fn GPIO12_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO12_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO12_LEVEL_LOW(v: u1) Value {
        return Value.GPIO12_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO11_EDGE_HIGH(v: u1) Value {
        return Value.GPIO11_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO11_EDGE_LOW(v: u1) Value {
        return Value.GPIO11_EDGE_LOW(.{}, v);
    }
    pub fn GPIO11_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO11_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO11_LEVEL_LOW(v: u1) Value {
        return Value.GPIO11_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO10_EDGE_HIGH(v: u1) Value {
        return Value.GPIO10_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO10_EDGE_LOW(v: u1) Value {
        return Value.GPIO10_EDGE_LOW(.{}, v);
    }
    pub fn GPIO10_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO10_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO10_LEVEL_LOW(v: u1) Value {
        return Value.GPIO10_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO9_EDGE_HIGH(v: u1) Value {
        return Value.GPIO9_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO9_EDGE_LOW(v: u1) Value {
        return Value.GPIO9_EDGE_LOW(.{}, v);
    }
    pub fn GPIO9_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO9_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO9_LEVEL_LOW(v: u1) Value {
        return Value.GPIO9_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO8_EDGE_HIGH(v: u1) Value {
        return Value.GPIO8_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO8_EDGE_LOW(v: u1) Value {
        return Value.GPIO8_EDGE_LOW(.{}, v);
    }
    pub fn GPIO8_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO8_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO8_LEVEL_LOW(v: u1) Value {
        return Value.GPIO8_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Enable for proc1
pub const PROC1_INTE2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014138),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO23_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO23_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO23_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO23_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO22_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO22_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO22_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO22_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO21_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO21_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO21_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO21_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO20_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO20_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO20_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO20_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO19_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO19_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO19_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO19_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO18_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO18_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO18_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO18_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO17_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO17_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO17_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO17_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO16_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO16_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO16_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO16_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO23_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO23_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO23_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO23_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO22_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO22_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO22_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO22_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO21_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO21_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO21_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO21_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO20_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO20_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO20_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO20_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO19_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO19_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO19_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO19_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO18_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO18_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO18_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO18_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO17_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO17_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO17_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO17_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO16_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO16_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO16_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO16_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO23_EDGE_HIGH(v: u1) Value {
        return Value.GPIO23_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO23_EDGE_LOW(v: u1) Value {
        return Value.GPIO23_EDGE_LOW(.{}, v);
    }
    pub fn GPIO23_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO23_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO23_LEVEL_LOW(v: u1) Value {
        return Value.GPIO23_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO22_EDGE_HIGH(v: u1) Value {
        return Value.GPIO22_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO22_EDGE_LOW(v: u1) Value {
        return Value.GPIO22_EDGE_LOW(.{}, v);
    }
    pub fn GPIO22_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO22_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO22_LEVEL_LOW(v: u1) Value {
        return Value.GPIO22_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO21_EDGE_HIGH(v: u1) Value {
        return Value.GPIO21_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO21_EDGE_LOW(v: u1) Value {
        return Value.GPIO21_EDGE_LOW(.{}, v);
    }
    pub fn GPIO21_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO21_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO21_LEVEL_LOW(v: u1) Value {
        return Value.GPIO21_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO20_EDGE_HIGH(v: u1) Value {
        return Value.GPIO20_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO20_EDGE_LOW(v: u1) Value {
        return Value.GPIO20_EDGE_LOW(.{}, v);
    }
    pub fn GPIO20_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO20_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO20_LEVEL_LOW(v: u1) Value {
        return Value.GPIO20_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO19_EDGE_HIGH(v: u1) Value {
        return Value.GPIO19_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO19_EDGE_LOW(v: u1) Value {
        return Value.GPIO19_EDGE_LOW(.{}, v);
    }
    pub fn GPIO19_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO19_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO19_LEVEL_LOW(v: u1) Value {
        return Value.GPIO19_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO18_EDGE_HIGH(v: u1) Value {
        return Value.GPIO18_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO18_EDGE_LOW(v: u1) Value {
        return Value.GPIO18_EDGE_LOW(.{}, v);
    }
    pub fn GPIO18_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO18_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO18_LEVEL_LOW(v: u1) Value {
        return Value.GPIO18_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO17_EDGE_HIGH(v: u1) Value {
        return Value.GPIO17_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO17_EDGE_LOW(v: u1) Value {
        return Value.GPIO17_EDGE_LOW(.{}, v);
    }
    pub fn GPIO17_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO17_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO17_LEVEL_LOW(v: u1) Value {
        return Value.GPIO17_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO16_EDGE_HIGH(v: u1) Value {
        return Value.GPIO16_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO16_EDGE_LOW(v: u1) Value {
        return Value.GPIO16_EDGE_LOW(.{}, v);
    }
    pub fn GPIO16_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO16_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO16_LEVEL_LOW(v: u1) Value {
        return Value.GPIO16_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Enable for proc1
pub const PROC1_INTE3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001413c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO29_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO29_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO29_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO29_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO28_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO28_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO28_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO28_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO27_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO27_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO27_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO27_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO26_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO26_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO26_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO26_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO25_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO25_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO25_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO25_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO24_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO24_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO24_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO24_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO29_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO29_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO29_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO29_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO28_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO28_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO28_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO28_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO27_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO27_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO27_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO27_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO26_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO26_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO26_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO26_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO25_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO25_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO25_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO25_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO24_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO24_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO24_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO24_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO29_EDGE_HIGH(v: u1) Value {
        return Value.GPIO29_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO29_EDGE_LOW(v: u1) Value {
        return Value.GPIO29_EDGE_LOW(.{}, v);
    }
    pub fn GPIO29_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO29_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO29_LEVEL_LOW(v: u1) Value {
        return Value.GPIO29_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO28_EDGE_HIGH(v: u1) Value {
        return Value.GPIO28_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO28_EDGE_LOW(v: u1) Value {
        return Value.GPIO28_EDGE_LOW(.{}, v);
    }
    pub fn GPIO28_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO28_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO28_LEVEL_LOW(v: u1) Value {
        return Value.GPIO28_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO27_EDGE_HIGH(v: u1) Value {
        return Value.GPIO27_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO27_EDGE_LOW(v: u1) Value {
        return Value.GPIO27_EDGE_LOW(.{}, v);
    }
    pub fn GPIO27_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO27_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO27_LEVEL_LOW(v: u1) Value {
        return Value.GPIO27_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO26_EDGE_HIGH(v: u1) Value {
        return Value.GPIO26_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO26_EDGE_LOW(v: u1) Value {
        return Value.GPIO26_EDGE_LOW(.{}, v);
    }
    pub fn GPIO26_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO26_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO26_LEVEL_LOW(v: u1) Value {
        return Value.GPIO26_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO25_EDGE_HIGH(v: u1) Value {
        return Value.GPIO25_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO25_EDGE_LOW(v: u1) Value {
        return Value.GPIO25_EDGE_LOW(.{}, v);
    }
    pub fn GPIO25_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO25_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO25_LEVEL_LOW(v: u1) Value {
        return Value.GPIO25_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO24_EDGE_HIGH(v: u1) Value {
        return Value.GPIO24_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO24_EDGE_LOW(v: u1) Value {
        return Value.GPIO24_EDGE_LOW(.{}, v);
    }
    pub fn GPIO24_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO24_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO24_LEVEL_LOW(v: u1) Value {
        return Value.GPIO24_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Force for proc1
pub const PROC1_INTF0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014140),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO7_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO7_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO7_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO7_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO6_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO6_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO6_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO6_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO5_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO5_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO5_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO5_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO4_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO4_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO4_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO4_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO3_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO3_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO3_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO3_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO2_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO2_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO2_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO2_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO1_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO1_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO1_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO1_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO0_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO0_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO0_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO0_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO7_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO7_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO7_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO7_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO6_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO6_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO6_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO6_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO5_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO5_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO5_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO5_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO4_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO4_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO4_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO4_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO7_EDGE_HIGH(v: u1) Value {
        return Value.GPIO7_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO7_EDGE_LOW(v: u1) Value {
        return Value.GPIO7_EDGE_LOW(.{}, v);
    }
    pub fn GPIO7_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO7_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO7_LEVEL_LOW(v: u1) Value {
        return Value.GPIO7_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO6_EDGE_HIGH(v: u1) Value {
        return Value.GPIO6_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO6_EDGE_LOW(v: u1) Value {
        return Value.GPIO6_EDGE_LOW(.{}, v);
    }
    pub fn GPIO6_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO6_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO6_LEVEL_LOW(v: u1) Value {
        return Value.GPIO6_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO5_EDGE_HIGH(v: u1) Value {
        return Value.GPIO5_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO5_EDGE_LOW(v: u1) Value {
        return Value.GPIO5_EDGE_LOW(.{}, v);
    }
    pub fn GPIO5_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO5_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO5_LEVEL_LOW(v: u1) Value {
        return Value.GPIO5_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO4_EDGE_HIGH(v: u1) Value {
        return Value.GPIO4_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO4_EDGE_LOW(v: u1) Value {
        return Value.GPIO4_EDGE_LOW(.{}, v);
    }
    pub fn GPIO4_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO4_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO4_LEVEL_LOW(v: u1) Value {
        return Value.GPIO4_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO3_EDGE_HIGH(v: u1) Value {
        return Value.GPIO3_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO3_EDGE_LOW(v: u1) Value {
        return Value.GPIO3_EDGE_LOW(.{}, v);
    }
    pub fn GPIO3_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO3_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO3_LEVEL_LOW(v: u1) Value {
        return Value.GPIO3_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO2_EDGE_HIGH(v: u1) Value {
        return Value.GPIO2_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO2_EDGE_LOW(v: u1) Value {
        return Value.GPIO2_EDGE_LOW(.{}, v);
    }
    pub fn GPIO2_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO2_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO2_LEVEL_LOW(v: u1) Value {
        return Value.GPIO2_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO1_EDGE_HIGH(v: u1) Value {
        return Value.GPIO1_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO1_EDGE_LOW(v: u1) Value {
        return Value.GPIO1_EDGE_LOW(.{}, v);
    }
    pub fn GPIO1_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO1_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO1_LEVEL_LOW(v: u1) Value {
        return Value.GPIO1_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO0_EDGE_HIGH(v: u1) Value {
        return Value.GPIO0_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO0_EDGE_LOW(v: u1) Value {
        return Value.GPIO0_EDGE_LOW(.{}, v);
    }
    pub fn GPIO0_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO0_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO0_LEVEL_LOW(v: u1) Value {
        return Value.GPIO0_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Force for proc1
pub const PROC1_INTF1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014144),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO15_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO15_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO15_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO15_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO14_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO14_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO14_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO14_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO13_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO13_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO13_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO13_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO12_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO12_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO12_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO12_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO11_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO11_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO11_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO11_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO10_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO10_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO10_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO10_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO9_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO9_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO9_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO9_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO8_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO8_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO8_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO8_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO15_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO15_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO15_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO15_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO14_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO14_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO14_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO14_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO13_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO13_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO13_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO13_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO12_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO12_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO12_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO12_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO11_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO11_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO11_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO11_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO10_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO10_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO10_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO10_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO9_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO9_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO9_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO9_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO8_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO8_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO8_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO8_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO15_EDGE_HIGH(v: u1) Value {
        return Value.GPIO15_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO15_EDGE_LOW(v: u1) Value {
        return Value.GPIO15_EDGE_LOW(.{}, v);
    }
    pub fn GPIO15_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO15_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO15_LEVEL_LOW(v: u1) Value {
        return Value.GPIO15_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO14_EDGE_HIGH(v: u1) Value {
        return Value.GPIO14_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO14_EDGE_LOW(v: u1) Value {
        return Value.GPIO14_EDGE_LOW(.{}, v);
    }
    pub fn GPIO14_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO14_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO14_LEVEL_LOW(v: u1) Value {
        return Value.GPIO14_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO13_EDGE_HIGH(v: u1) Value {
        return Value.GPIO13_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO13_EDGE_LOW(v: u1) Value {
        return Value.GPIO13_EDGE_LOW(.{}, v);
    }
    pub fn GPIO13_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO13_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO13_LEVEL_LOW(v: u1) Value {
        return Value.GPIO13_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO12_EDGE_HIGH(v: u1) Value {
        return Value.GPIO12_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO12_EDGE_LOW(v: u1) Value {
        return Value.GPIO12_EDGE_LOW(.{}, v);
    }
    pub fn GPIO12_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO12_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO12_LEVEL_LOW(v: u1) Value {
        return Value.GPIO12_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO11_EDGE_HIGH(v: u1) Value {
        return Value.GPIO11_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO11_EDGE_LOW(v: u1) Value {
        return Value.GPIO11_EDGE_LOW(.{}, v);
    }
    pub fn GPIO11_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO11_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO11_LEVEL_LOW(v: u1) Value {
        return Value.GPIO11_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO10_EDGE_HIGH(v: u1) Value {
        return Value.GPIO10_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO10_EDGE_LOW(v: u1) Value {
        return Value.GPIO10_EDGE_LOW(.{}, v);
    }
    pub fn GPIO10_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO10_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO10_LEVEL_LOW(v: u1) Value {
        return Value.GPIO10_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO9_EDGE_HIGH(v: u1) Value {
        return Value.GPIO9_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO9_EDGE_LOW(v: u1) Value {
        return Value.GPIO9_EDGE_LOW(.{}, v);
    }
    pub fn GPIO9_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO9_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO9_LEVEL_LOW(v: u1) Value {
        return Value.GPIO9_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO8_EDGE_HIGH(v: u1) Value {
        return Value.GPIO8_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO8_EDGE_LOW(v: u1) Value {
        return Value.GPIO8_EDGE_LOW(.{}, v);
    }
    pub fn GPIO8_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO8_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO8_LEVEL_LOW(v: u1) Value {
        return Value.GPIO8_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Force for proc1
pub const PROC1_INTF2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014148),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO23_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO23_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO23_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO23_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO22_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO22_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO22_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO22_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO21_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO21_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO21_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO21_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO20_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO20_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO20_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO20_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO19_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO19_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO19_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO19_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO18_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO18_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO18_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO18_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO17_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO17_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO17_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO17_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO16_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO16_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO16_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO16_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO23_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO23_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO23_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO23_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO22_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO22_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO22_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO22_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO21_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO21_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO21_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO21_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO20_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO20_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO20_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO20_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO19_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO19_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO19_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO19_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO18_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO18_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO18_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO18_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO17_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO17_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO17_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO17_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO16_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO16_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO16_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO16_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO23_EDGE_HIGH(v: u1) Value {
        return Value.GPIO23_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO23_EDGE_LOW(v: u1) Value {
        return Value.GPIO23_EDGE_LOW(.{}, v);
    }
    pub fn GPIO23_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO23_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO23_LEVEL_LOW(v: u1) Value {
        return Value.GPIO23_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO22_EDGE_HIGH(v: u1) Value {
        return Value.GPIO22_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO22_EDGE_LOW(v: u1) Value {
        return Value.GPIO22_EDGE_LOW(.{}, v);
    }
    pub fn GPIO22_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO22_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO22_LEVEL_LOW(v: u1) Value {
        return Value.GPIO22_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO21_EDGE_HIGH(v: u1) Value {
        return Value.GPIO21_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO21_EDGE_LOW(v: u1) Value {
        return Value.GPIO21_EDGE_LOW(.{}, v);
    }
    pub fn GPIO21_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO21_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO21_LEVEL_LOW(v: u1) Value {
        return Value.GPIO21_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO20_EDGE_HIGH(v: u1) Value {
        return Value.GPIO20_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO20_EDGE_LOW(v: u1) Value {
        return Value.GPIO20_EDGE_LOW(.{}, v);
    }
    pub fn GPIO20_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO20_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO20_LEVEL_LOW(v: u1) Value {
        return Value.GPIO20_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO19_EDGE_HIGH(v: u1) Value {
        return Value.GPIO19_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO19_EDGE_LOW(v: u1) Value {
        return Value.GPIO19_EDGE_LOW(.{}, v);
    }
    pub fn GPIO19_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO19_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO19_LEVEL_LOW(v: u1) Value {
        return Value.GPIO19_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO18_EDGE_HIGH(v: u1) Value {
        return Value.GPIO18_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO18_EDGE_LOW(v: u1) Value {
        return Value.GPIO18_EDGE_LOW(.{}, v);
    }
    pub fn GPIO18_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO18_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO18_LEVEL_LOW(v: u1) Value {
        return Value.GPIO18_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO17_EDGE_HIGH(v: u1) Value {
        return Value.GPIO17_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO17_EDGE_LOW(v: u1) Value {
        return Value.GPIO17_EDGE_LOW(.{}, v);
    }
    pub fn GPIO17_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO17_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO17_LEVEL_LOW(v: u1) Value {
        return Value.GPIO17_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO16_EDGE_HIGH(v: u1) Value {
        return Value.GPIO16_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO16_EDGE_LOW(v: u1) Value {
        return Value.GPIO16_EDGE_LOW(.{}, v);
    }
    pub fn GPIO16_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO16_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO16_LEVEL_LOW(v: u1) Value {
        return Value.GPIO16_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Force for proc1
pub const PROC1_INTF3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001414c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO29_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO29_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO29_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO29_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO28_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO28_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO28_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO28_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO27_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO27_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO27_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO27_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO26_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO26_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO26_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO26_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO25_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO25_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO25_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO25_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO24_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO24_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO24_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO24_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO29_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO29_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO29_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO29_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO28_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO28_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO28_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO28_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO27_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO27_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO27_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO27_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO26_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO26_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO26_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO26_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO25_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO25_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO25_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO25_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO24_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO24_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO24_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO24_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO29_EDGE_HIGH(v: u1) Value {
        return Value.GPIO29_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO29_EDGE_LOW(v: u1) Value {
        return Value.GPIO29_EDGE_LOW(.{}, v);
    }
    pub fn GPIO29_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO29_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO29_LEVEL_LOW(v: u1) Value {
        return Value.GPIO29_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO28_EDGE_HIGH(v: u1) Value {
        return Value.GPIO28_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO28_EDGE_LOW(v: u1) Value {
        return Value.GPIO28_EDGE_LOW(.{}, v);
    }
    pub fn GPIO28_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO28_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO28_LEVEL_LOW(v: u1) Value {
        return Value.GPIO28_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO27_EDGE_HIGH(v: u1) Value {
        return Value.GPIO27_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO27_EDGE_LOW(v: u1) Value {
        return Value.GPIO27_EDGE_LOW(.{}, v);
    }
    pub fn GPIO27_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO27_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO27_LEVEL_LOW(v: u1) Value {
        return Value.GPIO27_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO26_EDGE_HIGH(v: u1) Value {
        return Value.GPIO26_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO26_EDGE_LOW(v: u1) Value {
        return Value.GPIO26_EDGE_LOW(.{}, v);
    }
    pub fn GPIO26_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO26_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO26_LEVEL_LOW(v: u1) Value {
        return Value.GPIO26_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO25_EDGE_HIGH(v: u1) Value {
        return Value.GPIO25_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO25_EDGE_LOW(v: u1) Value {
        return Value.GPIO25_EDGE_LOW(.{}, v);
    }
    pub fn GPIO25_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO25_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO25_LEVEL_LOW(v: u1) Value {
        return Value.GPIO25_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO24_EDGE_HIGH(v: u1) Value {
        return Value.GPIO24_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO24_EDGE_LOW(v: u1) Value {
        return Value.GPIO24_EDGE_LOW(.{}, v);
    }
    pub fn GPIO24_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO24_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO24_LEVEL_LOW(v: u1) Value {
        return Value.GPIO24_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt status after masking &amp; forcing for proc1
pub const PROC1_INTS0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014150),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn GPIO7_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO7_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO7_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO7_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO6_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO6_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO6_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO6_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO5_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO5_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO5_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO5_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO4_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO4_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO4_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO4_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt status after masking &amp; forcing for proc1
pub const PROC1_INTS1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014154),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn GPIO15_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO15_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO15_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO15_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO14_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO14_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO14_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO14_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO13_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO13_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO13_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO13_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO12_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO12_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO12_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO12_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO11_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO11_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO11_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO11_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO10_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO10_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO10_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO10_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO9_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO9_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO9_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO9_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO8_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO8_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO8_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO8_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt status after masking &amp; forcing for proc1
pub const PROC1_INTS2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014158),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn GPIO23_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO23_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO23_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO23_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO22_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO22_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO22_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO22_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO21_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO21_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO21_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO21_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO20_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO20_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO20_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO20_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO19_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO19_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO19_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO19_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO18_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO18_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO18_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO18_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO17_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO17_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO17_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO17_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO16_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO16_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO16_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO16_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt status after masking &amp; forcing for proc1
pub const PROC1_INTS3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001415c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn GPIO29_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO29_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO29_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO29_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO28_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO28_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO28_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO28_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO27_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO27_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO27_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO27_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO26_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO26_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO26_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO26_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO25_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO25_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO25_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO25_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO24_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO24_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO24_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO24_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Enable for dormant_wake
pub const DORMANT_WAKE_INTE0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014160),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO7_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO7_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO7_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO7_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO6_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO6_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO6_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO6_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO5_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO5_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO5_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO5_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO4_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO4_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO4_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO4_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO3_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO3_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO3_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO3_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO2_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO2_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO2_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO2_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO1_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO1_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO1_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO1_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO0_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO0_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO0_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO0_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO7_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO7_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO7_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO7_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO6_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO6_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO6_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO6_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO5_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO5_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO5_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO5_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO4_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO4_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO4_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO4_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO7_EDGE_HIGH(v: u1) Value {
        return Value.GPIO7_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO7_EDGE_LOW(v: u1) Value {
        return Value.GPIO7_EDGE_LOW(.{}, v);
    }
    pub fn GPIO7_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO7_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO7_LEVEL_LOW(v: u1) Value {
        return Value.GPIO7_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO6_EDGE_HIGH(v: u1) Value {
        return Value.GPIO6_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO6_EDGE_LOW(v: u1) Value {
        return Value.GPIO6_EDGE_LOW(.{}, v);
    }
    pub fn GPIO6_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO6_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO6_LEVEL_LOW(v: u1) Value {
        return Value.GPIO6_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO5_EDGE_HIGH(v: u1) Value {
        return Value.GPIO5_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO5_EDGE_LOW(v: u1) Value {
        return Value.GPIO5_EDGE_LOW(.{}, v);
    }
    pub fn GPIO5_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO5_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO5_LEVEL_LOW(v: u1) Value {
        return Value.GPIO5_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO4_EDGE_HIGH(v: u1) Value {
        return Value.GPIO4_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO4_EDGE_LOW(v: u1) Value {
        return Value.GPIO4_EDGE_LOW(.{}, v);
    }
    pub fn GPIO4_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO4_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO4_LEVEL_LOW(v: u1) Value {
        return Value.GPIO4_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO3_EDGE_HIGH(v: u1) Value {
        return Value.GPIO3_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO3_EDGE_LOW(v: u1) Value {
        return Value.GPIO3_EDGE_LOW(.{}, v);
    }
    pub fn GPIO3_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO3_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO3_LEVEL_LOW(v: u1) Value {
        return Value.GPIO3_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO2_EDGE_HIGH(v: u1) Value {
        return Value.GPIO2_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO2_EDGE_LOW(v: u1) Value {
        return Value.GPIO2_EDGE_LOW(.{}, v);
    }
    pub fn GPIO2_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO2_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO2_LEVEL_LOW(v: u1) Value {
        return Value.GPIO2_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO1_EDGE_HIGH(v: u1) Value {
        return Value.GPIO1_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO1_EDGE_LOW(v: u1) Value {
        return Value.GPIO1_EDGE_LOW(.{}, v);
    }
    pub fn GPIO1_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO1_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO1_LEVEL_LOW(v: u1) Value {
        return Value.GPIO1_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO0_EDGE_HIGH(v: u1) Value {
        return Value.GPIO0_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO0_EDGE_LOW(v: u1) Value {
        return Value.GPIO0_EDGE_LOW(.{}, v);
    }
    pub fn GPIO0_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO0_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO0_LEVEL_LOW(v: u1) Value {
        return Value.GPIO0_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Enable for dormant_wake
pub const DORMANT_WAKE_INTE1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014164),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO15_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO15_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO15_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO15_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO14_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO14_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO14_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO14_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO13_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO13_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO13_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO13_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO12_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO12_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO12_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO12_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO11_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO11_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO11_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO11_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO10_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO10_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO10_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO10_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO9_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO9_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO9_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO9_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO8_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO8_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO8_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO8_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO15_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO15_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO15_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO15_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO14_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO14_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO14_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO14_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO13_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO13_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO13_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO13_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO12_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO12_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO12_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO12_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO11_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO11_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO11_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO11_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO10_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO10_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO10_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO10_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO9_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO9_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO9_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO9_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO8_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO8_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO8_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO8_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO15_EDGE_HIGH(v: u1) Value {
        return Value.GPIO15_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO15_EDGE_LOW(v: u1) Value {
        return Value.GPIO15_EDGE_LOW(.{}, v);
    }
    pub fn GPIO15_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO15_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO15_LEVEL_LOW(v: u1) Value {
        return Value.GPIO15_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO14_EDGE_HIGH(v: u1) Value {
        return Value.GPIO14_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO14_EDGE_LOW(v: u1) Value {
        return Value.GPIO14_EDGE_LOW(.{}, v);
    }
    pub fn GPIO14_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO14_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO14_LEVEL_LOW(v: u1) Value {
        return Value.GPIO14_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO13_EDGE_HIGH(v: u1) Value {
        return Value.GPIO13_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO13_EDGE_LOW(v: u1) Value {
        return Value.GPIO13_EDGE_LOW(.{}, v);
    }
    pub fn GPIO13_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO13_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO13_LEVEL_LOW(v: u1) Value {
        return Value.GPIO13_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO12_EDGE_HIGH(v: u1) Value {
        return Value.GPIO12_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO12_EDGE_LOW(v: u1) Value {
        return Value.GPIO12_EDGE_LOW(.{}, v);
    }
    pub fn GPIO12_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO12_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO12_LEVEL_LOW(v: u1) Value {
        return Value.GPIO12_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO11_EDGE_HIGH(v: u1) Value {
        return Value.GPIO11_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO11_EDGE_LOW(v: u1) Value {
        return Value.GPIO11_EDGE_LOW(.{}, v);
    }
    pub fn GPIO11_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO11_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO11_LEVEL_LOW(v: u1) Value {
        return Value.GPIO11_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO10_EDGE_HIGH(v: u1) Value {
        return Value.GPIO10_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO10_EDGE_LOW(v: u1) Value {
        return Value.GPIO10_EDGE_LOW(.{}, v);
    }
    pub fn GPIO10_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO10_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO10_LEVEL_LOW(v: u1) Value {
        return Value.GPIO10_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO9_EDGE_HIGH(v: u1) Value {
        return Value.GPIO9_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO9_EDGE_LOW(v: u1) Value {
        return Value.GPIO9_EDGE_LOW(.{}, v);
    }
    pub fn GPIO9_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO9_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO9_LEVEL_LOW(v: u1) Value {
        return Value.GPIO9_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO8_EDGE_HIGH(v: u1) Value {
        return Value.GPIO8_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO8_EDGE_LOW(v: u1) Value {
        return Value.GPIO8_EDGE_LOW(.{}, v);
    }
    pub fn GPIO8_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO8_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO8_LEVEL_LOW(v: u1) Value {
        return Value.GPIO8_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Enable for dormant_wake
pub const DORMANT_WAKE_INTE2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014168),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO23_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO23_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO23_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO23_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO22_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO22_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO22_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO22_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO21_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO21_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO21_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO21_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO20_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO20_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO20_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO20_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO19_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO19_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO19_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO19_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO18_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO18_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO18_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO18_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO17_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO17_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO17_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO17_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO16_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO16_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO16_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO16_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO23_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO23_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO23_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO23_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO22_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO22_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO22_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO22_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO21_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO21_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO21_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO21_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO20_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO20_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO20_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO20_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO19_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO19_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO19_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO19_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO18_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO18_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO18_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO18_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO17_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO17_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO17_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO17_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO16_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO16_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO16_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO16_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO23_EDGE_HIGH(v: u1) Value {
        return Value.GPIO23_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO23_EDGE_LOW(v: u1) Value {
        return Value.GPIO23_EDGE_LOW(.{}, v);
    }
    pub fn GPIO23_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO23_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO23_LEVEL_LOW(v: u1) Value {
        return Value.GPIO23_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO22_EDGE_HIGH(v: u1) Value {
        return Value.GPIO22_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO22_EDGE_LOW(v: u1) Value {
        return Value.GPIO22_EDGE_LOW(.{}, v);
    }
    pub fn GPIO22_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO22_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO22_LEVEL_LOW(v: u1) Value {
        return Value.GPIO22_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO21_EDGE_HIGH(v: u1) Value {
        return Value.GPIO21_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO21_EDGE_LOW(v: u1) Value {
        return Value.GPIO21_EDGE_LOW(.{}, v);
    }
    pub fn GPIO21_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO21_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO21_LEVEL_LOW(v: u1) Value {
        return Value.GPIO21_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO20_EDGE_HIGH(v: u1) Value {
        return Value.GPIO20_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO20_EDGE_LOW(v: u1) Value {
        return Value.GPIO20_EDGE_LOW(.{}, v);
    }
    pub fn GPIO20_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO20_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO20_LEVEL_LOW(v: u1) Value {
        return Value.GPIO20_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO19_EDGE_HIGH(v: u1) Value {
        return Value.GPIO19_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO19_EDGE_LOW(v: u1) Value {
        return Value.GPIO19_EDGE_LOW(.{}, v);
    }
    pub fn GPIO19_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO19_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO19_LEVEL_LOW(v: u1) Value {
        return Value.GPIO19_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO18_EDGE_HIGH(v: u1) Value {
        return Value.GPIO18_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO18_EDGE_LOW(v: u1) Value {
        return Value.GPIO18_EDGE_LOW(.{}, v);
    }
    pub fn GPIO18_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO18_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO18_LEVEL_LOW(v: u1) Value {
        return Value.GPIO18_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO17_EDGE_HIGH(v: u1) Value {
        return Value.GPIO17_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO17_EDGE_LOW(v: u1) Value {
        return Value.GPIO17_EDGE_LOW(.{}, v);
    }
    pub fn GPIO17_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO17_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO17_LEVEL_LOW(v: u1) Value {
        return Value.GPIO17_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO16_EDGE_HIGH(v: u1) Value {
        return Value.GPIO16_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO16_EDGE_LOW(v: u1) Value {
        return Value.GPIO16_EDGE_LOW(.{}, v);
    }
    pub fn GPIO16_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO16_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO16_LEVEL_LOW(v: u1) Value {
        return Value.GPIO16_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Enable for dormant_wake
pub const DORMANT_WAKE_INTE3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001416c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO29_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO29_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO29_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO29_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO28_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO28_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO28_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO28_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO27_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO27_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO27_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO27_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO26_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO26_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO26_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO26_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO25_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO25_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO25_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO25_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO24_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO24_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO24_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO24_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO29_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO29_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO29_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO29_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO28_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO28_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO28_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO28_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO27_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO27_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO27_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO27_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO26_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO26_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO26_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO26_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO25_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO25_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO25_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO25_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO24_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO24_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO24_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO24_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO29_EDGE_HIGH(v: u1) Value {
        return Value.GPIO29_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO29_EDGE_LOW(v: u1) Value {
        return Value.GPIO29_EDGE_LOW(.{}, v);
    }
    pub fn GPIO29_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO29_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO29_LEVEL_LOW(v: u1) Value {
        return Value.GPIO29_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO28_EDGE_HIGH(v: u1) Value {
        return Value.GPIO28_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO28_EDGE_LOW(v: u1) Value {
        return Value.GPIO28_EDGE_LOW(.{}, v);
    }
    pub fn GPIO28_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO28_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO28_LEVEL_LOW(v: u1) Value {
        return Value.GPIO28_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO27_EDGE_HIGH(v: u1) Value {
        return Value.GPIO27_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO27_EDGE_LOW(v: u1) Value {
        return Value.GPIO27_EDGE_LOW(.{}, v);
    }
    pub fn GPIO27_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO27_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO27_LEVEL_LOW(v: u1) Value {
        return Value.GPIO27_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO26_EDGE_HIGH(v: u1) Value {
        return Value.GPIO26_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO26_EDGE_LOW(v: u1) Value {
        return Value.GPIO26_EDGE_LOW(.{}, v);
    }
    pub fn GPIO26_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO26_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO26_LEVEL_LOW(v: u1) Value {
        return Value.GPIO26_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO25_EDGE_HIGH(v: u1) Value {
        return Value.GPIO25_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO25_EDGE_LOW(v: u1) Value {
        return Value.GPIO25_EDGE_LOW(.{}, v);
    }
    pub fn GPIO25_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO25_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO25_LEVEL_LOW(v: u1) Value {
        return Value.GPIO25_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO24_EDGE_HIGH(v: u1) Value {
        return Value.GPIO24_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO24_EDGE_LOW(v: u1) Value {
        return Value.GPIO24_EDGE_LOW(.{}, v);
    }
    pub fn GPIO24_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO24_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO24_LEVEL_LOW(v: u1) Value {
        return Value.GPIO24_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Force for dormant_wake
pub const DORMANT_WAKE_INTF0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014170),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO7_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO7_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO7_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO7_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO6_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO6_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO6_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO6_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO5_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO5_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO5_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO5_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO4_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO4_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO4_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO4_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO3_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO3_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO3_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO3_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO2_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO2_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO2_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO2_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO1_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO1_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO1_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO1_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO0_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO0_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO0_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO0_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO7_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO7_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO7_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO7_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO6_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO6_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO6_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO6_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO5_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO5_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO5_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO5_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO4_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO4_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO4_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO4_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO7_EDGE_HIGH(v: u1) Value {
        return Value.GPIO7_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO7_EDGE_LOW(v: u1) Value {
        return Value.GPIO7_EDGE_LOW(.{}, v);
    }
    pub fn GPIO7_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO7_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO7_LEVEL_LOW(v: u1) Value {
        return Value.GPIO7_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO6_EDGE_HIGH(v: u1) Value {
        return Value.GPIO6_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO6_EDGE_LOW(v: u1) Value {
        return Value.GPIO6_EDGE_LOW(.{}, v);
    }
    pub fn GPIO6_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO6_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO6_LEVEL_LOW(v: u1) Value {
        return Value.GPIO6_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO5_EDGE_HIGH(v: u1) Value {
        return Value.GPIO5_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO5_EDGE_LOW(v: u1) Value {
        return Value.GPIO5_EDGE_LOW(.{}, v);
    }
    pub fn GPIO5_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO5_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO5_LEVEL_LOW(v: u1) Value {
        return Value.GPIO5_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO4_EDGE_HIGH(v: u1) Value {
        return Value.GPIO4_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO4_EDGE_LOW(v: u1) Value {
        return Value.GPIO4_EDGE_LOW(.{}, v);
    }
    pub fn GPIO4_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO4_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO4_LEVEL_LOW(v: u1) Value {
        return Value.GPIO4_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO3_EDGE_HIGH(v: u1) Value {
        return Value.GPIO3_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO3_EDGE_LOW(v: u1) Value {
        return Value.GPIO3_EDGE_LOW(.{}, v);
    }
    pub fn GPIO3_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO3_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO3_LEVEL_LOW(v: u1) Value {
        return Value.GPIO3_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO2_EDGE_HIGH(v: u1) Value {
        return Value.GPIO2_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO2_EDGE_LOW(v: u1) Value {
        return Value.GPIO2_EDGE_LOW(.{}, v);
    }
    pub fn GPIO2_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO2_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO2_LEVEL_LOW(v: u1) Value {
        return Value.GPIO2_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO1_EDGE_HIGH(v: u1) Value {
        return Value.GPIO1_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO1_EDGE_LOW(v: u1) Value {
        return Value.GPIO1_EDGE_LOW(.{}, v);
    }
    pub fn GPIO1_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO1_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO1_LEVEL_LOW(v: u1) Value {
        return Value.GPIO1_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO0_EDGE_HIGH(v: u1) Value {
        return Value.GPIO0_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO0_EDGE_LOW(v: u1) Value {
        return Value.GPIO0_EDGE_LOW(.{}, v);
    }
    pub fn GPIO0_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO0_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO0_LEVEL_LOW(v: u1) Value {
        return Value.GPIO0_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Force for dormant_wake
pub const DORMANT_WAKE_INTF1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014174),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO15_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO15_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO15_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO15_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO14_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO14_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO14_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO14_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO13_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO13_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO13_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO13_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO12_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO12_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO12_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO12_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO11_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO11_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO11_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO11_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO10_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO10_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO10_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO10_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO9_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO9_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO9_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO9_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO8_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO8_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO8_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO8_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO15_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO15_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO15_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO15_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO14_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO14_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO14_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO14_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO13_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO13_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO13_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO13_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO12_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO12_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO12_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO12_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO11_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO11_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO11_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO11_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO10_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO10_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO10_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO10_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO9_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO9_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO9_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO9_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO8_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO8_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO8_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO8_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO15_EDGE_HIGH(v: u1) Value {
        return Value.GPIO15_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO15_EDGE_LOW(v: u1) Value {
        return Value.GPIO15_EDGE_LOW(.{}, v);
    }
    pub fn GPIO15_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO15_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO15_LEVEL_LOW(v: u1) Value {
        return Value.GPIO15_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO14_EDGE_HIGH(v: u1) Value {
        return Value.GPIO14_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO14_EDGE_LOW(v: u1) Value {
        return Value.GPIO14_EDGE_LOW(.{}, v);
    }
    pub fn GPIO14_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO14_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO14_LEVEL_LOW(v: u1) Value {
        return Value.GPIO14_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO13_EDGE_HIGH(v: u1) Value {
        return Value.GPIO13_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO13_EDGE_LOW(v: u1) Value {
        return Value.GPIO13_EDGE_LOW(.{}, v);
    }
    pub fn GPIO13_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO13_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO13_LEVEL_LOW(v: u1) Value {
        return Value.GPIO13_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO12_EDGE_HIGH(v: u1) Value {
        return Value.GPIO12_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO12_EDGE_LOW(v: u1) Value {
        return Value.GPIO12_EDGE_LOW(.{}, v);
    }
    pub fn GPIO12_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO12_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO12_LEVEL_LOW(v: u1) Value {
        return Value.GPIO12_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO11_EDGE_HIGH(v: u1) Value {
        return Value.GPIO11_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO11_EDGE_LOW(v: u1) Value {
        return Value.GPIO11_EDGE_LOW(.{}, v);
    }
    pub fn GPIO11_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO11_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO11_LEVEL_LOW(v: u1) Value {
        return Value.GPIO11_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO10_EDGE_HIGH(v: u1) Value {
        return Value.GPIO10_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO10_EDGE_LOW(v: u1) Value {
        return Value.GPIO10_EDGE_LOW(.{}, v);
    }
    pub fn GPIO10_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO10_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO10_LEVEL_LOW(v: u1) Value {
        return Value.GPIO10_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO9_EDGE_HIGH(v: u1) Value {
        return Value.GPIO9_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO9_EDGE_LOW(v: u1) Value {
        return Value.GPIO9_EDGE_LOW(.{}, v);
    }
    pub fn GPIO9_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO9_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO9_LEVEL_LOW(v: u1) Value {
        return Value.GPIO9_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO8_EDGE_HIGH(v: u1) Value {
        return Value.GPIO8_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO8_EDGE_LOW(v: u1) Value {
        return Value.GPIO8_EDGE_LOW(.{}, v);
    }
    pub fn GPIO8_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO8_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO8_LEVEL_LOW(v: u1) Value {
        return Value.GPIO8_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Force for dormant_wake
pub const DORMANT_WAKE_INTF2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014178),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO23_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn GPIO23_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn GPIO23_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn GPIO23_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn GPIO22_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn GPIO22_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn GPIO22_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn GPIO22_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn GPIO21_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO21_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO21_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO21_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO20_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO20_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO20_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO20_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO19_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO19_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO19_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO19_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO18_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO18_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO18_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO18_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO17_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO17_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO17_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO17_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO16_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO16_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO16_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO16_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO23_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO23_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO23_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO23_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO22_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO22_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO22_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO22_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO21_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO21_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO21_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO21_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO20_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO20_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO20_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO20_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO19_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO19_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO19_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO19_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO18_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO18_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO18_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO18_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO17_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO17_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO17_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO17_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO16_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO16_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO16_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO16_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO23_EDGE_HIGH(v: u1) Value {
        return Value.GPIO23_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO23_EDGE_LOW(v: u1) Value {
        return Value.GPIO23_EDGE_LOW(.{}, v);
    }
    pub fn GPIO23_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO23_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO23_LEVEL_LOW(v: u1) Value {
        return Value.GPIO23_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO22_EDGE_HIGH(v: u1) Value {
        return Value.GPIO22_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO22_EDGE_LOW(v: u1) Value {
        return Value.GPIO22_EDGE_LOW(.{}, v);
    }
    pub fn GPIO22_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO22_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO22_LEVEL_LOW(v: u1) Value {
        return Value.GPIO22_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO21_EDGE_HIGH(v: u1) Value {
        return Value.GPIO21_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO21_EDGE_LOW(v: u1) Value {
        return Value.GPIO21_EDGE_LOW(.{}, v);
    }
    pub fn GPIO21_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO21_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO21_LEVEL_LOW(v: u1) Value {
        return Value.GPIO21_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO20_EDGE_HIGH(v: u1) Value {
        return Value.GPIO20_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO20_EDGE_LOW(v: u1) Value {
        return Value.GPIO20_EDGE_LOW(.{}, v);
    }
    pub fn GPIO20_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO20_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO20_LEVEL_LOW(v: u1) Value {
        return Value.GPIO20_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO19_EDGE_HIGH(v: u1) Value {
        return Value.GPIO19_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO19_EDGE_LOW(v: u1) Value {
        return Value.GPIO19_EDGE_LOW(.{}, v);
    }
    pub fn GPIO19_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO19_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO19_LEVEL_LOW(v: u1) Value {
        return Value.GPIO19_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO18_EDGE_HIGH(v: u1) Value {
        return Value.GPIO18_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO18_EDGE_LOW(v: u1) Value {
        return Value.GPIO18_EDGE_LOW(.{}, v);
    }
    pub fn GPIO18_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO18_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO18_LEVEL_LOW(v: u1) Value {
        return Value.GPIO18_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO17_EDGE_HIGH(v: u1) Value {
        return Value.GPIO17_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO17_EDGE_LOW(v: u1) Value {
        return Value.GPIO17_EDGE_LOW(.{}, v);
    }
    pub fn GPIO17_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO17_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO17_LEVEL_LOW(v: u1) Value {
        return Value.GPIO17_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO16_EDGE_HIGH(v: u1) Value {
        return Value.GPIO16_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO16_EDGE_LOW(v: u1) Value {
        return Value.GPIO16_EDGE_LOW(.{}, v);
    }
    pub fn GPIO16_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO16_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO16_LEVEL_LOW(v: u1) Value {
        return Value.GPIO16_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Force for dormant_wake
pub const DORMANT_WAKE_INTF3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001417c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn GPIO29_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn GPIO29_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn GPIO29_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn GPIO29_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn GPIO28_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn GPIO28_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn GPIO28_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn GPIO28_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn GPIO27_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn GPIO27_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn GPIO27_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn GPIO27_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn GPIO26_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn GPIO26_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn GPIO26_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn GPIO26_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn GPIO25_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn GPIO25_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn GPIO25_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn GPIO25_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn GPIO24_EDGE_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn GPIO24_EDGE_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn GPIO24_LEVEL_HIGH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn GPIO24_LEVEL_LOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn GPIO29_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO29_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO29_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO29_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO28_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO28_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO28_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO28_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO27_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO27_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO27_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO27_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO26_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO26_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO26_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO26_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO25_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO25_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO25_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO25_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO24_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO24_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO24_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO24_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn GPIO29_EDGE_HIGH(v: u1) Value {
        return Value.GPIO29_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO29_EDGE_LOW(v: u1) Value {
        return Value.GPIO29_EDGE_LOW(.{}, v);
    }
    pub fn GPIO29_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO29_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO29_LEVEL_LOW(v: u1) Value {
        return Value.GPIO29_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO28_EDGE_HIGH(v: u1) Value {
        return Value.GPIO28_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO28_EDGE_LOW(v: u1) Value {
        return Value.GPIO28_EDGE_LOW(.{}, v);
    }
    pub fn GPIO28_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO28_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO28_LEVEL_LOW(v: u1) Value {
        return Value.GPIO28_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO27_EDGE_HIGH(v: u1) Value {
        return Value.GPIO27_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO27_EDGE_LOW(v: u1) Value {
        return Value.GPIO27_EDGE_LOW(.{}, v);
    }
    pub fn GPIO27_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO27_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO27_LEVEL_LOW(v: u1) Value {
        return Value.GPIO27_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO26_EDGE_HIGH(v: u1) Value {
        return Value.GPIO26_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO26_EDGE_LOW(v: u1) Value {
        return Value.GPIO26_EDGE_LOW(.{}, v);
    }
    pub fn GPIO26_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO26_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO26_LEVEL_LOW(v: u1) Value {
        return Value.GPIO26_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO25_EDGE_HIGH(v: u1) Value {
        return Value.GPIO25_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO25_EDGE_LOW(v: u1) Value {
        return Value.GPIO25_EDGE_LOW(.{}, v);
    }
    pub fn GPIO25_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO25_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO25_LEVEL_LOW(v: u1) Value {
        return Value.GPIO25_LEVEL_LOW(.{}, v);
    }
    pub fn GPIO24_EDGE_HIGH(v: u1) Value {
        return Value.GPIO24_EDGE_HIGH(.{}, v);
    }
    pub fn GPIO24_EDGE_LOW(v: u1) Value {
        return Value.GPIO24_EDGE_LOW(.{}, v);
    }
    pub fn GPIO24_LEVEL_HIGH(v: u1) Value {
        return Value.GPIO24_LEVEL_HIGH(.{}, v);
    }
    pub fn GPIO24_LEVEL_LOW(v: u1) Value {
        return Value.GPIO24_LEVEL_LOW(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt status after masking &amp; forcing for dormant_wake
pub const DORMANT_WAKE_INTS0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014180),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn GPIO7_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO7_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO7_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO7_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO6_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO6_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO6_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO6_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO5_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO5_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO5_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO5_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO4_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO4_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO4_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO4_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO3_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO3_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO3_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO3_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO2_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO2_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO2_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO2_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO1_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO1_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO1_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO1_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO0_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO0_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO0_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO0_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt status after masking &amp; forcing for dormant_wake
pub const DORMANT_WAKE_INTS1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014184),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn GPIO15_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO15_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO15_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO15_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO14_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO14_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO14_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO14_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO13_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO13_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO13_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO13_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO12_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO12_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO12_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO12_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO11_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO11_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO11_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO11_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO10_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO10_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO10_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO10_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO9_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO9_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO9_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO9_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO8_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO8_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO8_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO8_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt status after masking &amp; forcing for dormant_wake
pub const DORMANT_WAKE_INTS2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40014188),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn GPIO23_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn GPIO23_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn GPIO23_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn GPIO23_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn GPIO22_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn GPIO22_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn GPIO22_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn GPIO22_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn GPIO21_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO21_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO21_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO21_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO20_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO20_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO20_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO20_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO19_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO19_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO19_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO19_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO18_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO18_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO18_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO18_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO17_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO17_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO17_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO17_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO16_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO16_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO16_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO16_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt status after masking &amp; forcing for dormant_wake
pub const DORMANT_WAKE_INTS3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001418c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn GPIO29_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn GPIO29_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn GPIO29_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn GPIO29_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn GPIO28_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn GPIO28_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn GPIO28_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn GPIO28_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn GPIO27_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn GPIO27_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn GPIO27_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn GPIO27_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn GPIO26_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn GPIO26_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn GPIO26_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn GPIO26_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn GPIO25_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn GPIO25_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn GPIO25_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn GPIO25_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn GPIO24_EDGE_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn GPIO24_EDGE_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn GPIO24_LEVEL_HIGH(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn GPIO24_LEVEL_LOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const IO_BANK0_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x40014000),

    /// GPIO status
    GPIO0_STATUS: GPIO0_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO0_CTRL: GPIO0_CTRL = .{},
    /// GPIO status
    GPIO1_STATUS: GPIO1_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO1_CTRL: GPIO1_CTRL = .{},
    /// GPIO status
    GPIO2_STATUS: GPIO2_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO2_CTRL: GPIO2_CTRL = .{},
    /// GPIO status
    GPIO3_STATUS: GPIO3_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO3_CTRL: GPIO3_CTRL = .{},
    /// GPIO status
    GPIO4_STATUS: GPIO4_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO4_CTRL: GPIO4_CTRL = .{},
    /// GPIO status
    GPIO5_STATUS: GPIO5_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO5_CTRL: GPIO5_CTRL = .{},
    /// GPIO status
    GPIO6_STATUS: GPIO6_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO6_CTRL: GPIO6_CTRL = .{},
    /// GPIO status
    GPIO7_STATUS: GPIO7_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO7_CTRL: GPIO7_CTRL = .{},
    /// GPIO status
    GPIO8_STATUS: GPIO8_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO8_CTRL: GPIO8_CTRL = .{},
    /// GPIO status
    GPIO9_STATUS: GPIO9_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO9_CTRL: GPIO9_CTRL = .{},
    /// GPIO status
    GPIO10_STATUS: GPIO10_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO10_CTRL: GPIO10_CTRL = .{},
    /// GPIO status
    GPIO11_STATUS: GPIO11_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO11_CTRL: GPIO11_CTRL = .{},
    /// GPIO status
    GPIO12_STATUS: GPIO12_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO12_CTRL: GPIO12_CTRL = .{},
    /// GPIO status
    GPIO13_STATUS: GPIO13_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO13_CTRL: GPIO13_CTRL = .{},
    /// GPIO status
    GPIO14_STATUS: GPIO14_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO14_CTRL: GPIO14_CTRL = .{},
    /// GPIO status
    GPIO15_STATUS: GPIO15_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO15_CTRL: GPIO15_CTRL = .{},
    /// GPIO status
    GPIO16_STATUS: GPIO16_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO16_CTRL: GPIO16_CTRL = .{},
    /// GPIO status
    GPIO17_STATUS: GPIO17_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO17_CTRL: GPIO17_CTRL = .{},
    /// GPIO status
    GPIO18_STATUS: GPIO18_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO18_CTRL: GPIO18_CTRL = .{},
    /// GPIO status
    GPIO19_STATUS: GPIO19_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO19_CTRL: GPIO19_CTRL = .{},
    /// GPIO status
    GPIO20_STATUS: GPIO20_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO20_CTRL: GPIO20_CTRL = .{},
    /// GPIO status
    GPIO21_STATUS: GPIO21_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO21_CTRL: GPIO21_CTRL = .{},
    /// GPIO status
    GPIO22_STATUS: GPIO22_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO22_CTRL: GPIO22_CTRL = .{},
    /// GPIO status
    GPIO23_STATUS: GPIO23_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO23_CTRL: GPIO23_CTRL = .{},
    /// GPIO status
    GPIO24_STATUS: GPIO24_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO24_CTRL: GPIO24_CTRL = .{},
    /// GPIO status
    GPIO25_STATUS: GPIO25_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO25_CTRL: GPIO25_CTRL = .{},
    /// GPIO status
    GPIO26_STATUS: GPIO26_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO26_CTRL: GPIO26_CTRL = .{},
    /// GPIO status
    GPIO27_STATUS: GPIO27_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO27_CTRL: GPIO27_CTRL = .{},
    /// GPIO status
    GPIO28_STATUS: GPIO28_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO28_CTRL: GPIO28_CTRL = .{},
    /// GPIO status
    GPIO29_STATUS: GPIO29_STATUS = .{},
    /// GPIO control including function select and overrides.
    GPIO29_CTRL: GPIO29_CTRL = .{},
    /// Raw Interrupts
    INTR0: INTR0 = .{},
    /// Raw Interrupts
    INTR1: INTR1 = .{},
    /// Raw Interrupts
    INTR2: INTR2 = .{},
    /// Raw Interrupts
    INTR3: INTR3 = .{},
    /// Interrupt Enable for proc0
    PROC0_INTE0: PROC0_INTE0 = .{},
    /// Interrupt Enable for proc0
    PROC0_INTE1: PROC0_INTE1 = .{},
    /// Interrupt Enable for proc0
    PROC0_INTE2: PROC0_INTE2 = .{},
    /// Interrupt Enable for proc0
    PROC0_INTE3: PROC0_INTE3 = .{},
    /// Interrupt Force for proc0
    PROC0_INTF0: PROC0_INTF0 = .{},
    /// Interrupt Force for proc0
    PROC0_INTF1: PROC0_INTF1 = .{},
    /// Interrupt Force for proc0
    PROC0_INTF2: PROC0_INTF2 = .{},
    /// Interrupt Force for proc0
    PROC0_INTF3: PROC0_INTF3 = .{},
    /// Interrupt status after masking &amp; forcing for proc0
    PROC0_INTS0: PROC0_INTS0 = .{},
    /// Interrupt status after masking &amp; forcing for proc0
    PROC0_INTS1: PROC0_INTS1 = .{},
    /// Interrupt status after masking &amp; forcing for proc0
    PROC0_INTS2: PROC0_INTS2 = .{},
    /// Interrupt status after masking &amp; forcing for proc0
    PROC0_INTS3: PROC0_INTS3 = .{},
    /// Interrupt Enable for proc1
    PROC1_INTE0: PROC1_INTE0 = .{},
    /// Interrupt Enable for proc1
    PROC1_INTE1: PROC1_INTE1 = .{},
    /// Interrupt Enable for proc1
    PROC1_INTE2: PROC1_INTE2 = .{},
    /// Interrupt Enable for proc1
    PROC1_INTE3: PROC1_INTE3 = .{},
    /// Interrupt Force for proc1
    PROC1_INTF0: PROC1_INTF0 = .{},
    /// Interrupt Force for proc1
    PROC1_INTF1: PROC1_INTF1 = .{},
    /// Interrupt Force for proc1
    PROC1_INTF2: PROC1_INTF2 = .{},
    /// Interrupt Force for proc1
    PROC1_INTF3: PROC1_INTF3 = .{},
    /// Interrupt status after masking &amp; forcing for proc1
    PROC1_INTS0: PROC1_INTS0 = .{},
    /// Interrupt status after masking &amp; forcing for proc1
    PROC1_INTS1: PROC1_INTS1 = .{},
    /// Interrupt status after masking &amp; forcing for proc1
    PROC1_INTS2: PROC1_INTS2 = .{},
    /// Interrupt status after masking &amp; forcing for proc1
    PROC1_INTS3: PROC1_INTS3 = .{},
    /// Interrupt Enable for dormant_wake
    DORMANT_WAKE_INTE0: DORMANT_WAKE_INTE0 = .{},
    /// Interrupt Enable for dormant_wake
    DORMANT_WAKE_INTE1: DORMANT_WAKE_INTE1 = .{},
    /// Interrupt Enable for dormant_wake
    DORMANT_WAKE_INTE2: DORMANT_WAKE_INTE2 = .{},
    /// Interrupt Enable for dormant_wake
    DORMANT_WAKE_INTE3: DORMANT_WAKE_INTE3 = .{},
    /// Interrupt Force for dormant_wake
    DORMANT_WAKE_INTF0: DORMANT_WAKE_INTF0 = .{},
    /// Interrupt Force for dormant_wake
    DORMANT_WAKE_INTF1: DORMANT_WAKE_INTF1 = .{},
    /// Interrupt Force for dormant_wake
    DORMANT_WAKE_INTF2: DORMANT_WAKE_INTF2 = .{},
    /// Interrupt Force for dormant_wake
    DORMANT_WAKE_INTF3: DORMANT_WAKE_INTF3 = .{},
    /// Interrupt status after masking &amp; forcing for dormant_wake
    DORMANT_WAKE_INTS0: DORMANT_WAKE_INTS0 = .{},
    /// Interrupt status after masking &amp; forcing for dormant_wake
    DORMANT_WAKE_INTS1: DORMANT_WAKE_INTS1 = .{},
    /// Interrupt status after masking &amp; forcing for dormant_wake
    DORMANT_WAKE_INTS2: DORMANT_WAKE_INTS2 = .{},
    /// Interrupt status after masking &amp; forcing for dormant_wake
    DORMANT_WAKE_INTS3: DORMANT_WAKE_INTS3 = .{},
};
pub const IO_BANK0 = IO_BANK0_p{};
