const helpers = @import("helpers.zig");
/// Processor core identifier
pub const CPUID = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000000),
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
/// Input value for GPIO pins
pub const GPIO_IN = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000004),
    pub fn write(self: @This(), v: u30) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 30);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u30 {
        const mask = comptime helpers.generateMask(0, 30);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Input value for QSPI pins
pub const GPIO_HI_IN = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000008),
    pub fn write(self: @This(), v: u6) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 6);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// GPIO output value
pub const GPIO_OUT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000010),
    pub fn write(self: @This(), v: u30) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 30);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u30 {
        const mask = comptime helpers.generateMask(0, 30);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// GPIO output value set
pub const GPIO_OUT_SET = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000014),
    pub fn write(self: @This(), v: u30) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 30);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u30 {
        const mask = comptime helpers.generateMask(0, 30);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// GPIO output value clear
pub const GPIO_OUT_CLR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000018),
    pub fn write(self: @This(), v: u30) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 30);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u30 {
        const mask = comptime helpers.generateMask(0, 30);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// GPIO output value XOR
pub const GPIO_OUT_XOR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd000001c),
    pub fn write(self: @This(), v: u30) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 30);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u30 {
        const mask = comptime helpers.generateMask(0, 30);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// GPIO output enable
pub const GPIO_OE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000020),
    pub fn write(self: @This(), v: u30) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 30);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u30 {
        const mask = comptime helpers.generateMask(0, 30);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// GPIO output enable set
pub const GPIO_OE_SET = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000024),
    pub fn write(self: @This(), v: u30) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 30);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u30 {
        const mask = comptime helpers.generateMask(0, 30);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// GPIO output enable clear
pub const GPIO_OE_CLR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000028),
    pub fn write(self: @This(), v: u30) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 30);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u30 {
        const mask = comptime helpers.generateMask(0, 30);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// GPIO output enable XOR
pub const GPIO_OE_XOR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd000002c),
    pub fn write(self: @This(), v: u30) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 30);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u30 {
        const mask = comptime helpers.generateMask(0, 30);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// QSPI output value
pub const GPIO_HI_OUT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000030),
    pub fn write(self: @This(), v: u6) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 6);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// QSPI output value set
pub const GPIO_HI_OUT_SET = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000034),
    pub fn write(self: @This(), v: u6) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 6);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// QSPI output value clear
pub const GPIO_HI_OUT_CLR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000038),
    pub fn write(self: @This(), v: u6) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 6);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// QSPI output value XOR
pub const GPIO_HI_OUT_XOR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd000003c),
    pub fn write(self: @This(), v: u6) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 6);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// QSPI output enable
pub const GPIO_HI_OE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000040),
    pub fn write(self: @This(), v: u6) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 6);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// QSPI output enable set
pub const GPIO_HI_OE_SET = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000044),
    pub fn write(self: @This(), v: u6) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 6);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// QSPI output enable clear
pub const GPIO_HI_OE_CLR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000048),
    pub fn write(self: @This(), v: u6) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 6);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// QSPI output enable XOR
pub const GPIO_HI_OE_XOR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd000004c),
    pub fn write(self: @This(), v: u6) void {
        var content = self.reg.*;
        content &= ~comptime helpers.generateMask(0, 6);
        content |= (helpers.toU32(v) << 0);
        self.reg.* = content;
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Status register for inter-core FIFOs (mailboxes).
/// There is one FIFO in the core 0 -&gt; core 1 direction, and one core 1 -&gt; core 0. Both are 32 bits wide and 8 words deep.
/// Core 0 can see the read side of the 1-&gt;0 FIFO (RX), and the write side of 0-&gt;1 FIFO (TX).
/// Core 1 can see the read side of the 0-&gt;1 FIFO (RX), and the write side of 1-&gt;0 FIFO (TX).
/// The SIO IRQ for each core is the logical OR of the VLD, WOF and ROE fields of its FIFO_ST register.
pub const FIFO_ST = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000050),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Sticky flag indicating the RX FIFO was read when empty. This read was ignored by the FIFO.
        pub fn ROE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Sticky flag indicating the TX FIFO was written when full. This write was ignored by the FIFO.
        pub fn WOF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ROE(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn WOF(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn RDY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn VLD(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Sticky flag indicating the RX FIFO was read when empty. This read was ignored by the FIFO.
    pub fn ROE(v: u1) Value {
        return Value.ROE(.{}, v);
    }
    /// Sticky flag indicating the TX FIFO was written when full. This write was ignored by the FIFO.
    pub fn WOF(v: u1) Value {
        return Value.WOF(.{}, v);
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
/// Write access to this core&#39;s TX FIFO
pub const FIFO_WR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000054),
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
/// Read access to this core&#39;s RX FIFO
pub const FIFO_RD = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000058),
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
/// Spinlock state
/// A bitmap containing the state of all 32 spinlocks (1=locked).
/// Mainly intended for debugging.
pub const SPINLOCK_ST = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd000005c),
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
/// Divider unsigned dividend
/// Write to the DIVIDEND operand of the divider, i.e. the p in `p / q`.
/// Any operand write starts a new calculation. The results appear in QUOTIENT, REMAINDER.
/// UDIVIDEND/SDIVIDEND are aliases of the same internal register. The U alias starts an
/// unsigned calculation, and the S alias starts a signed calculation.
pub const DIV_UDIVIDEND = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000060),
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
/// Divider unsigned divisor
/// Write to the DIVISOR operand of the divider, i.e. the q in `p / q`.
/// Any operand write starts a new calculation. The results appear in QUOTIENT, REMAINDER.
/// UDIVISOR/SDIVISOR are aliases of the same internal register. The U alias starts an
/// unsigned calculation, and the S alias starts a signed calculation.
pub const DIV_UDIVISOR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000064),
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
/// Divider signed dividend
/// The same as UDIVIDEND, but starts a signed calculation, rather than unsigned.
pub const DIV_SDIVIDEND = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000068),
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
/// Divider signed divisor
/// The same as UDIVISOR, but starts a signed calculation, rather than unsigned.
pub const DIV_SDIVISOR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd000006c),
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
/// Divider result quotient
/// The result of `DIVIDEND / DIVISOR` (division). Contents undefined while CSR_READY is low.
/// For signed calculations, QUOTIENT is negative when the signs of DIVIDEND and DIVISOR differ.
/// This register can be written to directly, for context save/restore purposes. This halts any
/// in-progress calculation and sets the CSR_READY and CSR_DIRTY flags.
/// Reading from QUOTIENT clears the CSR_DIRTY flag, so should read results in the order
/// REMAINDER, QUOTIENT if CSR_DIRTY is used.
pub const DIV_QUOTIENT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000070),
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
/// Divider result remainder
/// The result of `DIVIDEND % DIVISOR` (modulo). Contents undefined while CSR_READY is low.
/// For signed calculations, REMAINDER is negative only when DIVIDEND is negative.
/// This register can be written to directly, for context save/restore purposes. This halts any
/// in-progress calculation and sets the CSR_READY and CSR_DIRTY flags.
pub const DIV_REMAINDER = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000074),
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
/// Control and status register for divider.
pub const DIV_CSR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000078),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn DIRTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn READY(self: Result) u1 {
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
/// Read/write access to accumulator 0
pub const INTERP0_ACCUM0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000080),
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
/// Read/write access to accumulator 1
pub const INTERP0_ACCUM1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000084),
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
/// Read/write access to BASE0 register.
pub const INTERP0_BASE0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000088),
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
/// Read/write access to BASE1 register.
pub const INTERP0_BASE1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd000008c),
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
/// Read/write access to BASE2 register.
pub const INTERP0_BASE2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000090),
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
/// Read LANE0 result, and simultaneously write lane results to both accumulators (POP).
pub const INTERP0_POP_LANE0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000094),
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
/// Read LANE1 result, and simultaneously write lane results to both accumulators (POP).
pub const INTERP0_POP_LANE1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000098),
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
/// Read FULL result, and simultaneously write lane results to both accumulators (POP).
pub const INTERP0_POP_FULL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd000009c),
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
/// Read LANE0 result, without altering any internal state (PEEK).
pub const INTERP0_PEEK_LANE0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000a0),
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
/// Read LANE1 result, without altering any internal state (PEEK).
pub const INTERP0_PEEK_LANE1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000a4),
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
/// Read FULL result, without altering any internal state (PEEK).
pub const INTERP0_PEEK_FULL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000a8),
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
/// Control register for lane 0
pub const INTERP0_CTRL_LANE0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000ac),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Only present on INTERP0 on each core. If BLEND mode is enabled:
        /// - LANE1 result is a linear interpolation between BASE0 and BASE1, controlled
        /// by the 8 LSBs of lane 1 shift and mask value (a fractional number between
        /// 0 and 255/256ths)
        /// - LANE0 result does not have BASE0 added (yields only the 8 LSBs of lane 1 shift+mask value)
        /// - FULL result does not have lane 1 shift+mask value added (BASE2 + lane 0 shift+mask)
        /// LANE1 SIGNED flag controls whether the interpolation is signed or unsigned.
        pub fn BLEND(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        /// ORed into bits 29:28 of the lane result presented to the processor on the bus.
        /// No effect on the internal 32-bit datapath. Handy for using a lane to generate sequence
        /// of pointers into flash or SRAM.
        pub fn FORCE_MSB(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 21),
            };
        }
        /// If 1, mask + shift is bypassed for LANE0 result. This does not affect FULL result.
        pub fn ADD_RAW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        /// If 1, feed the opposite lane&#39;s result into this lane&#39;s accumulator on POP.
        pub fn CROSS_RESULT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// If 1, feed the opposite lane&#39;s accumulator into this lane&#39;s shift + mask hardware.
        /// Takes effect even if ADD_RAW is set (the CROSS_INPUT mux is before the shift+mask bypass)
        pub fn CROSS_INPUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// If SIGNED is set, the shifted and masked accumulator value is sign-extended to 32 bits
        /// before adding to BASE0, and LANE0 PEEK/POP appear extended to 32 bits when read by processor.
        pub fn SIGNED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// The most-significant bit allowed to pass by the mask (inclusive)
        /// Setting MSB &lt; LSB may cause chip to turn inside-out
        pub fn MASK_MSB(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 15),
            };
        }
        /// The least-significant bit allowed to pass by the mask (inclusive)
        pub fn MASK_LSB(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 10),
            };
        }
        /// Logical right-shift applied to accumulator before masking
        pub fn SHIFT(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 5),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn OVERF(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn OVERF1(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn OVERF0(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn BLEND(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn FORCE_MSB(self: Result) u2 {
            const mask = comptime helpers.generateMask(19, 21);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn ADD_RAW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn CROSS_RESULT(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn CROSS_INPUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn SIGNED(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn MASK_MSB(self: Result) u5 {
            const mask = comptime helpers.generateMask(10, 15);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn MASK_LSB(self: Result) u5 {
            const mask = comptime helpers.generateMask(5, 10);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn SHIFT(self: Result) u5 {
            const mask = comptime helpers.generateMask(0, 5);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Only present on INTERP0 on each core. If BLEND mode is enabled:
    /// - LANE1 result is a linear interpolation between BASE0 and BASE1, controlled
    /// by the 8 LSBs of lane 1 shift and mask value (a fractional number between
    /// 0 and 255/256ths)
    /// - LANE0 result does not have BASE0 added (yields only the 8 LSBs of lane 1 shift+mask value)
    /// - FULL result does not have lane 1 shift+mask value added (BASE2 + lane 0 shift+mask)
    /// LANE1 SIGNED flag controls whether the interpolation is signed or unsigned.
    pub fn BLEND(v: u1) Value {
        return Value.BLEND(.{}, v);
    }
    /// ORed into bits 29:28 of the lane result presented to the processor on the bus.
    /// No effect on the internal 32-bit datapath. Handy for using a lane to generate sequence
    /// of pointers into flash or SRAM.
    pub fn FORCE_MSB(v: u2) Value {
        return Value.FORCE_MSB(.{}, v);
    }
    /// If 1, mask + shift is bypassed for LANE0 result. This does not affect FULL result.
    pub fn ADD_RAW(v: u1) Value {
        return Value.ADD_RAW(.{}, v);
    }
    /// If 1, feed the opposite lane&#39;s result into this lane&#39;s accumulator on POP.
    pub fn CROSS_RESULT(v: u1) Value {
        return Value.CROSS_RESULT(.{}, v);
    }
    /// If 1, feed the opposite lane&#39;s accumulator into this lane&#39;s shift + mask hardware.
    /// Takes effect even if ADD_RAW is set (the CROSS_INPUT mux is before the shift+mask bypass)
    pub fn CROSS_INPUT(v: u1) Value {
        return Value.CROSS_INPUT(.{}, v);
    }
    /// If SIGNED is set, the shifted and masked accumulator value is sign-extended to 32 bits
    /// before adding to BASE0, and LANE0 PEEK/POP appear extended to 32 bits when read by processor.
    pub fn SIGNED(v: u1) Value {
        return Value.SIGNED(.{}, v);
    }
    /// The most-significant bit allowed to pass by the mask (inclusive)
    /// Setting MSB &lt; LSB may cause chip to turn inside-out
    pub fn MASK_MSB(v: u5) Value {
        return Value.MASK_MSB(.{}, v);
    }
    /// The least-significant bit allowed to pass by the mask (inclusive)
    pub fn MASK_LSB(v: u5) Value {
        return Value.MASK_LSB(.{}, v);
    }
    /// Logical right-shift applied to accumulator before masking
    pub fn SHIFT(v: u5) Value {
        return Value.SHIFT(.{}, v);
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
/// Control register for lane 1
pub const INTERP0_CTRL_LANE1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000b0),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// ORed into bits 29:28 of the lane result presented to the processor on the bus.
        /// No effect on the internal 32-bit datapath. Handy for using a lane to generate sequence
        /// of pointers into flash or SRAM.
        pub fn FORCE_MSB(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 21),
            };
        }
        /// If 1, mask + shift is bypassed for LANE1 result. This does not affect FULL result.
        pub fn ADD_RAW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        /// If 1, feed the opposite lane&#39;s result into this lane&#39;s accumulator on POP.
        pub fn CROSS_RESULT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// If 1, feed the opposite lane&#39;s accumulator into this lane&#39;s shift + mask hardware.
        /// Takes effect even if ADD_RAW is set (the CROSS_INPUT mux is before the shift+mask bypass)
        pub fn CROSS_INPUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// If SIGNED is set, the shifted and masked accumulator value is sign-extended to 32 bits
        /// before adding to BASE1, and LANE1 PEEK/POP appear extended to 32 bits when read by processor.
        pub fn SIGNED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// The most-significant bit allowed to pass by the mask (inclusive)
        /// Setting MSB &lt; LSB may cause chip to turn inside-out
        pub fn MASK_MSB(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 15),
            };
        }
        /// The least-significant bit allowed to pass by the mask (inclusive)
        pub fn MASK_LSB(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 10),
            };
        }
        /// Logical right-shift applied to accumulator before masking
        pub fn SHIFT(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 5),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FORCE_MSB(self: Result) u2 {
            const mask = comptime helpers.generateMask(19, 21);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn ADD_RAW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn CROSS_RESULT(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn CROSS_INPUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn SIGNED(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn MASK_MSB(self: Result) u5 {
            const mask = comptime helpers.generateMask(10, 15);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn MASK_LSB(self: Result) u5 {
            const mask = comptime helpers.generateMask(5, 10);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn SHIFT(self: Result) u5 {
            const mask = comptime helpers.generateMask(0, 5);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// ORed into bits 29:28 of the lane result presented to the processor on the bus.
    /// No effect on the internal 32-bit datapath. Handy for using a lane to generate sequence
    /// of pointers into flash or SRAM.
    pub fn FORCE_MSB(v: u2) Value {
        return Value.FORCE_MSB(.{}, v);
    }
    /// If 1, mask + shift is bypassed for LANE1 result. This does not affect FULL result.
    pub fn ADD_RAW(v: u1) Value {
        return Value.ADD_RAW(.{}, v);
    }
    /// If 1, feed the opposite lane&#39;s result into this lane&#39;s accumulator on POP.
    pub fn CROSS_RESULT(v: u1) Value {
        return Value.CROSS_RESULT(.{}, v);
    }
    /// If 1, feed the opposite lane&#39;s accumulator into this lane&#39;s shift + mask hardware.
    /// Takes effect even if ADD_RAW is set (the CROSS_INPUT mux is before the shift+mask bypass)
    pub fn CROSS_INPUT(v: u1) Value {
        return Value.CROSS_INPUT(.{}, v);
    }
    /// If SIGNED is set, the shifted and masked accumulator value is sign-extended to 32 bits
    /// before adding to BASE1, and LANE1 PEEK/POP appear extended to 32 bits when read by processor.
    pub fn SIGNED(v: u1) Value {
        return Value.SIGNED(.{}, v);
    }
    /// The most-significant bit allowed to pass by the mask (inclusive)
    /// Setting MSB &lt; LSB may cause chip to turn inside-out
    pub fn MASK_MSB(v: u5) Value {
        return Value.MASK_MSB(.{}, v);
    }
    /// The least-significant bit allowed to pass by the mask (inclusive)
    pub fn MASK_LSB(v: u5) Value {
        return Value.MASK_LSB(.{}, v);
    }
    /// Logical right-shift applied to accumulator before masking
    pub fn SHIFT(v: u5) Value {
        return Value.SHIFT(.{}, v);
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
/// Values written here are atomically added to ACCUM0
/// Reading yields lane 0&#39;s raw shift and mask value (BASE0 not added).
pub const INTERP0_ACCUM0_ADD = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000b4),
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
/// Values written here are atomically added to ACCUM1
/// Reading yields lane 1&#39;s raw shift and mask value (BASE1 not added).
pub const INTERP0_ACCUM1_ADD = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000b8),
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
/// On write, the lower 16 bits go to BASE0, upper bits to BASE1 simultaneously.
/// Each half is sign-extended to 32 bits if that lane&#39;s SIGNED flag is set.
pub const INTERP0_BASE_1AND0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000bc),
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
/// Read/write access to accumulator 0
pub const INTERP1_ACCUM0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000c0),
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
/// Read/write access to accumulator 1
pub const INTERP1_ACCUM1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000c4),
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
/// Read/write access to BASE0 register.
pub const INTERP1_BASE0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000c8),
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
/// Read/write access to BASE1 register.
pub const INTERP1_BASE1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000cc),
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
/// Read/write access to BASE2 register.
pub const INTERP1_BASE2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000d0),
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
/// Read LANE0 result, and simultaneously write lane results to both accumulators (POP).
pub const INTERP1_POP_LANE0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000d4),
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
/// Read LANE1 result, and simultaneously write lane results to both accumulators (POP).
pub const INTERP1_POP_LANE1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000d8),
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
/// Read FULL result, and simultaneously write lane results to both accumulators (POP).
pub const INTERP1_POP_FULL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000dc),
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
/// Read LANE0 result, without altering any internal state (PEEK).
pub const INTERP1_PEEK_LANE0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000e0),
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
/// Read LANE1 result, without altering any internal state (PEEK).
pub const INTERP1_PEEK_LANE1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000e4),
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
/// Read FULL result, without altering any internal state (PEEK).
pub const INTERP1_PEEK_FULL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000e8),
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
/// Control register for lane 0
pub const INTERP1_CTRL_LANE0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000ec),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Only present on INTERP1 on each core. If CLAMP mode is enabled:
        /// - LANE0 result is shifted and masked ACCUM0, clamped by a lower bound of
        /// BASE0 and an upper bound of BASE1.
        /// - Signedness of these comparisons is determined by LANE0_CTRL_SIGNED
        pub fn CLAMP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        /// ORed into bits 29:28 of the lane result presented to the processor on the bus.
        /// No effect on the internal 32-bit datapath. Handy for using a lane to generate sequence
        /// of pointers into flash or SRAM.
        pub fn FORCE_MSB(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 21),
            };
        }
        /// If 1, mask + shift is bypassed for LANE0 result. This does not affect FULL result.
        pub fn ADD_RAW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        /// If 1, feed the opposite lane&#39;s result into this lane&#39;s accumulator on POP.
        pub fn CROSS_RESULT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// If 1, feed the opposite lane&#39;s accumulator into this lane&#39;s shift + mask hardware.
        /// Takes effect even if ADD_RAW is set (the CROSS_INPUT mux is before the shift+mask bypass)
        pub fn CROSS_INPUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// If SIGNED is set, the shifted and masked accumulator value is sign-extended to 32 bits
        /// before adding to BASE0, and LANE0 PEEK/POP appear extended to 32 bits when read by processor.
        pub fn SIGNED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// The most-significant bit allowed to pass by the mask (inclusive)
        /// Setting MSB &lt; LSB may cause chip to turn inside-out
        pub fn MASK_MSB(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 15),
            };
        }
        /// The least-significant bit allowed to pass by the mask (inclusive)
        pub fn MASK_LSB(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 10),
            };
        }
        /// Logical right-shift applied to accumulator before masking
        pub fn SHIFT(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 5),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn OVERF(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn OVERF1(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn OVERF0(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn CLAMP(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn FORCE_MSB(self: Result) u2 {
            const mask = comptime helpers.generateMask(19, 21);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn ADD_RAW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn CROSS_RESULT(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn CROSS_INPUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn SIGNED(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn MASK_MSB(self: Result) u5 {
            const mask = comptime helpers.generateMask(10, 15);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn MASK_LSB(self: Result) u5 {
            const mask = comptime helpers.generateMask(5, 10);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn SHIFT(self: Result) u5 {
            const mask = comptime helpers.generateMask(0, 5);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Only present on INTERP1 on each core. If CLAMP mode is enabled:
    /// - LANE0 result is shifted and masked ACCUM0, clamped by a lower bound of
    /// BASE0 and an upper bound of BASE1.
    /// - Signedness of these comparisons is determined by LANE0_CTRL_SIGNED
    pub fn CLAMP(v: u1) Value {
        return Value.CLAMP(.{}, v);
    }
    /// ORed into bits 29:28 of the lane result presented to the processor on the bus.
    /// No effect on the internal 32-bit datapath. Handy for using a lane to generate sequence
    /// of pointers into flash or SRAM.
    pub fn FORCE_MSB(v: u2) Value {
        return Value.FORCE_MSB(.{}, v);
    }
    /// If 1, mask + shift is bypassed for LANE0 result. This does not affect FULL result.
    pub fn ADD_RAW(v: u1) Value {
        return Value.ADD_RAW(.{}, v);
    }
    /// If 1, feed the opposite lane&#39;s result into this lane&#39;s accumulator on POP.
    pub fn CROSS_RESULT(v: u1) Value {
        return Value.CROSS_RESULT(.{}, v);
    }
    /// If 1, feed the opposite lane&#39;s accumulator into this lane&#39;s shift + mask hardware.
    /// Takes effect even if ADD_RAW is set (the CROSS_INPUT mux is before the shift+mask bypass)
    pub fn CROSS_INPUT(v: u1) Value {
        return Value.CROSS_INPUT(.{}, v);
    }
    /// If SIGNED is set, the shifted and masked accumulator value is sign-extended to 32 bits
    /// before adding to BASE0, and LANE0 PEEK/POP appear extended to 32 bits when read by processor.
    pub fn SIGNED(v: u1) Value {
        return Value.SIGNED(.{}, v);
    }
    /// The most-significant bit allowed to pass by the mask (inclusive)
    /// Setting MSB &lt; LSB may cause chip to turn inside-out
    pub fn MASK_MSB(v: u5) Value {
        return Value.MASK_MSB(.{}, v);
    }
    /// The least-significant bit allowed to pass by the mask (inclusive)
    pub fn MASK_LSB(v: u5) Value {
        return Value.MASK_LSB(.{}, v);
    }
    /// Logical right-shift applied to accumulator before masking
    pub fn SHIFT(v: u5) Value {
        return Value.SHIFT(.{}, v);
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
/// Control register for lane 1
pub const INTERP1_CTRL_LANE1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000f0),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// ORed into bits 29:28 of the lane result presented to the processor on the bus.
        /// No effect on the internal 32-bit datapath. Handy for using a lane to generate sequence
        /// of pointers into flash or SRAM.
        pub fn FORCE_MSB(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 21),
            };
        }
        /// If 1, mask + shift is bypassed for LANE1 result. This does not affect FULL result.
        pub fn ADD_RAW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        /// If 1, feed the opposite lane&#39;s result into this lane&#39;s accumulator on POP.
        pub fn CROSS_RESULT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// If 1, feed the opposite lane&#39;s accumulator into this lane&#39;s shift + mask hardware.
        /// Takes effect even if ADD_RAW is set (the CROSS_INPUT mux is before the shift+mask bypass)
        pub fn CROSS_INPUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// If SIGNED is set, the shifted and masked accumulator value is sign-extended to 32 bits
        /// before adding to BASE1, and LANE1 PEEK/POP appear extended to 32 bits when read by processor.
        pub fn SIGNED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// The most-significant bit allowed to pass by the mask (inclusive)
        /// Setting MSB &lt; LSB may cause chip to turn inside-out
        pub fn MASK_MSB(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 15),
            };
        }
        /// The least-significant bit allowed to pass by the mask (inclusive)
        pub fn MASK_LSB(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 10),
            };
        }
        /// Logical right-shift applied to accumulator before masking
        pub fn SHIFT(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 5),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FORCE_MSB(self: Result) u2 {
            const mask = comptime helpers.generateMask(19, 21);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn ADD_RAW(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn CROSS_RESULT(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn CROSS_INPUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn SIGNED(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn MASK_MSB(self: Result) u5 {
            const mask = comptime helpers.generateMask(10, 15);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn MASK_LSB(self: Result) u5 {
            const mask = comptime helpers.generateMask(5, 10);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn SHIFT(self: Result) u5 {
            const mask = comptime helpers.generateMask(0, 5);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// ORed into bits 29:28 of the lane result presented to the processor on the bus.
    /// No effect on the internal 32-bit datapath. Handy for using a lane to generate sequence
    /// of pointers into flash or SRAM.
    pub fn FORCE_MSB(v: u2) Value {
        return Value.FORCE_MSB(.{}, v);
    }
    /// If 1, mask + shift is bypassed for LANE1 result. This does not affect FULL result.
    pub fn ADD_RAW(v: u1) Value {
        return Value.ADD_RAW(.{}, v);
    }
    /// If 1, feed the opposite lane&#39;s result into this lane&#39;s accumulator on POP.
    pub fn CROSS_RESULT(v: u1) Value {
        return Value.CROSS_RESULT(.{}, v);
    }
    /// If 1, feed the opposite lane&#39;s accumulator into this lane&#39;s shift + mask hardware.
    /// Takes effect even if ADD_RAW is set (the CROSS_INPUT mux is before the shift+mask bypass)
    pub fn CROSS_INPUT(v: u1) Value {
        return Value.CROSS_INPUT(.{}, v);
    }
    /// If SIGNED is set, the shifted and masked accumulator value is sign-extended to 32 bits
    /// before adding to BASE1, and LANE1 PEEK/POP appear extended to 32 bits when read by processor.
    pub fn SIGNED(v: u1) Value {
        return Value.SIGNED(.{}, v);
    }
    /// The most-significant bit allowed to pass by the mask (inclusive)
    /// Setting MSB &lt; LSB may cause chip to turn inside-out
    pub fn MASK_MSB(v: u5) Value {
        return Value.MASK_MSB(.{}, v);
    }
    /// The least-significant bit allowed to pass by the mask (inclusive)
    pub fn MASK_LSB(v: u5) Value {
        return Value.MASK_LSB(.{}, v);
    }
    /// Logical right-shift applied to accumulator before masking
    pub fn SHIFT(v: u5) Value {
        return Value.SHIFT(.{}, v);
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
/// Values written here are atomically added to ACCUM0
/// Reading yields lane 0&#39;s raw shift and mask value (BASE0 not added).
pub const INTERP1_ACCUM0_ADD = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000f4),
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
/// Values written here are atomically added to ACCUM1
/// Reading yields lane 1&#39;s raw shift and mask value (BASE1 not added).
pub const INTERP1_ACCUM1_ADD = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000f8),
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
/// On write, the lower 16 bits go to BASE0, upper bits to BASE1 simultaneously.
/// Each half is sign-extended to 32 bits if that lane&#39;s SIGNED flag is set.
pub const INTERP1_BASE_1AND0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd00000fc),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000100),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000104),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000108),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd000010c),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK4 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000110),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK5 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000114),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK6 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000118),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK7 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd000011c),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK8 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000120),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK9 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000124),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK10 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000128),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK11 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd000012c),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK12 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000130),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK13 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000134),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK14 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000138),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK15 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd000013c),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK16 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000140),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK17 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000144),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK18 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000148),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK19 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd000014c),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK20 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000150),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK21 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000154),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK22 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000158),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK23 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd000015c),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK24 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000160),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK25 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000164),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK26 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000168),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK27 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd000016c),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK28 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000170),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK29 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000174),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK30 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd0000178),
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
/// Reading from a spinlock address will:
/// - Return 0 if lock is already locked
/// - Otherwise return nonzero, and simultaneously claim the lock
///
/// Writing (any value) releases the lock.
/// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
/// The value returned on success is 0x1 &lt;&lt; lock number.
pub const SPINLOCK31 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0xd000017c),
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
/// Single-cycle IO block
/// Provides core-local and inter-core hardware for the two processors, with single-cycle access.
pub const SIO_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0xd0000000),

    /// Processor core identifier
    CPUID: CPUID = .{},
    /// Input value for GPIO pins
    GPIO_IN: GPIO_IN = .{},
    /// Input value for QSPI pins
    GPIO_HI_IN: GPIO_HI_IN = .{},
    /// GPIO output value
    GPIO_OUT: GPIO_OUT = .{},
    /// GPIO output value set
    GPIO_OUT_SET: GPIO_OUT_SET = .{},
    /// GPIO output value clear
    GPIO_OUT_CLR: GPIO_OUT_CLR = .{},
    /// GPIO output value XOR
    GPIO_OUT_XOR: GPIO_OUT_XOR = .{},
    /// GPIO output enable
    GPIO_OE: GPIO_OE = .{},
    /// GPIO output enable set
    GPIO_OE_SET: GPIO_OE_SET = .{},
    /// GPIO output enable clear
    GPIO_OE_CLR: GPIO_OE_CLR = .{},
    /// GPIO output enable XOR
    GPIO_OE_XOR: GPIO_OE_XOR = .{},
    /// QSPI output value
    GPIO_HI_OUT: GPIO_HI_OUT = .{},
    /// QSPI output value set
    GPIO_HI_OUT_SET: GPIO_HI_OUT_SET = .{},
    /// QSPI output value clear
    GPIO_HI_OUT_CLR: GPIO_HI_OUT_CLR = .{},
    /// QSPI output value XOR
    GPIO_HI_OUT_XOR: GPIO_HI_OUT_XOR = .{},
    /// QSPI output enable
    GPIO_HI_OE: GPIO_HI_OE = .{},
    /// QSPI output enable set
    GPIO_HI_OE_SET: GPIO_HI_OE_SET = .{},
    /// QSPI output enable clear
    GPIO_HI_OE_CLR: GPIO_HI_OE_CLR = .{},
    /// QSPI output enable XOR
    GPIO_HI_OE_XOR: GPIO_HI_OE_XOR = .{},
    /// Status register for inter-core FIFOs (mailboxes).
    /// There is one FIFO in the core 0 -&gt; core 1 direction, and one core 1 -&gt; core 0. Both are 32 bits wide and 8 words deep.
    /// Core 0 can see the read side of the 1-&gt;0 FIFO (RX), and the write side of 0-&gt;1 FIFO (TX).
    /// Core 1 can see the read side of the 0-&gt;1 FIFO (RX), and the write side of 1-&gt;0 FIFO (TX).
    /// The SIO IRQ for each core is the logical OR of the VLD, WOF and ROE fields of its FIFO_ST register.
    FIFO_ST: FIFO_ST = .{},
    /// Write access to this core&#39;s TX FIFO
    FIFO_WR: FIFO_WR = .{},
    /// Read access to this core&#39;s RX FIFO
    FIFO_RD: FIFO_RD = .{},
    /// Spinlock state
    /// A bitmap containing the state of all 32 spinlocks (1=locked).
    /// Mainly intended for debugging.
    SPINLOCK_ST: SPINLOCK_ST = .{},
    /// Divider unsigned dividend
    /// Write to the DIVIDEND operand of the divider, i.e. the p in `p / q`.
    /// Any operand write starts a new calculation. The results appear in QUOTIENT, REMAINDER.
    /// UDIVIDEND/SDIVIDEND are aliases of the same internal register. The U alias starts an
    /// unsigned calculation, and the S alias starts a signed calculation.
    DIV_UDIVIDEND: DIV_UDIVIDEND = .{},
    /// Divider unsigned divisor
    /// Write to the DIVISOR operand of the divider, i.e. the q in `p / q`.
    /// Any operand write starts a new calculation. The results appear in QUOTIENT, REMAINDER.
    /// UDIVISOR/SDIVISOR are aliases of the same internal register. The U alias starts an
    /// unsigned calculation, and the S alias starts a signed calculation.
    DIV_UDIVISOR: DIV_UDIVISOR = .{},
    /// Divider signed dividend
    /// The same as UDIVIDEND, but starts a signed calculation, rather than unsigned.
    DIV_SDIVIDEND: DIV_SDIVIDEND = .{},
    /// Divider signed divisor
    /// The same as UDIVISOR, but starts a signed calculation, rather than unsigned.
    DIV_SDIVISOR: DIV_SDIVISOR = .{},
    /// Divider result quotient
    /// The result of `DIVIDEND / DIVISOR` (division). Contents undefined while CSR_READY is low.
    /// For signed calculations, QUOTIENT is negative when the signs of DIVIDEND and DIVISOR differ.
    /// This register can be written to directly, for context save/restore purposes. This halts any
    /// in-progress calculation and sets the CSR_READY and CSR_DIRTY flags.
    /// Reading from QUOTIENT clears the CSR_DIRTY flag, so should read results in the order
    /// REMAINDER, QUOTIENT if CSR_DIRTY is used.
    DIV_QUOTIENT: DIV_QUOTIENT = .{},
    /// Divider result remainder
    /// The result of `DIVIDEND % DIVISOR` (modulo). Contents undefined while CSR_READY is low.
    /// For signed calculations, REMAINDER is negative only when DIVIDEND is negative.
    /// This register can be written to directly, for context save/restore purposes. This halts any
    /// in-progress calculation and sets the CSR_READY and CSR_DIRTY flags.
    DIV_REMAINDER: DIV_REMAINDER = .{},
    /// Control and status register for divider.
    DIV_CSR: DIV_CSR = .{},
    /// Read/write access to accumulator 0
    INTERP0_ACCUM0: INTERP0_ACCUM0 = .{},
    /// Read/write access to accumulator 1
    INTERP0_ACCUM1: INTERP0_ACCUM1 = .{},
    /// Read/write access to BASE0 register.
    INTERP0_BASE0: INTERP0_BASE0 = .{},
    /// Read/write access to BASE1 register.
    INTERP0_BASE1: INTERP0_BASE1 = .{},
    /// Read/write access to BASE2 register.
    INTERP0_BASE2: INTERP0_BASE2 = .{},
    /// Read LANE0 result, and simultaneously write lane results to both accumulators (POP).
    INTERP0_POP_LANE0: INTERP0_POP_LANE0 = .{},
    /// Read LANE1 result, and simultaneously write lane results to both accumulators (POP).
    INTERP0_POP_LANE1: INTERP0_POP_LANE1 = .{},
    /// Read FULL result, and simultaneously write lane results to both accumulators (POP).
    INTERP0_POP_FULL: INTERP0_POP_FULL = .{},
    /// Read LANE0 result, without altering any internal state (PEEK).
    INTERP0_PEEK_LANE0: INTERP0_PEEK_LANE0 = .{},
    /// Read LANE1 result, without altering any internal state (PEEK).
    INTERP0_PEEK_LANE1: INTERP0_PEEK_LANE1 = .{},
    /// Read FULL result, without altering any internal state (PEEK).
    INTERP0_PEEK_FULL: INTERP0_PEEK_FULL = .{},
    /// Control register for lane 0
    INTERP0_CTRL_LANE0: INTERP0_CTRL_LANE0 = .{},
    /// Control register for lane 1
    INTERP0_CTRL_LANE1: INTERP0_CTRL_LANE1 = .{},
    /// Values written here are atomically added to ACCUM0
    /// Reading yields lane 0&#39;s raw shift and mask value (BASE0 not added).
    INTERP0_ACCUM0_ADD: INTERP0_ACCUM0_ADD = .{},
    /// Values written here are atomically added to ACCUM1
    /// Reading yields lane 1&#39;s raw shift and mask value (BASE1 not added).
    INTERP0_ACCUM1_ADD: INTERP0_ACCUM1_ADD = .{},
    /// On write, the lower 16 bits go to BASE0, upper bits to BASE1 simultaneously.
    /// Each half is sign-extended to 32 bits if that lane&#39;s SIGNED flag is set.
    INTERP0_BASE_1AND0: INTERP0_BASE_1AND0 = .{},
    /// Read/write access to accumulator 0
    INTERP1_ACCUM0: INTERP1_ACCUM0 = .{},
    /// Read/write access to accumulator 1
    INTERP1_ACCUM1: INTERP1_ACCUM1 = .{},
    /// Read/write access to BASE0 register.
    INTERP1_BASE0: INTERP1_BASE0 = .{},
    /// Read/write access to BASE1 register.
    INTERP1_BASE1: INTERP1_BASE1 = .{},
    /// Read/write access to BASE2 register.
    INTERP1_BASE2: INTERP1_BASE2 = .{},
    /// Read LANE0 result, and simultaneously write lane results to both accumulators (POP).
    INTERP1_POP_LANE0: INTERP1_POP_LANE0 = .{},
    /// Read LANE1 result, and simultaneously write lane results to both accumulators (POP).
    INTERP1_POP_LANE1: INTERP1_POP_LANE1 = .{},
    /// Read FULL result, and simultaneously write lane results to both accumulators (POP).
    INTERP1_POP_FULL: INTERP1_POP_FULL = .{},
    /// Read LANE0 result, without altering any internal state (PEEK).
    INTERP1_PEEK_LANE0: INTERP1_PEEK_LANE0 = .{},
    /// Read LANE1 result, without altering any internal state (PEEK).
    INTERP1_PEEK_LANE1: INTERP1_PEEK_LANE1 = .{},
    /// Read FULL result, without altering any internal state (PEEK).
    INTERP1_PEEK_FULL: INTERP1_PEEK_FULL = .{},
    /// Control register for lane 0
    INTERP1_CTRL_LANE0: INTERP1_CTRL_LANE0 = .{},
    /// Control register for lane 1
    INTERP1_CTRL_LANE1: INTERP1_CTRL_LANE1 = .{},
    /// Values written here are atomically added to ACCUM0
    /// Reading yields lane 0&#39;s raw shift and mask value (BASE0 not added).
    INTERP1_ACCUM0_ADD: INTERP1_ACCUM0_ADD = .{},
    /// Values written here are atomically added to ACCUM1
    /// Reading yields lane 1&#39;s raw shift and mask value (BASE1 not added).
    INTERP1_ACCUM1_ADD: INTERP1_ACCUM1_ADD = .{},
    /// On write, the lower 16 bits go to BASE0, upper bits to BASE1 simultaneously.
    /// Each half is sign-extended to 32 bits if that lane&#39;s SIGNED flag is set.
    INTERP1_BASE_1AND0: INTERP1_BASE_1AND0 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK0: SPINLOCK0 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK1: SPINLOCK1 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK2: SPINLOCK2 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK3: SPINLOCK3 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK4: SPINLOCK4 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK5: SPINLOCK5 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK6: SPINLOCK6 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK7: SPINLOCK7 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK8: SPINLOCK8 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK9: SPINLOCK9 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK10: SPINLOCK10 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK11: SPINLOCK11 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK12: SPINLOCK12 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK13: SPINLOCK13 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK14: SPINLOCK14 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK15: SPINLOCK15 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK16: SPINLOCK16 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK17: SPINLOCK17 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK18: SPINLOCK18 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK19: SPINLOCK19 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK20: SPINLOCK20 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK21: SPINLOCK21 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK22: SPINLOCK22 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK23: SPINLOCK23 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK24: SPINLOCK24 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK25: SPINLOCK25 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK26: SPINLOCK26 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK27: SPINLOCK27 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK28: SPINLOCK28 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK29: SPINLOCK29 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK30: SPINLOCK30 = .{},
    /// Reading from a spinlock address will:
    /// - Return 0 if lock is already locked
    /// - Otherwise return nonzero, and simultaneously claim the lock
    ///
    /// Writing (any value) releases the lock.
    /// If core 0 and core 1 attempt to claim the same lock simultaneously, core 0 wins.
    /// The value returned on success is 0x1 &lt;&lt; lock number.
    SPINLOCK31: SPINLOCK31 = .{},
};
pub const SIO = SIO_p{};
