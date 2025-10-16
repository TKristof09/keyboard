const helpers = @import("helpers.zig");
/// Control register 0
pub const CTRLR0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000000),
    pub const FieldMasks = struct {
        pub const SSTE: u32 = helpers.generateMask(24, 25);
        pub const SPI_FRF: u32 = helpers.generateMask(21, 23);
        pub const DFS_32: u32 = helpers.generateMask(16, 21);
        pub const CFS: u32 = helpers.generateMask(12, 16);
        pub const SRL: u32 = helpers.generateMask(11, 12);
        pub const SLV_OE: u32 = helpers.generateMask(10, 11);
        pub const TMOD: u32 = helpers.generateMask(8, 10);
        pub const SCPOL: u32 = helpers.generateMask(7, 8);
        pub const SCPH: u32 = helpers.generateMask(6, 7);
        pub const FRF: u32 = helpers.generateMask(4, 6);
        pub const DFS: u32 = helpers.generateMask(0, 4);
    };
    const SPI_FRF_e = enum(u2) {
        STD = 0,
        DUAL = 1,
        QUAD = 2,
    };
    const TMOD_e = enum(u2) {
        TX_AND_RX = 0,
        TX_ONLY = 1,
        RX_ONLY = 2,
        EEPROM_READ = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Slave select toggle enable
        pub fn SSTE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        /// SPI frame format
        pub fn SPI_FRF(self: Value, v: SPI_FRF_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 23),
            };
        }
        /// Data frame size in 32b transfer mode
        /// Value of n -&gt; n+1 clocks per frame.
        pub fn DFS_32(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 21),
            };
        }
        /// Control frame size
        /// Value of n -&gt; n+1 clocks per frame.
        pub fn CFS(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 16),
            };
        }
        /// Shift register loop (test mode)
        pub fn SRL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Slave output enable
        pub fn SLV_OE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Transfer mode
        pub fn TMOD(self: Value, v: TMOD_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 10),
            };
        }
        /// Serial clock polarity
        pub fn SCPOL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Serial clock phase
        pub fn SCPH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// Frame format
        pub fn FRF(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 6),
            };
        }
        /// Data frame size
        pub fn DFS(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 4),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn SSTE(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn SPI_FRF(self: Result) SPI_FRF_e {
            const mask = comptime helpers.generateMask(21, 23);
            const val: @typeInfo(SPI_FRF_e).@"enum".tag_type = @intCast((self.val & mask) >> 21);
            return @enumFromInt(val);
        }
        pub fn DFS_32(self: Result) u5 {
            const mask = comptime helpers.generateMask(16, 21);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn CFS(self: Result) u4 {
            const mask = comptime helpers.generateMask(12, 16);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn SRL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn SLV_OE(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn TMOD(self: Result) TMOD_e {
            const mask = comptime helpers.generateMask(8, 10);
            const val: @typeInfo(TMOD_e).@"enum".tag_type = @intCast((self.val & mask) >> 8);
            return @enumFromInt(val);
        }
        pub fn SCPOL(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn SCPH(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn FRF(self: Result) u2 {
            const mask = comptime helpers.generateMask(4, 6);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DFS(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Slave select toggle enable
    pub fn SSTE(v: u1) Value {
        return Value.SSTE(.{}, v);
    }
    /// SPI frame format
    pub fn SPI_FRF(v: SPI_FRF_e) Value {
        return Value.SPI_FRF(.{}, v);
    }
    /// Data frame size in 32b transfer mode
    /// Value of n -&gt; n+1 clocks per frame.
    pub fn DFS_32(v: u5) Value {
        return Value.DFS_32(.{}, v);
    }
    /// Control frame size
    /// Value of n -&gt; n+1 clocks per frame.
    pub fn CFS(v: u4) Value {
        return Value.CFS(.{}, v);
    }
    /// Shift register loop (test mode)
    pub fn SRL(v: u1) Value {
        return Value.SRL(.{}, v);
    }
    /// Slave output enable
    pub fn SLV_OE(v: u1) Value {
        return Value.SLV_OE(.{}, v);
    }
    /// Transfer mode
    pub fn TMOD(v: TMOD_e) Value {
        return Value.TMOD(.{}, v);
    }
    /// Serial clock polarity
    pub fn SCPOL(v: u1) Value {
        return Value.SCPOL(.{}, v);
    }
    /// Serial clock phase
    pub fn SCPH(v: u1) Value {
        return Value.SCPH(.{}, v);
    }
    /// Frame format
    pub fn FRF(v: u2) Value {
        return Value.FRF(.{}, v);
    }
    /// Data frame size
    pub fn DFS(v: u4) Value {
        return Value.DFS(.{}, v);
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
/// Master Control register 1
pub const CTRLR1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000004),
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
/// SSI Enable
pub const SSIENR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000008),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Microwire Control
pub const MWCR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x1800000c),
    pub const FieldMasks = struct {
        pub const MHS: u32 = helpers.generateMask(2, 3);
        pub const MDD: u32 = helpers.generateMask(1, 2);
        pub const MWMOD: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Microwire handshaking
        pub fn MHS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Microwire control
        pub fn MDD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Microwire transfer mode
        pub fn MWMOD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn MHS(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn MDD(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn MWMOD(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Microwire handshaking
    pub fn MHS(v: u1) Value {
        return Value.MHS(.{}, v);
    }
    /// Microwire control
    pub fn MDD(v: u1) Value {
        return Value.MDD(.{}, v);
    }
    /// Microwire transfer mode
    pub fn MWMOD(v: u1) Value {
        return Value.MWMOD(.{}, v);
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
/// Slave enable
pub const SER = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000010),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Baud rate
pub const BAUDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000014),
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
/// TX FIFO threshold level
pub const TXFTLR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000018),
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
/// RX FIFO threshold level
pub const RXFTLR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x1800001c),
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
/// TX FIFO level
pub const TXFLR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000020),
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
/// RX FIFO level
pub const RXFLR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000024),
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
/// Status register
pub const SR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000028),
    pub const FieldMasks = struct {
        pub const DCOL: u32 = helpers.generateMask(6, 7);
        pub const TXE: u32 = helpers.generateMask(5, 6);
        pub const RFF: u32 = helpers.generateMask(4, 5);
        pub const RFNE: u32 = helpers.generateMask(3, 4);
        pub const TFE: u32 = helpers.generateMask(2, 3);
        pub const TFNF: u32 = helpers.generateMask(1, 2);
        pub const BUSY: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn DCOL(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn TXE(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn RFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn RFNE(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn TFE(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn TFNF(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn BUSY(self: Result) u1 {
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
/// Interrupt mask
pub const IMR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x1800002c),
    pub const FieldMasks = struct {
        pub const MSTIM: u32 = helpers.generateMask(5, 6);
        pub const RXFIM: u32 = helpers.generateMask(4, 5);
        pub const RXOIM: u32 = helpers.generateMask(3, 4);
        pub const RXUIM: u32 = helpers.generateMask(2, 3);
        pub const TXOIM: u32 = helpers.generateMask(1, 2);
        pub const TXEIM: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Multi-master contention interrupt mask
        pub fn MSTIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// Receive FIFO full interrupt mask
        pub fn RXFIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Receive FIFO overflow interrupt mask
        pub fn RXOIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Receive FIFO underflow interrupt mask
        pub fn RXUIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Transmit FIFO overflow interrupt mask
        pub fn TXOIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Transmit FIFO empty interrupt mask
        pub fn TXEIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn MSTIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn RXFIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn RXOIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn RXUIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn TXOIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn TXEIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Multi-master contention interrupt mask
    pub fn MSTIM(v: u1) Value {
        return Value.MSTIM(.{}, v);
    }
    /// Receive FIFO full interrupt mask
    pub fn RXFIM(v: u1) Value {
        return Value.RXFIM(.{}, v);
    }
    /// Receive FIFO overflow interrupt mask
    pub fn RXOIM(v: u1) Value {
        return Value.RXOIM(.{}, v);
    }
    /// Receive FIFO underflow interrupt mask
    pub fn RXUIM(v: u1) Value {
        return Value.RXUIM(.{}, v);
    }
    /// Transmit FIFO overflow interrupt mask
    pub fn TXOIM(v: u1) Value {
        return Value.TXOIM(.{}, v);
    }
    /// Transmit FIFO empty interrupt mask
    pub fn TXEIM(v: u1) Value {
        return Value.TXEIM(.{}, v);
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
/// Interrupt status
pub const ISR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000030),
    pub const FieldMasks = struct {
        pub const MSTIS: u32 = helpers.generateMask(5, 6);
        pub const RXFIS: u32 = helpers.generateMask(4, 5);
        pub const RXOIS: u32 = helpers.generateMask(3, 4);
        pub const RXUIS: u32 = helpers.generateMask(2, 3);
        pub const TXOIS: u32 = helpers.generateMask(1, 2);
        pub const TXEIS: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn MSTIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn RXFIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn RXOIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn RXUIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn TXOIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn TXEIS(self: Result) u1 {
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
/// Raw interrupt status
pub const RISR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000034),
    pub const FieldMasks = struct {
        pub const MSTIR: u32 = helpers.generateMask(5, 6);
        pub const RXFIR: u32 = helpers.generateMask(4, 5);
        pub const RXOIR: u32 = helpers.generateMask(3, 4);
        pub const RXUIR: u32 = helpers.generateMask(2, 3);
        pub const TXOIR: u32 = helpers.generateMask(1, 2);
        pub const TXEIR: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn MSTIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn RXFIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn RXOIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn RXUIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn TXOIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn TXEIR(self: Result) u1 {
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
/// TX FIFO overflow interrupt clear
pub const TXOICR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000038),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// RX FIFO overflow interrupt clear
pub const RXOICR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x1800003c),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// RX FIFO underflow interrupt clear
pub const RXUICR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000040),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Multi-master interrupt clear
pub const MSTICR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000044),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// Interrupt clear
pub const ICR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000048),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
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
/// DMA control
pub const DMACR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x1800004c),
    pub const FieldMasks = struct {
        pub const TDMAE: u32 = helpers.generateMask(1, 2);
        pub const RDMAE: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Transmit DMA enable
        pub fn TDMAE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Receive DMA enable
        pub fn RDMAE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn TDMAE(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn RDMAE(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Transmit DMA enable
    pub fn TDMAE(v: u1) Value {
        return Value.TDMAE(.{}, v);
    }
    /// Receive DMA enable
    pub fn RDMAE(v: u1) Value {
        return Value.RDMAE(.{}, v);
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
/// DMA TX data level
pub const DMATDLR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000050),
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
/// DMA RX data level
pub const DMARDLR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000054),
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
/// Identification register
pub const IDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000058),
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
/// Version ID
pub const SSI_VERSION_ID = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x1800005c),
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
/// Data Register 0 (of 36)
pub const DR0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x18000060),
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
/// RX sample delay
pub const RX_SAMPLE_DLY = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x180000f0),
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
/// SPI control
pub const SPI_CTRLR0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x180000f4),
    pub const FieldMasks = struct {
        pub const XIP_CMD: u32 = helpers.generateMask(24, 32);
        pub const SPI_RXDS_EN: u32 = helpers.generateMask(18, 19);
        pub const INST_DDR_EN: u32 = helpers.generateMask(17, 18);
        pub const SPI_DDR_EN: u32 = helpers.generateMask(16, 17);
        pub const WAIT_CYCLES: u32 = helpers.generateMask(11, 16);
        pub const INST_L: u32 = helpers.generateMask(8, 10);
        pub const ADDR_L: u32 = helpers.generateMask(2, 6);
        pub const TRANS_TYPE: u32 = helpers.generateMask(0, 2);
    };
    const INST_L_e = enum(u2) {
        NONE = 0,
        @"4B" = 1,
        @"8B" = 2,
        @"16B" = 3,
    };
    const TRANS_TYPE_e = enum(u2) {
        @"1C1A" = 0,
        @"1C2A" = 1,
        @"2C2A" = 2,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// SPI Command to send in XIP mode (INST_L = 8-bit) or to append to Address (INST_L = 0-bit)
        pub fn XIP_CMD(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 32),
            };
        }
        /// Read data strobe enable
        pub fn SPI_RXDS_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        /// Instruction DDR transfer enable
        pub fn INST_DDR_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// SPI DDR transfer enable
        pub fn SPI_DDR_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// Wait cycles between control frame transmit and data reception (in SCLK cycles)
        pub fn WAIT_CYCLES(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 16),
            };
        }
        /// Instruction length (0/4/8/16b)
        pub fn INST_L(self: Value, v: INST_L_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 10),
            };
        }
        /// Address length (0b-60b in 4b increments)
        pub fn ADDR_L(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 6),
            };
        }
        /// Address and instruction transfer format
        pub fn TRANS_TYPE(self: Value, v: TRANS_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 2),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn XIP_CMD(self: Result) u8 {
            const mask = comptime helpers.generateMask(24, 32);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn SPI_RXDS_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn INST_DDR_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn SPI_DDR_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn WAIT_CYCLES(self: Result) u5 {
            const mask = comptime helpers.generateMask(11, 16);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn INST_L(self: Result) INST_L_e {
            const mask = comptime helpers.generateMask(8, 10);
            const val: @typeInfo(INST_L_e).@"enum".tag_type = @intCast((self.val & mask) >> 8);
            return @enumFromInt(val);
        }
        pub fn ADDR_L(self: Result) u4 {
            const mask = comptime helpers.generateMask(2, 6);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn TRANS_TYPE(self: Result) TRANS_TYPE_e {
            const mask = comptime helpers.generateMask(0, 2);
            const val: @typeInfo(TRANS_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
        }
    };
    /// SPI Command to send in XIP mode (INST_L = 8-bit) or to append to Address (INST_L = 0-bit)
    pub fn XIP_CMD(v: u8) Value {
        return Value.XIP_CMD(.{}, v);
    }
    /// Read data strobe enable
    pub fn SPI_RXDS_EN(v: u1) Value {
        return Value.SPI_RXDS_EN(.{}, v);
    }
    /// Instruction DDR transfer enable
    pub fn INST_DDR_EN(v: u1) Value {
        return Value.INST_DDR_EN(.{}, v);
    }
    /// SPI DDR transfer enable
    pub fn SPI_DDR_EN(v: u1) Value {
        return Value.SPI_DDR_EN(.{}, v);
    }
    /// Wait cycles between control frame transmit and data reception (in SCLK cycles)
    pub fn WAIT_CYCLES(v: u5) Value {
        return Value.WAIT_CYCLES(.{}, v);
    }
    /// Instruction length (0/4/8/16b)
    pub fn INST_L(v: INST_L_e) Value {
        return Value.INST_L(.{}, v);
    }
    /// Address length (0b-60b in 4b increments)
    pub fn ADDR_L(v: u4) Value {
        return Value.ADDR_L(.{}, v);
    }
    /// Address and instruction transfer format
    pub fn TRANS_TYPE(v: TRANS_TYPE_e) Value {
        return Value.TRANS_TYPE(.{}, v);
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
/// TX drive edge
pub const TXD_DRIVE_EDGE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x180000f8),
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
/// DW_apb_ssi has the following features:
/// * APB interface – Allows for easy integration into a DesignWare Synthesizable Components for AMBA 2 implementation.
/// * APB3 and APB4 protocol support.
/// * Scalable APB data bus width – Supports APB data bus widths of 8, 16, and 32 bits.
/// * Serial-master or serial-slave operation – Enables serial communication with serial-master or serial-slave peripheral devices.
/// * Programmable Dual/Quad/Octal SPI support in Master Mode.
/// * Dual Data Rate (DDR) and Read Data Strobe (RDS) Support - Enables the DW_apb_ssi master to perform operations with the device in DDR and RDS modes when working in Dual/Quad/Octal mode of operation.
/// * Data Mask Support - Enables the DW_apb_ssi to selectively update the bytes in the device. This feature is applicable only in enhanced SPI modes.
/// * eXecute-In-Place (XIP) support - Enables the DW_apb_ssi master to behave as a memory mapped I/O and fetches the data from the device based on the APB read request. This feature is applicable only in enhanced SPI modes.
/// * DMA Controller Interface – Enables the DW_apb_ssi to interface to a DMA controller over the bus using a handshaking interface for transfer requests.
/// * Independent masking of interrupts – Master collision, transmit FIFO overflow, transmit FIFO empty, receive FIFO full, receive FIFO underflow, and receive FIFO overflow interrupts can all be masked independently.
/// * Multi-master contention detection – Informs the processor of multiple serial-master accesses on the serial bus.
/// * Bypass of meta-stability flip-flops for synchronous clocks – When the APB clock (pclk) and the DW_apb_ssi serial clock (ssi_clk) are synchronous, meta-stable flip-flops are not used when transferring control signals across these clock domains.
/// * Programmable delay on the sample time of the received serial data bit (rxd); enables programmable control of routing delays resulting in higher serial data-bit rates.
/// * Programmable features:
/// - Serial interface operation – Choice of Motorola SPI, Texas Instruments Synchronous Serial Protocol or National Semiconductor Microwire.
/// - Clock bit-rate – Dynamic control of the serial bit rate of the data transfer; used in only serial-master mode of operation.
/// - Data Item size (4 to 32 bits) – Item size of each data transfer under the control of the programmer.
/// * Configured features:
/// - FIFO depth – 16 words deep. The FIFO width is fixed at 32 bits.
/// - 1 slave select output.
/// - Hardware slave-select – Dedicated hardware slave-select line.
/// - Combined interrupt line - one combined interrupt line from the DW_apb_ssi to the interrupt controller.
/// - Interrupt polarity – active high interrupt lines.
/// - Serial clock polarity – low serial-clock polarity directly after reset.
/// - Serial clock phase – capture on first edge of serial-clock directly after reset.
pub const SSI_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x18000000),

    /// Control register 0
    CTRLR0: CTRLR0 = .{},
    /// Master Control register 1
    CTRLR1: CTRLR1 = .{},
    /// SSI Enable
    SSIENR: SSIENR = .{},
    /// Microwire Control
    MWCR: MWCR = .{},
    /// Slave enable
    SER: SER = .{},
    /// Baud rate
    BAUDR: BAUDR = .{},
    /// TX FIFO threshold level
    TXFTLR: TXFTLR = .{},
    /// RX FIFO threshold level
    RXFTLR: RXFTLR = .{},
    /// TX FIFO level
    TXFLR: TXFLR = .{},
    /// RX FIFO level
    RXFLR: RXFLR = .{},
    /// Status register
    SR: SR = .{},
    /// Interrupt mask
    IMR: IMR = .{},
    /// Interrupt status
    ISR: ISR = .{},
    /// Raw interrupt status
    RISR: RISR = .{},
    /// TX FIFO overflow interrupt clear
    TXOICR: TXOICR = .{},
    /// RX FIFO overflow interrupt clear
    RXOICR: RXOICR = .{},
    /// RX FIFO underflow interrupt clear
    RXUICR: RXUICR = .{},
    /// Multi-master interrupt clear
    MSTICR: MSTICR = .{},
    /// Interrupt clear
    ICR: ICR = .{},
    /// DMA control
    DMACR: DMACR = .{},
    /// DMA TX data level
    DMATDLR: DMATDLR = .{},
    /// DMA RX data level
    DMARDLR: DMARDLR = .{},
    /// Identification register
    IDR: IDR = .{},
    /// Version ID
    SSI_VERSION_ID: SSI_VERSION_ID = .{},
    /// Data Register 0 (of 36)
    DR0: DR0 = .{},
    /// RX sample delay
    RX_SAMPLE_DLY: RX_SAMPLE_DLY = .{},
    /// SPI control
    SPI_CTRLR0: SPI_CTRLR0 = .{},
    /// TX drive edge
    TXD_DRIVE_EDGE: TXD_DRIVE_EDGE = .{},
};
pub const SSI = SSI_p{};
