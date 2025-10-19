const helpers = @import("helpers.zig");
/// Write to bits 63:32 of time
/// always write timelw before timehw
pub const TIMEHW = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40054000),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u32) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Write to bits 31:0 of time
/// writes do not get copied to time until timehw is written
pub const TIMELW = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40054004),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u32) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read from bits 63:32 of time
/// always read timelr before timehr
pub const TIMEHR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40054008),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u32) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read from bits 31:0 of time
pub const TIMELR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005400c),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u32) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Arm alarm 0, and configure the time it will fire.
/// Once armed, the alarm fires when TIMER_ALARM0 == TIMELR.
/// The alarm will disarm itself once it fires, and can
/// be disarmed early using the ARMED status register.
pub const ALARM0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40054010),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u32) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Arm alarm 1, and configure the time it will fire.
/// Once armed, the alarm fires when TIMER_ALARM1 == TIMELR.
/// The alarm will disarm itself once it fires, and can
/// be disarmed early using the ARMED status register.
pub const ALARM1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40054014),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u32) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Arm alarm 2, and configure the time it will fire.
/// Once armed, the alarm fires when TIMER_ALARM2 == TIMELR.
/// The alarm will disarm itself once it fires, and can
/// be disarmed early using the ARMED status register.
pub const ALARM2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40054018),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u32) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Arm alarm 3, and configure the time it will fire.
/// Once armed, the alarm fires when TIMER_ALARM3 == TIMELR.
/// The alarm will disarm itself once it fires, and can
/// be disarmed early using the ARMED status register.
pub const ALARM3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005401c),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u32) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Indicates the armed/disarmed status of each alarm.
/// A write to the corresponding ALARMx register arms the alarm.
/// Alarms automatically disarm upon firing, but writing ones here
/// will disarm immediately without waiting to fire.
pub const ARMED = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40054020),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 4);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 4);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u4 {
        const mask = comptime helpers.generateMask(0, 4);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Raw read from bits 63:32 of time (no side effects)
pub const TIMERAWH = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40054024),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u32) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Raw read from bits 31:0 of time (no side effects)
pub const TIMERAWL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40054028),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u32) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Set bits high to enable pause when the corresponding debug ports are active
pub const DBGPAUSE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005402c),
    pub const FieldMasks = struct {
        pub const DBG1: u32 = helpers.generateMask(2, 3);
        pub const DBG0: u32 = helpers.generateMask(1, 2);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Pause when processor 1 is in debug mode
        pub fn DBG1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Pause when processor 0 is in debug mode
        pub fn DBG0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn DBG1(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn DBG0(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
    };
    /// Pause when processor 1 is in debug mode
    pub fn DBG1(v: u1) Value {
        return Value.DBG1(.{}, v);
    }
    /// Pause when processor 0 is in debug mode
    pub fn DBG0(v: u1) Value {
        return Value.DBG0(.{}, v);
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
/// Set high to pause the timer
pub const PAUSE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40054030),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u1) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u1 {
        const mask = comptime helpers.generateMask(0, 1);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Raw Interrupts
pub const INTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40054034),
    pub const FieldMasks = struct {
        pub const ALARM_3: u32 = helpers.generateMask(3, 4);
        pub const ALARM_2: u32 = helpers.generateMask(2, 3);
        pub const ALARM_1: u32 = helpers.generateMask(1, 2);
        pub const ALARM_0: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn ALARM_3(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn ALARM_2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn ALARM_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn ALARM_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ALARM_3(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn ALARM_2(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn ALARM_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn ALARM_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn ALARM_3(v: u1) Value {
        return Value.ALARM_3(.{}, v);
    }
    pub fn ALARM_2(v: u1) Value {
        return Value.ALARM_2(.{}, v);
    }
    pub fn ALARM_1(v: u1) Value {
        return Value.ALARM_1(.{}, v);
    }
    pub fn ALARM_0(v: u1) Value {
        return Value.ALARM_0(.{}, v);
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
    comptime reg: *volatile u32 = @ptrFromInt(0x40054038),
    pub const FieldMasks = struct {
        pub const ALARM_3: u32 = helpers.generateMask(3, 4);
        pub const ALARM_2: u32 = helpers.generateMask(2, 3);
        pub const ALARM_1: u32 = helpers.generateMask(1, 2);
        pub const ALARM_0: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn ALARM_3(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn ALARM_2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn ALARM_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn ALARM_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ALARM_3(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn ALARM_2(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn ALARM_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn ALARM_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn ALARM_3(v: u1) Value {
        return Value.ALARM_3(.{}, v);
    }
    pub fn ALARM_2(v: u1) Value {
        return Value.ALARM_2(.{}, v);
    }
    pub fn ALARM_1(v: u1) Value {
        return Value.ALARM_1(.{}, v);
    }
    pub fn ALARM_0(v: u1) Value {
        return Value.ALARM_0(.{}, v);
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
    comptime reg: *volatile u32 = @ptrFromInt(0x4005403c),
    pub const FieldMasks = struct {
        pub const ALARM_3: u32 = helpers.generateMask(3, 4);
        pub const ALARM_2: u32 = helpers.generateMask(2, 3);
        pub const ALARM_1: u32 = helpers.generateMask(1, 2);
        pub const ALARM_0: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn ALARM_3(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn ALARM_2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn ALARM_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn ALARM_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ALARM_3(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn ALARM_2(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn ALARM_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn ALARM_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn ALARM_3(v: u1) Value {
        return Value.ALARM_3(.{}, v);
    }
    pub fn ALARM_2(v: u1) Value {
        return Value.ALARM_2(.{}, v);
    }
    pub fn ALARM_1(v: u1) Value {
        return Value.ALARM_1(.{}, v);
    }
    pub fn ALARM_0(v: u1) Value {
        return Value.ALARM_0(.{}, v);
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
    comptime reg: *volatile u32 = @ptrFromInt(0x40054040),
    pub const FieldMasks = struct {
        pub const ALARM_3: u32 = helpers.generateMask(3, 4);
        pub const ALARM_2: u32 = helpers.generateMask(2, 3);
        pub const ALARM_1: u32 = helpers.generateMask(1, 2);
        pub const ALARM_0: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn ALARM_3(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn ALARM_2(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn ALARM_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn ALARM_0(self: Result) u1 {
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
/// Controls time and alarms
/// time is a 64 bit value indicating the time in usec since power-on
/// timeh is the top 32 bits of time &amp; timel is the bottom 32 bits
/// to change time write to timelw before timehw
/// to read time read from timelr before timehr
/// An alarm is set by setting alarm_enable and writing to the corresponding alarm register
/// When an alarm is pending, the corresponding alarm_running signal will be high
/// An alarm can be cancelled before it has finished by clearing the alarm_enable
/// When an alarm fires, the corresponding alarm_irq is set and alarm_running is cleared
/// To clear the interrupt write a 1 to the corresponding alarm_irq
pub const TIMER_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x40054000),

    /// Write to bits 63:32 of time
    /// always write timelw before timehw
    TIMEHW: TIMEHW = .{},
    /// Write to bits 31:0 of time
    /// writes do not get copied to time until timehw is written
    TIMELW: TIMELW = .{},
    /// Read from bits 63:32 of time
    /// always read timelr before timehr
    TIMEHR: TIMEHR = .{},
    /// Read from bits 31:0 of time
    TIMELR: TIMELR = .{},
    /// Arm alarm 0, and configure the time it will fire.
    /// Once armed, the alarm fires when TIMER_ALARM0 == TIMELR.
    /// The alarm will disarm itself once it fires, and can
    /// be disarmed early using the ARMED status register.
    ALARM0: ALARM0 = .{},
    /// Arm alarm 1, and configure the time it will fire.
    /// Once armed, the alarm fires when TIMER_ALARM1 == TIMELR.
    /// The alarm will disarm itself once it fires, and can
    /// be disarmed early using the ARMED status register.
    ALARM1: ALARM1 = .{},
    /// Arm alarm 2, and configure the time it will fire.
    /// Once armed, the alarm fires when TIMER_ALARM2 == TIMELR.
    /// The alarm will disarm itself once it fires, and can
    /// be disarmed early using the ARMED status register.
    ALARM2: ALARM2 = .{},
    /// Arm alarm 3, and configure the time it will fire.
    /// Once armed, the alarm fires when TIMER_ALARM3 == TIMELR.
    /// The alarm will disarm itself once it fires, and can
    /// be disarmed early using the ARMED status register.
    ALARM3: ALARM3 = .{},
    /// Indicates the armed/disarmed status of each alarm.
    /// A write to the corresponding ALARMx register arms the alarm.
    /// Alarms automatically disarm upon firing, but writing ones here
    /// will disarm immediately without waiting to fire.
    ARMED: ARMED = .{},
    /// Raw read from bits 63:32 of time (no side effects)
    TIMERAWH: TIMERAWH = .{},
    /// Raw read from bits 31:0 of time (no side effects)
    TIMERAWL: TIMERAWL = .{},
    /// Set bits high to enable pause when the corresponding debug ports are active
    DBGPAUSE: DBGPAUSE = .{},
    /// Set high to pause the timer
    PAUSE: PAUSE = .{},
    /// Raw Interrupts
    INTR: INTR = .{},
    /// Interrupt Enable
    INTE: INTE = .{},
    /// Interrupt Force
    INTF: INTF = .{},
    /// Interrupt status after masking &amp; forcing
    INTS: INTS = .{},
};
pub const TIMER = TIMER_p{};
