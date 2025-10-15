const helpers = @import("helpers.zig");
/// Use the SysTick Control and Status Register to enable the SysTick features.
pub const SYST_CSR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000e010),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// SysTick clock source. Always reads as one if SYST_CALIB reports NOREF.
        /// Selects the SysTick timer clock source:
        /// 0 = External reference clock.
        /// 1 = Processor clock.
        pub fn CLKSOURCE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Enables SysTick exception request:
        /// 0 = Counting down to zero does not assert the SysTick exception request.
        /// 1 = Counting down to zero to asserts the SysTick exception request.
        pub fn TICKINT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Enable SysTick counter:
        /// 0 = Counter disabled.
        /// 1 = Counter enabled.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn COUNTFLAG(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn CLKSOURCE(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn TICKINT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// SysTick clock source. Always reads as one if SYST_CALIB reports NOREF.
    /// Selects the SysTick timer clock source:
    /// 0 = External reference clock.
    /// 1 = Processor clock.
    pub fn CLKSOURCE(v: u1) Value {
        return Value.CLKSOURCE(.{}, v);
    }
    /// Enables SysTick exception request:
    /// 0 = Counting down to zero does not assert the SysTick exception request.
    /// 1 = Counting down to zero to asserts the SysTick exception request.
    pub fn TICKINT(v: u1) Value {
        return Value.TICKINT(.{}, v);
    }
    /// Enable SysTick counter:
    /// 0 = Counter disabled.
    /// 1 = Counter enabled.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Use the SysTick Reload Value Register to specify the start value to load into the current value register when the counter reaches 0. It can be any value between 0 and 0x00FFFFFF. A start value of 0 is possible, but has no effect because the SysTick interrupt and COUNTFLAG are activated when counting from 1 to 0. The reset value of this register is UNKNOWN.
/// To generate a multi-shot timer with a period of N processor clock cycles, use a RELOAD value of N-1. For example, if the SysTick interrupt is required every 100 clock pulses, set RELOAD to 99.
pub const SYST_RVR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000e014),
    pub fn write(self: @This(), v: u24) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 24);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u24 {
        const mask = comptime helpers.generateMask(0, 24);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Use the SysTick Current Value Register to find the current value in the register. The reset value of this register is UNKNOWN.
pub const SYST_CVR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000e018),
    pub fn write(self: @This(), v: u24) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 24);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u24 {
        const mask = comptime helpers.generateMask(0, 24);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Use the SysTick Calibration Value Register to enable software to scale to any required speed using divide and multiply.
pub const SYST_CALIB = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000e01c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn NOREF(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn SKEW(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn TENMS(self: Result) u24 {
            const mask = comptime helpers.generateMask(0, 24);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Use the Interrupt Set-Enable Register to enable interrupts and determine which interrupts are currently enabled.
/// If a pending interrupt is enabled, the NVIC activates the interrupt based on its priority. If an interrupt is not enabled, asserting its interrupt signal changes the interrupt state to pending, but the NVIC never activates the interrupt, regardless of its priority.
pub const NVIC_ISER = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000e100),
    pub fn write(self: @This(), v: u32) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 32);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Use the Interrupt Clear-Enable Registers to disable interrupts and determine which interrupts are currently enabled.
pub const NVIC_ICER = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000e180),
    pub fn write(self: @This(), v: u32) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 32);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// The NVIC_ISPR forces interrupts into the pending state, and shows which interrupts are pending.
pub const NVIC_ISPR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000e200),
    pub fn write(self: @This(), v: u32) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 32);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Use the Interrupt Clear-Pending Register to clear pending interrupts and determine which interrupts are currently pending.
pub const NVIC_ICPR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000e280),
    pub fn write(self: @This(), v: u32) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 32);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Use the Interrupt Priority Registers to assign a priority from 0 to 3 to each of the available interrupts. 0 is the highest priority, and 3 is the lowest.
/// Note: Writing 1 to an NVIC_ICPR bit does not affect the active state of the corresponding interrupt.
/// These registers are only word-accessible
pub const NVIC_IPR0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000e400),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Priority of interrupt 3
        pub fn IP_3(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 32),
            };
        }
        /// Priority of interrupt 2
        pub fn IP_2(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 24),
            };
        }
        /// Priority of interrupt 1
        pub fn IP_1(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 16),
            };
        }
        /// Priority of interrupt 0
        pub fn IP_0(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn IP_3(self: Result) u2 {
            const mask = comptime helpers.generateMask(30, 32);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn IP_2(self: Result) u2 {
            const mask = comptime helpers.generateMask(22, 24);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IP_1(self: Result) u2 {
            const mask = comptime helpers.generateMask(14, 16);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn IP_0(self: Result) u2 {
            const mask = comptime helpers.generateMask(6, 8);
            return @intCast((self.val & mask) >> 6);
        }
    };
    /// Priority of interrupt 3
    pub fn IP_3(v: u2) Value {
        return Value.IP_3(.{}, v);
    }
    /// Priority of interrupt 2
    pub fn IP_2(v: u2) Value {
        return Value.IP_2(.{}, v);
    }
    /// Priority of interrupt 1
    pub fn IP_1(v: u2) Value {
        return Value.IP_1(.{}, v);
    }
    /// Priority of interrupt 0
    pub fn IP_0(v: u2) Value {
        return Value.IP_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Use the Interrupt Priority Registers to assign a priority from 0 to 3 to each of the available interrupts. 0 is the highest priority, and 3 is the lowest.
pub const NVIC_IPR1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000e404),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Priority of interrupt 7
        pub fn IP_7(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 32),
            };
        }
        /// Priority of interrupt 6
        pub fn IP_6(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 24),
            };
        }
        /// Priority of interrupt 5
        pub fn IP_5(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 16),
            };
        }
        /// Priority of interrupt 4
        pub fn IP_4(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn IP_7(self: Result) u2 {
            const mask = comptime helpers.generateMask(30, 32);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn IP_6(self: Result) u2 {
            const mask = comptime helpers.generateMask(22, 24);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IP_5(self: Result) u2 {
            const mask = comptime helpers.generateMask(14, 16);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn IP_4(self: Result) u2 {
            const mask = comptime helpers.generateMask(6, 8);
            return @intCast((self.val & mask) >> 6);
        }
    };
    /// Priority of interrupt 7
    pub fn IP_7(v: u2) Value {
        return Value.IP_7(.{}, v);
    }
    /// Priority of interrupt 6
    pub fn IP_6(v: u2) Value {
        return Value.IP_6(.{}, v);
    }
    /// Priority of interrupt 5
    pub fn IP_5(v: u2) Value {
        return Value.IP_5(.{}, v);
    }
    /// Priority of interrupt 4
    pub fn IP_4(v: u2) Value {
        return Value.IP_4(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Use the Interrupt Priority Registers to assign a priority from 0 to 3 to each of the available interrupts. 0 is the highest priority, and 3 is the lowest.
pub const NVIC_IPR2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000e408),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Priority of interrupt 11
        pub fn IP_11(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 32),
            };
        }
        /// Priority of interrupt 10
        pub fn IP_10(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 24),
            };
        }
        /// Priority of interrupt 9
        pub fn IP_9(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 16),
            };
        }
        /// Priority of interrupt 8
        pub fn IP_8(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn IP_11(self: Result) u2 {
            const mask = comptime helpers.generateMask(30, 32);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn IP_10(self: Result) u2 {
            const mask = comptime helpers.generateMask(22, 24);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IP_9(self: Result) u2 {
            const mask = comptime helpers.generateMask(14, 16);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn IP_8(self: Result) u2 {
            const mask = comptime helpers.generateMask(6, 8);
            return @intCast((self.val & mask) >> 6);
        }
    };
    /// Priority of interrupt 11
    pub fn IP_11(v: u2) Value {
        return Value.IP_11(.{}, v);
    }
    /// Priority of interrupt 10
    pub fn IP_10(v: u2) Value {
        return Value.IP_10(.{}, v);
    }
    /// Priority of interrupt 9
    pub fn IP_9(v: u2) Value {
        return Value.IP_9(.{}, v);
    }
    /// Priority of interrupt 8
    pub fn IP_8(v: u2) Value {
        return Value.IP_8(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Use the Interrupt Priority Registers to assign a priority from 0 to 3 to each of the available interrupts. 0 is the highest priority, and 3 is the lowest.
pub const NVIC_IPR3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000e40c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Priority of interrupt 15
        pub fn IP_15(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 32),
            };
        }
        /// Priority of interrupt 14
        pub fn IP_14(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 24),
            };
        }
        /// Priority of interrupt 13
        pub fn IP_13(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 16),
            };
        }
        /// Priority of interrupt 12
        pub fn IP_12(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn IP_15(self: Result) u2 {
            const mask = comptime helpers.generateMask(30, 32);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn IP_14(self: Result) u2 {
            const mask = comptime helpers.generateMask(22, 24);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IP_13(self: Result) u2 {
            const mask = comptime helpers.generateMask(14, 16);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn IP_12(self: Result) u2 {
            const mask = comptime helpers.generateMask(6, 8);
            return @intCast((self.val & mask) >> 6);
        }
    };
    /// Priority of interrupt 15
    pub fn IP_15(v: u2) Value {
        return Value.IP_15(.{}, v);
    }
    /// Priority of interrupt 14
    pub fn IP_14(v: u2) Value {
        return Value.IP_14(.{}, v);
    }
    /// Priority of interrupt 13
    pub fn IP_13(v: u2) Value {
        return Value.IP_13(.{}, v);
    }
    /// Priority of interrupt 12
    pub fn IP_12(v: u2) Value {
        return Value.IP_12(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Use the Interrupt Priority Registers to assign a priority from 0 to 3 to each of the available interrupts. 0 is the highest priority, and 3 is the lowest.
pub const NVIC_IPR4 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000e410),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Priority of interrupt 19
        pub fn IP_19(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 32),
            };
        }
        /// Priority of interrupt 18
        pub fn IP_18(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 24),
            };
        }
        /// Priority of interrupt 17
        pub fn IP_17(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 16),
            };
        }
        /// Priority of interrupt 16
        pub fn IP_16(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn IP_19(self: Result) u2 {
            const mask = comptime helpers.generateMask(30, 32);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn IP_18(self: Result) u2 {
            const mask = comptime helpers.generateMask(22, 24);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IP_17(self: Result) u2 {
            const mask = comptime helpers.generateMask(14, 16);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn IP_16(self: Result) u2 {
            const mask = comptime helpers.generateMask(6, 8);
            return @intCast((self.val & mask) >> 6);
        }
    };
    /// Priority of interrupt 19
    pub fn IP_19(v: u2) Value {
        return Value.IP_19(.{}, v);
    }
    /// Priority of interrupt 18
    pub fn IP_18(v: u2) Value {
        return Value.IP_18(.{}, v);
    }
    /// Priority of interrupt 17
    pub fn IP_17(v: u2) Value {
        return Value.IP_17(.{}, v);
    }
    /// Priority of interrupt 16
    pub fn IP_16(v: u2) Value {
        return Value.IP_16(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Use the Interrupt Priority Registers to assign a priority from 0 to 3 to each of the available interrupts. 0 is the highest priority, and 3 is the lowest.
pub const NVIC_IPR5 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000e414),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Priority of interrupt 23
        pub fn IP_23(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 32),
            };
        }
        /// Priority of interrupt 22
        pub fn IP_22(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 24),
            };
        }
        /// Priority of interrupt 21
        pub fn IP_21(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 16),
            };
        }
        /// Priority of interrupt 20
        pub fn IP_20(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn IP_23(self: Result) u2 {
            const mask = comptime helpers.generateMask(30, 32);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn IP_22(self: Result) u2 {
            const mask = comptime helpers.generateMask(22, 24);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IP_21(self: Result) u2 {
            const mask = comptime helpers.generateMask(14, 16);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn IP_20(self: Result) u2 {
            const mask = comptime helpers.generateMask(6, 8);
            return @intCast((self.val & mask) >> 6);
        }
    };
    /// Priority of interrupt 23
    pub fn IP_23(v: u2) Value {
        return Value.IP_23(.{}, v);
    }
    /// Priority of interrupt 22
    pub fn IP_22(v: u2) Value {
        return Value.IP_22(.{}, v);
    }
    /// Priority of interrupt 21
    pub fn IP_21(v: u2) Value {
        return Value.IP_21(.{}, v);
    }
    /// Priority of interrupt 20
    pub fn IP_20(v: u2) Value {
        return Value.IP_20(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Use the Interrupt Priority Registers to assign a priority from 0 to 3 to each of the available interrupts. 0 is the highest priority, and 3 is the lowest.
pub const NVIC_IPR6 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000e418),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Priority of interrupt 27
        pub fn IP_27(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 32),
            };
        }
        /// Priority of interrupt 26
        pub fn IP_26(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 24),
            };
        }
        /// Priority of interrupt 25
        pub fn IP_25(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 16),
            };
        }
        /// Priority of interrupt 24
        pub fn IP_24(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn IP_27(self: Result) u2 {
            const mask = comptime helpers.generateMask(30, 32);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn IP_26(self: Result) u2 {
            const mask = comptime helpers.generateMask(22, 24);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IP_25(self: Result) u2 {
            const mask = comptime helpers.generateMask(14, 16);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn IP_24(self: Result) u2 {
            const mask = comptime helpers.generateMask(6, 8);
            return @intCast((self.val & mask) >> 6);
        }
    };
    /// Priority of interrupt 27
    pub fn IP_27(v: u2) Value {
        return Value.IP_27(.{}, v);
    }
    /// Priority of interrupt 26
    pub fn IP_26(v: u2) Value {
        return Value.IP_26(.{}, v);
    }
    /// Priority of interrupt 25
    pub fn IP_25(v: u2) Value {
        return Value.IP_25(.{}, v);
    }
    /// Priority of interrupt 24
    pub fn IP_24(v: u2) Value {
        return Value.IP_24(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Use the Interrupt Priority Registers to assign a priority from 0 to 3 to each of the available interrupts. 0 is the highest priority, and 3 is the lowest.
pub const NVIC_IPR7 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000e41c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Priority of interrupt 31
        pub fn IP_31(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 32),
            };
        }
        /// Priority of interrupt 30
        pub fn IP_30(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 24),
            };
        }
        /// Priority of interrupt 29
        pub fn IP_29(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 16),
            };
        }
        /// Priority of interrupt 28
        pub fn IP_28(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn IP_31(self: Result) u2 {
            const mask = comptime helpers.generateMask(30, 32);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn IP_30(self: Result) u2 {
            const mask = comptime helpers.generateMask(22, 24);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IP_29(self: Result) u2 {
            const mask = comptime helpers.generateMask(14, 16);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn IP_28(self: Result) u2 {
            const mask = comptime helpers.generateMask(6, 8);
            return @intCast((self.val & mask) >> 6);
        }
    };
    /// Priority of interrupt 31
    pub fn IP_31(v: u2) Value {
        return Value.IP_31(.{}, v);
    }
    /// Priority of interrupt 30
    pub fn IP_30(v: u2) Value {
        return Value.IP_30(.{}, v);
    }
    /// Priority of interrupt 29
    pub fn IP_29(v: u2) Value {
        return Value.IP_29(.{}, v);
    }
    /// Priority of interrupt 28
    pub fn IP_28(v: u2) Value {
        return Value.IP_28(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Read the CPU ID Base Register to determine: the ID number of the processor core, the version number of the processor core, the implementation details of the processor core.
pub const CPUID = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000ed00),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn IMPLEMENTER(self: Result) u8 {
            const mask = comptime helpers.generateMask(24, 32);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn VARIANT(self: Result) u4 {
            const mask = comptime helpers.generateMask(20, 24);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn ARCHITECTURE(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn PARTNO(self: Result) u12 {
            const mask = comptime helpers.generateMask(4, 16);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn REVISION(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Use the Interrupt Control State Register to set a pending Non-Maskable Interrupt (NMI), set or clear a pending PendSV, set or clear a pending SysTick, check for pending exceptions, check the vector number of the highest priority pended exception, check the vector number of the active exception.
pub const ICSR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000ed04),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Setting this bit will activate an NMI. Since NMI is the highest priority exception, it will activate as soon as it is registered.
        /// NMI set-pending bit.
        /// Write:
        /// 0 = No effect.
        /// 1 = Changes NMI exception state to pending.
        /// Read:
        /// 0 = NMI exception is not pending.
        /// 1 = NMI exception is pending.
        /// Because NMI is the highest-priority exception, normally the processor enters the NMI
        /// exception handler as soon as it detects a write of 1 to this bit. Entering the handler then clears
        /// this bit to 0. This means a read of this bit by the NMI exception handler returns 1 only if the
        /// NMI signal is reasserted while the processor is executing that handler.
        pub fn NMIPENDSET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// PendSV set-pending bit.
        /// Write:
        /// 0 = No effect.
        /// 1 = Changes PendSV exception state to pending.
        /// Read:
        /// 0 = PendSV exception is not pending.
        /// 1 = PendSV exception is pending.
        /// Writing 1 to this bit is the only way to set the PendSV exception state to pending.
        pub fn PENDSVSET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        /// PendSV clear-pending bit.
        /// Write:
        /// 0 = No effect.
        /// 1 = Removes the pending state from the PendSV exception.
        pub fn PENDSVCLR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        /// SysTick exception set-pending bit.
        /// Write:
        /// 0 = No effect.
        /// 1 = Changes SysTick exception state to pending.
        /// Read:
        /// 0 = SysTick exception is not pending.
        /// 1 = SysTick exception is pending.
        pub fn PENDSTSET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// SysTick exception clear-pending bit.
        /// Write:
        /// 0 = No effect.
        /// 1 = Removes the pending state from the SysTick exception.
        /// This bit is WO. On a register read its value is Unknown.
        pub fn PENDSTCLR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn NMIPENDSET(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn PENDSVSET(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn PENDSVCLR(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn PENDSTSET(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn PENDSTCLR(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn ISRPREEMPT(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn ISRPENDING(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn VECTPENDING(self: Result) u9 {
            const mask = comptime helpers.generateMask(12, 21);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn VECTACTIVE(self: Result) u9 {
            const mask = comptime helpers.generateMask(0, 9);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Setting this bit will activate an NMI. Since NMI is the highest priority exception, it will activate as soon as it is registered.
    /// NMI set-pending bit.
    /// Write:
    /// 0 = No effect.
    /// 1 = Changes NMI exception state to pending.
    /// Read:
    /// 0 = NMI exception is not pending.
    /// 1 = NMI exception is pending.
    /// Because NMI is the highest-priority exception, normally the processor enters the NMI
    /// exception handler as soon as it detects a write of 1 to this bit. Entering the handler then clears
    /// this bit to 0. This means a read of this bit by the NMI exception handler returns 1 only if the
    /// NMI signal is reasserted while the processor is executing that handler.
    pub fn NMIPENDSET(v: u1) Value {
        return Value.NMIPENDSET(.{}, v);
    }
    /// PendSV set-pending bit.
    /// Write:
    /// 0 = No effect.
    /// 1 = Changes PendSV exception state to pending.
    /// Read:
    /// 0 = PendSV exception is not pending.
    /// 1 = PendSV exception is pending.
    /// Writing 1 to this bit is the only way to set the PendSV exception state to pending.
    pub fn PENDSVSET(v: u1) Value {
        return Value.PENDSVSET(.{}, v);
    }
    /// PendSV clear-pending bit.
    /// Write:
    /// 0 = No effect.
    /// 1 = Removes the pending state from the PendSV exception.
    pub fn PENDSVCLR(v: u1) Value {
        return Value.PENDSVCLR(.{}, v);
    }
    /// SysTick exception set-pending bit.
    /// Write:
    /// 0 = No effect.
    /// 1 = Changes SysTick exception state to pending.
    /// Read:
    /// 0 = SysTick exception is not pending.
    /// 1 = SysTick exception is pending.
    pub fn PENDSTSET(v: u1) Value {
        return Value.PENDSTSET(.{}, v);
    }
    /// SysTick exception clear-pending bit.
    /// Write:
    /// 0 = No effect.
    /// 1 = Removes the pending state from the SysTick exception.
    /// This bit is WO. On a register read its value is Unknown.
    pub fn PENDSTCLR(v: u1) Value {
        return Value.PENDSTCLR(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// The VTOR holds the vector table offset address.
pub const VTOR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000ed08),
    pub fn write(self: @This(), v: u24) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(8, 32);
        content |= (helpers.toU32(v) << 8);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u24 {
        const mask = comptime helpers.generateMask(8, 32);
        return @intCast((self.reg.* & mask) >> 8);
    }
};
/// Use the Application Interrupt and Reset Control Register to: determine data endianness, clear all active state information from debug halt mode, request a system reset.
pub const AIRCR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000ed0c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Register key:
        /// Reads as Unknown
        /// On writes, write 0x05FA to VECTKEY, otherwise the write is ignored.
        pub fn VECTKEY(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        /// Writing 1 to this bit causes the SYSRESETREQ signal to the outer system to be asserted to request a reset. The intention is to force a large system reset of all major components except for debug. The C_HALT bit in the DHCSR is cleared as a result of the system reset requested. The debugger does not lose contact with the device.
        pub fn SYSRESETREQ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Clears all active state information for fixed and configurable exceptions. This bit: is self-clearing, can only be set by the DAP when the core is halted.  When set: clears all active exception status of the processor, forces a return to Thread mode, forces an IPSR of 0. A debugger must re-initialize the stack.
        pub fn VECTCLRACTIVE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn VECTKEY(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ENDIANESS(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn SYSRESETREQ(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn VECTCLRACTIVE(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
    };
    /// Register key:
    /// Reads as Unknown
    /// On writes, write 0x05FA to VECTKEY, otherwise the write is ignored.
    pub fn VECTKEY(v: u16) Value {
        return Value.VECTKEY(.{}, v);
    }
    /// Writing 1 to this bit causes the SYSRESETREQ signal to the outer system to be asserted to request a reset. The intention is to force a large system reset of all major components except for debug. The C_HALT bit in the DHCSR is cleared as a result of the system reset requested. The debugger does not lose contact with the device.
    pub fn SYSRESETREQ(v: u1) Value {
        return Value.SYSRESETREQ(.{}, v);
    }
    /// Clears all active state information for fixed and configurable exceptions. This bit: is self-clearing, can only be set by the DAP when the core is halted.  When set: clears all active exception status of the processor, forces a return to Thread mode, forces an IPSR of 0. A debugger must re-initialize the stack.
    pub fn VECTCLRACTIVE(v: u1) Value {
        return Value.VECTCLRACTIVE(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// System Control Register. Use the System Control Register for power-management functions: signal to the system when the processor can enter a low power state, control how the processor enters and exits low power states.
pub const SCR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000ed10),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Send Event on Pending bit:
        /// 0 = Only enabled interrupts or events can wakeup the processor, disabled interrupts are excluded.
        /// 1 = Enabled events and all interrupts, including disabled interrupts, can wakeup the processor.
        /// When an event or interrupt becomes pending, the event signal wakes up the processor from WFE. If the
        /// processor is not waiting for an event, the event is registered and affects the next WFE.
        /// The processor also wakes up on execution of an SEV instruction or an external event.
        pub fn SEVONPEND(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Controls whether the processor uses sleep or deep sleep as its low power mode:
        /// 0 = Sleep.
        /// 1 = Deep sleep.
        pub fn SLEEPDEEP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Indicates sleep-on-exit when returning from Handler mode to Thread mode:
        /// 0 = Do not sleep when returning to Thread mode.
        /// 1 = Enter sleep, or deep sleep, on return from an ISR to Thread mode.
        /// Setting this bit to 1 enables an interrupt driven application to avoid returning to an empty main application.
        pub fn SLEEPONEXIT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn SEVONPEND(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn SLEEPDEEP(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SLEEPONEXIT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
    };
    /// Send Event on Pending bit:
    /// 0 = Only enabled interrupts or events can wakeup the processor, disabled interrupts are excluded.
    /// 1 = Enabled events and all interrupts, including disabled interrupts, can wakeup the processor.
    /// When an event or interrupt becomes pending, the event signal wakes up the processor from WFE. If the
    /// processor is not waiting for an event, the event is registered and affects the next WFE.
    /// The processor also wakes up on execution of an SEV instruction or an external event.
    pub fn SEVONPEND(v: u1) Value {
        return Value.SEVONPEND(.{}, v);
    }
    /// Controls whether the processor uses sleep or deep sleep as its low power mode:
    /// 0 = Sleep.
    /// 1 = Deep sleep.
    pub fn SLEEPDEEP(v: u1) Value {
        return Value.SLEEPDEEP(.{}, v);
    }
    /// Indicates sleep-on-exit when returning from Handler mode to Thread mode:
    /// 0 = Do not sleep when returning to Thread mode.
    /// 1 = Enter sleep, or deep sleep, on return from an ISR to Thread mode.
    /// Setting this bit to 1 enables an interrupt driven application to avoid returning to an empty main application.
    pub fn SLEEPONEXIT(v: u1) Value {
        return Value.SLEEPONEXIT(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// The Configuration and Control Register permanently enables stack alignment and causes unaligned accesses to result in a Hard Fault.
pub const CCR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000ed14),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn STKALIGN(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn UNALIGN_TRP(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// System handlers are a special class of exception handler that can have their priority set to any of the priority levels. Use the System Handler Priority Register 2 to set the priority of SVCall.
pub const SHPR2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000ed1c),
    pub fn write(self: @This(), v: u2) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(30, 32);
        content |= (helpers.toU32(v) << 30);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u2 {
        const mask = comptime helpers.generateMask(30, 32);
        return @intCast((self.reg.* & mask) >> 30);
    }
};
/// System handlers are a special class of exception handler that can have their priority set to any of the priority levels. Use the System Handler Priority Register 3 to set the priority of PendSV and SysTick.
pub const SHPR3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000ed20),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Priority of system handler 15, SysTick
        pub fn PRI_15(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 32),
            };
        }
        /// Priority of system handler 14, PendSV
        pub fn PRI_14(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 24),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn PRI_15(self: Result) u2 {
            const mask = comptime helpers.generateMask(30, 32);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PRI_14(self: Result) u2 {
            const mask = comptime helpers.generateMask(22, 24);
            return @intCast((self.val & mask) >> 22);
        }
    };
    /// Priority of system handler 15, SysTick
    pub fn PRI_15(v: u2) Value {
        return Value.PRI_15(.{}, v);
    }
    /// Priority of system handler 14, PendSV
    pub fn PRI_14(v: u2) Value {
        return Value.PRI_14(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Use the System Handler Control and State Register to determine or clear the pending status of SVCall.
pub const SHCSR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000ed24),
    pub fn write(self: @This(), v: u1) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(15, 16);
        content |= (helpers.toU32(v) << 15);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u1 {
        const mask = comptime helpers.generateMask(15, 16);
        return @intCast((self.reg.* & mask) >> 15);
    }
};
/// Read the MPU Type Register to determine if the processor implements an MPU, and how many regions the MPU supports.
pub const MPU_TYPE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000ed90),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn IREGION(self: Result) u8 {
            const mask = comptime helpers.generateMask(16, 24);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn DREGION(self: Result) u8 {
            const mask = comptime helpers.generateMask(8, 16);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SEPARATE(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Use the MPU Control Register to enable and disable the MPU, and to control whether the default memory map is enabled as a background region for privileged accesses, and whether the MPU is enabled for HardFaults and NMIs.
pub const MPU_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000ed94),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Controls whether the default memory map is enabled as a background region for privileged accesses. This bit is ignored when ENABLE is clear.
        /// 0 = If the MPU is enabled, disables use of the default memory map. Any memory access to a location not
        /// covered by any enabled region causes a fault.
        /// 1 = If the MPU is enabled, enables use of the default memory map as a background region for privileged software accesses.
        /// When enabled, the background region acts as if it is region number -1. Any region that is defined and enabled has priority over this default map.
        pub fn PRIVDEFENA(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Controls the use of the MPU for HardFaults and NMIs. Setting this bit when ENABLE is clear results in UNPREDICTABLE behaviour.
        /// When the MPU is enabled:
        /// 0 = MPU is disabled during HardFault and NMI handlers, regardless of the value of the ENABLE bit.
        /// 1 = the MPU is enabled during HardFault and NMI handlers.
        pub fn HFNMIENA(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Enables the MPU. If the MPU is disabled, privileged and unprivileged accesses use the default memory map.
        /// 0 = MPU disabled.
        /// 1 = MPU enabled.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn PRIVDEFENA(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn HFNMIENA(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Controls whether the default memory map is enabled as a background region for privileged accesses. This bit is ignored when ENABLE is clear.
    /// 0 = If the MPU is enabled, disables use of the default memory map. Any memory access to a location not
    /// covered by any enabled region causes a fault.
    /// 1 = If the MPU is enabled, enables use of the default memory map as a background region for privileged software accesses.
    /// When enabled, the background region acts as if it is region number -1. Any region that is defined and enabled has priority over this default map.
    pub fn PRIVDEFENA(v: u1) Value {
        return Value.PRIVDEFENA(.{}, v);
    }
    /// Controls the use of the MPU for HardFaults and NMIs. Setting this bit when ENABLE is clear results in UNPREDICTABLE behaviour.
    /// When the MPU is enabled:
    /// 0 = MPU is disabled during HardFault and NMI handlers, regardless of the value of the ENABLE bit.
    /// 1 = the MPU is enabled during HardFault and NMI handlers.
    pub fn HFNMIENA(v: u1) Value {
        return Value.HFNMIENA(.{}, v);
    }
    /// Enables the MPU. If the MPU is disabled, privileged and unprivileged accesses use the default memory map.
    /// 0 = MPU disabled.
    /// 1 = MPU enabled.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Use the MPU Region Number Register to select the region currently accessed by MPU_RBAR and MPU_RASR.
pub const MPU_RNR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000ed98),
    pub fn write(self: @This(), v: u4) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 4);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u4 {
        const mask = comptime helpers.generateMask(0, 4);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read the MPU Region Base Address Register to determine the base address of the region identified by MPU_RNR. Write to update the base address of said region or that of a specified region, with whose number MPU_RNR will also be updated.
pub const MPU_RBAR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000ed9c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Base address of the region.
        pub fn ADDR(self: Value, v: u24) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 32),
            };
        }
        /// On writes, indicates whether the write must update the base address of the region identified by the REGION field, updating the MPU_RNR to indicate this new region.
        /// Write:
        /// 0 = MPU_RNR not changed, and the processor:
        /// Updates the base address for the region specified in the MPU_RNR.
        /// Ignores the value of the REGION field.
        /// 1 = The processor:
        /// Updates the value of the MPU_RNR to the value of the REGION field.
        /// Updates the base address for the region specified in the REGION field.
        /// Always reads as zero.
        pub fn VALID(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// On writes, specifies the number of the region whose base address to update provided VALID is set written as 1. On reads, returns bits [3:0] of MPU_RNR.
        pub fn REGION(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 4),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ADDR(self: Result) u24 {
            const mask = comptime helpers.generateMask(8, 32);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn VALID(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn REGION(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Base address of the region.
    pub fn ADDR(v: u24) Value {
        return Value.ADDR(.{}, v);
    }
    /// On writes, indicates whether the write must update the base address of the region identified by the REGION field, updating the MPU_RNR to indicate this new region.
    /// Write:
    /// 0 = MPU_RNR not changed, and the processor:
    /// Updates the base address for the region specified in the MPU_RNR.
    /// Ignores the value of the REGION field.
    /// 1 = The processor:
    /// Updates the value of the MPU_RNR to the value of the REGION field.
    /// Updates the base address for the region specified in the REGION field.
    /// Always reads as zero.
    pub fn VALID(v: u1) Value {
        return Value.VALID(.{}, v);
    }
    /// On writes, specifies the number of the region whose base address to update provided VALID is set written as 1. On reads, returns bits [3:0] of MPU_RNR.
    pub fn REGION(v: u4) Value {
        return Value.REGION(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Use the MPU Region Attribute and Size Register to define the size, access behaviour and memory type of the region identified by MPU_RNR, and enable that region.
pub const MPU_RASR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xe000eda0),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// The MPU Region Attribute field. Use to define the region attribute control.
        /// 28 = XN: Instruction access disable bit:
        /// 0 = Instruction fetches enabled.
        /// 1 = Instruction fetches disabled.
        /// 26:24 = AP: Access permission field
        /// 18 = S: Shareable bit
        /// 17 = C: Cacheable bit
        /// 16 = B: Bufferable bit
        pub fn ATTRS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        /// Subregion Disable. For regions of 256 bytes or larger, each bit of this field controls whether one of the eight equal subregions is enabled.
        pub fn SRD(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 16),
            };
        }
        /// Indicates the region size. Region size in bytes = 2^(SIZE+1). The minimum permitted value is 7 (b00111) = 256Bytes
        pub fn SIZE(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 6),
            };
        }
        /// Enables the region.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ATTRS(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn SRD(self: Result) u8 {
            const mask = comptime helpers.generateMask(8, 16);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SIZE(self: Result) u5 {
            const mask = comptime helpers.generateMask(1, 6);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// The MPU Region Attribute field. Use to define the region attribute control.
    /// 28 = XN: Instruction access disable bit:
    /// 0 = Instruction fetches enabled.
    /// 1 = Instruction fetches disabled.
    /// 26:24 = AP: Access permission field
    /// 18 = S: Shareable bit
    /// 17 = C: Cacheable bit
    /// 16 = B: Bufferable bit
    pub fn ATTRS(v: u16) Value {
        return Value.ATTRS(.{}, v);
    }
    /// Subregion Disable. For regions of 256 bytes or larger, each bit of this field controls whether one of the eight equal subregions is enabled.
    pub fn SRD(v: u8) Value {
        return Value.SRD(.{}, v);
    }
    /// Indicates the region size. Region size in bytes = 2^(SIZE+1). The minimum permitted value is 7 (b00111) = 256Bytes
    pub fn SIZE(v: u5) Value {
        return Value.SIZE(.{}, v);
    }
    /// Enables the region.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        var content = self.reg.*;
        content &= ~v.mask;
        content |= v.val;
        self.reg.* = content;
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const PPB_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0xe0000000),

    /// Use the SysTick Control and Status Register to enable the SysTick features.
    SYST_CSR: SYST_CSR = .{},
    /// Use the SysTick Reload Value Register to specify the start value to load into the current value register when the counter reaches 0. It can be any value between 0 and 0x00FFFFFF. A start value of 0 is possible, but has no effect because the SysTick interrupt and COUNTFLAG are activated when counting from 1 to 0. The reset value of this register is UNKNOWN.
    /// To generate a multi-shot timer with a period of N processor clock cycles, use a RELOAD value of N-1. For example, if the SysTick interrupt is required every 100 clock pulses, set RELOAD to 99.
    SYST_RVR: SYST_RVR = .{},
    /// Use the SysTick Current Value Register to find the current value in the register. The reset value of this register is UNKNOWN.
    SYST_CVR: SYST_CVR = .{},
    /// Use the SysTick Calibration Value Register to enable software to scale to any required speed using divide and multiply.
    SYST_CALIB: SYST_CALIB = .{},
    /// Use the Interrupt Set-Enable Register to enable interrupts and determine which interrupts are currently enabled.
    /// If a pending interrupt is enabled, the NVIC activates the interrupt based on its priority. If an interrupt is not enabled, asserting its interrupt signal changes the interrupt state to pending, but the NVIC never activates the interrupt, regardless of its priority.
    NVIC_ISER: NVIC_ISER = .{},
    /// Use the Interrupt Clear-Enable Registers to disable interrupts and determine which interrupts are currently enabled.
    NVIC_ICER: NVIC_ICER = .{},
    /// The NVIC_ISPR forces interrupts into the pending state, and shows which interrupts are pending.
    NVIC_ISPR: NVIC_ISPR = .{},
    /// Use the Interrupt Clear-Pending Register to clear pending interrupts and determine which interrupts are currently pending.
    NVIC_ICPR: NVIC_ICPR = .{},
    /// Use the Interrupt Priority Registers to assign a priority from 0 to 3 to each of the available interrupts. 0 is the highest priority, and 3 is the lowest.
    /// Note: Writing 1 to an NVIC_ICPR bit does not affect the active state of the corresponding interrupt.
    /// These registers are only word-accessible
    NVIC_IPR0: NVIC_IPR0 = .{},
    /// Use the Interrupt Priority Registers to assign a priority from 0 to 3 to each of the available interrupts. 0 is the highest priority, and 3 is the lowest.
    NVIC_IPR1: NVIC_IPR1 = .{},
    /// Use the Interrupt Priority Registers to assign a priority from 0 to 3 to each of the available interrupts. 0 is the highest priority, and 3 is the lowest.
    NVIC_IPR2: NVIC_IPR2 = .{},
    /// Use the Interrupt Priority Registers to assign a priority from 0 to 3 to each of the available interrupts. 0 is the highest priority, and 3 is the lowest.
    NVIC_IPR3: NVIC_IPR3 = .{},
    /// Use the Interrupt Priority Registers to assign a priority from 0 to 3 to each of the available interrupts. 0 is the highest priority, and 3 is the lowest.
    NVIC_IPR4: NVIC_IPR4 = .{},
    /// Use the Interrupt Priority Registers to assign a priority from 0 to 3 to each of the available interrupts. 0 is the highest priority, and 3 is the lowest.
    NVIC_IPR5: NVIC_IPR5 = .{},
    /// Use the Interrupt Priority Registers to assign a priority from 0 to 3 to each of the available interrupts. 0 is the highest priority, and 3 is the lowest.
    NVIC_IPR6: NVIC_IPR6 = .{},
    /// Use the Interrupt Priority Registers to assign a priority from 0 to 3 to each of the available interrupts. 0 is the highest priority, and 3 is the lowest.
    NVIC_IPR7: NVIC_IPR7 = .{},
    /// Read the CPU ID Base Register to determine: the ID number of the processor core, the version number of the processor core, the implementation details of the processor core.
    CPUID: CPUID = .{},
    /// Use the Interrupt Control State Register to set a pending Non-Maskable Interrupt (NMI), set or clear a pending PendSV, set or clear a pending SysTick, check for pending exceptions, check the vector number of the highest priority pended exception, check the vector number of the active exception.
    ICSR: ICSR = .{},
    /// The VTOR holds the vector table offset address.
    VTOR: VTOR = .{},
    /// Use the Application Interrupt and Reset Control Register to: determine data endianness, clear all active state information from debug halt mode, request a system reset.
    AIRCR: AIRCR = .{},
    /// System Control Register. Use the System Control Register for power-management functions: signal to the system when the processor can enter a low power state, control how the processor enters and exits low power states.
    SCR: SCR = .{},
    /// The Configuration and Control Register permanently enables stack alignment and causes unaligned accesses to result in a Hard Fault.
    CCR: CCR = .{},
    /// System handlers are a special class of exception handler that can have their priority set to any of the priority levels. Use the System Handler Priority Register 2 to set the priority of SVCall.
    SHPR2: SHPR2 = .{},
    /// System handlers are a special class of exception handler that can have their priority set to any of the priority levels. Use the System Handler Priority Register 3 to set the priority of PendSV and SysTick.
    SHPR3: SHPR3 = .{},
    /// Use the System Handler Control and State Register to determine or clear the pending status of SVCall.
    SHCSR: SHCSR = .{},
    /// Read the MPU Type Register to determine if the processor implements an MPU, and how many regions the MPU supports.
    MPU_TYPE: MPU_TYPE = .{},
    /// Use the MPU Control Register to enable and disable the MPU, and to control whether the default memory map is enabled as a background region for privileged accesses, and whether the MPU is enabled for HardFaults and NMIs.
    MPU_CTRL: MPU_CTRL = .{},
    /// Use the MPU Region Number Register to select the region currently accessed by MPU_RBAR and MPU_RASR.
    MPU_RNR: MPU_RNR = .{},
    /// Read the MPU Region Base Address Register to determine the base address of the region identified by MPU_RNR. Write to update the base address of said region or that of a specified region, with whose number MPU_RNR will also be updated.
    MPU_RBAR: MPU_RBAR = .{},
    /// Use the MPU Region Attribute and Size Register to define the size, access behaviour and memory type of the region identified by MPU_RNR, and enable that region.
    MPU_RASR: MPU_RASR = .{},
};
pub const PPB = PPB_p{};
