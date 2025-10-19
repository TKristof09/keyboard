const helpers = @import("helpers.zig");
/// Watchdog control
/// The rst_wdsel register determines which subsystems are reset when the watchdog is triggered.
/// The watchdog can be triggered in software.
pub const CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40058000),
    pub const FieldMasks = struct {
        pub const TRIGGER: u32 = helpers.generateMask(31, 32);
        pub const ENABLE: u32 = helpers.generateMask(30, 31);
        pub const PAUSE_DBG1: u32 = helpers.generateMask(26, 27);
        pub const PAUSE_DBG0: u32 = helpers.generateMask(25, 26);
        pub const PAUSE_JTAG: u32 = helpers.generateMask(24, 25);
        pub const TIME: u32 = helpers.generateMask(0, 24);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Trigger a watchdog reset
        pub fn TRIGGER(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// When not enabled the watchdog timer is paused
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Pause the watchdog timer when processor 1 is in debug mode
        pub fn PAUSE_DBG1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Pause the watchdog timer when processor 0 is in debug mode
        pub fn PAUSE_DBG0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Pause the watchdog timer when JTAG is accessing the bus fabric
        pub fn PAUSE_JTAG(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PAUSE_DBG1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn PAUSE_DBG0(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn PAUSE_JTAG(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn TIME(self: Result) u24 {
            const mask = comptime helpers.generateMask(0, 24);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Trigger a watchdog reset
    pub fn TRIGGER(v: u1) Value {
        return Value.TRIGGER(.{}, v);
    }
    /// When not enabled the watchdog timer is paused
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// Pause the watchdog timer when processor 1 is in debug mode
    pub fn PAUSE_DBG1(v: u1) Value {
        return Value.PAUSE_DBG1(.{}, v);
    }
    /// Pause the watchdog timer when processor 0 is in debug mode
    pub fn PAUSE_DBG0(v: u1) Value {
        return Value.PAUSE_DBG0(.{}, v);
    }
    /// Pause the watchdog timer when JTAG is accessing the bus fabric
    pub fn PAUSE_JTAG(v: u1) Value {
        return Value.PAUSE_JTAG(.{}, v);
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
/// Load the watchdog timer. The maximum setting is 0xffffff which corresponds to 0xffffff / 2 ticks before triggering a watchdog reset (see errata RP2040-E1).
pub const LOAD = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40058004),
    pub fn write(self: @This(), v: u24) void {
        const mask = comptime helpers.generateMask(0, 24);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u24) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 24);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 24);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u24 {
        const mask = comptime helpers.generateMask(0, 24);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Logs the reason for the last reset. Both bits are zero for the case of a hardware reset.
pub const REASON = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40058008),
    pub const FieldMasks = struct {
        pub const FORCE: u32 = helpers.generateMask(1, 2);
        pub const TIMER: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn FORCE(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn TIMER(self: Result) u1 {
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
/// Scratch register. Information persists through soft reset of the chip.
pub const SCRATCH0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005800c),
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
/// Scratch register. Information persists through soft reset of the chip.
pub const SCRATCH1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40058010),
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
/// Scratch register. Information persists through soft reset of the chip.
pub const SCRATCH2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40058014),
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
/// Scratch register. Information persists through soft reset of the chip.
pub const SCRATCH3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40058018),
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
/// Scratch register. Information persists through soft reset of the chip.
pub const SCRATCH4 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005801c),
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
/// Scratch register. Information persists through soft reset of the chip.
pub const SCRATCH5 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40058020),
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
/// Scratch register. Information persists through soft reset of the chip.
pub const SCRATCH6 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40058024),
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
/// Scratch register. Information persists through soft reset of the chip.
pub const SCRATCH7 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40058028),
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
/// Controls the tick generator
pub const TICK = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005802c),
    pub const FieldMasks = struct {
        pub const COUNT: u32 = helpers.generateMask(11, 20);
        pub const RUNNING: u32 = helpers.generateMask(10, 11);
        pub const ENABLE: u32 = helpers.generateMask(9, 10);
        pub const CYCLES: u32 = helpers.generateMask(0, 9);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// start / stop tick generation
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        /// Total number of clk_tick cycles before the next tick.
        pub fn CYCLES(self: Value, v: u9) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 9),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn COUNT(self: Result) u9 {
            const mask = comptime helpers.generateMask(11, 20);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn RUNNING(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn CYCLES(self: Result) u9 {
            const mask = comptime helpers.generateMask(0, 9);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// start / stop tick generation
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// Total number of clk_tick cycles before the next tick.
    pub fn CYCLES(v: u9) Value {
        return Value.CYCLES(.{}, v);
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
pub const WATCHDOG_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x40058000),

    /// Watchdog control
    /// The rst_wdsel register determines which subsystems are reset when the watchdog is triggered.
    /// The watchdog can be triggered in software.
    CTRL: CTRL = .{},
    /// Load the watchdog timer. The maximum setting is 0xffffff which corresponds to 0xffffff / 2 ticks before triggering a watchdog reset (see errata RP2040-E1).
    LOAD: LOAD = .{},
    /// Logs the reason for the last reset. Both bits are zero for the case of a hardware reset.
    REASON: REASON = .{},
    /// Scratch register. Information persists through soft reset of the chip.
    SCRATCH0: SCRATCH0 = .{},
    /// Scratch register. Information persists through soft reset of the chip.
    SCRATCH1: SCRATCH1 = .{},
    /// Scratch register. Information persists through soft reset of the chip.
    SCRATCH2: SCRATCH2 = .{},
    /// Scratch register. Information persists through soft reset of the chip.
    SCRATCH3: SCRATCH3 = .{},
    /// Scratch register. Information persists through soft reset of the chip.
    SCRATCH4: SCRATCH4 = .{},
    /// Scratch register. Information persists through soft reset of the chip.
    SCRATCH5: SCRATCH5 = .{},
    /// Scratch register. Information persists through soft reset of the chip.
    SCRATCH6: SCRATCH6 = .{},
    /// Scratch register. Information persists through soft reset of the chip.
    SCRATCH7: SCRATCH7 = .{},
    /// Controls the tick generator
    TICK: TICK = .{},
};
pub const WATCHDOG = WATCHDOG_p{};
