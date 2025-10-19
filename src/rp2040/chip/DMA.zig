const helpers = @import("helpers.zig");
/// DMA Channel 0 Read Address pointer
pub const CH0_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000000),
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
/// DMA Channel 0 Write Address pointer
pub const CH0_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000004),
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
/// DMA Channel 0 Transfer Count
pub const CH0_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000008),
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
/// DMA Channel 0 Control and Status
pub const CH0_CTRL_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000000c),
    pub const FieldMasks = struct {
        pub const AHB_ERROR: u32 = helpers.generateMask(31, 32);
        pub const READ_ERROR: u32 = helpers.generateMask(30, 31);
        pub const WRITE_ERROR: u32 = helpers.generateMask(29, 30);
        pub const BUSY: u32 = helpers.generateMask(24, 25);
        pub const SNIFF_EN: u32 = helpers.generateMask(23, 24);
        pub const BSWAP: u32 = helpers.generateMask(22, 23);
        pub const IRQ_QUIET: u32 = helpers.generateMask(21, 22);
        pub const TREQ_SEL: u32 = helpers.generateMask(15, 21);
        pub const CHAIN_TO: u32 = helpers.generateMask(11, 15);
        pub const RING_SEL: u32 = helpers.generateMask(10, 11);
        pub const RING_SIZE: u32 = helpers.generateMask(6, 10);
        pub const INCR_WRITE: u32 = helpers.generateMask(5, 6);
        pub const INCR_READ: u32 = helpers.generateMask(4, 5);
        pub const DATA_SIZE: u32 = helpers.generateMask(2, 4);
        pub const HIGH_PRIORITY: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const TREQ_SEL_e = enum(u6) {
        PIO0_TX0 = 0,
        PIO0_TX1 = 1,
        PIO0_TX2 = 2,
        PIO0_TX3 = 3,
        PIO0_RX0 = 4,
        PIO0_RX1 = 5,
        PIO0_RX2 = 6,
        PIO0_RX3 = 7,
        PIO1_TX0 = 8,
        PIO1_TX1 = 9,
        PIO1_TX2 = 10,
        PIO1_TX3 = 11,
        PIO1_RX0 = 12,
        PIO1_RX1 = 13,
        PIO1_RX2 = 14,
        PIO1_RX3 = 15,
        SPI0_TX = 16,
        SPI0_RX = 17,
        SPI1_TX = 18,
        SPI1_RX = 19,
        UART0_TX = 20,
        UART0_RX = 21,
        UART1_TX = 22,
        UART1_RX = 23,
        PWM_WRAP0 = 24,
        PWM_WRAP1 = 25,
        PWM_WRAP2 = 26,
        PWM_WRAP3 = 27,
        PWM_WRAP4 = 28,
        PWM_WRAP5 = 29,
        PWM_WRAP6 = 30,
        PWM_WRAP7 = 31,
        I2C0_TX = 32,
        I2C0_RX = 33,
        I2C1_TX = 34,
        I2C1_RX = 35,
        ADC = 36,
        XIP_STREAM = 37,
        XIP_SSITX = 38,
        XIP_SSIRX = 39,
        TIMER0 = 59,
        TIMER1 = 60,
        TIMER2 = 61,
        TIMER3 = 62,
        PERMANENT = 63,
    };
    const RING_SIZE_e = enum(u4) {
        RING_NONE = 0,
    };
    const DATA_SIZE_e = enum(u2) {
        SIZE_BYTE = 0,
        SIZE_HALFWORD = 1,
        SIZE_WORD = 2,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If 1, the channel received a read bus error. Write one to clear.
        /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
        pub fn READ_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// If 1, the channel received a write bus error. Write one to clear.
        /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
        pub fn WRITE_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
        ///
        /// This allows checksum to be enabled or disabled on a per-control- block basis.
        pub fn SNIFF_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        /// Apply byte-swap transformation to DMA data.
        /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
        pub fn BSWAP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
        ///
        /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
        pub fn IRQ_QUIET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        /// Select a Transfer Request signal.
        /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
        /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
        pub fn TREQ_SEL(self: Value, v: TREQ_SEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 21),
            };
        }
        /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
        pub fn CHAIN_TO(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 15),
            };
        }
        /// Select whether RING_SIZE applies to read or write addresses.
        /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
        pub fn RING_SEL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
        ///
        /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
        pub fn RING_SIZE(self: Value, v: RING_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 10),
            };
        }
        /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
        ///
        /// Generally this should be disabled for memory-to-peripheral transfers.
        pub fn INCR_WRITE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
        ///
        /// Generally this should be disabled for peripheral-to-memory transfers.
        pub fn INCR_READ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
        pub fn DATA_SIZE(self: Value, v: DATA_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 4),
            };
        }
        /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
        ///
        /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
        pub fn HIGH_PRIORITY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// DMA Channel Enable.
        /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn AHB_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn READ_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn WRITE_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn BUSY(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn SNIFF_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn BSWAP(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IRQ_QUIET(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn TREQ_SEL(self: Result) TREQ_SEL_e {
            const mask = comptime helpers.generateMask(15, 21);
            const val: @typeInfo(TREQ_SEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 15);
            return @enumFromInt(val);
        }
        pub fn CHAIN_TO(self: Result) u4 {
            const mask = comptime helpers.generateMask(11, 15);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn RING_SEL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn RING_SIZE(self: Result) RING_SIZE_e {
            const mask = comptime helpers.generateMask(6, 10);
            const val: @typeInfo(RING_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn INCR_WRITE(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn INCR_READ(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DATA_SIZE(self: Result) DATA_SIZE_e {
            const mask = comptime helpers.generateMask(2, 4);
            const val: @typeInfo(DATA_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn HIGH_PRIORITY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If 1, the channel received a read bus error. Write one to clear.
    /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
    pub fn READ_ERROR(v: u1) Value {
        return Value.READ_ERROR(.{}, v);
    }
    /// If 1, the channel received a write bus error. Write one to clear.
    /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
    pub fn WRITE_ERROR(v: u1) Value {
        return Value.WRITE_ERROR(.{}, v);
    }
    /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
    ///
    /// This allows checksum to be enabled or disabled on a per-control- block basis.
    pub fn SNIFF_EN(v: u1) Value {
        return Value.SNIFF_EN(.{}, v);
    }
    /// Apply byte-swap transformation to DMA data.
    /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
    pub fn BSWAP(v: u1) Value {
        return Value.BSWAP(.{}, v);
    }
    /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
    ///
    /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
    pub fn IRQ_QUIET(v: u1) Value {
        return Value.IRQ_QUIET(.{}, v);
    }
    /// Select a Transfer Request signal.
    /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
    /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
    pub fn TREQ_SEL(v: TREQ_SEL_e) Value {
        return Value.TREQ_SEL(.{}, v);
    }
    /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
    pub fn CHAIN_TO(v: u4) Value {
        return Value.CHAIN_TO(.{}, v);
    }
    /// Select whether RING_SIZE applies to read or write addresses.
    /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
    pub fn RING_SEL(v: u1) Value {
        return Value.RING_SEL(.{}, v);
    }
    /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
    ///
    /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
    pub fn RING_SIZE(v: RING_SIZE_e) Value {
        return Value.RING_SIZE(.{}, v);
    }
    /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
    ///
    /// Generally this should be disabled for memory-to-peripheral transfers.
    pub fn INCR_WRITE(v: u1) Value {
        return Value.INCR_WRITE(.{}, v);
    }
    /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
    ///
    /// Generally this should be disabled for peripheral-to-memory transfers.
    pub fn INCR_READ(v: u1) Value {
        return Value.INCR_READ(.{}, v);
    }
    /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
    pub fn DATA_SIZE(v: DATA_SIZE_e) Value {
        return Value.DATA_SIZE(.{}, v);
    }
    /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
    ///
    /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
    pub fn HIGH_PRIORITY(v: u1) Value {
        return Value.HIGH_PRIORITY(.{}, v);
    }
    /// DMA Channel Enable.
    /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
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
/// Alias for channel 0 CTRL register
pub const CH0_AL1_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000010),
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
/// Alias for channel 0 READ_ADDR register
pub const CH0_AL1_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000014),
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
/// Alias for channel 0 WRITE_ADDR register
pub const CH0_AL1_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000018),
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
/// Alias for channel 0 TRANS_COUNT register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH0_AL1_TRANS_COUNT_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000001c),
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
/// Alias for channel 0 CTRL register
pub const CH0_AL2_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000020),
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
/// Alias for channel 0 TRANS_COUNT register
pub const CH0_AL2_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000024),
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
/// Alias for channel 0 READ_ADDR register
pub const CH0_AL2_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000028),
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
/// Alias for channel 0 WRITE_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH0_AL2_WRITE_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000002c),
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
/// Alias for channel 0 CTRL register
pub const CH0_AL3_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000030),
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
/// Alias for channel 0 WRITE_ADDR register
pub const CH0_AL3_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000034),
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
/// Alias for channel 0 TRANS_COUNT register
pub const CH0_AL3_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000038),
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
/// Alias for channel 0 READ_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH0_AL3_READ_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000003c),
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
/// DMA Channel 1 Read Address pointer
pub const CH1_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000040),
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
/// DMA Channel 1 Write Address pointer
pub const CH1_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000044),
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
/// DMA Channel 1 Transfer Count
pub const CH1_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000048),
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
/// DMA Channel 1 Control and Status
pub const CH1_CTRL_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000004c),
    pub const FieldMasks = struct {
        pub const AHB_ERROR: u32 = helpers.generateMask(31, 32);
        pub const READ_ERROR: u32 = helpers.generateMask(30, 31);
        pub const WRITE_ERROR: u32 = helpers.generateMask(29, 30);
        pub const BUSY: u32 = helpers.generateMask(24, 25);
        pub const SNIFF_EN: u32 = helpers.generateMask(23, 24);
        pub const BSWAP: u32 = helpers.generateMask(22, 23);
        pub const IRQ_QUIET: u32 = helpers.generateMask(21, 22);
        pub const TREQ_SEL: u32 = helpers.generateMask(15, 21);
        pub const CHAIN_TO: u32 = helpers.generateMask(11, 15);
        pub const RING_SEL: u32 = helpers.generateMask(10, 11);
        pub const RING_SIZE: u32 = helpers.generateMask(6, 10);
        pub const INCR_WRITE: u32 = helpers.generateMask(5, 6);
        pub const INCR_READ: u32 = helpers.generateMask(4, 5);
        pub const DATA_SIZE: u32 = helpers.generateMask(2, 4);
        pub const HIGH_PRIORITY: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const TREQ_SEL_e = enum(u6) {
        PIO0_TX0 = 0,
        PIO0_TX1 = 1,
        PIO0_TX2 = 2,
        PIO0_TX3 = 3,
        PIO0_RX0 = 4,
        PIO0_RX1 = 5,
        PIO0_RX2 = 6,
        PIO0_RX3 = 7,
        PIO1_TX0 = 8,
        PIO1_TX1 = 9,
        PIO1_TX2 = 10,
        PIO1_TX3 = 11,
        PIO1_RX0 = 12,
        PIO1_RX1 = 13,
        PIO1_RX2 = 14,
        PIO1_RX3 = 15,
        SPI0_TX = 16,
        SPI0_RX = 17,
        SPI1_TX = 18,
        SPI1_RX = 19,
        UART0_TX = 20,
        UART0_RX = 21,
        UART1_TX = 22,
        UART1_RX = 23,
        PWM_WRAP0 = 24,
        PWM_WRAP1 = 25,
        PWM_WRAP2 = 26,
        PWM_WRAP3 = 27,
        PWM_WRAP4 = 28,
        PWM_WRAP5 = 29,
        PWM_WRAP6 = 30,
        PWM_WRAP7 = 31,
        I2C0_TX = 32,
        I2C0_RX = 33,
        I2C1_TX = 34,
        I2C1_RX = 35,
        ADC = 36,
        XIP_STREAM = 37,
        XIP_SSITX = 38,
        XIP_SSIRX = 39,
        TIMER0 = 59,
        TIMER1 = 60,
        TIMER2 = 61,
        TIMER3 = 62,
        PERMANENT = 63,
    };
    const RING_SIZE_e = enum(u4) {
        RING_NONE = 0,
    };
    const DATA_SIZE_e = enum(u2) {
        SIZE_BYTE = 0,
        SIZE_HALFWORD = 1,
        SIZE_WORD = 2,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If 1, the channel received a read bus error. Write one to clear.
        /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
        pub fn READ_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// If 1, the channel received a write bus error. Write one to clear.
        /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
        pub fn WRITE_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
        ///
        /// This allows checksum to be enabled or disabled on a per-control- block basis.
        pub fn SNIFF_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        /// Apply byte-swap transformation to DMA data.
        /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
        pub fn BSWAP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
        ///
        /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
        pub fn IRQ_QUIET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        /// Select a Transfer Request signal.
        /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
        /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
        pub fn TREQ_SEL(self: Value, v: TREQ_SEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 21),
            };
        }
        /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
        pub fn CHAIN_TO(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 15),
            };
        }
        /// Select whether RING_SIZE applies to read or write addresses.
        /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
        pub fn RING_SEL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
        ///
        /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
        pub fn RING_SIZE(self: Value, v: RING_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 10),
            };
        }
        /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
        ///
        /// Generally this should be disabled for memory-to-peripheral transfers.
        pub fn INCR_WRITE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
        ///
        /// Generally this should be disabled for peripheral-to-memory transfers.
        pub fn INCR_READ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
        pub fn DATA_SIZE(self: Value, v: DATA_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 4),
            };
        }
        /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
        ///
        /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
        pub fn HIGH_PRIORITY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// DMA Channel Enable.
        /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn AHB_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn READ_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn WRITE_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn BUSY(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn SNIFF_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn BSWAP(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IRQ_QUIET(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn TREQ_SEL(self: Result) TREQ_SEL_e {
            const mask = comptime helpers.generateMask(15, 21);
            const val: @typeInfo(TREQ_SEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 15);
            return @enumFromInt(val);
        }
        pub fn CHAIN_TO(self: Result) u4 {
            const mask = comptime helpers.generateMask(11, 15);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn RING_SEL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn RING_SIZE(self: Result) RING_SIZE_e {
            const mask = comptime helpers.generateMask(6, 10);
            const val: @typeInfo(RING_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn INCR_WRITE(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn INCR_READ(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DATA_SIZE(self: Result) DATA_SIZE_e {
            const mask = comptime helpers.generateMask(2, 4);
            const val: @typeInfo(DATA_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn HIGH_PRIORITY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If 1, the channel received a read bus error. Write one to clear.
    /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
    pub fn READ_ERROR(v: u1) Value {
        return Value.READ_ERROR(.{}, v);
    }
    /// If 1, the channel received a write bus error. Write one to clear.
    /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
    pub fn WRITE_ERROR(v: u1) Value {
        return Value.WRITE_ERROR(.{}, v);
    }
    /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
    ///
    /// This allows checksum to be enabled or disabled on a per-control- block basis.
    pub fn SNIFF_EN(v: u1) Value {
        return Value.SNIFF_EN(.{}, v);
    }
    /// Apply byte-swap transformation to DMA data.
    /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
    pub fn BSWAP(v: u1) Value {
        return Value.BSWAP(.{}, v);
    }
    /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
    ///
    /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
    pub fn IRQ_QUIET(v: u1) Value {
        return Value.IRQ_QUIET(.{}, v);
    }
    /// Select a Transfer Request signal.
    /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
    /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
    pub fn TREQ_SEL(v: TREQ_SEL_e) Value {
        return Value.TREQ_SEL(.{}, v);
    }
    /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
    pub fn CHAIN_TO(v: u4) Value {
        return Value.CHAIN_TO(.{}, v);
    }
    /// Select whether RING_SIZE applies to read or write addresses.
    /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
    pub fn RING_SEL(v: u1) Value {
        return Value.RING_SEL(.{}, v);
    }
    /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
    ///
    /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
    pub fn RING_SIZE(v: RING_SIZE_e) Value {
        return Value.RING_SIZE(.{}, v);
    }
    /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
    ///
    /// Generally this should be disabled for memory-to-peripheral transfers.
    pub fn INCR_WRITE(v: u1) Value {
        return Value.INCR_WRITE(.{}, v);
    }
    /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
    ///
    /// Generally this should be disabled for peripheral-to-memory transfers.
    pub fn INCR_READ(v: u1) Value {
        return Value.INCR_READ(.{}, v);
    }
    /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
    pub fn DATA_SIZE(v: DATA_SIZE_e) Value {
        return Value.DATA_SIZE(.{}, v);
    }
    /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
    ///
    /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
    pub fn HIGH_PRIORITY(v: u1) Value {
        return Value.HIGH_PRIORITY(.{}, v);
    }
    /// DMA Channel Enable.
    /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
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
/// Alias for channel 1 CTRL register
pub const CH1_AL1_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000050),
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
/// Alias for channel 1 READ_ADDR register
pub const CH1_AL1_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000054),
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
/// Alias for channel 1 WRITE_ADDR register
pub const CH1_AL1_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000058),
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
/// Alias for channel 1 TRANS_COUNT register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH1_AL1_TRANS_COUNT_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000005c),
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
/// Alias for channel 1 CTRL register
pub const CH1_AL2_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000060),
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
/// Alias for channel 1 TRANS_COUNT register
pub const CH1_AL2_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000064),
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
/// Alias for channel 1 READ_ADDR register
pub const CH1_AL2_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000068),
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
/// Alias for channel 1 WRITE_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH1_AL2_WRITE_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000006c),
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
/// Alias for channel 1 CTRL register
pub const CH1_AL3_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000070),
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
/// Alias for channel 1 WRITE_ADDR register
pub const CH1_AL3_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000074),
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
/// Alias for channel 1 TRANS_COUNT register
pub const CH1_AL3_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000078),
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
/// Alias for channel 1 READ_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH1_AL3_READ_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000007c),
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
/// DMA Channel 2 Read Address pointer
pub const CH2_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000080),
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
/// DMA Channel 2 Write Address pointer
pub const CH2_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000084),
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
/// DMA Channel 2 Transfer Count
pub const CH2_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000088),
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
/// DMA Channel 2 Control and Status
pub const CH2_CTRL_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000008c),
    pub const FieldMasks = struct {
        pub const AHB_ERROR: u32 = helpers.generateMask(31, 32);
        pub const READ_ERROR: u32 = helpers.generateMask(30, 31);
        pub const WRITE_ERROR: u32 = helpers.generateMask(29, 30);
        pub const BUSY: u32 = helpers.generateMask(24, 25);
        pub const SNIFF_EN: u32 = helpers.generateMask(23, 24);
        pub const BSWAP: u32 = helpers.generateMask(22, 23);
        pub const IRQ_QUIET: u32 = helpers.generateMask(21, 22);
        pub const TREQ_SEL: u32 = helpers.generateMask(15, 21);
        pub const CHAIN_TO: u32 = helpers.generateMask(11, 15);
        pub const RING_SEL: u32 = helpers.generateMask(10, 11);
        pub const RING_SIZE: u32 = helpers.generateMask(6, 10);
        pub const INCR_WRITE: u32 = helpers.generateMask(5, 6);
        pub const INCR_READ: u32 = helpers.generateMask(4, 5);
        pub const DATA_SIZE: u32 = helpers.generateMask(2, 4);
        pub const HIGH_PRIORITY: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const TREQ_SEL_e = enum(u6) {
        PIO0_TX0 = 0,
        PIO0_TX1 = 1,
        PIO0_TX2 = 2,
        PIO0_TX3 = 3,
        PIO0_RX0 = 4,
        PIO0_RX1 = 5,
        PIO0_RX2 = 6,
        PIO0_RX3 = 7,
        PIO1_TX0 = 8,
        PIO1_TX1 = 9,
        PIO1_TX2 = 10,
        PIO1_TX3 = 11,
        PIO1_RX0 = 12,
        PIO1_RX1 = 13,
        PIO1_RX2 = 14,
        PIO1_RX3 = 15,
        SPI0_TX = 16,
        SPI0_RX = 17,
        SPI1_TX = 18,
        SPI1_RX = 19,
        UART0_TX = 20,
        UART0_RX = 21,
        UART1_TX = 22,
        UART1_RX = 23,
        PWM_WRAP0 = 24,
        PWM_WRAP1 = 25,
        PWM_WRAP2 = 26,
        PWM_WRAP3 = 27,
        PWM_WRAP4 = 28,
        PWM_WRAP5 = 29,
        PWM_WRAP6 = 30,
        PWM_WRAP7 = 31,
        I2C0_TX = 32,
        I2C0_RX = 33,
        I2C1_TX = 34,
        I2C1_RX = 35,
        ADC = 36,
        XIP_STREAM = 37,
        XIP_SSITX = 38,
        XIP_SSIRX = 39,
        TIMER0 = 59,
        TIMER1 = 60,
        TIMER2 = 61,
        TIMER3 = 62,
        PERMANENT = 63,
    };
    const RING_SIZE_e = enum(u4) {
        RING_NONE = 0,
    };
    const DATA_SIZE_e = enum(u2) {
        SIZE_BYTE = 0,
        SIZE_HALFWORD = 1,
        SIZE_WORD = 2,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If 1, the channel received a read bus error. Write one to clear.
        /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
        pub fn READ_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// If 1, the channel received a write bus error. Write one to clear.
        /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
        pub fn WRITE_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
        ///
        /// This allows checksum to be enabled or disabled on a per-control- block basis.
        pub fn SNIFF_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        /// Apply byte-swap transformation to DMA data.
        /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
        pub fn BSWAP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
        ///
        /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
        pub fn IRQ_QUIET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        /// Select a Transfer Request signal.
        /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
        /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
        pub fn TREQ_SEL(self: Value, v: TREQ_SEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 21),
            };
        }
        /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
        pub fn CHAIN_TO(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 15),
            };
        }
        /// Select whether RING_SIZE applies to read or write addresses.
        /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
        pub fn RING_SEL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
        ///
        /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
        pub fn RING_SIZE(self: Value, v: RING_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 10),
            };
        }
        /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
        ///
        /// Generally this should be disabled for memory-to-peripheral transfers.
        pub fn INCR_WRITE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
        ///
        /// Generally this should be disabled for peripheral-to-memory transfers.
        pub fn INCR_READ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
        pub fn DATA_SIZE(self: Value, v: DATA_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 4),
            };
        }
        /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
        ///
        /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
        pub fn HIGH_PRIORITY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// DMA Channel Enable.
        /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn AHB_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn READ_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn WRITE_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn BUSY(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn SNIFF_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn BSWAP(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IRQ_QUIET(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn TREQ_SEL(self: Result) TREQ_SEL_e {
            const mask = comptime helpers.generateMask(15, 21);
            const val: @typeInfo(TREQ_SEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 15);
            return @enumFromInt(val);
        }
        pub fn CHAIN_TO(self: Result) u4 {
            const mask = comptime helpers.generateMask(11, 15);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn RING_SEL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn RING_SIZE(self: Result) RING_SIZE_e {
            const mask = comptime helpers.generateMask(6, 10);
            const val: @typeInfo(RING_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn INCR_WRITE(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn INCR_READ(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DATA_SIZE(self: Result) DATA_SIZE_e {
            const mask = comptime helpers.generateMask(2, 4);
            const val: @typeInfo(DATA_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn HIGH_PRIORITY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If 1, the channel received a read bus error. Write one to clear.
    /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
    pub fn READ_ERROR(v: u1) Value {
        return Value.READ_ERROR(.{}, v);
    }
    /// If 1, the channel received a write bus error. Write one to clear.
    /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
    pub fn WRITE_ERROR(v: u1) Value {
        return Value.WRITE_ERROR(.{}, v);
    }
    /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
    ///
    /// This allows checksum to be enabled or disabled on a per-control- block basis.
    pub fn SNIFF_EN(v: u1) Value {
        return Value.SNIFF_EN(.{}, v);
    }
    /// Apply byte-swap transformation to DMA data.
    /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
    pub fn BSWAP(v: u1) Value {
        return Value.BSWAP(.{}, v);
    }
    /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
    ///
    /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
    pub fn IRQ_QUIET(v: u1) Value {
        return Value.IRQ_QUIET(.{}, v);
    }
    /// Select a Transfer Request signal.
    /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
    /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
    pub fn TREQ_SEL(v: TREQ_SEL_e) Value {
        return Value.TREQ_SEL(.{}, v);
    }
    /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
    pub fn CHAIN_TO(v: u4) Value {
        return Value.CHAIN_TO(.{}, v);
    }
    /// Select whether RING_SIZE applies to read or write addresses.
    /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
    pub fn RING_SEL(v: u1) Value {
        return Value.RING_SEL(.{}, v);
    }
    /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
    ///
    /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
    pub fn RING_SIZE(v: RING_SIZE_e) Value {
        return Value.RING_SIZE(.{}, v);
    }
    /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
    ///
    /// Generally this should be disabled for memory-to-peripheral transfers.
    pub fn INCR_WRITE(v: u1) Value {
        return Value.INCR_WRITE(.{}, v);
    }
    /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
    ///
    /// Generally this should be disabled for peripheral-to-memory transfers.
    pub fn INCR_READ(v: u1) Value {
        return Value.INCR_READ(.{}, v);
    }
    /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
    pub fn DATA_SIZE(v: DATA_SIZE_e) Value {
        return Value.DATA_SIZE(.{}, v);
    }
    /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
    ///
    /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
    pub fn HIGH_PRIORITY(v: u1) Value {
        return Value.HIGH_PRIORITY(.{}, v);
    }
    /// DMA Channel Enable.
    /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
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
/// Alias for channel 2 CTRL register
pub const CH2_AL1_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000090),
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
/// Alias for channel 2 READ_ADDR register
pub const CH2_AL1_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000094),
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
/// Alias for channel 2 WRITE_ADDR register
pub const CH2_AL1_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000098),
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
/// Alias for channel 2 TRANS_COUNT register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH2_AL1_TRANS_COUNT_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000009c),
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
/// Alias for channel 2 CTRL register
pub const CH2_AL2_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000a0),
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
/// Alias for channel 2 TRANS_COUNT register
pub const CH2_AL2_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000a4),
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
/// Alias for channel 2 READ_ADDR register
pub const CH2_AL2_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000a8),
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
/// Alias for channel 2 WRITE_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH2_AL2_WRITE_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000ac),
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
/// Alias for channel 2 CTRL register
pub const CH2_AL3_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000b0),
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
/// Alias for channel 2 WRITE_ADDR register
pub const CH2_AL3_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000b4),
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
/// Alias for channel 2 TRANS_COUNT register
pub const CH2_AL3_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000b8),
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
/// Alias for channel 2 READ_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH2_AL3_READ_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000bc),
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
/// DMA Channel 3 Read Address pointer
pub const CH3_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000c0),
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
/// DMA Channel 3 Write Address pointer
pub const CH3_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000c4),
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
/// DMA Channel 3 Transfer Count
pub const CH3_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000c8),
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
/// DMA Channel 3 Control and Status
pub const CH3_CTRL_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000cc),
    pub const FieldMasks = struct {
        pub const AHB_ERROR: u32 = helpers.generateMask(31, 32);
        pub const READ_ERROR: u32 = helpers.generateMask(30, 31);
        pub const WRITE_ERROR: u32 = helpers.generateMask(29, 30);
        pub const BUSY: u32 = helpers.generateMask(24, 25);
        pub const SNIFF_EN: u32 = helpers.generateMask(23, 24);
        pub const BSWAP: u32 = helpers.generateMask(22, 23);
        pub const IRQ_QUIET: u32 = helpers.generateMask(21, 22);
        pub const TREQ_SEL: u32 = helpers.generateMask(15, 21);
        pub const CHAIN_TO: u32 = helpers.generateMask(11, 15);
        pub const RING_SEL: u32 = helpers.generateMask(10, 11);
        pub const RING_SIZE: u32 = helpers.generateMask(6, 10);
        pub const INCR_WRITE: u32 = helpers.generateMask(5, 6);
        pub const INCR_READ: u32 = helpers.generateMask(4, 5);
        pub const DATA_SIZE: u32 = helpers.generateMask(2, 4);
        pub const HIGH_PRIORITY: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const TREQ_SEL_e = enum(u6) {
        PIO0_TX0 = 0,
        PIO0_TX1 = 1,
        PIO0_TX2 = 2,
        PIO0_TX3 = 3,
        PIO0_RX0 = 4,
        PIO0_RX1 = 5,
        PIO0_RX2 = 6,
        PIO0_RX3 = 7,
        PIO1_TX0 = 8,
        PIO1_TX1 = 9,
        PIO1_TX2 = 10,
        PIO1_TX3 = 11,
        PIO1_RX0 = 12,
        PIO1_RX1 = 13,
        PIO1_RX2 = 14,
        PIO1_RX3 = 15,
        SPI0_TX = 16,
        SPI0_RX = 17,
        SPI1_TX = 18,
        SPI1_RX = 19,
        UART0_TX = 20,
        UART0_RX = 21,
        UART1_TX = 22,
        UART1_RX = 23,
        PWM_WRAP0 = 24,
        PWM_WRAP1 = 25,
        PWM_WRAP2 = 26,
        PWM_WRAP3 = 27,
        PWM_WRAP4 = 28,
        PWM_WRAP5 = 29,
        PWM_WRAP6 = 30,
        PWM_WRAP7 = 31,
        I2C0_TX = 32,
        I2C0_RX = 33,
        I2C1_TX = 34,
        I2C1_RX = 35,
        ADC = 36,
        XIP_STREAM = 37,
        XIP_SSITX = 38,
        XIP_SSIRX = 39,
        TIMER0 = 59,
        TIMER1 = 60,
        TIMER2 = 61,
        TIMER3 = 62,
        PERMANENT = 63,
    };
    const RING_SIZE_e = enum(u4) {
        RING_NONE = 0,
    };
    const DATA_SIZE_e = enum(u2) {
        SIZE_BYTE = 0,
        SIZE_HALFWORD = 1,
        SIZE_WORD = 2,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If 1, the channel received a read bus error. Write one to clear.
        /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
        pub fn READ_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// If 1, the channel received a write bus error. Write one to clear.
        /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
        pub fn WRITE_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
        ///
        /// This allows checksum to be enabled or disabled on a per-control- block basis.
        pub fn SNIFF_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        /// Apply byte-swap transformation to DMA data.
        /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
        pub fn BSWAP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
        ///
        /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
        pub fn IRQ_QUIET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        /// Select a Transfer Request signal.
        /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
        /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
        pub fn TREQ_SEL(self: Value, v: TREQ_SEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 21),
            };
        }
        /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
        pub fn CHAIN_TO(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 15),
            };
        }
        /// Select whether RING_SIZE applies to read or write addresses.
        /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
        pub fn RING_SEL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
        ///
        /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
        pub fn RING_SIZE(self: Value, v: RING_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 10),
            };
        }
        /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
        ///
        /// Generally this should be disabled for memory-to-peripheral transfers.
        pub fn INCR_WRITE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
        ///
        /// Generally this should be disabled for peripheral-to-memory transfers.
        pub fn INCR_READ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
        pub fn DATA_SIZE(self: Value, v: DATA_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 4),
            };
        }
        /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
        ///
        /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
        pub fn HIGH_PRIORITY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// DMA Channel Enable.
        /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn AHB_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn READ_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn WRITE_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn BUSY(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn SNIFF_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn BSWAP(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IRQ_QUIET(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn TREQ_SEL(self: Result) TREQ_SEL_e {
            const mask = comptime helpers.generateMask(15, 21);
            const val: @typeInfo(TREQ_SEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 15);
            return @enumFromInt(val);
        }
        pub fn CHAIN_TO(self: Result) u4 {
            const mask = comptime helpers.generateMask(11, 15);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn RING_SEL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn RING_SIZE(self: Result) RING_SIZE_e {
            const mask = comptime helpers.generateMask(6, 10);
            const val: @typeInfo(RING_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn INCR_WRITE(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn INCR_READ(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DATA_SIZE(self: Result) DATA_SIZE_e {
            const mask = comptime helpers.generateMask(2, 4);
            const val: @typeInfo(DATA_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn HIGH_PRIORITY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If 1, the channel received a read bus error. Write one to clear.
    /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
    pub fn READ_ERROR(v: u1) Value {
        return Value.READ_ERROR(.{}, v);
    }
    /// If 1, the channel received a write bus error. Write one to clear.
    /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
    pub fn WRITE_ERROR(v: u1) Value {
        return Value.WRITE_ERROR(.{}, v);
    }
    /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
    ///
    /// This allows checksum to be enabled or disabled on a per-control- block basis.
    pub fn SNIFF_EN(v: u1) Value {
        return Value.SNIFF_EN(.{}, v);
    }
    /// Apply byte-swap transformation to DMA data.
    /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
    pub fn BSWAP(v: u1) Value {
        return Value.BSWAP(.{}, v);
    }
    /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
    ///
    /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
    pub fn IRQ_QUIET(v: u1) Value {
        return Value.IRQ_QUIET(.{}, v);
    }
    /// Select a Transfer Request signal.
    /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
    /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
    pub fn TREQ_SEL(v: TREQ_SEL_e) Value {
        return Value.TREQ_SEL(.{}, v);
    }
    /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
    pub fn CHAIN_TO(v: u4) Value {
        return Value.CHAIN_TO(.{}, v);
    }
    /// Select whether RING_SIZE applies to read or write addresses.
    /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
    pub fn RING_SEL(v: u1) Value {
        return Value.RING_SEL(.{}, v);
    }
    /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
    ///
    /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
    pub fn RING_SIZE(v: RING_SIZE_e) Value {
        return Value.RING_SIZE(.{}, v);
    }
    /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
    ///
    /// Generally this should be disabled for memory-to-peripheral transfers.
    pub fn INCR_WRITE(v: u1) Value {
        return Value.INCR_WRITE(.{}, v);
    }
    /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
    ///
    /// Generally this should be disabled for peripheral-to-memory transfers.
    pub fn INCR_READ(v: u1) Value {
        return Value.INCR_READ(.{}, v);
    }
    /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
    pub fn DATA_SIZE(v: DATA_SIZE_e) Value {
        return Value.DATA_SIZE(.{}, v);
    }
    /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
    ///
    /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
    pub fn HIGH_PRIORITY(v: u1) Value {
        return Value.HIGH_PRIORITY(.{}, v);
    }
    /// DMA Channel Enable.
    /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
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
/// Alias for channel 3 CTRL register
pub const CH3_AL1_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000d0),
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
/// Alias for channel 3 READ_ADDR register
pub const CH3_AL1_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000d4),
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
/// Alias for channel 3 WRITE_ADDR register
pub const CH3_AL1_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000d8),
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
/// Alias for channel 3 TRANS_COUNT register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH3_AL1_TRANS_COUNT_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000dc),
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
/// Alias for channel 3 CTRL register
pub const CH3_AL2_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000e0),
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
/// Alias for channel 3 TRANS_COUNT register
pub const CH3_AL2_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000e4),
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
/// Alias for channel 3 READ_ADDR register
pub const CH3_AL2_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000e8),
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
/// Alias for channel 3 WRITE_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH3_AL2_WRITE_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000ec),
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
/// Alias for channel 3 CTRL register
pub const CH3_AL3_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000f0),
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
/// Alias for channel 3 WRITE_ADDR register
pub const CH3_AL3_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000f4),
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
/// Alias for channel 3 TRANS_COUNT register
pub const CH3_AL3_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000f8),
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
/// Alias for channel 3 READ_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH3_AL3_READ_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500000fc),
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
/// DMA Channel 4 Read Address pointer
pub const CH4_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000100),
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
/// DMA Channel 4 Write Address pointer
pub const CH4_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000104),
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
/// DMA Channel 4 Transfer Count
pub const CH4_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000108),
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
/// DMA Channel 4 Control and Status
pub const CH4_CTRL_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000010c),
    pub const FieldMasks = struct {
        pub const AHB_ERROR: u32 = helpers.generateMask(31, 32);
        pub const READ_ERROR: u32 = helpers.generateMask(30, 31);
        pub const WRITE_ERROR: u32 = helpers.generateMask(29, 30);
        pub const BUSY: u32 = helpers.generateMask(24, 25);
        pub const SNIFF_EN: u32 = helpers.generateMask(23, 24);
        pub const BSWAP: u32 = helpers.generateMask(22, 23);
        pub const IRQ_QUIET: u32 = helpers.generateMask(21, 22);
        pub const TREQ_SEL: u32 = helpers.generateMask(15, 21);
        pub const CHAIN_TO: u32 = helpers.generateMask(11, 15);
        pub const RING_SEL: u32 = helpers.generateMask(10, 11);
        pub const RING_SIZE: u32 = helpers.generateMask(6, 10);
        pub const INCR_WRITE: u32 = helpers.generateMask(5, 6);
        pub const INCR_READ: u32 = helpers.generateMask(4, 5);
        pub const DATA_SIZE: u32 = helpers.generateMask(2, 4);
        pub const HIGH_PRIORITY: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const TREQ_SEL_e = enum(u6) {
        PIO0_TX0 = 0,
        PIO0_TX1 = 1,
        PIO0_TX2 = 2,
        PIO0_TX3 = 3,
        PIO0_RX0 = 4,
        PIO0_RX1 = 5,
        PIO0_RX2 = 6,
        PIO0_RX3 = 7,
        PIO1_TX0 = 8,
        PIO1_TX1 = 9,
        PIO1_TX2 = 10,
        PIO1_TX3 = 11,
        PIO1_RX0 = 12,
        PIO1_RX1 = 13,
        PIO1_RX2 = 14,
        PIO1_RX3 = 15,
        SPI0_TX = 16,
        SPI0_RX = 17,
        SPI1_TX = 18,
        SPI1_RX = 19,
        UART0_TX = 20,
        UART0_RX = 21,
        UART1_TX = 22,
        UART1_RX = 23,
        PWM_WRAP0 = 24,
        PWM_WRAP1 = 25,
        PWM_WRAP2 = 26,
        PWM_WRAP3 = 27,
        PWM_WRAP4 = 28,
        PWM_WRAP5 = 29,
        PWM_WRAP6 = 30,
        PWM_WRAP7 = 31,
        I2C0_TX = 32,
        I2C0_RX = 33,
        I2C1_TX = 34,
        I2C1_RX = 35,
        ADC = 36,
        XIP_STREAM = 37,
        XIP_SSITX = 38,
        XIP_SSIRX = 39,
        TIMER0 = 59,
        TIMER1 = 60,
        TIMER2 = 61,
        TIMER3 = 62,
        PERMANENT = 63,
    };
    const RING_SIZE_e = enum(u4) {
        RING_NONE = 0,
    };
    const DATA_SIZE_e = enum(u2) {
        SIZE_BYTE = 0,
        SIZE_HALFWORD = 1,
        SIZE_WORD = 2,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If 1, the channel received a read bus error. Write one to clear.
        /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
        pub fn READ_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// If 1, the channel received a write bus error. Write one to clear.
        /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
        pub fn WRITE_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
        ///
        /// This allows checksum to be enabled or disabled on a per-control- block basis.
        pub fn SNIFF_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        /// Apply byte-swap transformation to DMA data.
        /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
        pub fn BSWAP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
        ///
        /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
        pub fn IRQ_QUIET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        /// Select a Transfer Request signal.
        /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
        /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
        pub fn TREQ_SEL(self: Value, v: TREQ_SEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 21),
            };
        }
        /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
        pub fn CHAIN_TO(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 15),
            };
        }
        /// Select whether RING_SIZE applies to read or write addresses.
        /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
        pub fn RING_SEL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
        ///
        /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
        pub fn RING_SIZE(self: Value, v: RING_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 10),
            };
        }
        /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
        ///
        /// Generally this should be disabled for memory-to-peripheral transfers.
        pub fn INCR_WRITE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
        ///
        /// Generally this should be disabled for peripheral-to-memory transfers.
        pub fn INCR_READ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
        pub fn DATA_SIZE(self: Value, v: DATA_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 4),
            };
        }
        /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
        ///
        /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
        pub fn HIGH_PRIORITY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// DMA Channel Enable.
        /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn AHB_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn READ_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn WRITE_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn BUSY(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn SNIFF_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn BSWAP(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IRQ_QUIET(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn TREQ_SEL(self: Result) TREQ_SEL_e {
            const mask = comptime helpers.generateMask(15, 21);
            const val: @typeInfo(TREQ_SEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 15);
            return @enumFromInt(val);
        }
        pub fn CHAIN_TO(self: Result) u4 {
            const mask = comptime helpers.generateMask(11, 15);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn RING_SEL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn RING_SIZE(self: Result) RING_SIZE_e {
            const mask = comptime helpers.generateMask(6, 10);
            const val: @typeInfo(RING_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn INCR_WRITE(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn INCR_READ(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DATA_SIZE(self: Result) DATA_SIZE_e {
            const mask = comptime helpers.generateMask(2, 4);
            const val: @typeInfo(DATA_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn HIGH_PRIORITY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If 1, the channel received a read bus error. Write one to clear.
    /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
    pub fn READ_ERROR(v: u1) Value {
        return Value.READ_ERROR(.{}, v);
    }
    /// If 1, the channel received a write bus error. Write one to clear.
    /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
    pub fn WRITE_ERROR(v: u1) Value {
        return Value.WRITE_ERROR(.{}, v);
    }
    /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
    ///
    /// This allows checksum to be enabled or disabled on a per-control- block basis.
    pub fn SNIFF_EN(v: u1) Value {
        return Value.SNIFF_EN(.{}, v);
    }
    /// Apply byte-swap transformation to DMA data.
    /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
    pub fn BSWAP(v: u1) Value {
        return Value.BSWAP(.{}, v);
    }
    /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
    ///
    /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
    pub fn IRQ_QUIET(v: u1) Value {
        return Value.IRQ_QUIET(.{}, v);
    }
    /// Select a Transfer Request signal.
    /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
    /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
    pub fn TREQ_SEL(v: TREQ_SEL_e) Value {
        return Value.TREQ_SEL(.{}, v);
    }
    /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
    pub fn CHAIN_TO(v: u4) Value {
        return Value.CHAIN_TO(.{}, v);
    }
    /// Select whether RING_SIZE applies to read or write addresses.
    /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
    pub fn RING_SEL(v: u1) Value {
        return Value.RING_SEL(.{}, v);
    }
    /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
    ///
    /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
    pub fn RING_SIZE(v: RING_SIZE_e) Value {
        return Value.RING_SIZE(.{}, v);
    }
    /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
    ///
    /// Generally this should be disabled for memory-to-peripheral transfers.
    pub fn INCR_WRITE(v: u1) Value {
        return Value.INCR_WRITE(.{}, v);
    }
    /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
    ///
    /// Generally this should be disabled for peripheral-to-memory transfers.
    pub fn INCR_READ(v: u1) Value {
        return Value.INCR_READ(.{}, v);
    }
    /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
    pub fn DATA_SIZE(v: DATA_SIZE_e) Value {
        return Value.DATA_SIZE(.{}, v);
    }
    /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
    ///
    /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
    pub fn HIGH_PRIORITY(v: u1) Value {
        return Value.HIGH_PRIORITY(.{}, v);
    }
    /// DMA Channel Enable.
    /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
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
/// Alias for channel 4 CTRL register
pub const CH4_AL1_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000110),
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
/// Alias for channel 4 READ_ADDR register
pub const CH4_AL1_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000114),
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
/// Alias for channel 4 WRITE_ADDR register
pub const CH4_AL1_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000118),
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
/// Alias for channel 4 TRANS_COUNT register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH4_AL1_TRANS_COUNT_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000011c),
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
/// Alias for channel 4 CTRL register
pub const CH4_AL2_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000120),
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
/// Alias for channel 4 TRANS_COUNT register
pub const CH4_AL2_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000124),
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
/// Alias for channel 4 READ_ADDR register
pub const CH4_AL2_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000128),
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
/// Alias for channel 4 WRITE_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH4_AL2_WRITE_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000012c),
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
/// Alias for channel 4 CTRL register
pub const CH4_AL3_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000130),
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
/// Alias for channel 4 WRITE_ADDR register
pub const CH4_AL3_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000134),
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
/// Alias for channel 4 TRANS_COUNT register
pub const CH4_AL3_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000138),
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
/// Alias for channel 4 READ_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH4_AL3_READ_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000013c),
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
/// DMA Channel 5 Read Address pointer
pub const CH5_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000140),
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
/// DMA Channel 5 Write Address pointer
pub const CH5_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000144),
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
/// DMA Channel 5 Transfer Count
pub const CH5_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000148),
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
/// DMA Channel 5 Control and Status
pub const CH5_CTRL_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000014c),
    pub const FieldMasks = struct {
        pub const AHB_ERROR: u32 = helpers.generateMask(31, 32);
        pub const READ_ERROR: u32 = helpers.generateMask(30, 31);
        pub const WRITE_ERROR: u32 = helpers.generateMask(29, 30);
        pub const BUSY: u32 = helpers.generateMask(24, 25);
        pub const SNIFF_EN: u32 = helpers.generateMask(23, 24);
        pub const BSWAP: u32 = helpers.generateMask(22, 23);
        pub const IRQ_QUIET: u32 = helpers.generateMask(21, 22);
        pub const TREQ_SEL: u32 = helpers.generateMask(15, 21);
        pub const CHAIN_TO: u32 = helpers.generateMask(11, 15);
        pub const RING_SEL: u32 = helpers.generateMask(10, 11);
        pub const RING_SIZE: u32 = helpers.generateMask(6, 10);
        pub const INCR_WRITE: u32 = helpers.generateMask(5, 6);
        pub const INCR_READ: u32 = helpers.generateMask(4, 5);
        pub const DATA_SIZE: u32 = helpers.generateMask(2, 4);
        pub const HIGH_PRIORITY: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const TREQ_SEL_e = enum(u6) {
        PIO0_TX0 = 0,
        PIO0_TX1 = 1,
        PIO0_TX2 = 2,
        PIO0_TX3 = 3,
        PIO0_RX0 = 4,
        PIO0_RX1 = 5,
        PIO0_RX2 = 6,
        PIO0_RX3 = 7,
        PIO1_TX0 = 8,
        PIO1_TX1 = 9,
        PIO1_TX2 = 10,
        PIO1_TX3 = 11,
        PIO1_RX0 = 12,
        PIO1_RX1 = 13,
        PIO1_RX2 = 14,
        PIO1_RX3 = 15,
        SPI0_TX = 16,
        SPI0_RX = 17,
        SPI1_TX = 18,
        SPI1_RX = 19,
        UART0_TX = 20,
        UART0_RX = 21,
        UART1_TX = 22,
        UART1_RX = 23,
        PWM_WRAP0 = 24,
        PWM_WRAP1 = 25,
        PWM_WRAP2 = 26,
        PWM_WRAP3 = 27,
        PWM_WRAP4 = 28,
        PWM_WRAP5 = 29,
        PWM_WRAP6 = 30,
        PWM_WRAP7 = 31,
        I2C0_TX = 32,
        I2C0_RX = 33,
        I2C1_TX = 34,
        I2C1_RX = 35,
        ADC = 36,
        XIP_STREAM = 37,
        XIP_SSITX = 38,
        XIP_SSIRX = 39,
        TIMER0 = 59,
        TIMER1 = 60,
        TIMER2 = 61,
        TIMER3 = 62,
        PERMANENT = 63,
    };
    const RING_SIZE_e = enum(u4) {
        RING_NONE = 0,
    };
    const DATA_SIZE_e = enum(u2) {
        SIZE_BYTE = 0,
        SIZE_HALFWORD = 1,
        SIZE_WORD = 2,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If 1, the channel received a read bus error. Write one to clear.
        /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
        pub fn READ_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// If 1, the channel received a write bus error. Write one to clear.
        /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
        pub fn WRITE_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
        ///
        /// This allows checksum to be enabled or disabled on a per-control- block basis.
        pub fn SNIFF_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        /// Apply byte-swap transformation to DMA data.
        /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
        pub fn BSWAP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
        ///
        /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
        pub fn IRQ_QUIET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        /// Select a Transfer Request signal.
        /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
        /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
        pub fn TREQ_SEL(self: Value, v: TREQ_SEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 21),
            };
        }
        /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
        pub fn CHAIN_TO(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 15),
            };
        }
        /// Select whether RING_SIZE applies to read or write addresses.
        /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
        pub fn RING_SEL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
        ///
        /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
        pub fn RING_SIZE(self: Value, v: RING_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 10),
            };
        }
        /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
        ///
        /// Generally this should be disabled for memory-to-peripheral transfers.
        pub fn INCR_WRITE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
        ///
        /// Generally this should be disabled for peripheral-to-memory transfers.
        pub fn INCR_READ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
        pub fn DATA_SIZE(self: Value, v: DATA_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 4),
            };
        }
        /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
        ///
        /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
        pub fn HIGH_PRIORITY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// DMA Channel Enable.
        /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn AHB_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn READ_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn WRITE_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn BUSY(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn SNIFF_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn BSWAP(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IRQ_QUIET(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn TREQ_SEL(self: Result) TREQ_SEL_e {
            const mask = comptime helpers.generateMask(15, 21);
            const val: @typeInfo(TREQ_SEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 15);
            return @enumFromInt(val);
        }
        pub fn CHAIN_TO(self: Result) u4 {
            const mask = comptime helpers.generateMask(11, 15);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn RING_SEL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn RING_SIZE(self: Result) RING_SIZE_e {
            const mask = comptime helpers.generateMask(6, 10);
            const val: @typeInfo(RING_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn INCR_WRITE(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn INCR_READ(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DATA_SIZE(self: Result) DATA_SIZE_e {
            const mask = comptime helpers.generateMask(2, 4);
            const val: @typeInfo(DATA_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn HIGH_PRIORITY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If 1, the channel received a read bus error. Write one to clear.
    /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
    pub fn READ_ERROR(v: u1) Value {
        return Value.READ_ERROR(.{}, v);
    }
    /// If 1, the channel received a write bus error. Write one to clear.
    /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
    pub fn WRITE_ERROR(v: u1) Value {
        return Value.WRITE_ERROR(.{}, v);
    }
    /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
    ///
    /// This allows checksum to be enabled or disabled on a per-control- block basis.
    pub fn SNIFF_EN(v: u1) Value {
        return Value.SNIFF_EN(.{}, v);
    }
    /// Apply byte-swap transformation to DMA data.
    /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
    pub fn BSWAP(v: u1) Value {
        return Value.BSWAP(.{}, v);
    }
    /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
    ///
    /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
    pub fn IRQ_QUIET(v: u1) Value {
        return Value.IRQ_QUIET(.{}, v);
    }
    /// Select a Transfer Request signal.
    /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
    /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
    pub fn TREQ_SEL(v: TREQ_SEL_e) Value {
        return Value.TREQ_SEL(.{}, v);
    }
    /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
    pub fn CHAIN_TO(v: u4) Value {
        return Value.CHAIN_TO(.{}, v);
    }
    /// Select whether RING_SIZE applies to read or write addresses.
    /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
    pub fn RING_SEL(v: u1) Value {
        return Value.RING_SEL(.{}, v);
    }
    /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
    ///
    /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
    pub fn RING_SIZE(v: RING_SIZE_e) Value {
        return Value.RING_SIZE(.{}, v);
    }
    /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
    ///
    /// Generally this should be disabled for memory-to-peripheral transfers.
    pub fn INCR_WRITE(v: u1) Value {
        return Value.INCR_WRITE(.{}, v);
    }
    /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
    ///
    /// Generally this should be disabled for peripheral-to-memory transfers.
    pub fn INCR_READ(v: u1) Value {
        return Value.INCR_READ(.{}, v);
    }
    /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
    pub fn DATA_SIZE(v: DATA_SIZE_e) Value {
        return Value.DATA_SIZE(.{}, v);
    }
    /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
    ///
    /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
    pub fn HIGH_PRIORITY(v: u1) Value {
        return Value.HIGH_PRIORITY(.{}, v);
    }
    /// DMA Channel Enable.
    /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
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
/// Alias for channel 5 CTRL register
pub const CH5_AL1_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000150),
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
/// Alias for channel 5 READ_ADDR register
pub const CH5_AL1_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000154),
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
/// Alias for channel 5 WRITE_ADDR register
pub const CH5_AL1_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000158),
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
/// Alias for channel 5 TRANS_COUNT register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH5_AL1_TRANS_COUNT_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000015c),
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
/// Alias for channel 5 CTRL register
pub const CH5_AL2_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000160),
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
/// Alias for channel 5 TRANS_COUNT register
pub const CH5_AL2_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000164),
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
/// Alias for channel 5 READ_ADDR register
pub const CH5_AL2_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000168),
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
/// Alias for channel 5 WRITE_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH5_AL2_WRITE_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000016c),
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
/// Alias for channel 5 CTRL register
pub const CH5_AL3_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000170),
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
/// Alias for channel 5 WRITE_ADDR register
pub const CH5_AL3_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000174),
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
/// Alias for channel 5 TRANS_COUNT register
pub const CH5_AL3_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000178),
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
/// Alias for channel 5 READ_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH5_AL3_READ_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000017c),
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
/// DMA Channel 6 Read Address pointer
pub const CH6_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000180),
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
/// DMA Channel 6 Write Address pointer
pub const CH6_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000184),
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
/// DMA Channel 6 Transfer Count
pub const CH6_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000188),
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
/// DMA Channel 6 Control and Status
pub const CH6_CTRL_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000018c),
    pub const FieldMasks = struct {
        pub const AHB_ERROR: u32 = helpers.generateMask(31, 32);
        pub const READ_ERROR: u32 = helpers.generateMask(30, 31);
        pub const WRITE_ERROR: u32 = helpers.generateMask(29, 30);
        pub const BUSY: u32 = helpers.generateMask(24, 25);
        pub const SNIFF_EN: u32 = helpers.generateMask(23, 24);
        pub const BSWAP: u32 = helpers.generateMask(22, 23);
        pub const IRQ_QUIET: u32 = helpers.generateMask(21, 22);
        pub const TREQ_SEL: u32 = helpers.generateMask(15, 21);
        pub const CHAIN_TO: u32 = helpers.generateMask(11, 15);
        pub const RING_SEL: u32 = helpers.generateMask(10, 11);
        pub const RING_SIZE: u32 = helpers.generateMask(6, 10);
        pub const INCR_WRITE: u32 = helpers.generateMask(5, 6);
        pub const INCR_READ: u32 = helpers.generateMask(4, 5);
        pub const DATA_SIZE: u32 = helpers.generateMask(2, 4);
        pub const HIGH_PRIORITY: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const TREQ_SEL_e = enum(u6) {
        PIO0_TX0 = 0,
        PIO0_TX1 = 1,
        PIO0_TX2 = 2,
        PIO0_TX3 = 3,
        PIO0_RX0 = 4,
        PIO0_RX1 = 5,
        PIO0_RX2 = 6,
        PIO0_RX3 = 7,
        PIO1_TX0 = 8,
        PIO1_TX1 = 9,
        PIO1_TX2 = 10,
        PIO1_TX3 = 11,
        PIO1_RX0 = 12,
        PIO1_RX1 = 13,
        PIO1_RX2 = 14,
        PIO1_RX3 = 15,
        SPI0_TX = 16,
        SPI0_RX = 17,
        SPI1_TX = 18,
        SPI1_RX = 19,
        UART0_TX = 20,
        UART0_RX = 21,
        UART1_TX = 22,
        UART1_RX = 23,
        PWM_WRAP0 = 24,
        PWM_WRAP1 = 25,
        PWM_WRAP2 = 26,
        PWM_WRAP3 = 27,
        PWM_WRAP4 = 28,
        PWM_WRAP5 = 29,
        PWM_WRAP6 = 30,
        PWM_WRAP7 = 31,
        I2C0_TX = 32,
        I2C0_RX = 33,
        I2C1_TX = 34,
        I2C1_RX = 35,
        ADC = 36,
        XIP_STREAM = 37,
        XIP_SSITX = 38,
        XIP_SSIRX = 39,
        TIMER0 = 59,
        TIMER1 = 60,
        TIMER2 = 61,
        TIMER3 = 62,
        PERMANENT = 63,
    };
    const RING_SIZE_e = enum(u4) {
        RING_NONE = 0,
    };
    const DATA_SIZE_e = enum(u2) {
        SIZE_BYTE = 0,
        SIZE_HALFWORD = 1,
        SIZE_WORD = 2,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If 1, the channel received a read bus error. Write one to clear.
        /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
        pub fn READ_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// If 1, the channel received a write bus error. Write one to clear.
        /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
        pub fn WRITE_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
        ///
        /// This allows checksum to be enabled or disabled on a per-control- block basis.
        pub fn SNIFF_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        /// Apply byte-swap transformation to DMA data.
        /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
        pub fn BSWAP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
        ///
        /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
        pub fn IRQ_QUIET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        /// Select a Transfer Request signal.
        /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
        /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
        pub fn TREQ_SEL(self: Value, v: TREQ_SEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 21),
            };
        }
        /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
        pub fn CHAIN_TO(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 15),
            };
        }
        /// Select whether RING_SIZE applies to read or write addresses.
        /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
        pub fn RING_SEL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
        ///
        /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
        pub fn RING_SIZE(self: Value, v: RING_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 10),
            };
        }
        /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
        ///
        /// Generally this should be disabled for memory-to-peripheral transfers.
        pub fn INCR_WRITE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
        ///
        /// Generally this should be disabled for peripheral-to-memory transfers.
        pub fn INCR_READ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
        pub fn DATA_SIZE(self: Value, v: DATA_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 4),
            };
        }
        /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
        ///
        /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
        pub fn HIGH_PRIORITY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// DMA Channel Enable.
        /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn AHB_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn READ_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn WRITE_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn BUSY(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn SNIFF_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn BSWAP(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IRQ_QUIET(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn TREQ_SEL(self: Result) TREQ_SEL_e {
            const mask = comptime helpers.generateMask(15, 21);
            const val: @typeInfo(TREQ_SEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 15);
            return @enumFromInt(val);
        }
        pub fn CHAIN_TO(self: Result) u4 {
            const mask = comptime helpers.generateMask(11, 15);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn RING_SEL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn RING_SIZE(self: Result) RING_SIZE_e {
            const mask = comptime helpers.generateMask(6, 10);
            const val: @typeInfo(RING_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn INCR_WRITE(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn INCR_READ(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DATA_SIZE(self: Result) DATA_SIZE_e {
            const mask = comptime helpers.generateMask(2, 4);
            const val: @typeInfo(DATA_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn HIGH_PRIORITY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If 1, the channel received a read bus error. Write one to clear.
    /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
    pub fn READ_ERROR(v: u1) Value {
        return Value.READ_ERROR(.{}, v);
    }
    /// If 1, the channel received a write bus error. Write one to clear.
    /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
    pub fn WRITE_ERROR(v: u1) Value {
        return Value.WRITE_ERROR(.{}, v);
    }
    /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
    ///
    /// This allows checksum to be enabled or disabled on a per-control- block basis.
    pub fn SNIFF_EN(v: u1) Value {
        return Value.SNIFF_EN(.{}, v);
    }
    /// Apply byte-swap transformation to DMA data.
    /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
    pub fn BSWAP(v: u1) Value {
        return Value.BSWAP(.{}, v);
    }
    /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
    ///
    /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
    pub fn IRQ_QUIET(v: u1) Value {
        return Value.IRQ_QUIET(.{}, v);
    }
    /// Select a Transfer Request signal.
    /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
    /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
    pub fn TREQ_SEL(v: TREQ_SEL_e) Value {
        return Value.TREQ_SEL(.{}, v);
    }
    /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
    pub fn CHAIN_TO(v: u4) Value {
        return Value.CHAIN_TO(.{}, v);
    }
    /// Select whether RING_SIZE applies to read or write addresses.
    /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
    pub fn RING_SEL(v: u1) Value {
        return Value.RING_SEL(.{}, v);
    }
    /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
    ///
    /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
    pub fn RING_SIZE(v: RING_SIZE_e) Value {
        return Value.RING_SIZE(.{}, v);
    }
    /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
    ///
    /// Generally this should be disabled for memory-to-peripheral transfers.
    pub fn INCR_WRITE(v: u1) Value {
        return Value.INCR_WRITE(.{}, v);
    }
    /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
    ///
    /// Generally this should be disabled for peripheral-to-memory transfers.
    pub fn INCR_READ(v: u1) Value {
        return Value.INCR_READ(.{}, v);
    }
    /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
    pub fn DATA_SIZE(v: DATA_SIZE_e) Value {
        return Value.DATA_SIZE(.{}, v);
    }
    /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
    ///
    /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
    pub fn HIGH_PRIORITY(v: u1) Value {
        return Value.HIGH_PRIORITY(.{}, v);
    }
    /// DMA Channel Enable.
    /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
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
/// Alias for channel 6 CTRL register
pub const CH6_AL1_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000190),
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
/// Alias for channel 6 READ_ADDR register
pub const CH6_AL1_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000194),
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
/// Alias for channel 6 WRITE_ADDR register
pub const CH6_AL1_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000198),
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
/// Alias for channel 6 TRANS_COUNT register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH6_AL1_TRANS_COUNT_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000019c),
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
/// Alias for channel 6 CTRL register
pub const CH6_AL2_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001a0),
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
/// Alias for channel 6 TRANS_COUNT register
pub const CH6_AL2_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001a4),
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
/// Alias for channel 6 READ_ADDR register
pub const CH6_AL2_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001a8),
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
/// Alias for channel 6 WRITE_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH6_AL2_WRITE_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001ac),
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
/// Alias for channel 6 CTRL register
pub const CH6_AL3_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001b0),
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
/// Alias for channel 6 WRITE_ADDR register
pub const CH6_AL3_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001b4),
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
/// Alias for channel 6 TRANS_COUNT register
pub const CH6_AL3_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001b8),
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
/// Alias for channel 6 READ_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH6_AL3_READ_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001bc),
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
/// DMA Channel 7 Read Address pointer
pub const CH7_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001c0),
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
/// DMA Channel 7 Write Address pointer
pub const CH7_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001c4),
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
/// DMA Channel 7 Transfer Count
pub const CH7_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001c8),
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
/// DMA Channel 7 Control and Status
pub const CH7_CTRL_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001cc),
    pub const FieldMasks = struct {
        pub const AHB_ERROR: u32 = helpers.generateMask(31, 32);
        pub const READ_ERROR: u32 = helpers.generateMask(30, 31);
        pub const WRITE_ERROR: u32 = helpers.generateMask(29, 30);
        pub const BUSY: u32 = helpers.generateMask(24, 25);
        pub const SNIFF_EN: u32 = helpers.generateMask(23, 24);
        pub const BSWAP: u32 = helpers.generateMask(22, 23);
        pub const IRQ_QUIET: u32 = helpers.generateMask(21, 22);
        pub const TREQ_SEL: u32 = helpers.generateMask(15, 21);
        pub const CHAIN_TO: u32 = helpers.generateMask(11, 15);
        pub const RING_SEL: u32 = helpers.generateMask(10, 11);
        pub const RING_SIZE: u32 = helpers.generateMask(6, 10);
        pub const INCR_WRITE: u32 = helpers.generateMask(5, 6);
        pub const INCR_READ: u32 = helpers.generateMask(4, 5);
        pub const DATA_SIZE: u32 = helpers.generateMask(2, 4);
        pub const HIGH_PRIORITY: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const TREQ_SEL_e = enum(u6) {
        PIO0_TX0 = 0,
        PIO0_TX1 = 1,
        PIO0_TX2 = 2,
        PIO0_TX3 = 3,
        PIO0_RX0 = 4,
        PIO0_RX1 = 5,
        PIO0_RX2 = 6,
        PIO0_RX3 = 7,
        PIO1_TX0 = 8,
        PIO1_TX1 = 9,
        PIO1_TX2 = 10,
        PIO1_TX3 = 11,
        PIO1_RX0 = 12,
        PIO1_RX1 = 13,
        PIO1_RX2 = 14,
        PIO1_RX3 = 15,
        SPI0_TX = 16,
        SPI0_RX = 17,
        SPI1_TX = 18,
        SPI1_RX = 19,
        UART0_TX = 20,
        UART0_RX = 21,
        UART1_TX = 22,
        UART1_RX = 23,
        PWM_WRAP0 = 24,
        PWM_WRAP1 = 25,
        PWM_WRAP2 = 26,
        PWM_WRAP3 = 27,
        PWM_WRAP4 = 28,
        PWM_WRAP5 = 29,
        PWM_WRAP6 = 30,
        PWM_WRAP7 = 31,
        I2C0_TX = 32,
        I2C0_RX = 33,
        I2C1_TX = 34,
        I2C1_RX = 35,
        ADC = 36,
        XIP_STREAM = 37,
        XIP_SSITX = 38,
        XIP_SSIRX = 39,
        TIMER0 = 59,
        TIMER1 = 60,
        TIMER2 = 61,
        TIMER3 = 62,
        PERMANENT = 63,
    };
    const RING_SIZE_e = enum(u4) {
        RING_NONE = 0,
    };
    const DATA_SIZE_e = enum(u2) {
        SIZE_BYTE = 0,
        SIZE_HALFWORD = 1,
        SIZE_WORD = 2,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If 1, the channel received a read bus error. Write one to clear.
        /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
        pub fn READ_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// If 1, the channel received a write bus error. Write one to clear.
        /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
        pub fn WRITE_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
        ///
        /// This allows checksum to be enabled or disabled on a per-control- block basis.
        pub fn SNIFF_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        /// Apply byte-swap transformation to DMA data.
        /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
        pub fn BSWAP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
        ///
        /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
        pub fn IRQ_QUIET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        /// Select a Transfer Request signal.
        /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
        /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
        pub fn TREQ_SEL(self: Value, v: TREQ_SEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 21),
            };
        }
        /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
        pub fn CHAIN_TO(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 15),
            };
        }
        /// Select whether RING_SIZE applies to read or write addresses.
        /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
        pub fn RING_SEL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
        ///
        /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
        pub fn RING_SIZE(self: Value, v: RING_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 10),
            };
        }
        /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
        ///
        /// Generally this should be disabled for memory-to-peripheral transfers.
        pub fn INCR_WRITE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
        ///
        /// Generally this should be disabled for peripheral-to-memory transfers.
        pub fn INCR_READ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
        pub fn DATA_SIZE(self: Value, v: DATA_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 4),
            };
        }
        /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
        ///
        /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
        pub fn HIGH_PRIORITY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// DMA Channel Enable.
        /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn AHB_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn READ_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn WRITE_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn BUSY(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn SNIFF_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn BSWAP(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IRQ_QUIET(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn TREQ_SEL(self: Result) TREQ_SEL_e {
            const mask = comptime helpers.generateMask(15, 21);
            const val: @typeInfo(TREQ_SEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 15);
            return @enumFromInt(val);
        }
        pub fn CHAIN_TO(self: Result) u4 {
            const mask = comptime helpers.generateMask(11, 15);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn RING_SEL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn RING_SIZE(self: Result) RING_SIZE_e {
            const mask = comptime helpers.generateMask(6, 10);
            const val: @typeInfo(RING_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn INCR_WRITE(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn INCR_READ(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DATA_SIZE(self: Result) DATA_SIZE_e {
            const mask = comptime helpers.generateMask(2, 4);
            const val: @typeInfo(DATA_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn HIGH_PRIORITY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If 1, the channel received a read bus error. Write one to clear.
    /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
    pub fn READ_ERROR(v: u1) Value {
        return Value.READ_ERROR(.{}, v);
    }
    /// If 1, the channel received a write bus error. Write one to clear.
    /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
    pub fn WRITE_ERROR(v: u1) Value {
        return Value.WRITE_ERROR(.{}, v);
    }
    /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
    ///
    /// This allows checksum to be enabled or disabled on a per-control- block basis.
    pub fn SNIFF_EN(v: u1) Value {
        return Value.SNIFF_EN(.{}, v);
    }
    /// Apply byte-swap transformation to DMA data.
    /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
    pub fn BSWAP(v: u1) Value {
        return Value.BSWAP(.{}, v);
    }
    /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
    ///
    /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
    pub fn IRQ_QUIET(v: u1) Value {
        return Value.IRQ_QUIET(.{}, v);
    }
    /// Select a Transfer Request signal.
    /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
    /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
    pub fn TREQ_SEL(v: TREQ_SEL_e) Value {
        return Value.TREQ_SEL(.{}, v);
    }
    /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
    pub fn CHAIN_TO(v: u4) Value {
        return Value.CHAIN_TO(.{}, v);
    }
    /// Select whether RING_SIZE applies to read or write addresses.
    /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
    pub fn RING_SEL(v: u1) Value {
        return Value.RING_SEL(.{}, v);
    }
    /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
    ///
    /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
    pub fn RING_SIZE(v: RING_SIZE_e) Value {
        return Value.RING_SIZE(.{}, v);
    }
    /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
    ///
    /// Generally this should be disabled for memory-to-peripheral transfers.
    pub fn INCR_WRITE(v: u1) Value {
        return Value.INCR_WRITE(.{}, v);
    }
    /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
    ///
    /// Generally this should be disabled for peripheral-to-memory transfers.
    pub fn INCR_READ(v: u1) Value {
        return Value.INCR_READ(.{}, v);
    }
    /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
    pub fn DATA_SIZE(v: DATA_SIZE_e) Value {
        return Value.DATA_SIZE(.{}, v);
    }
    /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
    ///
    /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
    pub fn HIGH_PRIORITY(v: u1) Value {
        return Value.HIGH_PRIORITY(.{}, v);
    }
    /// DMA Channel Enable.
    /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
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
/// Alias for channel 7 CTRL register
pub const CH7_AL1_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001d0),
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
/// Alias for channel 7 READ_ADDR register
pub const CH7_AL1_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001d4),
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
/// Alias for channel 7 WRITE_ADDR register
pub const CH7_AL1_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001d8),
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
/// Alias for channel 7 TRANS_COUNT register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH7_AL1_TRANS_COUNT_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001dc),
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
/// Alias for channel 7 CTRL register
pub const CH7_AL2_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001e0),
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
/// Alias for channel 7 TRANS_COUNT register
pub const CH7_AL2_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001e4),
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
/// Alias for channel 7 READ_ADDR register
pub const CH7_AL2_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001e8),
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
/// Alias for channel 7 WRITE_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH7_AL2_WRITE_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001ec),
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
/// Alias for channel 7 CTRL register
pub const CH7_AL3_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001f0),
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
/// Alias for channel 7 WRITE_ADDR register
pub const CH7_AL3_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001f4),
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
/// Alias for channel 7 TRANS_COUNT register
pub const CH7_AL3_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001f8),
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
/// Alias for channel 7 READ_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH7_AL3_READ_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500001fc),
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
/// DMA Channel 8 Read Address pointer
pub const CH8_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000200),
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
/// DMA Channel 8 Write Address pointer
pub const CH8_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000204),
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
/// DMA Channel 8 Transfer Count
pub const CH8_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000208),
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
/// DMA Channel 8 Control and Status
pub const CH8_CTRL_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000020c),
    pub const FieldMasks = struct {
        pub const AHB_ERROR: u32 = helpers.generateMask(31, 32);
        pub const READ_ERROR: u32 = helpers.generateMask(30, 31);
        pub const WRITE_ERROR: u32 = helpers.generateMask(29, 30);
        pub const BUSY: u32 = helpers.generateMask(24, 25);
        pub const SNIFF_EN: u32 = helpers.generateMask(23, 24);
        pub const BSWAP: u32 = helpers.generateMask(22, 23);
        pub const IRQ_QUIET: u32 = helpers.generateMask(21, 22);
        pub const TREQ_SEL: u32 = helpers.generateMask(15, 21);
        pub const CHAIN_TO: u32 = helpers.generateMask(11, 15);
        pub const RING_SEL: u32 = helpers.generateMask(10, 11);
        pub const RING_SIZE: u32 = helpers.generateMask(6, 10);
        pub const INCR_WRITE: u32 = helpers.generateMask(5, 6);
        pub const INCR_READ: u32 = helpers.generateMask(4, 5);
        pub const DATA_SIZE: u32 = helpers.generateMask(2, 4);
        pub const HIGH_PRIORITY: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const TREQ_SEL_e = enum(u6) {
        PIO0_TX0 = 0,
        PIO0_TX1 = 1,
        PIO0_TX2 = 2,
        PIO0_TX3 = 3,
        PIO0_RX0 = 4,
        PIO0_RX1 = 5,
        PIO0_RX2 = 6,
        PIO0_RX3 = 7,
        PIO1_TX0 = 8,
        PIO1_TX1 = 9,
        PIO1_TX2 = 10,
        PIO1_TX3 = 11,
        PIO1_RX0 = 12,
        PIO1_RX1 = 13,
        PIO1_RX2 = 14,
        PIO1_RX3 = 15,
        SPI0_TX = 16,
        SPI0_RX = 17,
        SPI1_TX = 18,
        SPI1_RX = 19,
        UART0_TX = 20,
        UART0_RX = 21,
        UART1_TX = 22,
        UART1_RX = 23,
        PWM_WRAP0 = 24,
        PWM_WRAP1 = 25,
        PWM_WRAP2 = 26,
        PWM_WRAP3 = 27,
        PWM_WRAP4 = 28,
        PWM_WRAP5 = 29,
        PWM_WRAP6 = 30,
        PWM_WRAP7 = 31,
        I2C0_TX = 32,
        I2C0_RX = 33,
        I2C1_TX = 34,
        I2C1_RX = 35,
        ADC = 36,
        XIP_STREAM = 37,
        XIP_SSITX = 38,
        XIP_SSIRX = 39,
        TIMER0 = 59,
        TIMER1 = 60,
        TIMER2 = 61,
        TIMER3 = 62,
        PERMANENT = 63,
    };
    const RING_SIZE_e = enum(u4) {
        RING_NONE = 0,
    };
    const DATA_SIZE_e = enum(u2) {
        SIZE_BYTE = 0,
        SIZE_HALFWORD = 1,
        SIZE_WORD = 2,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If 1, the channel received a read bus error. Write one to clear.
        /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
        pub fn READ_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// If 1, the channel received a write bus error. Write one to clear.
        /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
        pub fn WRITE_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
        ///
        /// This allows checksum to be enabled or disabled on a per-control- block basis.
        pub fn SNIFF_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        /// Apply byte-swap transformation to DMA data.
        /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
        pub fn BSWAP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
        ///
        /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
        pub fn IRQ_QUIET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        /// Select a Transfer Request signal.
        /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
        /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
        pub fn TREQ_SEL(self: Value, v: TREQ_SEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 21),
            };
        }
        /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
        pub fn CHAIN_TO(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 15),
            };
        }
        /// Select whether RING_SIZE applies to read or write addresses.
        /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
        pub fn RING_SEL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
        ///
        /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
        pub fn RING_SIZE(self: Value, v: RING_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 10),
            };
        }
        /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
        ///
        /// Generally this should be disabled for memory-to-peripheral transfers.
        pub fn INCR_WRITE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
        ///
        /// Generally this should be disabled for peripheral-to-memory transfers.
        pub fn INCR_READ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
        pub fn DATA_SIZE(self: Value, v: DATA_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 4),
            };
        }
        /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
        ///
        /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
        pub fn HIGH_PRIORITY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// DMA Channel Enable.
        /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn AHB_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn READ_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn WRITE_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn BUSY(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn SNIFF_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn BSWAP(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IRQ_QUIET(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn TREQ_SEL(self: Result) TREQ_SEL_e {
            const mask = comptime helpers.generateMask(15, 21);
            const val: @typeInfo(TREQ_SEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 15);
            return @enumFromInt(val);
        }
        pub fn CHAIN_TO(self: Result) u4 {
            const mask = comptime helpers.generateMask(11, 15);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn RING_SEL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn RING_SIZE(self: Result) RING_SIZE_e {
            const mask = comptime helpers.generateMask(6, 10);
            const val: @typeInfo(RING_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn INCR_WRITE(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn INCR_READ(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DATA_SIZE(self: Result) DATA_SIZE_e {
            const mask = comptime helpers.generateMask(2, 4);
            const val: @typeInfo(DATA_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn HIGH_PRIORITY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If 1, the channel received a read bus error. Write one to clear.
    /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
    pub fn READ_ERROR(v: u1) Value {
        return Value.READ_ERROR(.{}, v);
    }
    /// If 1, the channel received a write bus error. Write one to clear.
    /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
    pub fn WRITE_ERROR(v: u1) Value {
        return Value.WRITE_ERROR(.{}, v);
    }
    /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
    ///
    /// This allows checksum to be enabled or disabled on a per-control- block basis.
    pub fn SNIFF_EN(v: u1) Value {
        return Value.SNIFF_EN(.{}, v);
    }
    /// Apply byte-swap transformation to DMA data.
    /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
    pub fn BSWAP(v: u1) Value {
        return Value.BSWAP(.{}, v);
    }
    /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
    ///
    /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
    pub fn IRQ_QUIET(v: u1) Value {
        return Value.IRQ_QUIET(.{}, v);
    }
    /// Select a Transfer Request signal.
    /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
    /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
    pub fn TREQ_SEL(v: TREQ_SEL_e) Value {
        return Value.TREQ_SEL(.{}, v);
    }
    /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
    pub fn CHAIN_TO(v: u4) Value {
        return Value.CHAIN_TO(.{}, v);
    }
    /// Select whether RING_SIZE applies to read or write addresses.
    /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
    pub fn RING_SEL(v: u1) Value {
        return Value.RING_SEL(.{}, v);
    }
    /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
    ///
    /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
    pub fn RING_SIZE(v: RING_SIZE_e) Value {
        return Value.RING_SIZE(.{}, v);
    }
    /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
    ///
    /// Generally this should be disabled for memory-to-peripheral transfers.
    pub fn INCR_WRITE(v: u1) Value {
        return Value.INCR_WRITE(.{}, v);
    }
    /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
    ///
    /// Generally this should be disabled for peripheral-to-memory transfers.
    pub fn INCR_READ(v: u1) Value {
        return Value.INCR_READ(.{}, v);
    }
    /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
    pub fn DATA_SIZE(v: DATA_SIZE_e) Value {
        return Value.DATA_SIZE(.{}, v);
    }
    /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
    ///
    /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
    pub fn HIGH_PRIORITY(v: u1) Value {
        return Value.HIGH_PRIORITY(.{}, v);
    }
    /// DMA Channel Enable.
    /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
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
/// Alias for channel 8 CTRL register
pub const CH8_AL1_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000210),
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
/// Alias for channel 8 READ_ADDR register
pub const CH8_AL1_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000214),
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
/// Alias for channel 8 WRITE_ADDR register
pub const CH8_AL1_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000218),
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
/// Alias for channel 8 TRANS_COUNT register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH8_AL1_TRANS_COUNT_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000021c),
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
/// Alias for channel 8 CTRL register
pub const CH8_AL2_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000220),
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
/// Alias for channel 8 TRANS_COUNT register
pub const CH8_AL2_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000224),
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
/// Alias for channel 8 READ_ADDR register
pub const CH8_AL2_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000228),
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
/// Alias for channel 8 WRITE_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH8_AL2_WRITE_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000022c),
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
/// Alias for channel 8 CTRL register
pub const CH8_AL3_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000230),
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
/// Alias for channel 8 WRITE_ADDR register
pub const CH8_AL3_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000234),
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
/// Alias for channel 8 TRANS_COUNT register
pub const CH8_AL3_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000238),
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
/// Alias for channel 8 READ_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH8_AL3_READ_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000023c),
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
/// DMA Channel 9 Read Address pointer
pub const CH9_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000240),
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
/// DMA Channel 9 Write Address pointer
pub const CH9_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000244),
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
/// DMA Channel 9 Transfer Count
pub const CH9_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000248),
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
/// DMA Channel 9 Control and Status
pub const CH9_CTRL_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000024c),
    pub const FieldMasks = struct {
        pub const AHB_ERROR: u32 = helpers.generateMask(31, 32);
        pub const READ_ERROR: u32 = helpers.generateMask(30, 31);
        pub const WRITE_ERROR: u32 = helpers.generateMask(29, 30);
        pub const BUSY: u32 = helpers.generateMask(24, 25);
        pub const SNIFF_EN: u32 = helpers.generateMask(23, 24);
        pub const BSWAP: u32 = helpers.generateMask(22, 23);
        pub const IRQ_QUIET: u32 = helpers.generateMask(21, 22);
        pub const TREQ_SEL: u32 = helpers.generateMask(15, 21);
        pub const CHAIN_TO: u32 = helpers.generateMask(11, 15);
        pub const RING_SEL: u32 = helpers.generateMask(10, 11);
        pub const RING_SIZE: u32 = helpers.generateMask(6, 10);
        pub const INCR_WRITE: u32 = helpers.generateMask(5, 6);
        pub const INCR_READ: u32 = helpers.generateMask(4, 5);
        pub const DATA_SIZE: u32 = helpers.generateMask(2, 4);
        pub const HIGH_PRIORITY: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const TREQ_SEL_e = enum(u6) {
        PIO0_TX0 = 0,
        PIO0_TX1 = 1,
        PIO0_TX2 = 2,
        PIO0_TX3 = 3,
        PIO0_RX0 = 4,
        PIO0_RX1 = 5,
        PIO0_RX2 = 6,
        PIO0_RX3 = 7,
        PIO1_TX0 = 8,
        PIO1_TX1 = 9,
        PIO1_TX2 = 10,
        PIO1_TX3 = 11,
        PIO1_RX0 = 12,
        PIO1_RX1 = 13,
        PIO1_RX2 = 14,
        PIO1_RX3 = 15,
        SPI0_TX = 16,
        SPI0_RX = 17,
        SPI1_TX = 18,
        SPI1_RX = 19,
        UART0_TX = 20,
        UART0_RX = 21,
        UART1_TX = 22,
        UART1_RX = 23,
        PWM_WRAP0 = 24,
        PWM_WRAP1 = 25,
        PWM_WRAP2 = 26,
        PWM_WRAP3 = 27,
        PWM_WRAP4 = 28,
        PWM_WRAP5 = 29,
        PWM_WRAP6 = 30,
        PWM_WRAP7 = 31,
        I2C0_TX = 32,
        I2C0_RX = 33,
        I2C1_TX = 34,
        I2C1_RX = 35,
        ADC = 36,
        XIP_STREAM = 37,
        XIP_SSITX = 38,
        XIP_SSIRX = 39,
        TIMER0 = 59,
        TIMER1 = 60,
        TIMER2 = 61,
        TIMER3 = 62,
        PERMANENT = 63,
    };
    const RING_SIZE_e = enum(u4) {
        RING_NONE = 0,
    };
    const DATA_SIZE_e = enum(u2) {
        SIZE_BYTE = 0,
        SIZE_HALFWORD = 1,
        SIZE_WORD = 2,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If 1, the channel received a read bus error. Write one to clear.
        /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
        pub fn READ_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// If 1, the channel received a write bus error. Write one to clear.
        /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
        pub fn WRITE_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
        ///
        /// This allows checksum to be enabled or disabled on a per-control- block basis.
        pub fn SNIFF_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        /// Apply byte-swap transformation to DMA data.
        /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
        pub fn BSWAP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
        ///
        /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
        pub fn IRQ_QUIET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        /// Select a Transfer Request signal.
        /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
        /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
        pub fn TREQ_SEL(self: Value, v: TREQ_SEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 21),
            };
        }
        /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
        pub fn CHAIN_TO(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 15),
            };
        }
        /// Select whether RING_SIZE applies to read or write addresses.
        /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
        pub fn RING_SEL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
        ///
        /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
        pub fn RING_SIZE(self: Value, v: RING_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 10),
            };
        }
        /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
        ///
        /// Generally this should be disabled for memory-to-peripheral transfers.
        pub fn INCR_WRITE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
        ///
        /// Generally this should be disabled for peripheral-to-memory transfers.
        pub fn INCR_READ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
        pub fn DATA_SIZE(self: Value, v: DATA_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 4),
            };
        }
        /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
        ///
        /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
        pub fn HIGH_PRIORITY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// DMA Channel Enable.
        /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn AHB_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn READ_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn WRITE_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn BUSY(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn SNIFF_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn BSWAP(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IRQ_QUIET(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn TREQ_SEL(self: Result) TREQ_SEL_e {
            const mask = comptime helpers.generateMask(15, 21);
            const val: @typeInfo(TREQ_SEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 15);
            return @enumFromInt(val);
        }
        pub fn CHAIN_TO(self: Result) u4 {
            const mask = comptime helpers.generateMask(11, 15);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn RING_SEL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn RING_SIZE(self: Result) RING_SIZE_e {
            const mask = comptime helpers.generateMask(6, 10);
            const val: @typeInfo(RING_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn INCR_WRITE(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn INCR_READ(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DATA_SIZE(self: Result) DATA_SIZE_e {
            const mask = comptime helpers.generateMask(2, 4);
            const val: @typeInfo(DATA_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn HIGH_PRIORITY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If 1, the channel received a read bus error. Write one to clear.
    /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
    pub fn READ_ERROR(v: u1) Value {
        return Value.READ_ERROR(.{}, v);
    }
    /// If 1, the channel received a write bus error. Write one to clear.
    /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
    pub fn WRITE_ERROR(v: u1) Value {
        return Value.WRITE_ERROR(.{}, v);
    }
    /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
    ///
    /// This allows checksum to be enabled or disabled on a per-control- block basis.
    pub fn SNIFF_EN(v: u1) Value {
        return Value.SNIFF_EN(.{}, v);
    }
    /// Apply byte-swap transformation to DMA data.
    /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
    pub fn BSWAP(v: u1) Value {
        return Value.BSWAP(.{}, v);
    }
    /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
    ///
    /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
    pub fn IRQ_QUIET(v: u1) Value {
        return Value.IRQ_QUIET(.{}, v);
    }
    /// Select a Transfer Request signal.
    /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
    /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
    pub fn TREQ_SEL(v: TREQ_SEL_e) Value {
        return Value.TREQ_SEL(.{}, v);
    }
    /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
    pub fn CHAIN_TO(v: u4) Value {
        return Value.CHAIN_TO(.{}, v);
    }
    /// Select whether RING_SIZE applies to read or write addresses.
    /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
    pub fn RING_SEL(v: u1) Value {
        return Value.RING_SEL(.{}, v);
    }
    /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
    ///
    /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
    pub fn RING_SIZE(v: RING_SIZE_e) Value {
        return Value.RING_SIZE(.{}, v);
    }
    /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
    ///
    /// Generally this should be disabled for memory-to-peripheral transfers.
    pub fn INCR_WRITE(v: u1) Value {
        return Value.INCR_WRITE(.{}, v);
    }
    /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
    ///
    /// Generally this should be disabled for peripheral-to-memory transfers.
    pub fn INCR_READ(v: u1) Value {
        return Value.INCR_READ(.{}, v);
    }
    /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
    pub fn DATA_SIZE(v: DATA_SIZE_e) Value {
        return Value.DATA_SIZE(.{}, v);
    }
    /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
    ///
    /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
    pub fn HIGH_PRIORITY(v: u1) Value {
        return Value.HIGH_PRIORITY(.{}, v);
    }
    /// DMA Channel Enable.
    /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
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
/// Alias for channel 9 CTRL register
pub const CH9_AL1_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000250),
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
/// Alias for channel 9 READ_ADDR register
pub const CH9_AL1_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000254),
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
/// Alias for channel 9 WRITE_ADDR register
pub const CH9_AL1_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000258),
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
/// Alias for channel 9 TRANS_COUNT register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH9_AL1_TRANS_COUNT_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000025c),
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
/// Alias for channel 9 CTRL register
pub const CH9_AL2_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000260),
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
/// Alias for channel 9 TRANS_COUNT register
pub const CH9_AL2_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000264),
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
/// Alias for channel 9 READ_ADDR register
pub const CH9_AL2_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000268),
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
/// Alias for channel 9 WRITE_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH9_AL2_WRITE_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000026c),
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
/// Alias for channel 9 CTRL register
pub const CH9_AL3_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000270),
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
/// Alias for channel 9 WRITE_ADDR register
pub const CH9_AL3_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000274),
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
/// Alias for channel 9 TRANS_COUNT register
pub const CH9_AL3_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000278),
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
/// Alias for channel 9 READ_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH9_AL3_READ_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000027c),
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
/// DMA Channel 10 Read Address pointer
pub const CH10_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000280),
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
/// DMA Channel 10 Write Address pointer
pub const CH10_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000284),
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
/// DMA Channel 10 Transfer Count
pub const CH10_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000288),
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
/// DMA Channel 10 Control and Status
pub const CH10_CTRL_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000028c),
    pub const FieldMasks = struct {
        pub const AHB_ERROR: u32 = helpers.generateMask(31, 32);
        pub const READ_ERROR: u32 = helpers.generateMask(30, 31);
        pub const WRITE_ERROR: u32 = helpers.generateMask(29, 30);
        pub const BUSY: u32 = helpers.generateMask(24, 25);
        pub const SNIFF_EN: u32 = helpers.generateMask(23, 24);
        pub const BSWAP: u32 = helpers.generateMask(22, 23);
        pub const IRQ_QUIET: u32 = helpers.generateMask(21, 22);
        pub const TREQ_SEL: u32 = helpers.generateMask(15, 21);
        pub const CHAIN_TO: u32 = helpers.generateMask(11, 15);
        pub const RING_SEL: u32 = helpers.generateMask(10, 11);
        pub const RING_SIZE: u32 = helpers.generateMask(6, 10);
        pub const INCR_WRITE: u32 = helpers.generateMask(5, 6);
        pub const INCR_READ: u32 = helpers.generateMask(4, 5);
        pub const DATA_SIZE: u32 = helpers.generateMask(2, 4);
        pub const HIGH_PRIORITY: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const TREQ_SEL_e = enum(u6) {
        PIO0_TX0 = 0,
        PIO0_TX1 = 1,
        PIO0_TX2 = 2,
        PIO0_TX3 = 3,
        PIO0_RX0 = 4,
        PIO0_RX1 = 5,
        PIO0_RX2 = 6,
        PIO0_RX3 = 7,
        PIO1_TX0 = 8,
        PIO1_TX1 = 9,
        PIO1_TX2 = 10,
        PIO1_TX3 = 11,
        PIO1_RX0 = 12,
        PIO1_RX1 = 13,
        PIO1_RX2 = 14,
        PIO1_RX3 = 15,
        SPI0_TX = 16,
        SPI0_RX = 17,
        SPI1_TX = 18,
        SPI1_RX = 19,
        UART0_TX = 20,
        UART0_RX = 21,
        UART1_TX = 22,
        UART1_RX = 23,
        PWM_WRAP0 = 24,
        PWM_WRAP1 = 25,
        PWM_WRAP2 = 26,
        PWM_WRAP3 = 27,
        PWM_WRAP4 = 28,
        PWM_WRAP5 = 29,
        PWM_WRAP6 = 30,
        PWM_WRAP7 = 31,
        I2C0_TX = 32,
        I2C0_RX = 33,
        I2C1_TX = 34,
        I2C1_RX = 35,
        ADC = 36,
        XIP_STREAM = 37,
        XIP_SSITX = 38,
        XIP_SSIRX = 39,
        TIMER0 = 59,
        TIMER1 = 60,
        TIMER2 = 61,
        TIMER3 = 62,
        PERMANENT = 63,
    };
    const RING_SIZE_e = enum(u4) {
        RING_NONE = 0,
    };
    const DATA_SIZE_e = enum(u2) {
        SIZE_BYTE = 0,
        SIZE_HALFWORD = 1,
        SIZE_WORD = 2,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If 1, the channel received a read bus error. Write one to clear.
        /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
        pub fn READ_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// If 1, the channel received a write bus error. Write one to clear.
        /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
        pub fn WRITE_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
        ///
        /// This allows checksum to be enabled or disabled on a per-control- block basis.
        pub fn SNIFF_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        /// Apply byte-swap transformation to DMA data.
        /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
        pub fn BSWAP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
        ///
        /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
        pub fn IRQ_QUIET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        /// Select a Transfer Request signal.
        /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
        /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
        pub fn TREQ_SEL(self: Value, v: TREQ_SEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 21),
            };
        }
        /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
        pub fn CHAIN_TO(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 15),
            };
        }
        /// Select whether RING_SIZE applies to read or write addresses.
        /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
        pub fn RING_SEL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
        ///
        /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
        pub fn RING_SIZE(self: Value, v: RING_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 10),
            };
        }
        /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
        ///
        /// Generally this should be disabled for memory-to-peripheral transfers.
        pub fn INCR_WRITE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
        ///
        /// Generally this should be disabled for peripheral-to-memory transfers.
        pub fn INCR_READ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
        pub fn DATA_SIZE(self: Value, v: DATA_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 4),
            };
        }
        /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
        ///
        /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
        pub fn HIGH_PRIORITY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// DMA Channel Enable.
        /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn AHB_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn READ_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn WRITE_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn BUSY(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn SNIFF_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn BSWAP(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IRQ_QUIET(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn TREQ_SEL(self: Result) TREQ_SEL_e {
            const mask = comptime helpers.generateMask(15, 21);
            const val: @typeInfo(TREQ_SEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 15);
            return @enumFromInt(val);
        }
        pub fn CHAIN_TO(self: Result) u4 {
            const mask = comptime helpers.generateMask(11, 15);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn RING_SEL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn RING_SIZE(self: Result) RING_SIZE_e {
            const mask = comptime helpers.generateMask(6, 10);
            const val: @typeInfo(RING_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn INCR_WRITE(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn INCR_READ(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DATA_SIZE(self: Result) DATA_SIZE_e {
            const mask = comptime helpers.generateMask(2, 4);
            const val: @typeInfo(DATA_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn HIGH_PRIORITY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If 1, the channel received a read bus error. Write one to clear.
    /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
    pub fn READ_ERROR(v: u1) Value {
        return Value.READ_ERROR(.{}, v);
    }
    /// If 1, the channel received a write bus error. Write one to clear.
    /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
    pub fn WRITE_ERROR(v: u1) Value {
        return Value.WRITE_ERROR(.{}, v);
    }
    /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
    ///
    /// This allows checksum to be enabled or disabled on a per-control- block basis.
    pub fn SNIFF_EN(v: u1) Value {
        return Value.SNIFF_EN(.{}, v);
    }
    /// Apply byte-swap transformation to DMA data.
    /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
    pub fn BSWAP(v: u1) Value {
        return Value.BSWAP(.{}, v);
    }
    /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
    ///
    /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
    pub fn IRQ_QUIET(v: u1) Value {
        return Value.IRQ_QUIET(.{}, v);
    }
    /// Select a Transfer Request signal.
    /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
    /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
    pub fn TREQ_SEL(v: TREQ_SEL_e) Value {
        return Value.TREQ_SEL(.{}, v);
    }
    /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
    pub fn CHAIN_TO(v: u4) Value {
        return Value.CHAIN_TO(.{}, v);
    }
    /// Select whether RING_SIZE applies to read or write addresses.
    /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
    pub fn RING_SEL(v: u1) Value {
        return Value.RING_SEL(.{}, v);
    }
    /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
    ///
    /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
    pub fn RING_SIZE(v: RING_SIZE_e) Value {
        return Value.RING_SIZE(.{}, v);
    }
    /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
    ///
    /// Generally this should be disabled for memory-to-peripheral transfers.
    pub fn INCR_WRITE(v: u1) Value {
        return Value.INCR_WRITE(.{}, v);
    }
    /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
    ///
    /// Generally this should be disabled for peripheral-to-memory transfers.
    pub fn INCR_READ(v: u1) Value {
        return Value.INCR_READ(.{}, v);
    }
    /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
    pub fn DATA_SIZE(v: DATA_SIZE_e) Value {
        return Value.DATA_SIZE(.{}, v);
    }
    /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
    ///
    /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
    pub fn HIGH_PRIORITY(v: u1) Value {
        return Value.HIGH_PRIORITY(.{}, v);
    }
    /// DMA Channel Enable.
    /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
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
/// Alias for channel 10 CTRL register
pub const CH10_AL1_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000290),
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
/// Alias for channel 10 READ_ADDR register
pub const CH10_AL1_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000294),
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
/// Alias for channel 10 WRITE_ADDR register
pub const CH10_AL1_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000298),
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
/// Alias for channel 10 TRANS_COUNT register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH10_AL1_TRANS_COUNT_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000029c),
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
/// Alias for channel 10 CTRL register
pub const CH10_AL2_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002a0),
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
/// Alias for channel 10 TRANS_COUNT register
pub const CH10_AL2_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002a4),
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
/// Alias for channel 10 READ_ADDR register
pub const CH10_AL2_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002a8),
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
/// Alias for channel 10 WRITE_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH10_AL2_WRITE_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002ac),
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
/// Alias for channel 10 CTRL register
pub const CH10_AL3_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002b0),
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
/// Alias for channel 10 WRITE_ADDR register
pub const CH10_AL3_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002b4),
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
/// Alias for channel 10 TRANS_COUNT register
pub const CH10_AL3_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002b8),
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
/// Alias for channel 10 READ_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH10_AL3_READ_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002bc),
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
/// DMA Channel 11 Read Address pointer
pub const CH11_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002c0),
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
/// DMA Channel 11 Write Address pointer
pub const CH11_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002c4),
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
/// DMA Channel 11 Transfer Count
pub const CH11_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002c8),
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
/// DMA Channel 11 Control and Status
pub const CH11_CTRL_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002cc),
    pub const FieldMasks = struct {
        pub const AHB_ERROR: u32 = helpers.generateMask(31, 32);
        pub const READ_ERROR: u32 = helpers.generateMask(30, 31);
        pub const WRITE_ERROR: u32 = helpers.generateMask(29, 30);
        pub const BUSY: u32 = helpers.generateMask(24, 25);
        pub const SNIFF_EN: u32 = helpers.generateMask(23, 24);
        pub const BSWAP: u32 = helpers.generateMask(22, 23);
        pub const IRQ_QUIET: u32 = helpers.generateMask(21, 22);
        pub const TREQ_SEL: u32 = helpers.generateMask(15, 21);
        pub const CHAIN_TO: u32 = helpers.generateMask(11, 15);
        pub const RING_SEL: u32 = helpers.generateMask(10, 11);
        pub const RING_SIZE: u32 = helpers.generateMask(6, 10);
        pub const INCR_WRITE: u32 = helpers.generateMask(5, 6);
        pub const INCR_READ: u32 = helpers.generateMask(4, 5);
        pub const DATA_SIZE: u32 = helpers.generateMask(2, 4);
        pub const HIGH_PRIORITY: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const TREQ_SEL_e = enum(u6) {
        PIO0_TX0 = 0,
        PIO0_TX1 = 1,
        PIO0_TX2 = 2,
        PIO0_TX3 = 3,
        PIO0_RX0 = 4,
        PIO0_RX1 = 5,
        PIO0_RX2 = 6,
        PIO0_RX3 = 7,
        PIO1_TX0 = 8,
        PIO1_TX1 = 9,
        PIO1_TX2 = 10,
        PIO1_TX3 = 11,
        PIO1_RX0 = 12,
        PIO1_RX1 = 13,
        PIO1_RX2 = 14,
        PIO1_RX3 = 15,
        SPI0_TX = 16,
        SPI0_RX = 17,
        SPI1_TX = 18,
        SPI1_RX = 19,
        UART0_TX = 20,
        UART0_RX = 21,
        UART1_TX = 22,
        UART1_RX = 23,
        PWM_WRAP0 = 24,
        PWM_WRAP1 = 25,
        PWM_WRAP2 = 26,
        PWM_WRAP3 = 27,
        PWM_WRAP4 = 28,
        PWM_WRAP5 = 29,
        PWM_WRAP6 = 30,
        PWM_WRAP7 = 31,
        I2C0_TX = 32,
        I2C0_RX = 33,
        I2C1_TX = 34,
        I2C1_RX = 35,
        ADC = 36,
        XIP_STREAM = 37,
        XIP_SSITX = 38,
        XIP_SSIRX = 39,
        TIMER0 = 59,
        TIMER1 = 60,
        TIMER2 = 61,
        TIMER3 = 62,
        PERMANENT = 63,
    };
    const RING_SIZE_e = enum(u4) {
        RING_NONE = 0,
    };
    const DATA_SIZE_e = enum(u2) {
        SIZE_BYTE = 0,
        SIZE_HALFWORD = 1,
        SIZE_WORD = 2,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If 1, the channel received a read bus error. Write one to clear.
        /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
        pub fn READ_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// If 1, the channel received a write bus error. Write one to clear.
        /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
        pub fn WRITE_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
        ///
        /// This allows checksum to be enabled or disabled on a per-control- block basis.
        pub fn SNIFF_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        /// Apply byte-swap transformation to DMA data.
        /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
        pub fn BSWAP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
        ///
        /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
        pub fn IRQ_QUIET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        /// Select a Transfer Request signal.
        /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
        /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
        pub fn TREQ_SEL(self: Value, v: TREQ_SEL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 21),
            };
        }
        /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
        pub fn CHAIN_TO(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 15),
            };
        }
        /// Select whether RING_SIZE applies to read or write addresses.
        /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
        pub fn RING_SEL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
        ///
        /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
        pub fn RING_SIZE(self: Value, v: RING_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 10),
            };
        }
        /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
        ///
        /// Generally this should be disabled for memory-to-peripheral transfers.
        pub fn INCR_WRITE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
        ///
        /// Generally this should be disabled for peripheral-to-memory transfers.
        pub fn INCR_READ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
        pub fn DATA_SIZE(self: Value, v: DATA_SIZE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 4),
            };
        }
        /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
        ///
        /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
        pub fn HIGH_PRIORITY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// DMA Channel Enable.
        /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn AHB_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn READ_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn WRITE_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn BUSY(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn SNIFF_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn BSWAP(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn IRQ_QUIET(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn TREQ_SEL(self: Result) TREQ_SEL_e {
            const mask = comptime helpers.generateMask(15, 21);
            const val: @typeInfo(TREQ_SEL_e).@"enum".tag_type = @intCast((self.val & mask) >> 15);
            return @enumFromInt(val);
        }
        pub fn CHAIN_TO(self: Result) u4 {
            const mask = comptime helpers.generateMask(11, 15);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn RING_SEL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn RING_SIZE(self: Result) RING_SIZE_e {
            const mask = comptime helpers.generateMask(6, 10);
            const val: @typeInfo(RING_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn INCR_WRITE(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn INCR_READ(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DATA_SIZE(self: Result) DATA_SIZE_e {
            const mask = comptime helpers.generateMask(2, 4);
            const val: @typeInfo(DATA_SIZE_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn HIGH_PRIORITY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If 1, the channel received a read bus error. Write one to clear.
    /// READ_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 3 transfers later)
    pub fn READ_ERROR(v: u1) Value {
        return Value.READ_ERROR(.{}, v);
    }
    /// If 1, the channel received a write bus error. Write one to clear.
    /// WRITE_ADDR shows the approximate address where the bus error was encountered (will not be earlier, or more than 5 transfers later)
    pub fn WRITE_ERROR(v: u1) Value {
        return Value.WRITE_ERROR(.{}, v);
    }
    /// If 1, this channel&#39;s data transfers are visible to the sniff hardware, and each transfer will advance the state of the checksum. This only applies if the sniff hardware is enabled, and has this channel selected.
    ///
    /// This allows checksum to be enabled or disabled on a per-control- block basis.
    pub fn SNIFF_EN(v: u1) Value {
        return Value.SNIFF_EN(.{}, v);
    }
    /// Apply byte-swap transformation to DMA data.
    /// For byte data, this has no effect. For halfword data, the two bytes of each halfword are swapped. For word data, the four bytes of each word are swapped to reverse order.
    pub fn BSWAP(v: u1) Value {
        return Value.BSWAP(.{}, v);
    }
    /// In QUIET mode, the channel does not generate IRQs at the end of every transfer block. Instead, an IRQ is raised when NULL is written to a trigger register, indicating the end of a control block chain.
    ///
    /// This reduces the number of interrupts to be serviced by the CPU when transferring a DMA chain of many small control blocks.
    pub fn IRQ_QUIET(v: u1) Value {
        return Value.IRQ_QUIET(.{}, v);
    }
    /// Select a Transfer Request signal.
    /// The channel uses the transfer request signal to pace its data transfer rate. Sources for TREQ signals are internal (TIMERS) or external (DREQ, a Data Request from the system).
    /// 0x0 to 0x3a -&gt; select DREQ n as TREQ
    pub fn TREQ_SEL(v: TREQ_SEL_e) Value {
        return Value.TREQ_SEL(.{}, v);
    }
    /// When this channel completes, it will trigger the channel indicated by CHAIN_TO. Disable by setting CHAIN_TO = _(this channel)_.
    pub fn CHAIN_TO(v: u4) Value {
        return Value.CHAIN_TO(.{}, v);
    }
    /// Select whether RING_SIZE applies to read or write addresses.
    /// If 0, read addresses are wrapped on a (1 &lt;&lt; RING_SIZE) boundary. If 1, write addresses are wrapped.
    pub fn RING_SEL(v: u1) Value {
        return Value.RING_SEL(.{}, v);
    }
    /// Size of address wrap region. If 0, don&#39;t wrap. For values n &gt; 0, only the lower n bits of the address will change. This wraps the address on a (1 &lt;&lt; n) byte boundary, facilitating access to naturally-aligned ring buffers.
    ///
    /// Ring sizes between 2 and 32768 bytes are possible. This can apply to either read or write addresses, based on value of RING_SEL.
    pub fn RING_SIZE(v: RING_SIZE_e) Value {
        return Value.RING_SIZE(.{}, v);
    }
    /// If 1, the write address increments with each transfer. If 0, each write is directed to the same, initial address.
    ///
    /// Generally this should be disabled for memory-to-peripheral transfers.
    pub fn INCR_WRITE(v: u1) Value {
        return Value.INCR_WRITE(.{}, v);
    }
    /// If 1, the read address increments with each transfer. If 0, each read is directed to the same, initial address.
    ///
    /// Generally this should be disabled for peripheral-to-memory transfers.
    pub fn INCR_READ(v: u1) Value {
        return Value.INCR_READ(.{}, v);
    }
    /// Set the size of each bus transfer (byte/halfword/word). READ_ADDR and WRITE_ADDR advance by this amount (1/2/4 bytes) with each transfer.
    pub fn DATA_SIZE(v: DATA_SIZE_e) Value {
        return Value.DATA_SIZE(.{}, v);
    }
    /// HIGH_PRIORITY gives a channel preferential treatment in issue scheduling: in each scheduling round, all high priority channels are considered first, and then only a single low priority channel, before returning to the high priority channels.
    ///
    /// This only affects the order in which the DMA schedules channels. The DMA&#39;s bus priority is not changed. If the DMA is not saturated then a low priority channel will see no loss of throughput.
    pub fn HIGH_PRIORITY(v: u1) Value {
        return Value.HIGH_PRIORITY(.{}, v);
    }
    /// DMA Channel Enable.
    /// When 1, the channel will respond to triggering events, which will cause it to become BUSY and start transferring data. When 0, the channel will ignore triggers, stop issuing transfers, and pause the current transfer sequence (i.e. BUSY will remain high if already high)
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
/// Alias for channel 11 CTRL register
pub const CH11_AL1_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002d0),
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
/// Alias for channel 11 READ_ADDR register
pub const CH11_AL1_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002d4),
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
/// Alias for channel 11 WRITE_ADDR register
pub const CH11_AL1_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002d8),
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
/// Alias for channel 11 TRANS_COUNT register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH11_AL1_TRANS_COUNT_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002dc),
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
/// Alias for channel 11 CTRL register
pub const CH11_AL2_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002e0),
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
/// Alias for channel 11 TRANS_COUNT register
pub const CH11_AL2_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002e4),
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
/// Alias for channel 11 READ_ADDR register
pub const CH11_AL2_READ_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002e8),
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
/// Alias for channel 11 WRITE_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH11_AL2_WRITE_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002ec),
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
/// Alias for channel 11 CTRL register
pub const CH11_AL3_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002f0),
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
/// Alias for channel 11 WRITE_ADDR register
pub const CH11_AL3_WRITE_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002f4),
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
/// Alias for channel 11 TRANS_COUNT register
pub const CH11_AL3_TRANS_COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002f8),
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
/// Alias for channel 11 READ_ADDR register
/// This is a trigger register (0xc). Writing a nonzero value will
/// reload the channel counter and start the channel.
pub const CH11_AL3_READ_ADDR_TRIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500002fc),
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
/// Interrupt Status (raw)
pub const INTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000400),
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
/// Interrupt Enables for IRQ 0
pub const INTE0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000404),
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
/// Force Interrupts
pub const INTF0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000408),
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
/// Interrupt Status for IRQ 0
pub const INTS0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000040c),
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
/// Interrupt Status (raw)
pub const INTR1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000410),
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
/// Interrupt Enables for IRQ 1
pub const INTE1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000414),
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
/// Force Interrupts for IRQ 1
pub const INTF1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000418),
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
/// Interrupt Status (masked) for IRQ 1
pub const INTS1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000041c),
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
/// Pacing (X/Y) Fractional Timer
/// The pacing timer produces TREQ assertions at a rate set by ((X/Y) * sys_clk). This equation is evaluated every sys_clk cycles and therefore can only generate TREQs at a rate of 1 per sys_clk (i.e. permanent TREQ) or less.
pub const TIMER0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000420),
    pub const FieldMasks = struct {
        pub const X: u32 = helpers.generateMask(16, 32);
        pub const Y: u32 = helpers.generateMask(0, 16);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Pacing Timer Dividend. Specifies the X value for the (X/Y) fractional timer.
        pub fn X(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        /// Pacing Timer Divisor. Specifies the Y value for the (X/Y) fractional timer.
        pub fn Y(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn X(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn Y(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Pacing Timer Dividend. Specifies the X value for the (X/Y) fractional timer.
    pub fn X(v: u16) Value {
        return Value.X(.{}, v);
    }
    /// Pacing Timer Divisor. Specifies the Y value for the (X/Y) fractional timer.
    pub fn Y(v: u16) Value {
        return Value.Y(.{}, v);
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
/// Pacing (X/Y) Fractional Timer
/// The pacing timer produces TREQ assertions at a rate set by ((X/Y) * sys_clk). This equation is evaluated every sys_clk cycles and therefore can only generate TREQs at a rate of 1 per sys_clk (i.e. permanent TREQ) or less.
pub const TIMER1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000424),
    pub const FieldMasks = struct {
        pub const X: u32 = helpers.generateMask(16, 32);
        pub const Y: u32 = helpers.generateMask(0, 16);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Pacing Timer Dividend. Specifies the X value for the (X/Y) fractional timer.
        pub fn X(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        /// Pacing Timer Divisor. Specifies the Y value for the (X/Y) fractional timer.
        pub fn Y(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn X(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn Y(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Pacing Timer Dividend. Specifies the X value for the (X/Y) fractional timer.
    pub fn X(v: u16) Value {
        return Value.X(.{}, v);
    }
    /// Pacing Timer Divisor. Specifies the Y value for the (X/Y) fractional timer.
    pub fn Y(v: u16) Value {
        return Value.Y(.{}, v);
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
/// Pacing (X/Y) Fractional Timer
/// The pacing timer produces TREQ assertions at a rate set by ((X/Y) * sys_clk). This equation is evaluated every sys_clk cycles and therefore can only generate TREQs at a rate of 1 per sys_clk (i.e. permanent TREQ) or less.
pub const TIMER2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000428),
    pub const FieldMasks = struct {
        pub const X: u32 = helpers.generateMask(16, 32);
        pub const Y: u32 = helpers.generateMask(0, 16);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Pacing Timer Dividend. Specifies the X value for the (X/Y) fractional timer.
        pub fn X(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        /// Pacing Timer Divisor. Specifies the Y value for the (X/Y) fractional timer.
        pub fn Y(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn X(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn Y(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Pacing Timer Dividend. Specifies the X value for the (X/Y) fractional timer.
    pub fn X(v: u16) Value {
        return Value.X(.{}, v);
    }
    /// Pacing Timer Divisor. Specifies the Y value for the (X/Y) fractional timer.
    pub fn Y(v: u16) Value {
        return Value.Y(.{}, v);
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
/// Pacing (X/Y) Fractional Timer
/// The pacing timer produces TREQ assertions at a rate set by ((X/Y) * sys_clk). This equation is evaluated every sys_clk cycles and therefore can only generate TREQs at a rate of 1 per sys_clk (i.e. permanent TREQ) or less.
pub const TIMER3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5000042c),
    pub const FieldMasks = struct {
        pub const X: u32 = helpers.generateMask(16, 32);
        pub const Y: u32 = helpers.generateMask(0, 16);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Pacing Timer Dividend. Specifies the X value for the (X/Y) fractional timer.
        pub fn X(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        /// Pacing Timer Divisor. Specifies the Y value for the (X/Y) fractional timer.
        pub fn Y(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn X(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn Y(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Pacing Timer Dividend. Specifies the X value for the (X/Y) fractional timer.
    pub fn X(v: u16) Value {
        return Value.X(.{}, v);
    }
    /// Pacing Timer Divisor. Specifies the Y value for the (X/Y) fractional timer.
    pub fn Y(v: u16) Value {
        return Value.Y(.{}, v);
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
/// Trigger one or more channels simultaneously
pub const MULTI_CHAN_TRIGGER = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000430),
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
/// Sniffer Control
pub const SNIFF_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000434),
    pub const FieldMasks = struct {
        pub const OUT_INV: u32 = helpers.generateMask(11, 12);
        pub const OUT_REV: u32 = helpers.generateMask(10, 11);
        pub const BSWAP: u32 = helpers.generateMask(9, 10);
        pub const CALC: u32 = helpers.generateMask(5, 9);
        pub const DMACH: u32 = helpers.generateMask(1, 5);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const CALC_e = enum(u4) {
        CRC32 = 0,
        CRC32R = 1,
        CRC16 = 2,
        CRC16R = 3,
        EVEN = 14,
        SUM = 15,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If set, the result appears inverted (bitwise complement) when read. This does not affect the way the checksum is calculated; the result is transformed on-the-fly between the result register and the bus.
        pub fn OUT_INV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// If set, the result appears bit-reversed when read. This does not affect the way the checksum is calculated; the result is transformed on-the-fly between the result register and the bus.
        pub fn OUT_REV(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Locally perform a byte reverse on the sniffed data, before feeding into checksum.
        ///
        /// Note that the sniff hardware is downstream of the DMA channel byteswap performed in the read master: if channel CTRL_BSWAP and SNIFF_CTRL_BSWAP are both enabled, their effects cancel from the sniffer&#39;s point of view.
        pub fn BSWAP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn CALC(self: Value, v: CALC_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 9),
            };
        }
        /// DMA channel for Sniffer to observe
        pub fn DMACH(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 5),
            };
        }
        /// Enable sniffer
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn OUT_INV(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn OUT_REV(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn BSWAP(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn CALC(self: Result) CALC_e {
            const mask = comptime helpers.generateMask(5, 9);
            const val: @typeInfo(CALC_e).@"enum".tag_type = @intCast((self.val & mask) >> 5);
            return @enumFromInt(val);
        }
        pub fn DMACH(self: Result) u4 {
            const mask = comptime helpers.generateMask(1, 5);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If set, the result appears inverted (bitwise complement) when read. This does not affect the way the checksum is calculated; the result is transformed on-the-fly between the result register and the bus.
    pub fn OUT_INV(v: u1) Value {
        return Value.OUT_INV(.{}, v);
    }
    /// If set, the result appears bit-reversed when read. This does not affect the way the checksum is calculated; the result is transformed on-the-fly between the result register and the bus.
    pub fn OUT_REV(v: u1) Value {
        return Value.OUT_REV(.{}, v);
    }
    /// Locally perform a byte reverse on the sniffed data, before feeding into checksum.
    ///
    /// Note that the sniff hardware is downstream of the DMA channel byteswap performed in the read master: if channel CTRL_BSWAP and SNIFF_CTRL_BSWAP are both enabled, their effects cancel from the sniffer&#39;s point of view.
    pub fn BSWAP(v: u1) Value {
        return Value.BSWAP(.{}, v);
    }
    pub fn CALC(v: CALC_e) Value {
        return Value.CALC(.{}, v);
    }
    /// DMA channel for Sniffer to observe
    pub fn DMACH(v: u4) Value {
        return Value.DMACH(.{}, v);
    }
    /// Enable sniffer
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
/// Data accumulator for sniff hardware
pub const SNIFF_DATA = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000438),
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
/// Debug RAF, WAF, TDF levels
pub const FIFO_LEVELS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000440),
    pub const FieldMasks = struct {
        pub const RAF_LVL: u32 = helpers.generateMask(16, 24);
        pub const WAF_LVL: u32 = helpers.generateMask(8, 16);
        pub const TDF_LVL: u32 = helpers.generateMask(0, 8);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn RAF_LVL(self: Result) u8 {
            const mask = comptime helpers.generateMask(16, 24);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn WAF_LVL(self: Result) u8 {
            const mask = comptime helpers.generateMask(8, 16);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn TDF_LVL(self: Result) u8 {
            const mask = comptime helpers.generateMask(0, 8);
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
/// Abort an in-progress transfer sequence on one or more channels
pub const CHAN_ABORT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000444),
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
/// The number of channels this DMA instance is equipped with. This DMA supports up to 16 hardware channels, but can be configured with as few as one, to minimise silicon area.
pub const N_CHANNELS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000448),
    pub fn write(self: @This(), v: u5) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u5) void {
        self.reg.* = (helpers.toU32(v) << 0);
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
/// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
pub const CH0_DBG_CTDREQ = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000800),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
pub const CH0_DBG_TCR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000804),
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
/// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
pub const CH1_DBG_CTDREQ = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000840),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
pub const CH1_DBG_TCR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000844),
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
/// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
pub const CH2_DBG_CTDREQ = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000880),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
pub const CH2_DBG_TCR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000884),
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
/// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
pub const CH3_DBG_CTDREQ = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500008c0),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
pub const CH3_DBG_TCR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500008c4),
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
/// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
pub const CH4_DBG_CTDREQ = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000900),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
pub const CH4_DBG_TCR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000904),
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
/// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
pub const CH5_DBG_CTDREQ = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000940),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
pub const CH5_DBG_TCR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000944),
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
/// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
pub const CH6_DBG_CTDREQ = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000980),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
pub const CH6_DBG_TCR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000984),
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
/// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
pub const CH7_DBG_CTDREQ = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500009c0),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
pub const CH7_DBG_TCR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x500009c4),
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
/// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
pub const CH8_DBG_CTDREQ = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000a00),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
pub const CH8_DBG_TCR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000a04),
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
/// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
pub const CH9_DBG_CTDREQ = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000a40),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
pub const CH9_DBG_TCR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000a44),
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
/// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
pub const CH10_DBG_CTDREQ = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000a80),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
pub const CH10_DBG_TCR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000a84),
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
/// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
pub const CH11_DBG_CTDREQ = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000ac0),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
pub const CH11_DBG_TCR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50000ac4),
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
/// DMA with separate read and write masters
pub const DMA_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x50000000),

    /// DMA Channel 0 Read Address pointer
    CH0_READ_ADDR: CH0_READ_ADDR = .{},
    /// DMA Channel 0 Write Address pointer
    CH0_WRITE_ADDR: CH0_WRITE_ADDR = .{},
    /// DMA Channel 0 Transfer Count
    CH0_TRANS_COUNT: CH0_TRANS_COUNT = .{},
    /// DMA Channel 0 Control and Status
    CH0_CTRL_TRIG: CH0_CTRL_TRIG = .{},
    /// Alias for channel 0 CTRL register
    CH0_AL1_CTRL: CH0_AL1_CTRL = .{},
    /// Alias for channel 0 READ_ADDR register
    CH0_AL1_READ_ADDR: CH0_AL1_READ_ADDR = .{},
    /// Alias for channel 0 WRITE_ADDR register
    CH0_AL1_WRITE_ADDR: CH0_AL1_WRITE_ADDR = .{},
    /// Alias for channel 0 TRANS_COUNT register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH0_AL1_TRANS_COUNT_TRIG: CH0_AL1_TRANS_COUNT_TRIG = .{},
    /// Alias for channel 0 CTRL register
    CH0_AL2_CTRL: CH0_AL2_CTRL = .{},
    /// Alias for channel 0 TRANS_COUNT register
    CH0_AL2_TRANS_COUNT: CH0_AL2_TRANS_COUNT = .{},
    /// Alias for channel 0 READ_ADDR register
    CH0_AL2_READ_ADDR: CH0_AL2_READ_ADDR = .{},
    /// Alias for channel 0 WRITE_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH0_AL2_WRITE_ADDR_TRIG: CH0_AL2_WRITE_ADDR_TRIG = .{},
    /// Alias for channel 0 CTRL register
    CH0_AL3_CTRL: CH0_AL3_CTRL = .{},
    /// Alias for channel 0 WRITE_ADDR register
    CH0_AL3_WRITE_ADDR: CH0_AL3_WRITE_ADDR = .{},
    /// Alias for channel 0 TRANS_COUNT register
    CH0_AL3_TRANS_COUNT: CH0_AL3_TRANS_COUNT = .{},
    /// Alias for channel 0 READ_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH0_AL3_READ_ADDR_TRIG: CH0_AL3_READ_ADDR_TRIG = .{},
    /// DMA Channel 1 Read Address pointer
    CH1_READ_ADDR: CH1_READ_ADDR = .{},
    /// DMA Channel 1 Write Address pointer
    CH1_WRITE_ADDR: CH1_WRITE_ADDR = .{},
    /// DMA Channel 1 Transfer Count
    CH1_TRANS_COUNT: CH1_TRANS_COUNT = .{},
    /// DMA Channel 1 Control and Status
    CH1_CTRL_TRIG: CH1_CTRL_TRIG = .{},
    /// Alias for channel 1 CTRL register
    CH1_AL1_CTRL: CH1_AL1_CTRL = .{},
    /// Alias for channel 1 READ_ADDR register
    CH1_AL1_READ_ADDR: CH1_AL1_READ_ADDR = .{},
    /// Alias for channel 1 WRITE_ADDR register
    CH1_AL1_WRITE_ADDR: CH1_AL1_WRITE_ADDR = .{},
    /// Alias for channel 1 TRANS_COUNT register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH1_AL1_TRANS_COUNT_TRIG: CH1_AL1_TRANS_COUNT_TRIG = .{},
    /// Alias for channel 1 CTRL register
    CH1_AL2_CTRL: CH1_AL2_CTRL = .{},
    /// Alias for channel 1 TRANS_COUNT register
    CH1_AL2_TRANS_COUNT: CH1_AL2_TRANS_COUNT = .{},
    /// Alias for channel 1 READ_ADDR register
    CH1_AL2_READ_ADDR: CH1_AL2_READ_ADDR = .{},
    /// Alias for channel 1 WRITE_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH1_AL2_WRITE_ADDR_TRIG: CH1_AL2_WRITE_ADDR_TRIG = .{},
    /// Alias for channel 1 CTRL register
    CH1_AL3_CTRL: CH1_AL3_CTRL = .{},
    /// Alias for channel 1 WRITE_ADDR register
    CH1_AL3_WRITE_ADDR: CH1_AL3_WRITE_ADDR = .{},
    /// Alias for channel 1 TRANS_COUNT register
    CH1_AL3_TRANS_COUNT: CH1_AL3_TRANS_COUNT = .{},
    /// Alias for channel 1 READ_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH1_AL3_READ_ADDR_TRIG: CH1_AL3_READ_ADDR_TRIG = .{},
    /// DMA Channel 2 Read Address pointer
    CH2_READ_ADDR: CH2_READ_ADDR = .{},
    /// DMA Channel 2 Write Address pointer
    CH2_WRITE_ADDR: CH2_WRITE_ADDR = .{},
    /// DMA Channel 2 Transfer Count
    CH2_TRANS_COUNT: CH2_TRANS_COUNT = .{},
    /// DMA Channel 2 Control and Status
    CH2_CTRL_TRIG: CH2_CTRL_TRIG = .{},
    /// Alias for channel 2 CTRL register
    CH2_AL1_CTRL: CH2_AL1_CTRL = .{},
    /// Alias for channel 2 READ_ADDR register
    CH2_AL1_READ_ADDR: CH2_AL1_READ_ADDR = .{},
    /// Alias for channel 2 WRITE_ADDR register
    CH2_AL1_WRITE_ADDR: CH2_AL1_WRITE_ADDR = .{},
    /// Alias for channel 2 TRANS_COUNT register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH2_AL1_TRANS_COUNT_TRIG: CH2_AL1_TRANS_COUNT_TRIG = .{},
    /// Alias for channel 2 CTRL register
    CH2_AL2_CTRL: CH2_AL2_CTRL = .{},
    /// Alias for channel 2 TRANS_COUNT register
    CH2_AL2_TRANS_COUNT: CH2_AL2_TRANS_COUNT = .{},
    /// Alias for channel 2 READ_ADDR register
    CH2_AL2_READ_ADDR: CH2_AL2_READ_ADDR = .{},
    /// Alias for channel 2 WRITE_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH2_AL2_WRITE_ADDR_TRIG: CH2_AL2_WRITE_ADDR_TRIG = .{},
    /// Alias for channel 2 CTRL register
    CH2_AL3_CTRL: CH2_AL3_CTRL = .{},
    /// Alias for channel 2 WRITE_ADDR register
    CH2_AL3_WRITE_ADDR: CH2_AL3_WRITE_ADDR = .{},
    /// Alias for channel 2 TRANS_COUNT register
    CH2_AL3_TRANS_COUNT: CH2_AL3_TRANS_COUNT = .{},
    /// Alias for channel 2 READ_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH2_AL3_READ_ADDR_TRIG: CH2_AL3_READ_ADDR_TRIG = .{},
    /// DMA Channel 3 Read Address pointer
    CH3_READ_ADDR: CH3_READ_ADDR = .{},
    /// DMA Channel 3 Write Address pointer
    CH3_WRITE_ADDR: CH3_WRITE_ADDR = .{},
    /// DMA Channel 3 Transfer Count
    CH3_TRANS_COUNT: CH3_TRANS_COUNT = .{},
    /// DMA Channel 3 Control and Status
    CH3_CTRL_TRIG: CH3_CTRL_TRIG = .{},
    /// Alias for channel 3 CTRL register
    CH3_AL1_CTRL: CH3_AL1_CTRL = .{},
    /// Alias for channel 3 READ_ADDR register
    CH3_AL1_READ_ADDR: CH3_AL1_READ_ADDR = .{},
    /// Alias for channel 3 WRITE_ADDR register
    CH3_AL1_WRITE_ADDR: CH3_AL1_WRITE_ADDR = .{},
    /// Alias for channel 3 TRANS_COUNT register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH3_AL1_TRANS_COUNT_TRIG: CH3_AL1_TRANS_COUNT_TRIG = .{},
    /// Alias for channel 3 CTRL register
    CH3_AL2_CTRL: CH3_AL2_CTRL = .{},
    /// Alias for channel 3 TRANS_COUNT register
    CH3_AL2_TRANS_COUNT: CH3_AL2_TRANS_COUNT = .{},
    /// Alias for channel 3 READ_ADDR register
    CH3_AL2_READ_ADDR: CH3_AL2_READ_ADDR = .{},
    /// Alias for channel 3 WRITE_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH3_AL2_WRITE_ADDR_TRIG: CH3_AL2_WRITE_ADDR_TRIG = .{},
    /// Alias for channel 3 CTRL register
    CH3_AL3_CTRL: CH3_AL3_CTRL = .{},
    /// Alias for channel 3 WRITE_ADDR register
    CH3_AL3_WRITE_ADDR: CH3_AL3_WRITE_ADDR = .{},
    /// Alias for channel 3 TRANS_COUNT register
    CH3_AL3_TRANS_COUNT: CH3_AL3_TRANS_COUNT = .{},
    /// Alias for channel 3 READ_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH3_AL3_READ_ADDR_TRIG: CH3_AL3_READ_ADDR_TRIG = .{},
    /// DMA Channel 4 Read Address pointer
    CH4_READ_ADDR: CH4_READ_ADDR = .{},
    /// DMA Channel 4 Write Address pointer
    CH4_WRITE_ADDR: CH4_WRITE_ADDR = .{},
    /// DMA Channel 4 Transfer Count
    CH4_TRANS_COUNT: CH4_TRANS_COUNT = .{},
    /// DMA Channel 4 Control and Status
    CH4_CTRL_TRIG: CH4_CTRL_TRIG = .{},
    /// Alias for channel 4 CTRL register
    CH4_AL1_CTRL: CH4_AL1_CTRL = .{},
    /// Alias for channel 4 READ_ADDR register
    CH4_AL1_READ_ADDR: CH4_AL1_READ_ADDR = .{},
    /// Alias for channel 4 WRITE_ADDR register
    CH4_AL1_WRITE_ADDR: CH4_AL1_WRITE_ADDR = .{},
    /// Alias for channel 4 TRANS_COUNT register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH4_AL1_TRANS_COUNT_TRIG: CH4_AL1_TRANS_COUNT_TRIG = .{},
    /// Alias for channel 4 CTRL register
    CH4_AL2_CTRL: CH4_AL2_CTRL = .{},
    /// Alias for channel 4 TRANS_COUNT register
    CH4_AL2_TRANS_COUNT: CH4_AL2_TRANS_COUNT = .{},
    /// Alias for channel 4 READ_ADDR register
    CH4_AL2_READ_ADDR: CH4_AL2_READ_ADDR = .{},
    /// Alias for channel 4 WRITE_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH4_AL2_WRITE_ADDR_TRIG: CH4_AL2_WRITE_ADDR_TRIG = .{},
    /// Alias for channel 4 CTRL register
    CH4_AL3_CTRL: CH4_AL3_CTRL = .{},
    /// Alias for channel 4 WRITE_ADDR register
    CH4_AL3_WRITE_ADDR: CH4_AL3_WRITE_ADDR = .{},
    /// Alias for channel 4 TRANS_COUNT register
    CH4_AL3_TRANS_COUNT: CH4_AL3_TRANS_COUNT = .{},
    /// Alias for channel 4 READ_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH4_AL3_READ_ADDR_TRIG: CH4_AL3_READ_ADDR_TRIG = .{},
    /// DMA Channel 5 Read Address pointer
    CH5_READ_ADDR: CH5_READ_ADDR = .{},
    /// DMA Channel 5 Write Address pointer
    CH5_WRITE_ADDR: CH5_WRITE_ADDR = .{},
    /// DMA Channel 5 Transfer Count
    CH5_TRANS_COUNT: CH5_TRANS_COUNT = .{},
    /// DMA Channel 5 Control and Status
    CH5_CTRL_TRIG: CH5_CTRL_TRIG = .{},
    /// Alias for channel 5 CTRL register
    CH5_AL1_CTRL: CH5_AL1_CTRL = .{},
    /// Alias for channel 5 READ_ADDR register
    CH5_AL1_READ_ADDR: CH5_AL1_READ_ADDR = .{},
    /// Alias for channel 5 WRITE_ADDR register
    CH5_AL1_WRITE_ADDR: CH5_AL1_WRITE_ADDR = .{},
    /// Alias for channel 5 TRANS_COUNT register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH5_AL1_TRANS_COUNT_TRIG: CH5_AL1_TRANS_COUNT_TRIG = .{},
    /// Alias for channel 5 CTRL register
    CH5_AL2_CTRL: CH5_AL2_CTRL = .{},
    /// Alias for channel 5 TRANS_COUNT register
    CH5_AL2_TRANS_COUNT: CH5_AL2_TRANS_COUNT = .{},
    /// Alias for channel 5 READ_ADDR register
    CH5_AL2_READ_ADDR: CH5_AL2_READ_ADDR = .{},
    /// Alias for channel 5 WRITE_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH5_AL2_WRITE_ADDR_TRIG: CH5_AL2_WRITE_ADDR_TRIG = .{},
    /// Alias for channel 5 CTRL register
    CH5_AL3_CTRL: CH5_AL3_CTRL = .{},
    /// Alias for channel 5 WRITE_ADDR register
    CH5_AL3_WRITE_ADDR: CH5_AL3_WRITE_ADDR = .{},
    /// Alias for channel 5 TRANS_COUNT register
    CH5_AL3_TRANS_COUNT: CH5_AL3_TRANS_COUNT = .{},
    /// Alias for channel 5 READ_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH5_AL3_READ_ADDR_TRIG: CH5_AL3_READ_ADDR_TRIG = .{},
    /// DMA Channel 6 Read Address pointer
    CH6_READ_ADDR: CH6_READ_ADDR = .{},
    /// DMA Channel 6 Write Address pointer
    CH6_WRITE_ADDR: CH6_WRITE_ADDR = .{},
    /// DMA Channel 6 Transfer Count
    CH6_TRANS_COUNT: CH6_TRANS_COUNT = .{},
    /// DMA Channel 6 Control and Status
    CH6_CTRL_TRIG: CH6_CTRL_TRIG = .{},
    /// Alias for channel 6 CTRL register
    CH6_AL1_CTRL: CH6_AL1_CTRL = .{},
    /// Alias for channel 6 READ_ADDR register
    CH6_AL1_READ_ADDR: CH6_AL1_READ_ADDR = .{},
    /// Alias for channel 6 WRITE_ADDR register
    CH6_AL1_WRITE_ADDR: CH6_AL1_WRITE_ADDR = .{},
    /// Alias for channel 6 TRANS_COUNT register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH6_AL1_TRANS_COUNT_TRIG: CH6_AL1_TRANS_COUNT_TRIG = .{},
    /// Alias for channel 6 CTRL register
    CH6_AL2_CTRL: CH6_AL2_CTRL = .{},
    /// Alias for channel 6 TRANS_COUNT register
    CH6_AL2_TRANS_COUNT: CH6_AL2_TRANS_COUNT = .{},
    /// Alias for channel 6 READ_ADDR register
    CH6_AL2_READ_ADDR: CH6_AL2_READ_ADDR = .{},
    /// Alias for channel 6 WRITE_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH6_AL2_WRITE_ADDR_TRIG: CH6_AL2_WRITE_ADDR_TRIG = .{},
    /// Alias for channel 6 CTRL register
    CH6_AL3_CTRL: CH6_AL3_CTRL = .{},
    /// Alias for channel 6 WRITE_ADDR register
    CH6_AL3_WRITE_ADDR: CH6_AL3_WRITE_ADDR = .{},
    /// Alias for channel 6 TRANS_COUNT register
    CH6_AL3_TRANS_COUNT: CH6_AL3_TRANS_COUNT = .{},
    /// Alias for channel 6 READ_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH6_AL3_READ_ADDR_TRIG: CH6_AL3_READ_ADDR_TRIG = .{},
    /// DMA Channel 7 Read Address pointer
    CH7_READ_ADDR: CH7_READ_ADDR = .{},
    /// DMA Channel 7 Write Address pointer
    CH7_WRITE_ADDR: CH7_WRITE_ADDR = .{},
    /// DMA Channel 7 Transfer Count
    CH7_TRANS_COUNT: CH7_TRANS_COUNT = .{},
    /// DMA Channel 7 Control and Status
    CH7_CTRL_TRIG: CH7_CTRL_TRIG = .{},
    /// Alias for channel 7 CTRL register
    CH7_AL1_CTRL: CH7_AL1_CTRL = .{},
    /// Alias for channel 7 READ_ADDR register
    CH7_AL1_READ_ADDR: CH7_AL1_READ_ADDR = .{},
    /// Alias for channel 7 WRITE_ADDR register
    CH7_AL1_WRITE_ADDR: CH7_AL1_WRITE_ADDR = .{},
    /// Alias for channel 7 TRANS_COUNT register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH7_AL1_TRANS_COUNT_TRIG: CH7_AL1_TRANS_COUNT_TRIG = .{},
    /// Alias for channel 7 CTRL register
    CH7_AL2_CTRL: CH7_AL2_CTRL = .{},
    /// Alias for channel 7 TRANS_COUNT register
    CH7_AL2_TRANS_COUNT: CH7_AL2_TRANS_COUNT = .{},
    /// Alias for channel 7 READ_ADDR register
    CH7_AL2_READ_ADDR: CH7_AL2_READ_ADDR = .{},
    /// Alias for channel 7 WRITE_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH7_AL2_WRITE_ADDR_TRIG: CH7_AL2_WRITE_ADDR_TRIG = .{},
    /// Alias for channel 7 CTRL register
    CH7_AL3_CTRL: CH7_AL3_CTRL = .{},
    /// Alias for channel 7 WRITE_ADDR register
    CH7_AL3_WRITE_ADDR: CH7_AL3_WRITE_ADDR = .{},
    /// Alias for channel 7 TRANS_COUNT register
    CH7_AL3_TRANS_COUNT: CH7_AL3_TRANS_COUNT = .{},
    /// Alias for channel 7 READ_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH7_AL3_READ_ADDR_TRIG: CH7_AL3_READ_ADDR_TRIG = .{},
    /// DMA Channel 8 Read Address pointer
    CH8_READ_ADDR: CH8_READ_ADDR = .{},
    /// DMA Channel 8 Write Address pointer
    CH8_WRITE_ADDR: CH8_WRITE_ADDR = .{},
    /// DMA Channel 8 Transfer Count
    CH8_TRANS_COUNT: CH8_TRANS_COUNT = .{},
    /// DMA Channel 8 Control and Status
    CH8_CTRL_TRIG: CH8_CTRL_TRIG = .{},
    /// Alias for channel 8 CTRL register
    CH8_AL1_CTRL: CH8_AL1_CTRL = .{},
    /// Alias for channel 8 READ_ADDR register
    CH8_AL1_READ_ADDR: CH8_AL1_READ_ADDR = .{},
    /// Alias for channel 8 WRITE_ADDR register
    CH8_AL1_WRITE_ADDR: CH8_AL1_WRITE_ADDR = .{},
    /// Alias for channel 8 TRANS_COUNT register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH8_AL1_TRANS_COUNT_TRIG: CH8_AL1_TRANS_COUNT_TRIG = .{},
    /// Alias for channel 8 CTRL register
    CH8_AL2_CTRL: CH8_AL2_CTRL = .{},
    /// Alias for channel 8 TRANS_COUNT register
    CH8_AL2_TRANS_COUNT: CH8_AL2_TRANS_COUNT = .{},
    /// Alias for channel 8 READ_ADDR register
    CH8_AL2_READ_ADDR: CH8_AL2_READ_ADDR = .{},
    /// Alias for channel 8 WRITE_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH8_AL2_WRITE_ADDR_TRIG: CH8_AL2_WRITE_ADDR_TRIG = .{},
    /// Alias for channel 8 CTRL register
    CH8_AL3_CTRL: CH8_AL3_CTRL = .{},
    /// Alias for channel 8 WRITE_ADDR register
    CH8_AL3_WRITE_ADDR: CH8_AL3_WRITE_ADDR = .{},
    /// Alias for channel 8 TRANS_COUNT register
    CH8_AL3_TRANS_COUNT: CH8_AL3_TRANS_COUNT = .{},
    /// Alias for channel 8 READ_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH8_AL3_READ_ADDR_TRIG: CH8_AL3_READ_ADDR_TRIG = .{},
    /// DMA Channel 9 Read Address pointer
    CH9_READ_ADDR: CH9_READ_ADDR = .{},
    /// DMA Channel 9 Write Address pointer
    CH9_WRITE_ADDR: CH9_WRITE_ADDR = .{},
    /// DMA Channel 9 Transfer Count
    CH9_TRANS_COUNT: CH9_TRANS_COUNT = .{},
    /// DMA Channel 9 Control and Status
    CH9_CTRL_TRIG: CH9_CTRL_TRIG = .{},
    /// Alias for channel 9 CTRL register
    CH9_AL1_CTRL: CH9_AL1_CTRL = .{},
    /// Alias for channel 9 READ_ADDR register
    CH9_AL1_READ_ADDR: CH9_AL1_READ_ADDR = .{},
    /// Alias for channel 9 WRITE_ADDR register
    CH9_AL1_WRITE_ADDR: CH9_AL1_WRITE_ADDR = .{},
    /// Alias for channel 9 TRANS_COUNT register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH9_AL1_TRANS_COUNT_TRIG: CH9_AL1_TRANS_COUNT_TRIG = .{},
    /// Alias for channel 9 CTRL register
    CH9_AL2_CTRL: CH9_AL2_CTRL = .{},
    /// Alias for channel 9 TRANS_COUNT register
    CH9_AL2_TRANS_COUNT: CH9_AL2_TRANS_COUNT = .{},
    /// Alias for channel 9 READ_ADDR register
    CH9_AL2_READ_ADDR: CH9_AL2_READ_ADDR = .{},
    /// Alias for channel 9 WRITE_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH9_AL2_WRITE_ADDR_TRIG: CH9_AL2_WRITE_ADDR_TRIG = .{},
    /// Alias for channel 9 CTRL register
    CH9_AL3_CTRL: CH9_AL3_CTRL = .{},
    /// Alias for channel 9 WRITE_ADDR register
    CH9_AL3_WRITE_ADDR: CH9_AL3_WRITE_ADDR = .{},
    /// Alias for channel 9 TRANS_COUNT register
    CH9_AL3_TRANS_COUNT: CH9_AL3_TRANS_COUNT = .{},
    /// Alias for channel 9 READ_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH9_AL3_READ_ADDR_TRIG: CH9_AL3_READ_ADDR_TRIG = .{},
    /// DMA Channel 10 Read Address pointer
    CH10_READ_ADDR: CH10_READ_ADDR = .{},
    /// DMA Channel 10 Write Address pointer
    CH10_WRITE_ADDR: CH10_WRITE_ADDR = .{},
    /// DMA Channel 10 Transfer Count
    CH10_TRANS_COUNT: CH10_TRANS_COUNT = .{},
    /// DMA Channel 10 Control and Status
    CH10_CTRL_TRIG: CH10_CTRL_TRIG = .{},
    /// Alias for channel 10 CTRL register
    CH10_AL1_CTRL: CH10_AL1_CTRL = .{},
    /// Alias for channel 10 READ_ADDR register
    CH10_AL1_READ_ADDR: CH10_AL1_READ_ADDR = .{},
    /// Alias for channel 10 WRITE_ADDR register
    CH10_AL1_WRITE_ADDR: CH10_AL1_WRITE_ADDR = .{},
    /// Alias for channel 10 TRANS_COUNT register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH10_AL1_TRANS_COUNT_TRIG: CH10_AL1_TRANS_COUNT_TRIG = .{},
    /// Alias for channel 10 CTRL register
    CH10_AL2_CTRL: CH10_AL2_CTRL = .{},
    /// Alias for channel 10 TRANS_COUNT register
    CH10_AL2_TRANS_COUNT: CH10_AL2_TRANS_COUNT = .{},
    /// Alias for channel 10 READ_ADDR register
    CH10_AL2_READ_ADDR: CH10_AL2_READ_ADDR = .{},
    /// Alias for channel 10 WRITE_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH10_AL2_WRITE_ADDR_TRIG: CH10_AL2_WRITE_ADDR_TRIG = .{},
    /// Alias for channel 10 CTRL register
    CH10_AL3_CTRL: CH10_AL3_CTRL = .{},
    /// Alias for channel 10 WRITE_ADDR register
    CH10_AL3_WRITE_ADDR: CH10_AL3_WRITE_ADDR = .{},
    /// Alias for channel 10 TRANS_COUNT register
    CH10_AL3_TRANS_COUNT: CH10_AL3_TRANS_COUNT = .{},
    /// Alias for channel 10 READ_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH10_AL3_READ_ADDR_TRIG: CH10_AL3_READ_ADDR_TRIG = .{},
    /// DMA Channel 11 Read Address pointer
    CH11_READ_ADDR: CH11_READ_ADDR = .{},
    /// DMA Channel 11 Write Address pointer
    CH11_WRITE_ADDR: CH11_WRITE_ADDR = .{},
    /// DMA Channel 11 Transfer Count
    CH11_TRANS_COUNT: CH11_TRANS_COUNT = .{},
    /// DMA Channel 11 Control and Status
    CH11_CTRL_TRIG: CH11_CTRL_TRIG = .{},
    /// Alias for channel 11 CTRL register
    CH11_AL1_CTRL: CH11_AL1_CTRL = .{},
    /// Alias for channel 11 READ_ADDR register
    CH11_AL1_READ_ADDR: CH11_AL1_READ_ADDR = .{},
    /// Alias for channel 11 WRITE_ADDR register
    CH11_AL1_WRITE_ADDR: CH11_AL1_WRITE_ADDR = .{},
    /// Alias for channel 11 TRANS_COUNT register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH11_AL1_TRANS_COUNT_TRIG: CH11_AL1_TRANS_COUNT_TRIG = .{},
    /// Alias for channel 11 CTRL register
    CH11_AL2_CTRL: CH11_AL2_CTRL = .{},
    /// Alias for channel 11 TRANS_COUNT register
    CH11_AL2_TRANS_COUNT: CH11_AL2_TRANS_COUNT = .{},
    /// Alias for channel 11 READ_ADDR register
    CH11_AL2_READ_ADDR: CH11_AL2_READ_ADDR = .{},
    /// Alias for channel 11 WRITE_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH11_AL2_WRITE_ADDR_TRIG: CH11_AL2_WRITE_ADDR_TRIG = .{},
    /// Alias for channel 11 CTRL register
    CH11_AL3_CTRL: CH11_AL3_CTRL = .{},
    /// Alias for channel 11 WRITE_ADDR register
    CH11_AL3_WRITE_ADDR: CH11_AL3_WRITE_ADDR = .{},
    /// Alias for channel 11 TRANS_COUNT register
    CH11_AL3_TRANS_COUNT: CH11_AL3_TRANS_COUNT = .{},
    /// Alias for channel 11 READ_ADDR register
    /// This is a trigger register (0xc). Writing a nonzero value will
    /// reload the channel counter and start the channel.
    CH11_AL3_READ_ADDR_TRIG: CH11_AL3_READ_ADDR_TRIG = .{},
    /// Interrupt Status (raw)
    INTR: INTR = .{},
    /// Interrupt Enables for IRQ 0
    INTE0: INTE0 = .{},
    /// Force Interrupts
    INTF0: INTF0 = .{},
    /// Interrupt Status for IRQ 0
    INTS0: INTS0 = .{},
    /// Interrupt Status (raw)
    INTR1: INTR1 = .{},
    /// Interrupt Enables for IRQ 1
    INTE1: INTE1 = .{},
    /// Force Interrupts for IRQ 1
    INTF1: INTF1 = .{},
    /// Interrupt Status (masked) for IRQ 1
    INTS1: INTS1 = .{},
    /// Pacing (X/Y) Fractional Timer
    /// The pacing timer produces TREQ assertions at a rate set by ((X/Y) * sys_clk). This equation is evaluated every sys_clk cycles and therefore can only generate TREQs at a rate of 1 per sys_clk (i.e. permanent TREQ) or less.
    TIMER0: TIMER0 = .{},
    /// Pacing (X/Y) Fractional Timer
    /// The pacing timer produces TREQ assertions at a rate set by ((X/Y) * sys_clk). This equation is evaluated every sys_clk cycles and therefore can only generate TREQs at a rate of 1 per sys_clk (i.e. permanent TREQ) or less.
    TIMER1: TIMER1 = .{},
    /// Pacing (X/Y) Fractional Timer
    /// The pacing timer produces TREQ assertions at a rate set by ((X/Y) * sys_clk). This equation is evaluated every sys_clk cycles and therefore can only generate TREQs at a rate of 1 per sys_clk (i.e. permanent TREQ) or less.
    TIMER2: TIMER2 = .{},
    /// Pacing (X/Y) Fractional Timer
    /// The pacing timer produces TREQ assertions at a rate set by ((X/Y) * sys_clk). This equation is evaluated every sys_clk cycles and therefore can only generate TREQs at a rate of 1 per sys_clk (i.e. permanent TREQ) or less.
    TIMER3: TIMER3 = .{},
    /// Trigger one or more channels simultaneously
    MULTI_CHAN_TRIGGER: MULTI_CHAN_TRIGGER = .{},
    /// Sniffer Control
    SNIFF_CTRL: SNIFF_CTRL = .{},
    /// Data accumulator for sniff hardware
    SNIFF_DATA: SNIFF_DATA = .{},
    /// Debug RAF, WAF, TDF levels
    FIFO_LEVELS: FIFO_LEVELS = .{},
    /// Abort an in-progress transfer sequence on one or more channels
    CHAN_ABORT: CHAN_ABORT = .{},
    /// The number of channels this DMA instance is equipped with. This DMA supports up to 16 hardware channels, but can be configured with as few as one, to minimise silicon area.
    N_CHANNELS: N_CHANNELS = .{},
    /// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
    CH0_DBG_CTDREQ: CH0_DBG_CTDREQ = .{},
    /// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
    CH0_DBG_TCR: CH0_DBG_TCR = .{},
    /// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
    CH1_DBG_CTDREQ: CH1_DBG_CTDREQ = .{},
    /// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
    CH1_DBG_TCR: CH1_DBG_TCR = .{},
    /// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
    CH2_DBG_CTDREQ: CH2_DBG_CTDREQ = .{},
    /// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
    CH2_DBG_TCR: CH2_DBG_TCR = .{},
    /// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
    CH3_DBG_CTDREQ: CH3_DBG_CTDREQ = .{},
    /// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
    CH3_DBG_TCR: CH3_DBG_TCR = .{},
    /// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
    CH4_DBG_CTDREQ: CH4_DBG_CTDREQ = .{},
    /// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
    CH4_DBG_TCR: CH4_DBG_TCR = .{},
    /// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
    CH5_DBG_CTDREQ: CH5_DBG_CTDREQ = .{},
    /// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
    CH5_DBG_TCR: CH5_DBG_TCR = .{},
    /// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
    CH6_DBG_CTDREQ: CH6_DBG_CTDREQ = .{},
    /// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
    CH6_DBG_TCR: CH6_DBG_TCR = .{},
    /// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
    CH7_DBG_CTDREQ: CH7_DBG_CTDREQ = .{},
    /// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
    CH7_DBG_TCR: CH7_DBG_TCR = .{},
    /// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
    CH8_DBG_CTDREQ: CH8_DBG_CTDREQ = .{},
    /// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
    CH8_DBG_TCR: CH8_DBG_TCR = .{},
    /// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
    CH9_DBG_CTDREQ: CH9_DBG_CTDREQ = .{},
    /// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
    CH9_DBG_TCR: CH9_DBG_TCR = .{},
    /// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
    CH10_DBG_CTDREQ: CH10_DBG_CTDREQ = .{},
    /// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
    CH10_DBG_TCR: CH10_DBG_TCR = .{},
    /// Read: get channel DREQ counter (i.e. how many accesses the DMA expects it can perform on the peripheral without overflow/underflow. Write any value: clears the counter, and cause channel to re-initiate DREQ handshake.
    CH11_DBG_CTDREQ: CH11_DBG_CTDREQ = .{},
    /// Read to get channel TRANS_COUNT reload value, i.e. the length of the next transfer
    CH11_DBG_TCR: CH11_DBG_TCR = .{},
};
pub const DMA = DMA_p{};
