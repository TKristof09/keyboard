const helpers = @import("helpers.zig");
/// PIO control register
pub const CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300000),
    pub const FieldMasks = struct {
        pub const CLKDIV_RESTART: u32 = helpers.generateMask(8, 12);
        pub const SM_RESTART: u32 = helpers.generateMask(4, 8);
        pub const SM_ENABLE: u32 = helpers.generateMask(0, 4);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Restart a state machine&#39;s clock divider from an initial phase of 0. Clock dividers are free-running, so once started, their output (including fractional jitter) is completely determined by the integer/fractional divisor configured in SMx_CLKDIV. This means that, if multiple clock dividers with the same divisor are restarted simultaneously, by writing multiple 1 bits to this field, the execution clocks of those state machines will run in precise lockstep.
        ///
        /// Note that setting/clearing SM_ENABLE does not stop the clock divider from running, so once multiple state machines&#39; clocks are synchronised, it is safe to disable/reenable a state machine, whilst keeping the clock dividers in sync.
        ///
        /// Note also that CLKDIV_RESTART can be written to whilst the state machine is running, and this is useful to resynchronise clock dividers after the divisors (SMx_CLKDIV) have been changed on-the-fly.
        pub fn CLKDIV_RESTART(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 12),
            };
        }
        /// Write 1 to instantly clear internal SM state which may be otherwise difficult to access and will affect future execution.
        ///
        /// Specifically, the following are cleared: input and output shift counters; the contents of the input shift register; the delay counter; the waiting-on-IRQ state; any stalled instruction written to SMx_INSTR or run by OUT/MOV EXEC; any pin write left asserted due to OUT_STICKY.
        ///
        /// The program counter, the contents of the output shift register and the X/Y scratch registers are not affected.
        pub fn SM_RESTART(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 8),
            };
        }
        /// Enable/disable each of the four state machines by writing 1/0 to each of these four bits. When disabled, a state machine will cease executing instructions, except those written directly to SMx_INSTR by the system. Multiple bits can be set/cleared at once to run/halt multiple state machines simultaneously.
        pub fn SM_ENABLE(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 4),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn SM_ENABLE(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Restart a state machine&#39;s clock divider from an initial phase of 0. Clock dividers are free-running, so once started, their output (including fractional jitter) is completely determined by the integer/fractional divisor configured in SMx_CLKDIV. This means that, if multiple clock dividers with the same divisor are restarted simultaneously, by writing multiple 1 bits to this field, the execution clocks of those state machines will run in precise lockstep.
    ///
    /// Note that setting/clearing SM_ENABLE does not stop the clock divider from running, so once multiple state machines&#39; clocks are synchronised, it is safe to disable/reenable a state machine, whilst keeping the clock dividers in sync.
    ///
    /// Note also that CLKDIV_RESTART can be written to whilst the state machine is running, and this is useful to resynchronise clock dividers after the divisors (SMx_CLKDIV) have been changed on-the-fly.
    pub fn CLKDIV_RESTART(v: u4) Value {
        return Value.CLKDIV_RESTART(.{}, v);
    }
    /// Write 1 to instantly clear internal SM state which may be otherwise difficult to access and will affect future execution.
    ///
    /// Specifically, the following are cleared: input and output shift counters; the contents of the input shift register; the delay counter; the waiting-on-IRQ state; any stalled instruction written to SMx_INSTR or run by OUT/MOV EXEC; any pin write left asserted due to OUT_STICKY.
    ///
    /// The program counter, the contents of the output shift register and the X/Y scratch registers are not affected.
    pub fn SM_RESTART(v: u4) Value {
        return Value.SM_RESTART(.{}, v);
    }
    /// Enable/disable each of the four state machines by writing 1/0 to each of these four bits. When disabled, a state machine will cease executing instructions, except those written directly to SMx_INSTR by the system. Multiple bits can be set/cleared at once to run/halt multiple state machines simultaneously.
    pub fn SM_ENABLE(v: u4) Value {
        return Value.SM_ENABLE(.{}, v);
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
/// FIFO status register
pub const FSTAT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300004),
    pub const FieldMasks = struct {
        pub const TXEMPTY: u32 = helpers.generateMask(24, 28);
        pub const TXFULL: u32 = helpers.generateMask(16, 20);
        pub const RXEMPTY: u32 = helpers.generateMask(8, 12);
        pub const RXFULL: u32 = helpers.generateMask(0, 4);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn TXEMPTY(self: Result) u4 {
            const mask = comptime helpers.generateMask(24, 28);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn TXFULL(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn RXEMPTY(self: Result) u4 {
            const mask = comptime helpers.generateMask(8, 12);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn RXFULL(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
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
/// FIFO debug register
pub const FDEBUG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300008),
    pub const FieldMasks = struct {
        pub const TXSTALL: u32 = helpers.generateMask(24, 28);
        pub const TXOVER: u32 = helpers.generateMask(16, 20);
        pub const RXUNDER: u32 = helpers.generateMask(8, 12);
        pub const RXSTALL: u32 = helpers.generateMask(0, 4);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// State machine has stalled on empty TX FIFO during a blocking PULL, or an OUT with autopull enabled. Write 1 to clear.
        pub fn TXSTALL(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 28),
            };
        }
        /// TX FIFO overflow (i.e. write-on-full by the system) has occurred. Write 1 to clear. Note that write-on-full does not alter the state or contents of the FIFO in any way, but the data that the system attempted to write is dropped, so if this flag is set, your software has quite likely dropped some data on the floor.
        pub fn TXOVER(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 20),
            };
        }
        /// RX FIFO underflow (i.e. read-on-empty by the system) has occurred. Write 1 to clear. Note that read-on-empty does not perturb the state of the FIFO in any way, but the data returned by reading from an empty FIFO is undefined, so this flag generally only becomes set due to some kind of software error.
        pub fn RXUNDER(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 12),
            };
        }
        /// State machine has stalled on full RX FIFO during a blocking PUSH, or an IN with autopush enabled. This flag is also set when a nonblocking PUSH to a full FIFO took place, in which case the state machine has dropped data. Write 1 to clear.
        pub fn RXSTALL(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 4),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn TXSTALL(self: Result) u4 {
            const mask = comptime helpers.generateMask(24, 28);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn TXOVER(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn RXUNDER(self: Result) u4 {
            const mask = comptime helpers.generateMask(8, 12);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn RXSTALL(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// State machine has stalled on empty TX FIFO during a blocking PULL, or an OUT with autopull enabled. Write 1 to clear.
    pub fn TXSTALL(v: u4) Value {
        return Value.TXSTALL(.{}, v);
    }
    /// TX FIFO overflow (i.e. write-on-full by the system) has occurred. Write 1 to clear. Note that write-on-full does not alter the state or contents of the FIFO in any way, but the data that the system attempted to write is dropped, so if this flag is set, your software has quite likely dropped some data on the floor.
    pub fn TXOVER(v: u4) Value {
        return Value.TXOVER(.{}, v);
    }
    /// RX FIFO underflow (i.e. read-on-empty by the system) has occurred. Write 1 to clear. Note that read-on-empty does not perturb the state of the FIFO in any way, but the data returned by reading from an empty FIFO is undefined, so this flag generally only becomes set due to some kind of software error.
    pub fn RXUNDER(v: u4) Value {
        return Value.RXUNDER(.{}, v);
    }
    /// State machine has stalled on full RX FIFO during a blocking PUSH, or an IN with autopush enabled. This flag is also set when a nonblocking PUSH to a full FIFO took place, in which case the state machine has dropped data. Write 1 to clear.
    pub fn RXSTALL(v: u4) Value {
        return Value.RXSTALL(.{}, v);
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
/// FIFO levels
pub const FLEVEL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5030000c),
    pub const FieldMasks = struct {
        pub const RX3: u32 = helpers.generateMask(28, 32);
        pub const TX3: u32 = helpers.generateMask(24, 28);
        pub const RX2: u32 = helpers.generateMask(20, 24);
        pub const TX2: u32 = helpers.generateMask(16, 20);
        pub const RX1: u32 = helpers.generateMask(12, 16);
        pub const TX1: u32 = helpers.generateMask(8, 12);
        pub const RX0: u32 = helpers.generateMask(4, 8);
        pub const TX0: u32 = helpers.generateMask(0, 4);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn RX3(self: Result) u4 {
            const mask = comptime helpers.generateMask(28, 32);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn TX3(self: Result) u4 {
            const mask = comptime helpers.generateMask(24, 28);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn RX2(self: Result) u4 {
            const mask = comptime helpers.generateMask(20, 24);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn TX2(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn RX1(self: Result) u4 {
            const mask = comptime helpers.generateMask(12, 16);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn TX1(self: Result) u4 {
            const mask = comptime helpers.generateMask(8, 12);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn RX0(self: Result) u4 {
            const mask = comptime helpers.generateMask(4, 8);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn TX0(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
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
/// Direct write access to the TX FIFO for this state machine. Each write pushes one word to the FIFO. Attempting to write to a full FIFO has no effect on the FIFO state or contents, and sets the sticky FDEBUG_TXOVER error flag for this FIFO.
pub const TXF0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300010),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Direct write access to the TX FIFO for this state machine. Each write pushes one word to the FIFO. Attempting to write to a full FIFO has no effect on the FIFO state or contents, and sets the sticky FDEBUG_TXOVER error flag for this FIFO.
pub const TXF1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300014),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Direct write access to the TX FIFO for this state machine. Each write pushes one word to the FIFO. Attempting to write to a full FIFO has no effect on the FIFO state or contents, and sets the sticky FDEBUG_TXOVER error flag for this FIFO.
pub const TXF2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300018),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Direct write access to the TX FIFO for this state machine. Each write pushes one word to the FIFO. Attempting to write to a full FIFO has no effect on the FIFO state or contents, and sets the sticky FDEBUG_TXOVER error flag for this FIFO.
pub const TXF3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5030001c),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Direct read access to the RX FIFO for this state machine. Each read pops one word from the FIFO. Attempting to read from an empty FIFO has no effect on the FIFO state, and sets the sticky FDEBUG_RXUNDER error flag for this FIFO. The data returned to the system on a read from an empty FIFO is undefined.
pub const RXF0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300020),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Direct read access to the RX FIFO for this state machine. Each read pops one word from the FIFO. Attempting to read from an empty FIFO has no effect on the FIFO state, and sets the sticky FDEBUG_RXUNDER error flag for this FIFO. The data returned to the system on a read from an empty FIFO is undefined.
pub const RXF1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300024),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Direct read access to the RX FIFO for this state machine. Each read pops one word from the FIFO. Attempting to read from an empty FIFO has no effect on the FIFO state, and sets the sticky FDEBUG_RXUNDER error flag for this FIFO. The data returned to the system on a read from an empty FIFO is undefined.
pub const RXF2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300028),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Direct read access to the RX FIFO for this state machine. Each read pops one word from the FIFO. Attempting to read from an empty FIFO has no effect on the FIFO state, and sets the sticky FDEBUG_RXUNDER error flag for this FIFO. The data returned to the system on a read from an empty FIFO is undefined.
pub const RXF3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5030002c),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// State machine IRQ flags register. Write 1 to clear. There are 8 state machine IRQ flags, which can be set, cleared, and waited on by the state machines. There&#39;s no fixed association between flags and state machines -- any state machine can use any flag.
///
/// Any of the 8 flags can be used for timing synchronisation between state machines, using IRQ and WAIT instructions. The lower four of these flags are also routed out to system-level interrupt requests, alongside FIFO status interrupts -- see e.g. IRQ0_INTE.
pub const IRQ = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300030),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Writing a 1 to each of these bits will forcibly assert the corresponding IRQ. Note this is different to the INTF register: writing here affects PIO internal state. INTF just asserts the processor-facing IRQ signal for testing ISRs, and is not visible to the state machines.
pub const IRQ_FORCE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300034),
    pub fn write(self: @This(), v: u8) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// There is a 2-flipflop synchronizer on each GPIO input, which protects PIO logic from metastabilities. This increases input delay, and for fast synchronous IO (e.g. SPI) these synchronizers may need to be bypassed. Each bit in this register corresponds to one GPIO.
/// 0 -&gt; input is synchronized (default)
/// 1 -&gt; synchronizer is bypassed
/// If in doubt, leave this register as all zeroes.
pub const INPUT_SYNC_BYPASS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300038),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Read to sample the pad output values PIO is currently driving to the GPIOs. On RP2040 there are 30 GPIOs, so the two most significant bits are hardwired to 0.
pub const DBG_PADOUT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5030003c),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Read to sample the pad output enables (direction) PIO is currently driving to the GPIOs. On RP2040 there are 30 GPIOs, so the two most significant bits are hardwired to 0.
pub const DBG_PADOE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300040),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// The PIO hardware has some free parameters that may vary between chip products.
/// These should be provided in the chip datasheet, but are also exposed here.
pub const DBG_CFGINFO = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300044),
    pub const FieldMasks = struct {
        pub const IMEM_SIZE: u32 = helpers.generateMask(16, 22);
        pub const SM_COUNT: u32 = helpers.generateMask(8, 12);
        pub const FIFO_DEPTH: u32 = helpers.generateMask(0, 6);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn IMEM_SIZE(self: Result) u6 {
            const mask = comptime helpers.generateMask(16, 22);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn SM_COUNT(self: Result) u4 {
            const mask = comptime helpers.generateMask(8, 12);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn FIFO_DEPTH(self: Result) u6 {
            const mask = comptime helpers.generateMask(0, 6);
            return @intCast((self.val & mask) >> 0);
        }
    };
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
/// Write-only access to instruction memory location 0
pub const INSTR_MEM0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300048),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 1
pub const INSTR_MEM1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5030004c),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 2
pub const INSTR_MEM2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300050),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 3
pub const INSTR_MEM3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300054),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 4
pub const INSTR_MEM4 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300058),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 5
pub const INSTR_MEM5 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5030005c),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 6
pub const INSTR_MEM6 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300060),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 7
pub const INSTR_MEM7 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300064),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 8
pub const INSTR_MEM8 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300068),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 9
pub const INSTR_MEM9 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5030006c),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 10
pub const INSTR_MEM10 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300070),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 11
pub const INSTR_MEM11 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300074),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 12
pub const INSTR_MEM12 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300078),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 13
pub const INSTR_MEM13 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5030007c),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 14
pub const INSTR_MEM14 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300080),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 15
pub const INSTR_MEM15 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300084),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 16
pub const INSTR_MEM16 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300088),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 17
pub const INSTR_MEM17 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5030008c),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 18
pub const INSTR_MEM18 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300090),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 19
pub const INSTR_MEM19 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300094),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 20
pub const INSTR_MEM20 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300098),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 21
pub const INSTR_MEM21 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5030009c),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 22
pub const INSTR_MEM22 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000a0),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 23
pub const INSTR_MEM23 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000a4),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 24
pub const INSTR_MEM24 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000a8),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 25
pub const INSTR_MEM25 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000ac),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 26
pub const INSTR_MEM26 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000b0),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 27
pub const INSTR_MEM27 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000b4),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 28
pub const INSTR_MEM28 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000b8),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 29
pub const INSTR_MEM29 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000bc),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 30
pub const INSTR_MEM30 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000c0),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Write-only access to instruction memory location 31
pub const INSTR_MEM31 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000c4),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Clock divisor register for state machine 0
/// Frequency = clock freq / (CLKDIV_INT + CLKDIV_FRAC / 256)
pub const SM0_CLKDIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000c8),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(16, 32);
        pub const FRAC: u32 = helpers.generateMask(8, 16);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Effective frequency is sysclk/(int + frac/256).
        /// Value of 0 is interpreted as 65536. If INT is 0, FRAC must also be 0.
        pub fn INT(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        /// Fractional part of clock divisor
        pub fn FRAC(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FRAC(self: Result) u8 {
            const mask = comptime helpers.generateMask(8, 16);
            return @intCast((self.val & mask) >> 8);
        }
    };
    /// Effective frequency is sysclk/(int + frac/256).
    /// Value of 0 is interpreted as 65536. If INT is 0, FRAC must also be 0.
    pub fn INT(v: u16) Value {
        return Value.INT(.{}, v);
    }
    /// Fractional part of clock divisor
    pub fn FRAC(v: u8) Value {
        return Value.FRAC(.{}, v);
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
/// Execution/behavioural settings for state machine 0
pub const SM0_EXECCTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000cc),
    pub const FieldMasks = struct {
        pub const EXEC_STALLED: u32 = helpers.generateMask(31, 32);
        pub const SIDE_EN: u32 = helpers.generateMask(30, 31);
        pub const SIDE_PINDIR: u32 = helpers.generateMask(29, 30);
        pub const JMP_PIN: u32 = helpers.generateMask(24, 29);
        pub const OUT_EN_SEL: u32 = helpers.generateMask(19, 24);
        pub const INLINE_OUT_EN: u32 = helpers.generateMask(18, 19);
        pub const OUT_STICKY: u32 = helpers.generateMask(17, 18);
        pub const WRAP_TOP: u32 = helpers.generateMask(12, 17);
        pub const WRAP_BOTTOM: u32 = helpers.generateMask(7, 12);
        pub const STATUS_SEL: u32 = helpers.generateMask(4, 5);
        pub const STATUS_N: u32 = helpers.generateMask(0, 4);
    };
    const STATUS_SEL_e = enum(u1) {
        TXLEVEL = 0,
        RXLEVEL = 1,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If 1, the MSB of the Delay/Side-set instruction field is used as side-set enable, rather than a side-set data bit. This allows instructions to perform side-set optionally, rather than on every instruction, but the maximum possible side-set width is reduced from 5 to 4. Note that the value of PINCTRL_SIDESET_COUNT is inclusive of this enable bit.
        pub fn SIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// If 1, side-set data is asserted to pin directions, instead of pin values
        pub fn SIDE_PINDIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The GPIO number to use as condition for JMP PIN. Unaffected by input mapping.
        pub fn JMP_PIN(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 29),
            };
        }
        /// Which data bit to use for inline OUT enable
        pub fn OUT_EN_SEL(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 24),
            };
        }
        /// If 1, use a bit of OUT data as an auxiliary write enable
        /// When used in conjunction with OUT_STICKY, writes with an enable of 0 will
        /// deassert the latest pin write. This can create useful masking/override behaviour
        /// due to the priority ordering of state machine pin writes (SM0 &lt; SM1 &lt; ...)
        pub fn INLINE_OUT_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        /// Continuously assert the most recent OUT/SET to the pins
        pub fn OUT_STICKY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// After reaching this address, execution is wrapped to wrap_bottom.
        /// If the instruction is a jump, and the jump condition is true, the jump takes priority.
        pub fn WRAP_TOP(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 17),
            };
        }
        /// After reaching wrap_top, execution is wrapped to this address.
        pub fn WRAP_BOTTOM(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 12),
            };
        }
        /// Comparison used for the MOV x, STATUS instruction.
        pub fn STATUS_SEL(self: Value, v: STATUS_SEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Comparison level for the MOV x, STATUS instruction
        pub fn STATUS_N(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 4),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn EXEC_STALLED(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn SIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn SIDE_PINDIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn JMP_PIN(self: Result) u5 {
            const mask = comptime helpers.generateMask(24, 29);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn OUT_EN_SEL(self: Result) u5 {
            const mask = comptime helpers.generateMask(19, 24);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn INLINE_OUT_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn OUT_STICKY(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn WRAP_TOP(self: Result) u5 {
            const mask = comptime helpers.generateMask(12, 17);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn WRAP_BOTTOM(self: Result) u5 {
            const mask = comptime helpers.generateMask(7, 12);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn STATUS_SEL(self: Result) STATUS_SEL_e {
            const mask = comptime helpers.generateMask(4, 5);
            const val: @typeInfo(STATUS_SEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn STATUS_N(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If 1, the MSB of the Delay/Side-set instruction field is used as side-set enable, rather than a side-set data bit. This allows instructions to perform side-set optionally, rather than on every instruction, but the maximum possible side-set width is reduced from 5 to 4. Note that the value of PINCTRL_SIDESET_COUNT is inclusive of this enable bit.
    pub fn SIDE_EN(v: u1) Value {
        return Value.SIDE_EN(.{}, v);
    }
    /// If 1, side-set data is asserted to pin directions, instead of pin values
    pub fn SIDE_PINDIR(v: u1) Value {
        return Value.SIDE_PINDIR(.{}, v);
    }
    /// The GPIO number to use as condition for JMP PIN. Unaffected by input mapping.
    pub fn JMP_PIN(v: u5) Value {
        return Value.JMP_PIN(.{}, v);
    }
    /// Which data bit to use for inline OUT enable
    pub fn OUT_EN_SEL(v: u5) Value {
        return Value.OUT_EN_SEL(.{}, v);
    }
    /// If 1, use a bit of OUT data as an auxiliary write enable
    /// When used in conjunction with OUT_STICKY, writes with an enable of 0 will
    /// deassert the latest pin write. This can create useful masking/override behaviour
    /// due to the priority ordering of state machine pin writes (SM0 &lt; SM1 &lt; ...)
    pub fn INLINE_OUT_EN(v: u1) Value {
        return Value.INLINE_OUT_EN(.{}, v);
    }
    /// Continuously assert the most recent OUT/SET to the pins
    pub fn OUT_STICKY(v: u1) Value {
        return Value.OUT_STICKY(.{}, v);
    }
    /// After reaching this address, execution is wrapped to wrap_bottom.
    /// If the instruction is a jump, and the jump condition is true, the jump takes priority.
    pub fn WRAP_TOP(v: u5) Value {
        return Value.WRAP_TOP(.{}, v);
    }
    /// After reaching wrap_top, execution is wrapped to this address.
    pub fn WRAP_BOTTOM(v: u5) Value {
        return Value.WRAP_BOTTOM(.{}, v);
    }
    /// Comparison used for the MOV x, STATUS instruction.
    pub fn STATUS_SEL(v: STATUS_SEL_e) Value {
        return Value.STATUS_SEL(.{}, v);
    }
    /// Comparison level for the MOV x, STATUS instruction
    pub fn STATUS_N(v: u4) Value {
        return Value.STATUS_N(.{}, v);
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
/// Control behaviour of the input/output shift registers for state machine 0
pub const SM0_SHIFTCTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000d0),
    pub const FieldMasks = struct {
        pub const FJOIN_RX: u32 = helpers.generateMask(31, 32);
        pub const FJOIN_TX: u32 = helpers.generateMask(30, 31);
        pub const PULL_THRESH: u32 = helpers.generateMask(25, 30);
        pub const PUSH_THRESH: u32 = helpers.generateMask(20, 25);
        pub const OUT_SHIFTDIR: u32 = helpers.generateMask(19, 20);
        pub const IN_SHIFTDIR: u32 = helpers.generateMask(18, 19);
        pub const AUTOPULL: u32 = helpers.generateMask(17, 18);
        pub const AUTOPUSH: u32 = helpers.generateMask(16, 17);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// When 1, RX FIFO steals the TX FIFO&#39;s storage, and becomes twice as deep.
        /// TX FIFO is disabled as a result (always reads as both full and empty).
        /// FIFOs are flushed when this bit is changed.
        pub fn FJOIN_RX(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// When 1, TX FIFO steals the RX FIFO&#39;s storage, and becomes twice as deep.
        /// RX FIFO is disabled as a result (always reads as both full and empty).
        /// FIFOs are flushed when this bit is changed.
        pub fn FJOIN_TX(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Number of bits shifted out of OSR before autopull, or conditional pull (PULL IFEMPTY), will take place.
        /// Write 0 for value of 32.
        pub fn PULL_THRESH(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 30),
            };
        }
        /// Number of bits shifted into ISR before autopush, or conditional push (PUSH IFFULL), will take place.
        /// Write 0 for value of 32.
        pub fn PUSH_THRESH(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 25),
            };
        }
        /// 1 = shift out of output shift register to right. 0 = to left.
        pub fn OUT_SHIFTDIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        /// 1 = shift input shift register to right (data enters from left). 0 = to left.
        pub fn IN_SHIFTDIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        /// Pull automatically when the output shift register is emptied, i.e. on or following an OUT instruction which causes the output shift counter to reach or exceed PULL_THRESH.
        pub fn AUTOPULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Push automatically when the input shift register is filled, i.e. on an IN instruction which causes the input shift counter to reach or exceed PUSH_THRESH.
        pub fn AUTOPUSH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FJOIN_RX(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn FJOIN_TX(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PULL_THRESH(self: Result) u5 {
            const mask = comptime helpers.generateMask(25, 30);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn PUSH_THRESH(self: Result) u5 {
            const mask = comptime helpers.generateMask(20, 25);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn OUT_SHIFTDIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn IN_SHIFTDIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn AUTOPULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn AUTOPUSH(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
    };
    /// When 1, RX FIFO steals the TX FIFO&#39;s storage, and becomes twice as deep.
    /// TX FIFO is disabled as a result (always reads as both full and empty).
    /// FIFOs are flushed when this bit is changed.
    pub fn FJOIN_RX(v: u1) Value {
        return Value.FJOIN_RX(.{}, v);
    }
    /// When 1, TX FIFO steals the RX FIFO&#39;s storage, and becomes twice as deep.
    /// RX FIFO is disabled as a result (always reads as both full and empty).
    /// FIFOs are flushed when this bit is changed.
    pub fn FJOIN_TX(v: u1) Value {
        return Value.FJOIN_TX(.{}, v);
    }
    /// Number of bits shifted out of OSR before autopull, or conditional pull (PULL IFEMPTY), will take place.
    /// Write 0 for value of 32.
    pub fn PULL_THRESH(v: u5) Value {
        return Value.PULL_THRESH(.{}, v);
    }
    /// Number of bits shifted into ISR before autopush, or conditional push (PUSH IFFULL), will take place.
    /// Write 0 for value of 32.
    pub fn PUSH_THRESH(v: u5) Value {
        return Value.PUSH_THRESH(.{}, v);
    }
    /// 1 = shift out of output shift register to right. 0 = to left.
    pub fn OUT_SHIFTDIR(v: u1) Value {
        return Value.OUT_SHIFTDIR(.{}, v);
    }
    /// 1 = shift input shift register to right (data enters from left). 0 = to left.
    pub fn IN_SHIFTDIR(v: u1) Value {
        return Value.IN_SHIFTDIR(.{}, v);
    }
    /// Pull automatically when the output shift register is emptied, i.e. on or following an OUT instruction which causes the output shift counter to reach or exceed PULL_THRESH.
    pub fn AUTOPULL(v: u1) Value {
        return Value.AUTOPULL(.{}, v);
    }
    /// Push automatically when the input shift register is filled, i.e. on an IN instruction which causes the input shift counter to reach or exceed PUSH_THRESH.
    pub fn AUTOPUSH(v: u1) Value {
        return Value.AUTOPUSH(.{}, v);
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
/// Current instruction address of state machine 0
pub const SM0_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000d4),
    pub fn write(self: @This(), v: u5) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u5 {
        const mask = comptime helpers.generateMask(0, 5);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read to see the instruction currently addressed by state machine 0&#39;s program counter
/// Write to execute an instruction immediately (including jumps) and then resume execution.
pub const SM0_INSTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000d8),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// State machine pin control
pub const SM0_PINCTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000dc),
    pub const FieldMasks = struct {
        pub const SIDESET_COUNT: u32 = helpers.generateMask(29, 32);
        pub const SET_COUNT: u32 = helpers.generateMask(26, 29);
        pub const OUT_COUNT: u32 = helpers.generateMask(20, 26);
        pub const IN_BASE: u32 = helpers.generateMask(15, 20);
        pub const SIDESET_BASE: u32 = helpers.generateMask(10, 15);
        pub const SET_BASE: u32 = helpers.generateMask(5, 10);
        pub const OUT_BASE: u32 = helpers.generateMask(0, 5);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// The number of MSBs of the Delay/Side-set instruction field which are used for side-set. Inclusive of the enable bit, if present. Minimum of 0 (all delay bits, no side-set) and maximum of 5 (all side-set, no delay).
        pub fn SIDESET_COUNT(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 32),
            };
        }
        /// The number of pins asserted by a SET. In the range 0 to 5 inclusive.
        pub fn SET_COUNT(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 29),
            };
        }
        /// The number of pins asserted by an OUT PINS, OUT PINDIRS or MOV PINS instruction. In the range 0 to 32 inclusive.
        pub fn OUT_COUNT(self: Value, v: u6) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 26),
            };
        }
        /// The pin which is mapped to the least-significant bit of a state machine&#39;s IN data bus. Higher-numbered pins are mapped to consecutively more-significant data bits, with a modulo of 32 applied to pin number.
        pub fn IN_BASE(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 20),
            };
        }
        /// The lowest-numbered pin that will be affected by a side-set operation. The MSBs of an instruction&#39;s side-set/delay field (up to 5, determined by SIDESET_COUNT) are used for side-set data, with the remaining LSBs used for delay. The least-significant bit of the side-set portion is the bit written to this pin, with more-significant bits written to higher-numbered pins.
        pub fn SIDESET_BASE(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 15),
            };
        }
        /// The lowest-numbered pin that will be affected by a SET PINS or SET PINDIRS instruction. The data written to this pin is the least-significant bit of the SET data.
        pub fn SET_BASE(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 10),
            };
        }
        /// The lowest-numbered pin that will be affected by an OUT PINS, OUT PINDIRS or MOV PINS instruction. The data written to this pin will always be the least-significant bit of the OUT or MOV data.
        pub fn OUT_BASE(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 5),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn SIDESET_COUNT(self: Result) u3 {
            const mask = comptime helpers.generateMask(29, 32);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn SET_COUNT(self: Result) u3 {
            const mask = comptime helpers.generateMask(26, 29);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn OUT_COUNT(self: Result) u6 {
            const mask = comptime helpers.generateMask(20, 26);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn IN_BASE(self: Result) u5 {
            const mask = comptime helpers.generateMask(15, 20);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn SIDESET_BASE(self: Result) u5 {
            const mask = comptime helpers.generateMask(10, 15);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn SET_BASE(self: Result) u5 {
            const mask = comptime helpers.generateMask(5, 10);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn OUT_BASE(self: Result) u5 {
            const mask = comptime helpers.generateMask(0, 5);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// The number of MSBs of the Delay/Side-set instruction field which are used for side-set. Inclusive of the enable bit, if present. Minimum of 0 (all delay bits, no side-set) and maximum of 5 (all side-set, no delay).
    pub fn SIDESET_COUNT(v: u3) Value {
        return Value.SIDESET_COUNT(.{}, v);
    }
    /// The number of pins asserted by a SET. In the range 0 to 5 inclusive.
    pub fn SET_COUNT(v: u3) Value {
        return Value.SET_COUNT(.{}, v);
    }
    /// The number of pins asserted by an OUT PINS, OUT PINDIRS or MOV PINS instruction. In the range 0 to 32 inclusive.
    pub fn OUT_COUNT(v: u6) Value {
        return Value.OUT_COUNT(.{}, v);
    }
    /// The pin which is mapped to the least-significant bit of a state machine&#39;s IN data bus. Higher-numbered pins are mapped to consecutively more-significant data bits, with a modulo of 32 applied to pin number.
    pub fn IN_BASE(v: u5) Value {
        return Value.IN_BASE(.{}, v);
    }
    /// The lowest-numbered pin that will be affected by a side-set operation. The MSBs of an instruction&#39;s side-set/delay field (up to 5, determined by SIDESET_COUNT) are used for side-set data, with the remaining LSBs used for delay. The least-significant bit of the side-set portion is the bit written to this pin, with more-significant bits written to higher-numbered pins.
    pub fn SIDESET_BASE(v: u5) Value {
        return Value.SIDESET_BASE(.{}, v);
    }
    /// The lowest-numbered pin that will be affected by a SET PINS or SET PINDIRS instruction. The data written to this pin is the least-significant bit of the SET data.
    pub fn SET_BASE(v: u5) Value {
        return Value.SET_BASE(.{}, v);
    }
    /// The lowest-numbered pin that will be affected by an OUT PINS, OUT PINDIRS or MOV PINS instruction. The data written to this pin will always be the least-significant bit of the OUT or MOV data.
    pub fn OUT_BASE(v: u5) Value {
        return Value.OUT_BASE(.{}, v);
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
/// Clock divisor register for state machine 1
/// Frequency = clock freq / (CLKDIV_INT + CLKDIV_FRAC / 256)
pub const SM1_CLKDIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000e0),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(16, 32);
        pub const FRAC: u32 = helpers.generateMask(8, 16);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Effective frequency is sysclk/(int + frac/256).
        /// Value of 0 is interpreted as 65536. If INT is 0, FRAC must also be 0.
        pub fn INT(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        /// Fractional part of clock divisor
        pub fn FRAC(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FRAC(self: Result) u8 {
            const mask = comptime helpers.generateMask(8, 16);
            return @intCast((self.val & mask) >> 8);
        }
    };
    /// Effective frequency is sysclk/(int + frac/256).
    /// Value of 0 is interpreted as 65536. If INT is 0, FRAC must also be 0.
    pub fn INT(v: u16) Value {
        return Value.INT(.{}, v);
    }
    /// Fractional part of clock divisor
    pub fn FRAC(v: u8) Value {
        return Value.FRAC(.{}, v);
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
/// Execution/behavioural settings for state machine 1
pub const SM1_EXECCTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000e4),
    pub const FieldMasks = struct {
        pub const EXEC_STALLED: u32 = helpers.generateMask(31, 32);
        pub const SIDE_EN: u32 = helpers.generateMask(30, 31);
        pub const SIDE_PINDIR: u32 = helpers.generateMask(29, 30);
        pub const JMP_PIN: u32 = helpers.generateMask(24, 29);
        pub const OUT_EN_SEL: u32 = helpers.generateMask(19, 24);
        pub const INLINE_OUT_EN: u32 = helpers.generateMask(18, 19);
        pub const OUT_STICKY: u32 = helpers.generateMask(17, 18);
        pub const WRAP_TOP: u32 = helpers.generateMask(12, 17);
        pub const WRAP_BOTTOM: u32 = helpers.generateMask(7, 12);
        pub const STATUS_SEL: u32 = helpers.generateMask(4, 5);
        pub const STATUS_N: u32 = helpers.generateMask(0, 4);
    };
    const STATUS_SEL_e = enum(u1) {
        TXLEVEL = 0,
        RXLEVEL = 1,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If 1, the MSB of the Delay/Side-set instruction field is used as side-set enable, rather than a side-set data bit. This allows instructions to perform side-set optionally, rather than on every instruction, but the maximum possible side-set width is reduced from 5 to 4. Note that the value of PINCTRL_SIDESET_COUNT is inclusive of this enable bit.
        pub fn SIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// If 1, side-set data is asserted to pin directions, instead of pin values
        pub fn SIDE_PINDIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The GPIO number to use as condition for JMP PIN. Unaffected by input mapping.
        pub fn JMP_PIN(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 29),
            };
        }
        /// Which data bit to use for inline OUT enable
        pub fn OUT_EN_SEL(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 24),
            };
        }
        /// If 1, use a bit of OUT data as an auxiliary write enable
        /// When used in conjunction with OUT_STICKY, writes with an enable of 0 will
        /// deassert the latest pin write. This can create useful masking/override behaviour
        /// due to the priority ordering of state machine pin writes (SM0 &lt; SM1 &lt; ...)
        pub fn INLINE_OUT_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        /// Continuously assert the most recent OUT/SET to the pins
        pub fn OUT_STICKY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// After reaching this address, execution is wrapped to wrap_bottom.
        /// If the instruction is a jump, and the jump condition is true, the jump takes priority.
        pub fn WRAP_TOP(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 17),
            };
        }
        /// After reaching wrap_top, execution is wrapped to this address.
        pub fn WRAP_BOTTOM(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 12),
            };
        }
        /// Comparison used for the MOV x, STATUS instruction.
        pub fn STATUS_SEL(self: Value, v: STATUS_SEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Comparison level for the MOV x, STATUS instruction
        pub fn STATUS_N(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 4),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn EXEC_STALLED(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn SIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn SIDE_PINDIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn JMP_PIN(self: Result) u5 {
            const mask = comptime helpers.generateMask(24, 29);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn OUT_EN_SEL(self: Result) u5 {
            const mask = comptime helpers.generateMask(19, 24);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn INLINE_OUT_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn OUT_STICKY(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn WRAP_TOP(self: Result) u5 {
            const mask = comptime helpers.generateMask(12, 17);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn WRAP_BOTTOM(self: Result) u5 {
            const mask = comptime helpers.generateMask(7, 12);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn STATUS_SEL(self: Result) STATUS_SEL_e {
            const mask = comptime helpers.generateMask(4, 5);
            const val: @typeInfo(STATUS_SEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn STATUS_N(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If 1, the MSB of the Delay/Side-set instruction field is used as side-set enable, rather than a side-set data bit. This allows instructions to perform side-set optionally, rather than on every instruction, but the maximum possible side-set width is reduced from 5 to 4. Note that the value of PINCTRL_SIDESET_COUNT is inclusive of this enable bit.
    pub fn SIDE_EN(v: u1) Value {
        return Value.SIDE_EN(.{}, v);
    }
    /// If 1, side-set data is asserted to pin directions, instead of pin values
    pub fn SIDE_PINDIR(v: u1) Value {
        return Value.SIDE_PINDIR(.{}, v);
    }
    /// The GPIO number to use as condition for JMP PIN. Unaffected by input mapping.
    pub fn JMP_PIN(v: u5) Value {
        return Value.JMP_PIN(.{}, v);
    }
    /// Which data bit to use for inline OUT enable
    pub fn OUT_EN_SEL(v: u5) Value {
        return Value.OUT_EN_SEL(.{}, v);
    }
    /// If 1, use a bit of OUT data as an auxiliary write enable
    /// When used in conjunction with OUT_STICKY, writes with an enable of 0 will
    /// deassert the latest pin write. This can create useful masking/override behaviour
    /// due to the priority ordering of state machine pin writes (SM0 &lt; SM1 &lt; ...)
    pub fn INLINE_OUT_EN(v: u1) Value {
        return Value.INLINE_OUT_EN(.{}, v);
    }
    /// Continuously assert the most recent OUT/SET to the pins
    pub fn OUT_STICKY(v: u1) Value {
        return Value.OUT_STICKY(.{}, v);
    }
    /// After reaching this address, execution is wrapped to wrap_bottom.
    /// If the instruction is a jump, and the jump condition is true, the jump takes priority.
    pub fn WRAP_TOP(v: u5) Value {
        return Value.WRAP_TOP(.{}, v);
    }
    /// After reaching wrap_top, execution is wrapped to this address.
    pub fn WRAP_BOTTOM(v: u5) Value {
        return Value.WRAP_BOTTOM(.{}, v);
    }
    /// Comparison used for the MOV x, STATUS instruction.
    pub fn STATUS_SEL(v: STATUS_SEL_e) Value {
        return Value.STATUS_SEL(.{}, v);
    }
    /// Comparison level for the MOV x, STATUS instruction
    pub fn STATUS_N(v: u4) Value {
        return Value.STATUS_N(.{}, v);
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
/// Control behaviour of the input/output shift registers for state machine 1
pub const SM1_SHIFTCTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000e8),
    pub const FieldMasks = struct {
        pub const FJOIN_RX: u32 = helpers.generateMask(31, 32);
        pub const FJOIN_TX: u32 = helpers.generateMask(30, 31);
        pub const PULL_THRESH: u32 = helpers.generateMask(25, 30);
        pub const PUSH_THRESH: u32 = helpers.generateMask(20, 25);
        pub const OUT_SHIFTDIR: u32 = helpers.generateMask(19, 20);
        pub const IN_SHIFTDIR: u32 = helpers.generateMask(18, 19);
        pub const AUTOPULL: u32 = helpers.generateMask(17, 18);
        pub const AUTOPUSH: u32 = helpers.generateMask(16, 17);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// When 1, RX FIFO steals the TX FIFO&#39;s storage, and becomes twice as deep.
        /// TX FIFO is disabled as a result (always reads as both full and empty).
        /// FIFOs are flushed when this bit is changed.
        pub fn FJOIN_RX(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// When 1, TX FIFO steals the RX FIFO&#39;s storage, and becomes twice as deep.
        /// RX FIFO is disabled as a result (always reads as both full and empty).
        /// FIFOs are flushed when this bit is changed.
        pub fn FJOIN_TX(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Number of bits shifted out of OSR before autopull, or conditional pull (PULL IFEMPTY), will take place.
        /// Write 0 for value of 32.
        pub fn PULL_THRESH(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 30),
            };
        }
        /// Number of bits shifted into ISR before autopush, or conditional push (PUSH IFFULL), will take place.
        /// Write 0 for value of 32.
        pub fn PUSH_THRESH(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 25),
            };
        }
        /// 1 = shift out of output shift register to right. 0 = to left.
        pub fn OUT_SHIFTDIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        /// 1 = shift input shift register to right (data enters from left). 0 = to left.
        pub fn IN_SHIFTDIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        /// Pull automatically when the output shift register is emptied, i.e. on or following an OUT instruction which causes the output shift counter to reach or exceed PULL_THRESH.
        pub fn AUTOPULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Push automatically when the input shift register is filled, i.e. on an IN instruction which causes the input shift counter to reach or exceed PUSH_THRESH.
        pub fn AUTOPUSH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FJOIN_RX(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn FJOIN_TX(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PULL_THRESH(self: Result) u5 {
            const mask = comptime helpers.generateMask(25, 30);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn PUSH_THRESH(self: Result) u5 {
            const mask = comptime helpers.generateMask(20, 25);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn OUT_SHIFTDIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn IN_SHIFTDIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn AUTOPULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn AUTOPUSH(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
    };
    /// When 1, RX FIFO steals the TX FIFO&#39;s storage, and becomes twice as deep.
    /// TX FIFO is disabled as a result (always reads as both full and empty).
    /// FIFOs are flushed when this bit is changed.
    pub fn FJOIN_RX(v: u1) Value {
        return Value.FJOIN_RX(.{}, v);
    }
    /// When 1, TX FIFO steals the RX FIFO&#39;s storage, and becomes twice as deep.
    /// RX FIFO is disabled as a result (always reads as both full and empty).
    /// FIFOs are flushed when this bit is changed.
    pub fn FJOIN_TX(v: u1) Value {
        return Value.FJOIN_TX(.{}, v);
    }
    /// Number of bits shifted out of OSR before autopull, or conditional pull (PULL IFEMPTY), will take place.
    /// Write 0 for value of 32.
    pub fn PULL_THRESH(v: u5) Value {
        return Value.PULL_THRESH(.{}, v);
    }
    /// Number of bits shifted into ISR before autopush, or conditional push (PUSH IFFULL), will take place.
    /// Write 0 for value of 32.
    pub fn PUSH_THRESH(v: u5) Value {
        return Value.PUSH_THRESH(.{}, v);
    }
    /// 1 = shift out of output shift register to right. 0 = to left.
    pub fn OUT_SHIFTDIR(v: u1) Value {
        return Value.OUT_SHIFTDIR(.{}, v);
    }
    /// 1 = shift input shift register to right (data enters from left). 0 = to left.
    pub fn IN_SHIFTDIR(v: u1) Value {
        return Value.IN_SHIFTDIR(.{}, v);
    }
    /// Pull automatically when the output shift register is emptied, i.e. on or following an OUT instruction which causes the output shift counter to reach or exceed PULL_THRESH.
    pub fn AUTOPULL(v: u1) Value {
        return Value.AUTOPULL(.{}, v);
    }
    /// Push automatically when the input shift register is filled, i.e. on an IN instruction which causes the input shift counter to reach or exceed PUSH_THRESH.
    pub fn AUTOPUSH(v: u1) Value {
        return Value.AUTOPUSH(.{}, v);
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
/// Current instruction address of state machine 1
pub const SM1_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000ec),
    pub fn write(self: @This(), v: u5) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u5 {
        const mask = comptime helpers.generateMask(0, 5);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read to see the instruction currently addressed by state machine 1&#39;s program counter
/// Write to execute an instruction immediately (including jumps) and then resume execution.
pub const SM1_INSTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000f0),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// State machine pin control
pub const SM1_PINCTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000f4),
    pub const FieldMasks = struct {
        pub const SIDESET_COUNT: u32 = helpers.generateMask(29, 32);
        pub const SET_COUNT: u32 = helpers.generateMask(26, 29);
        pub const OUT_COUNT: u32 = helpers.generateMask(20, 26);
        pub const IN_BASE: u32 = helpers.generateMask(15, 20);
        pub const SIDESET_BASE: u32 = helpers.generateMask(10, 15);
        pub const SET_BASE: u32 = helpers.generateMask(5, 10);
        pub const OUT_BASE: u32 = helpers.generateMask(0, 5);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// The number of MSBs of the Delay/Side-set instruction field which are used for side-set. Inclusive of the enable bit, if present. Minimum of 0 (all delay bits, no side-set) and maximum of 5 (all side-set, no delay).
        pub fn SIDESET_COUNT(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 32),
            };
        }
        /// The number of pins asserted by a SET. In the range 0 to 5 inclusive.
        pub fn SET_COUNT(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 29),
            };
        }
        /// The number of pins asserted by an OUT PINS, OUT PINDIRS or MOV PINS instruction. In the range 0 to 32 inclusive.
        pub fn OUT_COUNT(self: Value, v: u6) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 26),
            };
        }
        /// The pin which is mapped to the least-significant bit of a state machine&#39;s IN data bus. Higher-numbered pins are mapped to consecutively more-significant data bits, with a modulo of 32 applied to pin number.
        pub fn IN_BASE(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 20),
            };
        }
        /// The lowest-numbered pin that will be affected by a side-set operation. The MSBs of an instruction&#39;s side-set/delay field (up to 5, determined by SIDESET_COUNT) are used for side-set data, with the remaining LSBs used for delay. The least-significant bit of the side-set portion is the bit written to this pin, with more-significant bits written to higher-numbered pins.
        pub fn SIDESET_BASE(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 15),
            };
        }
        /// The lowest-numbered pin that will be affected by a SET PINS or SET PINDIRS instruction. The data written to this pin is the least-significant bit of the SET data.
        pub fn SET_BASE(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 10),
            };
        }
        /// The lowest-numbered pin that will be affected by an OUT PINS, OUT PINDIRS or MOV PINS instruction. The data written to this pin will always be the least-significant bit of the OUT or MOV data.
        pub fn OUT_BASE(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 5),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn SIDESET_COUNT(self: Result) u3 {
            const mask = comptime helpers.generateMask(29, 32);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn SET_COUNT(self: Result) u3 {
            const mask = comptime helpers.generateMask(26, 29);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn OUT_COUNT(self: Result) u6 {
            const mask = comptime helpers.generateMask(20, 26);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn IN_BASE(self: Result) u5 {
            const mask = comptime helpers.generateMask(15, 20);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn SIDESET_BASE(self: Result) u5 {
            const mask = comptime helpers.generateMask(10, 15);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn SET_BASE(self: Result) u5 {
            const mask = comptime helpers.generateMask(5, 10);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn OUT_BASE(self: Result) u5 {
            const mask = comptime helpers.generateMask(0, 5);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// The number of MSBs of the Delay/Side-set instruction field which are used for side-set. Inclusive of the enable bit, if present. Minimum of 0 (all delay bits, no side-set) and maximum of 5 (all side-set, no delay).
    pub fn SIDESET_COUNT(v: u3) Value {
        return Value.SIDESET_COUNT(.{}, v);
    }
    /// The number of pins asserted by a SET. In the range 0 to 5 inclusive.
    pub fn SET_COUNT(v: u3) Value {
        return Value.SET_COUNT(.{}, v);
    }
    /// The number of pins asserted by an OUT PINS, OUT PINDIRS or MOV PINS instruction. In the range 0 to 32 inclusive.
    pub fn OUT_COUNT(v: u6) Value {
        return Value.OUT_COUNT(.{}, v);
    }
    /// The pin which is mapped to the least-significant bit of a state machine&#39;s IN data bus. Higher-numbered pins are mapped to consecutively more-significant data bits, with a modulo of 32 applied to pin number.
    pub fn IN_BASE(v: u5) Value {
        return Value.IN_BASE(.{}, v);
    }
    /// The lowest-numbered pin that will be affected by a side-set operation. The MSBs of an instruction&#39;s side-set/delay field (up to 5, determined by SIDESET_COUNT) are used for side-set data, with the remaining LSBs used for delay. The least-significant bit of the side-set portion is the bit written to this pin, with more-significant bits written to higher-numbered pins.
    pub fn SIDESET_BASE(v: u5) Value {
        return Value.SIDESET_BASE(.{}, v);
    }
    /// The lowest-numbered pin that will be affected by a SET PINS or SET PINDIRS instruction. The data written to this pin is the least-significant bit of the SET data.
    pub fn SET_BASE(v: u5) Value {
        return Value.SET_BASE(.{}, v);
    }
    /// The lowest-numbered pin that will be affected by an OUT PINS, OUT PINDIRS or MOV PINS instruction. The data written to this pin will always be the least-significant bit of the OUT or MOV data.
    pub fn OUT_BASE(v: u5) Value {
        return Value.OUT_BASE(.{}, v);
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
/// Clock divisor register for state machine 2
/// Frequency = clock freq / (CLKDIV_INT + CLKDIV_FRAC / 256)
pub const SM2_CLKDIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000f8),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(16, 32);
        pub const FRAC: u32 = helpers.generateMask(8, 16);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Effective frequency is sysclk/(int + frac/256).
        /// Value of 0 is interpreted as 65536. If INT is 0, FRAC must also be 0.
        pub fn INT(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        /// Fractional part of clock divisor
        pub fn FRAC(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FRAC(self: Result) u8 {
            const mask = comptime helpers.generateMask(8, 16);
            return @intCast((self.val & mask) >> 8);
        }
    };
    /// Effective frequency is sysclk/(int + frac/256).
    /// Value of 0 is interpreted as 65536. If INT is 0, FRAC must also be 0.
    pub fn INT(v: u16) Value {
        return Value.INT(.{}, v);
    }
    /// Fractional part of clock divisor
    pub fn FRAC(v: u8) Value {
        return Value.FRAC(.{}, v);
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
/// Execution/behavioural settings for state machine 2
pub const SM2_EXECCTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x503000fc),
    pub const FieldMasks = struct {
        pub const EXEC_STALLED: u32 = helpers.generateMask(31, 32);
        pub const SIDE_EN: u32 = helpers.generateMask(30, 31);
        pub const SIDE_PINDIR: u32 = helpers.generateMask(29, 30);
        pub const JMP_PIN: u32 = helpers.generateMask(24, 29);
        pub const OUT_EN_SEL: u32 = helpers.generateMask(19, 24);
        pub const INLINE_OUT_EN: u32 = helpers.generateMask(18, 19);
        pub const OUT_STICKY: u32 = helpers.generateMask(17, 18);
        pub const WRAP_TOP: u32 = helpers.generateMask(12, 17);
        pub const WRAP_BOTTOM: u32 = helpers.generateMask(7, 12);
        pub const STATUS_SEL: u32 = helpers.generateMask(4, 5);
        pub const STATUS_N: u32 = helpers.generateMask(0, 4);
    };
    const STATUS_SEL_e = enum(u1) {
        TXLEVEL = 0,
        RXLEVEL = 1,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If 1, the MSB of the Delay/Side-set instruction field is used as side-set enable, rather than a side-set data bit. This allows instructions to perform side-set optionally, rather than on every instruction, but the maximum possible side-set width is reduced from 5 to 4. Note that the value of PINCTRL_SIDESET_COUNT is inclusive of this enable bit.
        pub fn SIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// If 1, side-set data is asserted to pin directions, instead of pin values
        pub fn SIDE_PINDIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The GPIO number to use as condition for JMP PIN. Unaffected by input mapping.
        pub fn JMP_PIN(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 29),
            };
        }
        /// Which data bit to use for inline OUT enable
        pub fn OUT_EN_SEL(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 24),
            };
        }
        /// If 1, use a bit of OUT data as an auxiliary write enable
        /// When used in conjunction with OUT_STICKY, writes with an enable of 0 will
        /// deassert the latest pin write. This can create useful masking/override behaviour
        /// due to the priority ordering of state machine pin writes (SM0 &lt; SM1 &lt; ...)
        pub fn INLINE_OUT_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        /// Continuously assert the most recent OUT/SET to the pins
        pub fn OUT_STICKY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// After reaching this address, execution is wrapped to wrap_bottom.
        /// If the instruction is a jump, and the jump condition is true, the jump takes priority.
        pub fn WRAP_TOP(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 17),
            };
        }
        /// After reaching wrap_top, execution is wrapped to this address.
        pub fn WRAP_BOTTOM(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 12),
            };
        }
        /// Comparison used for the MOV x, STATUS instruction.
        pub fn STATUS_SEL(self: Value, v: STATUS_SEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Comparison level for the MOV x, STATUS instruction
        pub fn STATUS_N(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 4),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn EXEC_STALLED(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn SIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn SIDE_PINDIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn JMP_PIN(self: Result) u5 {
            const mask = comptime helpers.generateMask(24, 29);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn OUT_EN_SEL(self: Result) u5 {
            const mask = comptime helpers.generateMask(19, 24);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn INLINE_OUT_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn OUT_STICKY(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn WRAP_TOP(self: Result) u5 {
            const mask = comptime helpers.generateMask(12, 17);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn WRAP_BOTTOM(self: Result) u5 {
            const mask = comptime helpers.generateMask(7, 12);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn STATUS_SEL(self: Result) STATUS_SEL_e {
            const mask = comptime helpers.generateMask(4, 5);
            const val: @typeInfo(STATUS_SEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn STATUS_N(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If 1, the MSB of the Delay/Side-set instruction field is used as side-set enable, rather than a side-set data bit. This allows instructions to perform side-set optionally, rather than on every instruction, but the maximum possible side-set width is reduced from 5 to 4. Note that the value of PINCTRL_SIDESET_COUNT is inclusive of this enable bit.
    pub fn SIDE_EN(v: u1) Value {
        return Value.SIDE_EN(.{}, v);
    }
    /// If 1, side-set data is asserted to pin directions, instead of pin values
    pub fn SIDE_PINDIR(v: u1) Value {
        return Value.SIDE_PINDIR(.{}, v);
    }
    /// The GPIO number to use as condition for JMP PIN. Unaffected by input mapping.
    pub fn JMP_PIN(v: u5) Value {
        return Value.JMP_PIN(.{}, v);
    }
    /// Which data bit to use for inline OUT enable
    pub fn OUT_EN_SEL(v: u5) Value {
        return Value.OUT_EN_SEL(.{}, v);
    }
    /// If 1, use a bit of OUT data as an auxiliary write enable
    /// When used in conjunction with OUT_STICKY, writes with an enable of 0 will
    /// deassert the latest pin write. This can create useful masking/override behaviour
    /// due to the priority ordering of state machine pin writes (SM0 &lt; SM1 &lt; ...)
    pub fn INLINE_OUT_EN(v: u1) Value {
        return Value.INLINE_OUT_EN(.{}, v);
    }
    /// Continuously assert the most recent OUT/SET to the pins
    pub fn OUT_STICKY(v: u1) Value {
        return Value.OUT_STICKY(.{}, v);
    }
    /// After reaching this address, execution is wrapped to wrap_bottom.
    /// If the instruction is a jump, and the jump condition is true, the jump takes priority.
    pub fn WRAP_TOP(v: u5) Value {
        return Value.WRAP_TOP(.{}, v);
    }
    /// After reaching wrap_top, execution is wrapped to this address.
    pub fn WRAP_BOTTOM(v: u5) Value {
        return Value.WRAP_BOTTOM(.{}, v);
    }
    /// Comparison used for the MOV x, STATUS instruction.
    pub fn STATUS_SEL(v: STATUS_SEL_e) Value {
        return Value.STATUS_SEL(.{}, v);
    }
    /// Comparison level for the MOV x, STATUS instruction
    pub fn STATUS_N(v: u4) Value {
        return Value.STATUS_N(.{}, v);
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
/// Control behaviour of the input/output shift registers for state machine 2
pub const SM2_SHIFTCTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300100),
    pub const FieldMasks = struct {
        pub const FJOIN_RX: u32 = helpers.generateMask(31, 32);
        pub const FJOIN_TX: u32 = helpers.generateMask(30, 31);
        pub const PULL_THRESH: u32 = helpers.generateMask(25, 30);
        pub const PUSH_THRESH: u32 = helpers.generateMask(20, 25);
        pub const OUT_SHIFTDIR: u32 = helpers.generateMask(19, 20);
        pub const IN_SHIFTDIR: u32 = helpers.generateMask(18, 19);
        pub const AUTOPULL: u32 = helpers.generateMask(17, 18);
        pub const AUTOPUSH: u32 = helpers.generateMask(16, 17);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// When 1, RX FIFO steals the TX FIFO&#39;s storage, and becomes twice as deep.
        /// TX FIFO is disabled as a result (always reads as both full and empty).
        /// FIFOs are flushed when this bit is changed.
        pub fn FJOIN_RX(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// When 1, TX FIFO steals the RX FIFO&#39;s storage, and becomes twice as deep.
        /// RX FIFO is disabled as a result (always reads as both full and empty).
        /// FIFOs are flushed when this bit is changed.
        pub fn FJOIN_TX(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Number of bits shifted out of OSR before autopull, or conditional pull (PULL IFEMPTY), will take place.
        /// Write 0 for value of 32.
        pub fn PULL_THRESH(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 30),
            };
        }
        /// Number of bits shifted into ISR before autopush, or conditional push (PUSH IFFULL), will take place.
        /// Write 0 for value of 32.
        pub fn PUSH_THRESH(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 25),
            };
        }
        /// 1 = shift out of output shift register to right. 0 = to left.
        pub fn OUT_SHIFTDIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        /// 1 = shift input shift register to right (data enters from left). 0 = to left.
        pub fn IN_SHIFTDIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        /// Pull automatically when the output shift register is emptied, i.e. on or following an OUT instruction which causes the output shift counter to reach or exceed PULL_THRESH.
        pub fn AUTOPULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Push automatically when the input shift register is filled, i.e. on an IN instruction which causes the input shift counter to reach or exceed PUSH_THRESH.
        pub fn AUTOPUSH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FJOIN_RX(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn FJOIN_TX(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PULL_THRESH(self: Result) u5 {
            const mask = comptime helpers.generateMask(25, 30);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn PUSH_THRESH(self: Result) u5 {
            const mask = comptime helpers.generateMask(20, 25);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn OUT_SHIFTDIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn IN_SHIFTDIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn AUTOPULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn AUTOPUSH(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
    };
    /// When 1, RX FIFO steals the TX FIFO&#39;s storage, and becomes twice as deep.
    /// TX FIFO is disabled as a result (always reads as both full and empty).
    /// FIFOs are flushed when this bit is changed.
    pub fn FJOIN_RX(v: u1) Value {
        return Value.FJOIN_RX(.{}, v);
    }
    /// When 1, TX FIFO steals the RX FIFO&#39;s storage, and becomes twice as deep.
    /// RX FIFO is disabled as a result (always reads as both full and empty).
    /// FIFOs are flushed when this bit is changed.
    pub fn FJOIN_TX(v: u1) Value {
        return Value.FJOIN_TX(.{}, v);
    }
    /// Number of bits shifted out of OSR before autopull, or conditional pull (PULL IFEMPTY), will take place.
    /// Write 0 for value of 32.
    pub fn PULL_THRESH(v: u5) Value {
        return Value.PULL_THRESH(.{}, v);
    }
    /// Number of bits shifted into ISR before autopush, or conditional push (PUSH IFFULL), will take place.
    /// Write 0 for value of 32.
    pub fn PUSH_THRESH(v: u5) Value {
        return Value.PUSH_THRESH(.{}, v);
    }
    /// 1 = shift out of output shift register to right. 0 = to left.
    pub fn OUT_SHIFTDIR(v: u1) Value {
        return Value.OUT_SHIFTDIR(.{}, v);
    }
    /// 1 = shift input shift register to right (data enters from left). 0 = to left.
    pub fn IN_SHIFTDIR(v: u1) Value {
        return Value.IN_SHIFTDIR(.{}, v);
    }
    /// Pull automatically when the output shift register is emptied, i.e. on or following an OUT instruction which causes the output shift counter to reach or exceed PULL_THRESH.
    pub fn AUTOPULL(v: u1) Value {
        return Value.AUTOPULL(.{}, v);
    }
    /// Push automatically when the input shift register is filled, i.e. on an IN instruction which causes the input shift counter to reach or exceed PUSH_THRESH.
    pub fn AUTOPUSH(v: u1) Value {
        return Value.AUTOPUSH(.{}, v);
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
/// Current instruction address of state machine 2
pub const SM2_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300104),
    pub fn write(self: @This(), v: u5) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u5 {
        const mask = comptime helpers.generateMask(0, 5);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read to see the instruction currently addressed by state machine 2&#39;s program counter
/// Write to execute an instruction immediately (including jumps) and then resume execution.
pub const SM2_INSTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300108),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// State machine pin control
pub const SM2_PINCTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5030010c),
    pub const FieldMasks = struct {
        pub const SIDESET_COUNT: u32 = helpers.generateMask(29, 32);
        pub const SET_COUNT: u32 = helpers.generateMask(26, 29);
        pub const OUT_COUNT: u32 = helpers.generateMask(20, 26);
        pub const IN_BASE: u32 = helpers.generateMask(15, 20);
        pub const SIDESET_BASE: u32 = helpers.generateMask(10, 15);
        pub const SET_BASE: u32 = helpers.generateMask(5, 10);
        pub const OUT_BASE: u32 = helpers.generateMask(0, 5);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// The number of MSBs of the Delay/Side-set instruction field which are used for side-set. Inclusive of the enable bit, if present. Minimum of 0 (all delay bits, no side-set) and maximum of 5 (all side-set, no delay).
        pub fn SIDESET_COUNT(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 32),
            };
        }
        /// The number of pins asserted by a SET. In the range 0 to 5 inclusive.
        pub fn SET_COUNT(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 29),
            };
        }
        /// The number of pins asserted by an OUT PINS, OUT PINDIRS or MOV PINS instruction. In the range 0 to 32 inclusive.
        pub fn OUT_COUNT(self: Value, v: u6) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 26),
            };
        }
        /// The pin which is mapped to the least-significant bit of a state machine&#39;s IN data bus. Higher-numbered pins are mapped to consecutively more-significant data bits, with a modulo of 32 applied to pin number.
        pub fn IN_BASE(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 20),
            };
        }
        /// The lowest-numbered pin that will be affected by a side-set operation. The MSBs of an instruction&#39;s side-set/delay field (up to 5, determined by SIDESET_COUNT) are used for side-set data, with the remaining LSBs used for delay. The least-significant bit of the side-set portion is the bit written to this pin, with more-significant bits written to higher-numbered pins.
        pub fn SIDESET_BASE(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 15),
            };
        }
        /// The lowest-numbered pin that will be affected by a SET PINS or SET PINDIRS instruction. The data written to this pin is the least-significant bit of the SET data.
        pub fn SET_BASE(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 10),
            };
        }
        /// The lowest-numbered pin that will be affected by an OUT PINS, OUT PINDIRS or MOV PINS instruction. The data written to this pin will always be the least-significant bit of the OUT or MOV data.
        pub fn OUT_BASE(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 5),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn SIDESET_COUNT(self: Result) u3 {
            const mask = comptime helpers.generateMask(29, 32);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn SET_COUNT(self: Result) u3 {
            const mask = comptime helpers.generateMask(26, 29);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn OUT_COUNT(self: Result) u6 {
            const mask = comptime helpers.generateMask(20, 26);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn IN_BASE(self: Result) u5 {
            const mask = comptime helpers.generateMask(15, 20);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn SIDESET_BASE(self: Result) u5 {
            const mask = comptime helpers.generateMask(10, 15);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn SET_BASE(self: Result) u5 {
            const mask = comptime helpers.generateMask(5, 10);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn OUT_BASE(self: Result) u5 {
            const mask = comptime helpers.generateMask(0, 5);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// The number of MSBs of the Delay/Side-set instruction field which are used for side-set. Inclusive of the enable bit, if present. Minimum of 0 (all delay bits, no side-set) and maximum of 5 (all side-set, no delay).
    pub fn SIDESET_COUNT(v: u3) Value {
        return Value.SIDESET_COUNT(.{}, v);
    }
    /// The number of pins asserted by a SET. In the range 0 to 5 inclusive.
    pub fn SET_COUNT(v: u3) Value {
        return Value.SET_COUNT(.{}, v);
    }
    /// The number of pins asserted by an OUT PINS, OUT PINDIRS or MOV PINS instruction. In the range 0 to 32 inclusive.
    pub fn OUT_COUNT(v: u6) Value {
        return Value.OUT_COUNT(.{}, v);
    }
    /// The pin which is mapped to the least-significant bit of a state machine&#39;s IN data bus. Higher-numbered pins are mapped to consecutively more-significant data bits, with a modulo of 32 applied to pin number.
    pub fn IN_BASE(v: u5) Value {
        return Value.IN_BASE(.{}, v);
    }
    /// The lowest-numbered pin that will be affected by a side-set operation. The MSBs of an instruction&#39;s side-set/delay field (up to 5, determined by SIDESET_COUNT) are used for side-set data, with the remaining LSBs used for delay. The least-significant bit of the side-set portion is the bit written to this pin, with more-significant bits written to higher-numbered pins.
    pub fn SIDESET_BASE(v: u5) Value {
        return Value.SIDESET_BASE(.{}, v);
    }
    /// The lowest-numbered pin that will be affected by a SET PINS or SET PINDIRS instruction. The data written to this pin is the least-significant bit of the SET data.
    pub fn SET_BASE(v: u5) Value {
        return Value.SET_BASE(.{}, v);
    }
    /// The lowest-numbered pin that will be affected by an OUT PINS, OUT PINDIRS or MOV PINS instruction. The data written to this pin will always be the least-significant bit of the OUT or MOV data.
    pub fn OUT_BASE(v: u5) Value {
        return Value.OUT_BASE(.{}, v);
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
/// Clock divisor register for state machine 3
/// Frequency = clock freq / (CLKDIV_INT + CLKDIV_FRAC / 256)
pub const SM3_CLKDIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300110),
    pub const FieldMasks = struct {
        pub const INT: u32 = helpers.generateMask(16, 32);
        pub const FRAC: u32 = helpers.generateMask(8, 16);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Effective frequency is sysclk/(int + frac/256).
        /// Value of 0 is interpreted as 65536. If INT is 0, FRAC must also be 0.
        pub fn INT(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        /// Fractional part of clock divisor
        pub fn FRAC(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INT(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FRAC(self: Result) u8 {
            const mask = comptime helpers.generateMask(8, 16);
            return @intCast((self.val & mask) >> 8);
        }
    };
    /// Effective frequency is sysclk/(int + frac/256).
    /// Value of 0 is interpreted as 65536. If INT is 0, FRAC must also be 0.
    pub fn INT(v: u16) Value {
        return Value.INT(.{}, v);
    }
    /// Fractional part of clock divisor
    pub fn FRAC(v: u8) Value {
        return Value.FRAC(.{}, v);
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
/// Execution/behavioural settings for state machine 3
pub const SM3_EXECCTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300114),
    pub const FieldMasks = struct {
        pub const EXEC_STALLED: u32 = helpers.generateMask(31, 32);
        pub const SIDE_EN: u32 = helpers.generateMask(30, 31);
        pub const SIDE_PINDIR: u32 = helpers.generateMask(29, 30);
        pub const JMP_PIN: u32 = helpers.generateMask(24, 29);
        pub const OUT_EN_SEL: u32 = helpers.generateMask(19, 24);
        pub const INLINE_OUT_EN: u32 = helpers.generateMask(18, 19);
        pub const OUT_STICKY: u32 = helpers.generateMask(17, 18);
        pub const WRAP_TOP: u32 = helpers.generateMask(12, 17);
        pub const WRAP_BOTTOM: u32 = helpers.generateMask(7, 12);
        pub const STATUS_SEL: u32 = helpers.generateMask(4, 5);
        pub const STATUS_N: u32 = helpers.generateMask(0, 4);
    };
    const STATUS_SEL_e = enum(u1) {
        TXLEVEL = 0,
        RXLEVEL = 1,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If 1, the MSB of the Delay/Side-set instruction field is used as side-set enable, rather than a side-set data bit. This allows instructions to perform side-set optionally, rather than on every instruction, but the maximum possible side-set width is reduced from 5 to 4. Note that the value of PINCTRL_SIDESET_COUNT is inclusive of this enable bit.
        pub fn SIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// If 1, side-set data is asserted to pin directions, instead of pin values
        pub fn SIDE_PINDIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The GPIO number to use as condition for JMP PIN. Unaffected by input mapping.
        pub fn JMP_PIN(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 29),
            };
        }
        /// Which data bit to use for inline OUT enable
        pub fn OUT_EN_SEL(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 24),
            };
        }
        /// If 1, use a bit of OUT data as an auxiliary write enable
        /// When used in conjunction with OUT_STICKY, writes with an enable of 0 will
        /// deassert the latest pin write. This can create useful masking/override behaviour
        /// due to the priority ordering of state machine pin writes (SM0 &lt; SM1 &lt; ...)
        pub fn INLINE_OUT_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        /// Continuously assert the most recent OUT/SET to the pins
        pub fn OUT_STICKY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// After reaching this address, execution is wrapped to wrap_bottom.
        /// If the instruction is a jump, and the jump condition is true, the jump takes priority.
        pub fn WRAP_TOP(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 17),
            };
        }
        /// After reaching wrap_top, execution is wrapped to this address.
        pub fn WRAP_BOTTOM(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 12),
            };
        }
        /// Comparison used for the MOV x, STATUS instruction.
        pub fn STATUS_SEL(self: Value, v: STATUS_SEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Comparison level for the MOV x, STATUS instruction
        pub fn STATUS_N(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 4),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn EXEC_STALLED(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn SIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn SIDE_PINDIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn JMP_PIN(self: Result) u5 {
            const mask = comptime helpers.generateMask(24, 29);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn OUT_EN_SEL(self: Result) u5 {
            const mask = comptime helpers.generateMask(19, 24);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn INLINE_OUT_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn OUT_STICKY(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn WRAP_TOP(self: Result) u5 {
            const mask = comptime helpers.generateMask(12, 17);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn WRAP_BOTTOM(self: Result) u5 {
            const mask = comptime helpers.generateMask(7, 12);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn STATUS_SEL(self: Result) STATUS_SEL_e {
            const mask = comptime helpers.generateMask(4, 5);
            const val: @typeInfo(STATUS_SEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn STATUS_N(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If 1, the MSB of the Delay/Side-set instruction field is used as side-set enable, rather than a side-set data bit. This allows instructions to perform side-set optionally, rather than on every instruction, but the maximum possible side-set width is reduced from 5 to 4. Note that the value of PINCTRL_SIDESET_COUNT is inclusive of this enable bit.
    pub fn SIDE_EN(v: u1) Value {
        return Value.SIDE_EN(.{}, v);
    }
    /// If 1, side-set data is asserted to pin directions, instead of pin values
    pub fn SIDE_PINDIR(v: u1) Value {
        return Value.SIDE_PINDIR(.{}, v);
    }
    /// The GPIO number to use as condition for JMP PIN. Unaffected by input mapping.
    pub fn JMP_PIN(v: u5) Value {
        return Value.JMP_PIN(.{}, v);
    }
    /// Which data bit to use for inline OUT enable
    pub fn OUT_EN_SEL(v: u5) Value {
        return Value.OUT_EN_SEL(.{}, v);
    }
    /// If 1, use a bit of OUT data as an auxiliary write enable
    /// When used in conjunction with OUT_STICKY, writes with an enable of 0 will
    /// deassert the latest pin write. This can create useful masking/override behaviour
    /// due to the priority ordering of state machine pin writes (SM0 &lt; SM1 &lt; ...)
    pub fn INLINE_OUT_EN(v: u1) Value {
        return Value.INLINE_OUT_EN(.{}, v);
    }
    /// Continuously assert the most recent OUT/SET to the pins
    pub fn OUT_STICKY(v: u1) Value {
        return Value.OUT_STICKY(.{}, v);
    }
    /// After reaching this address, execution is wrapped to wrap_bottom.
    /// If the instruction is a jump, and the jump condition is true, the jump takes priority.
    pub fn WRAP_TOP(v: u5) Value {
        return Value.WRAP_TOP(.{}, v);
    }
    /// After reaching wrap_top, execution is wrapped to this address.
    pub fn WRAP_BOTTOM(v: u5) Value {
        return Value.WRAP_BOTTOM(.{}, v);
    }
    /// Comparison used for the MOV x, STATUS instruction.
    pub fn STATUS_SEL(v: STATUS_SEL_e) Value {
        return Value.STATUS_SEL(.{}, v);
    }
    /// Comparison level for the MOV x, STATUS instruction
    pub fn STATUS_N(v: u4) Value {
        return Value.STATUS_N(.{}, v);
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
/// Control behaviour of the input/output shift registers for state machine 3
pub const SM3_SHIFTCTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300118),
    pub const FieldMasks = struct {
        pub const FJOIN_RX: u32 = helpers.generateMask(31, 32);
        pub const FJOIN_TX: u32 = helpers.generateMask(30, 31);
        pub const PULL_THRESH: u32 = helpers.generateMask(25, 30);
        pub const PUSH_THRESH: u32 = helpers.generateMask(20, 25);
        pub const OUT_SHIFTDIR: u32 = helpers.generateMask(19, 20);
        pub const IN_SHIFTDIR: u32 = helpers.generateMask(18, 19);
        pub const AUTOPULL: u32 = helpers.generateMask(17, 18);
        pub const AUTOPUSH: u32 = helpers.generateMask(16, 17);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// When 1, RX FIFO steals the TX FIFO&#39;s storage, and becomes twice as deep.
        /// TX FIFO is disabled as a result (always reads as both full and empty).
        /// FIFOs are flushed when this bit is changed.
        pub fn FJOIN_RX(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// When 1, TX FIFO steals the RX FIFO&#39;s storage, and becomes twice as deep.
        /// RX FIFO is disabled as a result (always reads as both full and empty).
        /// FIFOs are flushed when this bit is changed.
        pub fn FJOIN_TX(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Number of bits shifted out of OSR before autopull, or conditional pull (PULL IFEMPTY), will take place.
        /// Write 0 for value of 32.
        pub fn PULL_THRESH(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 30),
            };
        }
        /// Number of bits shifted into ISR before autopush, or conditional push (PUSH IFFULL), will take place.
        /// Write 0 for value of 32.
        pub fn PUSH_THRESH(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 25),
            };
        }
        /// 1 = shift out of output shift register to right. 0 = to left.
        pub fn OUT_SHIFTDIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        /// 1 = shift input shift register to right (data enters from left). 0 = to left.
        pub fn IN_SHIFTDIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        /// Pull automatically when the output shift register is emptied, i.e. on or following an OUT instruction which causes the output shift counter to reach or exceed PULL_THRESH.
        pub fn AUTOPULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Push automatically when the input shift register is filled, i.e. on an IN instruction which causes the input shift counter to reach or exceed PUSH_THRESH.
        pub fn AUTOPUSH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FJOIN_RX(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn FJOIN_TX(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PULL_THRESH(self: Result) u5 {
            const mask = comptime helpers.generateMask(25, 30);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn PUSH_THRESH(self: Result) u5 {
            const mask = comptime helpers.generateMask(20, 25);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn OUT_SHIFTDIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn IN_SHIFTDIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn AUTOPULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn AUTOPUSH(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
    };
    /// When 1, RX FIFO steals the TX FIFO&#39;s storage, and becomes twice as deep.
    /// TX FIFO is disabled as a result (always reads as both full and empty).
    /// FIFOs are flushed when this bit is changed.
    pub fn FJOIN_RX(v: u1) Value {
        return Value.FJOIN_RX(.{}, v);
    }
    /// When 1, TX FIFO steals the RX FIFO&#39;s storage, and becomes twice as deep.
    /// RX FIFO is disabled as a result (always reads as both full and empty).
    /// FIFOs are flushed when this bit is changed.
    pub fn FJOIN_TX(v: u1) Value {
        return Value.FJOIN_TX(.{}, v);
    }
    /// Number of bits shifted out of OSR before autopull, or conditional pull (PULL IFEMPTY), will take place.
    /// Write 0 for value of 32.
    pub fn PULL_THRESH(v: u5) Value {
        return Value.PULL_THRESH(.{}, v);
    }
    /// Number of bits shifted into ISR before autopush, or conditional push (PUSH IFFULL), will take place.
    /// Write 0 for value of 32.
    pub fn PUSH_THRESH(v: u5) Value {
        return Value.PUSH_THRESH(.{}, v);
    }
    /// 1 = shift out of output shift register to right. 0 = to left.
    pub fn OUT_SHIFTDIR(v: u1) Value {
        return Value.OUT_SHIFTDIR(.{}, v);
    }
    /// 1 = shift input shift register to right (data enters from left). 0 = to left.
    pub fn IN_SHIFTDIR(v: u1) Value {
        return Value.IN_SHIFTDIR(.{}, v);
    }
    /// Pull automatically when the output shift register is emptied, i.e. on or following an OUT instruction which causes the output shift counter to reach or exceed PULL_THRESH.
    pub fn AUTOPULL(v: u1) Value {
        return Value.AUTOPULL(.{}, v);
    }
    /// Push automatically when the input shift register is filled, i.e. on an IN instruction which causes the input shift counter to reach or exceed PUSH_THRESH.
    pub fn AUTOPUSH(v: u1) Value {
        return Value.AUTOPUSH(.{}, v);
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
/// Current instruction address of state machine 3
pub const SM3_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5030011c),
    pub fn write(self: @This(), v: u5) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u5 {
        const mask = comptime helpers.generateMask(0, 5);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read to see the instruction currently addressed by state machine 3&#39;s program counter
/// Write to execute an instruction immediately (including jumps) and then resume execution.
pub const SM3_INSTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300120),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// State machine pin control
pub const SM3_PINCTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300124),
    pub const FieldMasks = struct {
        pub const SIDESET_COUNT: u32 = helpers.generateMask(29, 32);
        pub const SET_COUNT: u32 = helpers.generateMask(26, 29);
        pub const OUT_COUNT: u32 = helpers.generateMask(20, 26);
        pub const IN_BASE: u32 = helpers.generateMask(15, 20);
        pub const SIDESET_BASE: u32 = helpers.generateMask(10, 15);
        pub const SET_BASE: u32 = helpers.generateMask(5, 10);
        pub const OUT_BASE: u32 = helpers.generateMask(0, 5);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// The number of MSBs of the Delay/Side-set instruction field which are used for side-set. Inclusive of the enable bit, if present. Minimum of 0 (all delay bits, no side-set) and maximum of 5 (all side-set, no delay).
        pub fn SIDESET_COUNT(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 32),
            };
        }
        /// The number of pins asserted by a SET. In the range 0 to 5 inclusive.
        pub fn SET_COUNT(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 29),
            };
        }
        /// The number of pins asserted by an OUT PINS, OUT PINDIRS or MOV PINS instruction. In the range 0 to 32 inclusive.
        pub fn OUT_COUNT(self: Value, v: u6) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 26),
            };
        }
        /// The pin which is mapped to the least-significant bit of a state machine&#39;s IN data bus. Higher-numbered pins are mapped to consecutively more-significant data bits, with a modulo of 32 applied to pin number.
        pub fn IN_BASE(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 20),
            };
        }
        /// The lowest-numbered pin that will be affected by a side-set operation. The MSBs of an instruction&#39;s side-set/delay field (up to 5, determined by SIDESET_COUNT) are used for side-set data, with the remaining LSBs used for delay. The least-significant bit of the side-set portion is the bit written to this pin, with more-significant bits written to higher-numbered pins.
        pub fn SIDESET_BASE(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 15),
            };
        }
        /// The lowest-numbered pin that will be affected by a SET PINS or SET PINDIRS instruction. The data written to this pin is the least-significant bit of the SET data.
        pub fn SET_BASE(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 10),
            };
        }
        /// The lowest-numbered pin that will be affected by an OUT PINS, OUT PINDIRS or MOV PINS instruction. The data written to this pin will always be the least-significant bit of the OUT or MOV data.
        pub fn OUT_BASE(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 5),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn SIDESET_COUNT(self: Result) u3 {
            const mask = comptime helpers.generateMask(29, 32);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn SET_COUNT(self: Result) u3 {
            const mask = comptime helpers.generateMask(26, 29);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn OUT_COUNT(self: Result) u6 {
            const mask = comptime helpers.generateMask(20, 26);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn IN_BASE(self: Result) u5 {
            const mask = comptime helpers.generateMask(15, 20);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn SIDESET_BASE(self: Result) u5 {
            const mask = comptime helpers.generateMask(10, 15);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn SET_BASE(self: Result) u5 {
            const mask = comptime helpers.generateMask(5, 10);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn OUT_BASE(self: Result) u5 {
            const mask = comptime helpers.generateMask(0, 5);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// The number of MSBs of the Delay/Side-set instruction field which are used for side-set. Inclusive of the enable bit, if present. Minimum of 0 (all delay bits, no side-set) and maximum of 5 (all side-set, no delay).
    pub fn SIDESET_COUNT(v: u3) Value {
        return Value.SIDESET_COUNT(.{}, v);
    }
    /// The number of pins asserted by a SET. In the range 0 to 5 inclusive.
    pub fn SET_COUNT(v: u3) Value {
        return Value.SET_COUNT(.{}, v);
    }
    /// The number of pins asserted by an OUT PINS, OUT PINDIRS or MOV PINS instruction. In the range 0 to 32 inclusive.
    pub fn OUT_COUNT(v: u6) Value {
        return Value.OUT_COUNT(.{}, v);
    }
    /// The pin which is mapped to the least-significant bit of a state machine&#39;s IN data bus. Higher-numbered pins are mapped to consecutively more-significant data bits, with a modulo of 32 applied to pin number.
    pub fn IN_BASE(v: u5) Value {
        return Value.IN_BASE(.{}, v);
    }
    /// The lowest-numbered pin that will be affected by a side-set operation. The MSBs of an instruction&#39;s side-set/delay field (up to 5, determined by SIDESET_COUNT) are used for side-set data, with the remaining LSBs used for delay. The least-significant bit of the side-set portion is the bit written to this pin, with more-significant bits written to higher-numbered pins.
    pub fn SIDESET_BASE(v: u5) Value {
        return Value.SIDESET_BASE(.{}, v);
    }
    /// The lowest-numbered pin that will be affected by a SET PINS or SET PINDIRS instruction. The data written to this pin is the least-significant bit of the SET data.
    pub fn SET_BASE(v: u5) Value {
        return Value.SET_BASE(.{}, v);
    }
    /// The lowest-numbered pin that will be affected by an OUT PINS, OUT PINDIRS or MOV PINS instruction. The data written to this pin will always be the least-significant bit of the OUT or MOV data.
    pub fn OUT_BASE(v: u5) Value {
        return Value.OUT_BASE(.{}, v);
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
/// Raw Interrupts
pub const INTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300128),
    pub const FieldMasks = struct {
        pub const SM3: u32 = helpers.generateMask(11, 12);
        pub const SM2: u32 = helpers.generateMask(10, 11);
        pub const SM1: u32 = helpers.generateMask(9, 10);
        pub const SM0: u32 = helpers.generateMask(8, 9);
        pub const SM3_TXNFULL: u32 = helpers.generateMask(7, 8);
        pub const SM2_TXNFULL: u32 = helpers.generateMask(6, 7);
        pub const SM1_TXNFULL: u32 = helpers.generateMask(5, 6);
        pub const SM0_TXNFULL: u32 = helpers.generateMask(4, 5);
        pub const SM3_RXNEMPTY: u32 = helpers.generateMask(3, 4);
        pub const SM2_RXNEMPTY: u32 = helpers.generateMask(2, 3);
        pub const SM1_RXNEMPTY: u32 = helpers.generateMask(1, 2);
        pub const SM0_RXNEMPTY: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn SM3(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn SM2(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn SM1(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn SM0(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SM3_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn SM2_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn SM1_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn SM0_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn SM3_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn SM2_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SM1_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn SM0_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
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
/// Interrupt Enable for irq0
pub const IRQ0_INTE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5030012c),
    pub const FieldMasks = struct {
        pub const SM3: u32 = helpers.generateMask(11, 12);
        pub const SM2: u32 = helpers.generateMask(10, 11);
        pub const SM1: u32 = helpers.generateMask(9, 10);
        pub const SM0: u32 = helpers.generateMask(8, 9);
        pub const SM3_TXNFULL: u32 = helpers.generateMask(7, 8);
        pub const SM2_TXNFULL: u32 = helpers.generateMask(6, 7);
        pub const SM1_TXNFULL: u32 = helpers.generateMask(5, 6);
        pub const SM0_TXNFULL: u32 = helpers.generateMask(4, 5);
        pub const SM3_RXNEMPTY: u32 = helpers.generateMask(3, 4);
        pub const SM2_RXNEMPTY: u32 = helpers.generateMask(2, 3);
        pub const SM1_RXNEMPTY: u32 = helpers.generateMask(1, 2);
        pub const SM0_RXNEMPTY: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn SM3(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn SM2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn SM1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn SM0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn SM3_TXNFULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn SM2_TXNFULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn SM1_TXNFULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn SM0_TXNFULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn SM3_RXNEMPTY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn SM2_RXNEMPTY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn SM1_RXNEMPTY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn SM0_RXNEMPTY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn SM3(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn SM2(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn SM1(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn SM0(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SM3_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn SM2_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn SM1_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn SM0_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn SM3_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn SM2_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SM1_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn SM0_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn SM3(v: u1) Value {
        return Value.SM3(.{}, v);
    }
    pub fn SM2(v: u1) Value {
        return Value.SM2(.{}, v);
    }
    pub fn SM1(v: u1) Value {
        return Value.SM1(.{}, v);
    }
    pub fn SM0(v: u1) Value {
        return Value.SM0(.{}, v);
    }
    pub fn SM3_TXNFULL(v: u1) Value {
        return Value.SM3_TXNFULL(.{}, v);
    }
    pub fn SM2_TXNFULL(v: u1) Value {
        return Value.SM2_TXNFULL(.{}, v);
    }
    pub fn SM1_TXNFULL(v: u1) Value {
        return Value.SM1_TXNFULL(.{}, v);
    }
    pub fn SM0_TXNFULL(v: u1) Value {
        return Value.SM0_TXNFULL(.{}, v);
    }
    pub fn SM3_RXNEMPTY(v: u1) Value {
        return Value.SM3_RXNEMPTY(.{}, v);
    }
    pub fn SM2_RXNEMPTY(v: u1) Value {
        return Value.SM2_RXNEMPTY(.{}, v);
    }
    pub fn SM1_RXNEMPTY(v: u1) Value {
        return Value.SM1_RXNEMPTY(.{}, v);
    }
    pub fn SM0_RXNEMPTY(v: u1) Value {
        return Value.SM0_RXNEMPTY(.{}, v);
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
/// Interrupt Force for irq0
pub const IRQ0_INTF = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300130),
    pub const FieldMasks = struct {
        pub const SM3: u32 = helpers.generateMask(11, 12);
        pub const SM2: u32 = helpers.generateMask(10, 11);
        pub const SM1: u32 = helpers.generateMask(9, 10);
        pub const SM0: u32 = helpers.generateMask(8, 9);
        pub const SM3_TXNFULL: u32 = helpers.generateMask(7, 8);
        pub const SM2_TXNFULL: u32 = helpers.generateMask(6, 7);
        pub const SM1_TXNFULL: u32 = helpers.generateMask(5, 6);
        pub const SM0_TXNFULL: u32 = helpers.generateMask(4, 5);
        pub const SM3_RXNEMPTY: u32 = helpers.generateMask(3, 4);
        pub const SM2_RXNEMPTY: u32 = helpers.generateMask(2, 3);
        pub const SM1_RXNEMPTY: u32 = helpers.generateMask(1, 2);
        pub const SM0_RXNEMPTY: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn SM3(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn SM2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn SM1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn SM0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn SM3_TXNFULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn SM2_TXNFULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn SM1_TXNFULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn SM0_TXNFULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn SM3_RXNEMPTY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn SM2_RXNEMPTY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn SM1_RXNEMPTY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn SM0_RXNEMPTY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn SM3(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn SM2(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn SM1(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn SM0(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SM3_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn SM2_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn SM1_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn SM0_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn SM3_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn SM2_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SM1_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn SM0_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn SM3(v: u1) Value {
        return Value.SM3(.{}, v);
    }
    pub fn SM2(v: u1) Value {
        return Value.SM2(.{}, v);
    }
    pub fn SM1(v: u1) Value {
        return Value.SM1(.{}, v);
    }
    pub fn SM0(v: u1) Value {
        return Value.SM0(.{}, v);
    }
    pub fn SM3_TXNFULL(v: u1) Value {
        return Value.SM3_TXNFULL(.{}, v);
    }
    pub fn SM2_TXNFULL(v: u1) Value {
        return Value.SM2_TXNFULL(.{}, v);
    }
    pub fn SM1_TXNFULL(v: u1) Value {
        return Value.SM1_TXNFULL(.{}, v);
    }
    pub fn SM0_TXNFULL(v: u1) Value {
        return Value.SM0_TXNFULL(.{}, v);
    }
    pub fn SM3_RXNEMPTY(v: u1) Value {
        return Value.SM3_RXNEMPTY(.{}, v);
    }
    pub fn SM2_RXNEMPTY(v: u1) Value {
        return Value.SM2_RXNEMPTY(.{}, v);
    }
    pub fn SM1_RXNEMPTY(v: u1) Value {
        return Value.SM1_RXNEMPTY(.{}, v);
    }
    pub fn SM0_RXNEMPTY(v: u1) Value {
        return Value.SM0_RXNEMPTY(.{}, v);
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
/// Interrupt status after masking &amp; forcing for irq0
pub const IRQ0_INTS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300134),
    pub const FieldMasks = struct {
        pub const SM3: u32 = helpers.generateMask(11, 12);
        pub const SM2: u32 = helpers.generateMask(10, 11);
        pub const SM1: u32 = helpers.generateMask(9, 10);
        pub const SM0: u32 = helpers.generateMask(8, 9);
        pub const SM3_TXNFULL: u32 = helpers.generateMask(7, 8);
        pub const SM2_TXNFULL: u32 = helpers.generateMask(6, 7);
        pub const SM1_TXNFULL: u32 = helpers.generateMask(5, 6);
        pub const SM0_TXNFULL: u32 = helpers.generateMask(4, 5);
        pub const SM3_RXNEMPTY: u32 = helpers.generateMask(3, 4);
        pub const SM2_RXNEMPTY: u32 = helpers.generateMask(2, 3);
        pub const SM1_RXNEMPTY: u32 = helpers.generateMask(1, 2);
        pub const SM0_RXNEMPTY: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn SM3(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn SM2(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn SM1(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn SM0(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SM3_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn SM2_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn SM1_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn SM0_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn SM3_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn SM2_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SM1_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn SM0_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
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
/// Interrupt Enable for irq1
pub const IRQ1_INTE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300138),
    pub const FieldMasks = struct {
        pub const SM3: u32 = helpers.generateMask(11, 12);
        pub const SM2: u32 = helpers.generateMask(10, 11);
        pub const SM1: u32 = helpers.generateMask(9, 10);
        pub const SM0: u32 = helpers.generateMask(8, 9);
        pub const SM3_TXNFULL: u32 = helpers.generateMask(7, 8);
        pub const SM2_TXNFULL: u32 = helpers.generateMask(6, 7);
        pub const SM1_TXNFULL: u32 = helpers.generateMask(5, 6);
        pub const SM0_TXNFULL: u32 = helpers.generateMask(4, 5);
        pub const SM3_RXNEMPTY: u32 = helpers.generateMask(3, 4);
        pub const SM2_RXNEMPTY: u32 = helpers.generateMask(2, 3);
        pub const SM1_RXNEMPTY: u32 = helpers.generateMask(1, 2);
        pub const SM0_RXNEMPTY: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn SM3(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn SM2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn SM1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn SM0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn SM3_TXNFULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn SM2_TXNFULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn SM1_TXNFULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn SM0_TXNFULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn SM3_RXNEMPTY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn SM2_RXNEMPTY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn SM1_RXNEMPTY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn SM0_RXNEMPTY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn SM3(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn SM2(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn SM1(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn SM0(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SM3_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn SM2_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn SM1_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn SM0_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn SM3_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn SM2_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SM1_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn SM0_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn SM3(v: u1) Value {
        return Value.SM3(.{}, v);
    }
    pub fn SM2(v: u1) Value {
        return Value.SM2(.{}, v);
    }
    pub fn SM1(v: u1) Value {
        return Value.SM1(.{}, v);
    }
    pub fn SM0(v: u1) Value {
        return Value.SM0(.{}, v);
    }
    pub fn SM3_TXNFULL(v: u1) Value {
        return Value.SM3_TXNFULL(.{}, v);
    }
    pub fn SM2_TXNFULL(v: u1) Value {
        return Value.SM2_TXNFULL(.{}, v);
    }
    pub fn SM1_TXNFULL(v: u1) Value {
        return Value.SM1_TXNFULL(.{}, v);
    }
    pub fn SM0_TXNFULL(v: u1) Value {
        return Value.SM0_TXNFULL(.{}, v);
    }
    pub fn SM3_RXNEMPTY(v: u1) Value {
        return Value.SM3_RXNEMPTY(.{}, v);
    }
    pub fn SM2_RXNEMPTY(v: u1) Value {
        return Value.SM2_RXNEMPTY(.{}, v);
    }
    pub fn SM1_RXNEMPTY(v: u1) Value {
        return Value.SM1_RXNEMPTY(.{}, v);
    }
    pub fn SM0_RXNEMPTY(v: u1) Value {
        return Value.SM0_RXNEMPTY(.{}, v);
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
/// Interrupt Force for irq1
pub const IRQ1_INTF = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5030013c),
    pub const FieldMasks = struct {
        pub const SM3: u32 = helpers.generateMask(11, 12);
        pub const SM2: u32 = helpers.generateMask(10, 11);
        pub const SM1: u32 = helpers.generateMask(9, 10);
        pub const SM0: u32 = helpers.generateMask(8, 9);
        pub const SM3_TXNFULL: u32 = helpers.generateMask(7, 8);
        pub const SM2_TXNFULL: u32 = helpers.generateMask(6, 7);
        pub const SM1_TXNFULL: u32 = helpers.generateMask(5, 6);
        pub const SM0_TXNFULL: u32 = helpers.generateMask(4, 5);
        pub const SM3_RXNEMPTY: u32 = helpers.generateMask(3, 4);
        pub const SM2_RXNEMPTY: u32 = helpers.generateMask(2, 3);
        pub const SM1_RXNEMPTY: u32 = helpers.generateMask(1, 2);
        pub const SM0_RXNEMPTY: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn SM3(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn SM2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn SM1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn SM0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn SM3_TXNFULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn SM2_TXNFULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn SM1_TXNFULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn SM0_TXNFULL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn SM3_RXNEMPTY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn SM2_RXNEMPTY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn SM1_RXNEMPTY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn SM0_RXNEMPTY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn SM3(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn SM2(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn SM1(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn SM0(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SM3_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn SM2_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn SM1_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn SM0_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn SM3_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn SM2_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SM1_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn SM0_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn SM3(v: u1) Value {
        return Value.SM3(.{}, v);
    }
    pub fn SM2(v: u1) Value {
        return Value.SM2(.{}, v);
    }
    pub fn SM1(v: u1) Value {
        return Value.SM1(.{}, v);
    }
    pub fn SM0(v: u1) Value {
        return Value.SM0(.{}, v);
    }
    pub fn SM3_TXNFULL(v: u1) Value {
        return Value.SM3_TXNFULL(.{}, v);
    }
    pub fn SM2_TXNFULL(v: u1) Value {
        return Value.SM2_TXNFULL(.{}, v);
    }
    pub fn SM1_TXNFULL(v: u1) Value {
        return Value.SM1_TXNFULL(.{}, v);
    }
    pub fn SM0_TXNFULL(v: u1) Value {
        return Value.SM0_TXNFULL(.{}, v);
    }
    pub fn SM3_RXNEMPTY(v: u1) Value {
        return Value.SM3_RXNEMPTY(.{}, v);
    }
    pub fn SM2_RXNEMPTY(v: u1) Value {
        return Value.SM2_RXNEMPTY(.{}, v);
    }
    pub fn SM1_RXNEMPTY(v: u1) Value {
        return Value.SM1_RXNEMPTY(.{}, v);
    }
    pub fn SM0_RXNEMPTY(v: u1) Value {
        return Value.SM0_RXNEMPTY(.{}, v);
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
/// Interrupt status after masking &amp; forcing for irq1
pub const IRQ1_INTS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50300140),
    pub const FieldMasks = struct {
        pub const SM3: u32 = helpers.generateMask(11, 12);
        pub const SM2: u32 = helpers.generateMask(10, 11);
        pub const SM1: u32 = helpers.generateMask(9, 10);
        pub const SM0: u32 = helpers.generateMask(8, 9);
        pub const SM3_TXNFULL: u32 = helpers.generateMask(7, 8);
        pub const SM2_TXNFULL: u32 = helpers.generateMask(6, 7);
        pub const SM1_TXNFULL: u32 = helpers.generateMask(5, 6);
        pub const SM0_TXNFULL: u32 = helpers.generateMask(4, 5);
        pub const SM3_RXNEMPTY: u32 = helpers.generateMask(3, 4);
        pub const SM2_RXNEMPTY: u32 = helpers.generateMask(2, 3);
        pub const SM1_RXNEMPTY: u32 = helpers.generateMask(1, 2);
        pub const SM0_RXNEMPTY: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn SM3(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn SM2(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn SM1(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn SM0(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SM3_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn SM2_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn SM1_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn SM0_TXNFULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn SM3_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn SM2_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SM1_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn SM0_RXNEMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
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
pub const PIO1_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x50300000),

    /// PIO control register
    CTRL: CTRL = .{},
    /// FIFO status register
    FSTAT: FSTAT = .{},
    /// FIFO debug register
    FDEBUG: FDEBUG = .{},
    /// FIFO levels
    FLEVEL: FLEVEL = .{},
    /// Direct write access to the TX FIFO for this state machine. Each write pushes one word to the FIFO. Attempting to write to a full FIFO has no effect on the FIFO state or contents, and sets the sticky FDEBUG_TXOVER error flag for this FIFO.
    TXF0: TXF0 = .{},
    /// Direct write access to the TX FIFO for this state machine. Each write pushes one word to the FIFO. Attempting to write to a full FIFO has no effect on the FIFO state or contents, and sets the sticky FDEBUG_TXOVER error flag for this FIFO.
    TXF1: TXF1 = .{},
    /// Direct write access to the TX FIFO for this state machine. Each write pushes one word to the FIFO. Attempting to write to a full FIFO has no effect on the FIFO state or contents, and sets the sticky FDEBUG_TXOVER error flag for this FIFO.
    TXF2: TXF2 = .{},
    /// Direct write access to the TX FIFO for this state machine. Each write pushes one word to the FIFO. Attempting to write to a full FIFO has no effect on the FIFO state or contents, and sets the sticky FDEBUG_TXOVER error flag for this FIFO.
    TXF3: TXF3 = .{},
    /// Direct read access to the RX FIFO for this state machine. Each read pops one word from the FIFO. Attempting to read from an empty FIFO has no effect on the FIFO state, and sets the sticky FDEBUG_RXUNDER error flag for this FIFO. The data returned to the system on a read from an empty FIFO is undefined.
    RXF0: RXF0 = .{},
    /// Direct read access to the RX FIFO for this state machine. Each read pops one word from the FIFO. Attempting to read from an empty FIFO has no effect on the FIFO state, and sets the sticky FDEBUG_RXUNDER error flag for this FIFO. The data returned to the system on a read from an empty FIFO is undefined.
    RXF1: RXF1 = .{},
    /// Direct read access to the RX FIFO for this state machine. Each read pops one word from the FIFO. Attempting to read from an empty FIFO has no effect on the FIFO state, and sets the sticky FDEBUG_RXUNDER error flag for this FIFO. The data returned to the system on a read from an empty FIFO is undefined.
    RXF2: RXF2 = .{},
    /// Direct read access to the RX FIFO for this state machine. Each read pops one word from the FIFO. Attempting to read from an empty FIFO has no effect on the FIFO state, and sets the sticky FDEBUG_RXUNDER error flag for this FIFO. The data returned to the system on a read from an empty FIFO is undefined.
    RXF3: RXF3 = .{},
    /// State machine IRQ flags register. Write 1 to clear. There are 8 state machine IRQ flags, which can be set, cleared, and waited on by the state machines. There&#39;s no fixed association between flags and state machines -- any state machine can use any flag.
    ///
    /// Any of the 8 flags can be used for timing synchronisation between state machines, using IRQ and WAIT instructions. The lower four of these flags are also routed out to system-level interrupt requests, alongside FIFO status interrupts -- see e.g. IRQ0_INTE.
    IRQ: IRQ = .{},
    /// Writing a 1 to each of these bits will forcibly assert the corresponding IRQ. Note this is different to the INTF register: writing here affects PIO internal state. INTF just asserts the processor-facing IRQ signal for testing ISRs, and is not visible to the state machines.
    IRQ_FORCE: IRQ_FORCE = .{},
    /// There is a 2-flipflop synchronizer on each GPIO input, which protects PIO logic from metastabilities. This increases input delay, and for fast synchronous IO (e.g. SPI) these synchronizers may need to be bypassed. Each bit in this register corresponds to one GPIO.
    /// 0 -&gt; input is synchronized (default)
    /// 1 -&gt; synchronizer is bypassed
    /// If in doubt, leave this register as all zeroes.
    INPUT_SYNC_BYPASS: INPUT_SYNC_BYPASS = .{},
    /// Read to sample the pad output values PIO is currently driving to the GPIOs. On RP2040 there are 30 GPIOs, so the two most significant bits are hardwired to 0.
    DBG_PADOUT: DBG_PADOUT = .{},
    /// Read to sample the pad output enables (direction) PIO is currently driving to the GPIOs. On RP2040 there are 30 GPIOs, so the two most significant bits are hardwired to 0.
    DBG_PADOE: DBG_PADOE = .{},
    /// The PIO hardware has some free parameters that may vary between chip products.
    /// These should be provided in the chip datasheet, but are also exposed here.
    DBG_CFGINFO: DBG_CFGINFO = .{},
    /// Write-only access to instruction memory location 0
    INSTR_MEM0: INSTR_MEM0 = .{},
    /// Write-only access to instruction memory location 1
    INSTR_MEM1: INSTR_MEM1 = .{},
    /// Write-only access to instruction memory location 2
    INSTR_MEM2: INSTR_MEM2 = .{},
    /// Write-only access to instruction memory location 3
    INSTR_MEM3: INSTR_MEM3 = .{},
    /// Write-only access to instruction memory location 4
    INSTR_MEM4: INSTR_MEM4 = .{},
    /// Write-only access to instruction memory location 5
    INSTR_MEM5: INSTR_MEM5 = .{},
    /// Write-only access to instruction memory location 6
    INSTR_MEM6: INSTR_MEM6 = .{},
    /// Write-only access to instruction memory location 7
    INSTR_MEM7: INSTR_MEM7 = .{},
    /// Write-only access to instruction memory location 8
    INSTR_MEM8: INSTR_MEM8 = .{},
    /// Write-only access to instruction memory location 9
    INSTR_MEM9: INSTR_MEM9 = .{},
    /// Write-only access to instruction memory location 10
    INSTR_MEM10: INSTR_MEM10 = .{},
    /// Write-only access to instruction memory location 11
    INSTR_MEM11: INSTR_MEM11 = .{},
    /// Write-only access to instruction memory location 12
    INSTR_MEM12: INSTR_MEM12 = .{},
    /// Write-only access to instruction memory location 13
    INSTR_MEM13: INSTR_MEM13 = .{},
    /// Write-only access to instruction memory location 14
    INSTR_MEM14: INSTR_MEM14 = .{},
    /// Write-only access to instruction memory location 15
    INSTR_MEM15: INSTR_MEM15 = .{},
    /// Write-only access to instruction memory location 16
    INSTR_MEM16: INSTR_MEM16 = .{},
    /// Write-only access to instruction memory location 17
    INSTR_MEM17: INSTR_MEM17 = .{},
    /// Write-only access to instruction memory location 18
    INSTR_MEM18: INSTR_MEM18 = .{},
    /// Write-only access to instruction memory location 19
    INSTR_MEM19: INSTR_MEM19 = .{},
    /// Write-only access to instruction memory location 20
    INSTR_MEM20: INSTR_MEM20 = .{},
    /// Write-only access to instruction memory location 21
    INSTR_MEM21: INSTR_MEM21 = .{},
    /// Write-only access to instruction memory location 22
    INSTR_MEM22: INSTR_MEM22 = .{},
    /// Write-only access to instruction memory location 23
    INSTR_MEM23: INSTR_MEM23 = .{},
    /// Write-only access to instruction memory location 24
    INSTR_MEM24: INSTR_MEM24 = .{},
    /// Write-only access to instruction memory location 25
    INSTR_MEM25: INSTR_MEM25 = .{},
    /// Write-only access to instruction memory location 26
    INSTR_MEM26: INSTR_MEM26 = .{},
    /// Write-only access to instruction memory location 27
    INSTR_MEM27: INSTR_MEM27 = .{},
    /// Write-only access to instruction memory location 28
    INSTR_MEM28: INSTR_MEM28 = .{},
    /// Write-only access to instruction memory location 29
    INSTR_MEM29: INSTR_MEM29 = .{},
    /// Write-only access to instruction memory location 30
    INSTR_MEM30: INSTR_MEM30 = .{},
    /// Write-only access to instruction memory location 31
    INSTR_MEM31: INSTR_MEM31 = .{},
    /// Clock divisor register for state machine 0
    /// Frequency = clock freq / (CLKDIV_INT + CLKDIV_FRAC / 256)
    SM0_CLKDIV: SM0_CLKDIV = .{},
    /// Execution/behavioural settings for state machine 0
    SM0_EXECCTRL: SM0_EXECCTRL = .{},
    /// Control behaviour of the input/output shift registers for state machine 0
    SM0_SHIFTCTRL: SM0_SHIFTCTRL = .{},
    /// Current instruction address of state machine 0
    SM0_ADDR: SM0_ADDR = .{},
    /// Read to see the instruction currently addressed by state machine 0&#39;s program counter
    /// Write to execute an instruction immediately (including jumps) and then resume execution.
    SM0_INSTR: SM0_INSTR = .{},
    /// State machine pin control
    SM0_PINCTRL: SM0_PINCTRL = .{},
    /// Clock divisor register for state machine 1
    /// Frequency = clock freq / (CLKDIV_INT + CLKDIV_FRAC / 256)
    SM1_CLKDIV: SM1_CLKDIV = .{},
    /// Execution/behavioural settings for state machine 1
    SM1_EXECCTRL: SM1_EXECCTRL = .{},
    /// Control behaviour of the input/output shift registers for state machine 1
    SM1_SHIFTCTRL: SM1_SHIFTCTRL = .{},
    /// Current instruction address of state machine 1
    SM1_ADDR: SM1_ADDR = .{},
    /// Read to see the instruction currently addressed by state machine 1&#39;s program counter
    /// Write to execute an instruction immediately (including jumps) and then resume execution.
    SM1_INSTR: SM1_INSTR = .{},
    /// State machine pin control
    SM1_PINCTRL: SM1_PINCTRL = .{},
    /// Clock divisor register for state machine 2
    /// Frequency = clock freq / (CLKDIV_INT + CLKDIV_FRAC / 256)
    SM2_CLKDIV: SM2_CLKDIV = .{},
    /// Execution/behavioural settings for state machine 2
    SM2_EXECCTRL: SM2_EXECCTRL = .{},
    /// Control behaviour of the input/output shift registers for state machine 2
    SM2_SHIFTCTRL: SM2_SHIFTCTRL = .{},
    /// Current instruction address of state machine 2
    SM2_ADDR: SM2_ADDR = .{},
    /// Read to see the instruction currently addressed by state machine 2&#39;s program counter
    /// Write to execute an instruction immediately (including jumps) and then resume execution.
    SM2_INSTR: SM2_INSTR = .{},
    /// State machine pin control
    SM2_PINCTRL: SM2_PINCTRL = .{},
    /// Clock divisor register for state machine 3
    /// Frequency = clock freq / (CLKDIV_INT + CLKDIV_FRAC / 256)
    SM3_CLKDIV: SM3_CLKDIV = .{},
    /// Execution/behavioural settings for state machine 3
    SM3_EXECCTRL: SM3_EXECCTRL = .{},
    /// Control behaviour of the input/output shift registers for state machine 3
    SM3_SHIFTCTRL: SM3_SHIFTCTRL = .{},
    /// Current instruction address of state machine 3
    SM3_ADDR: SM3_ADDR = .{},
    /// Read to see the instruction currently addressed by state machine 3&#39;s program counter
    /// Write to execute an instruction immediately (including jumps) and then resume execution.
    SM3_INSTR: SM3_INSTR = .{},
    /// State machine pin control
    SM3_PINCTRL: SM3_PINCTRL = .{},
    /// Raw Interrupts
    INTR: INTR = .{},
    /// Interrupt Enable for irq0
    IRQ0_INTE: IRQ0_INTE = .{},
    /// Interrupt Force for irq0
    IRQ0_INTF: IRQ0_INTF = .{},
    /// Interrupt status after masking &amp; forcing for irq0
    IRQ0_INTS: IRQ0_INTS = .{},
    /// Interrupt Enable for irq1
    IRQ1_INTE: IRQ1_INTE = .{},
    /// Interrupt Force for irq1
    IRQ1_INTF: IRQ1_INTF = .{},
    /// Interrupt status after masking &amp; forcing for irq1
    IRQ1_INTS: IRQ1_INTS = .{},
};
pub const PIO1 = PIO1_p{};
