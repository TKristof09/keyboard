const helpers = @import("helpers.zig");
/// Control register 0, SSPCR0 on page 3-4
pub const SSPCR0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003c000),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Serial clock rate. The value SCR is used to generate the transmit and receive bit rate of the PrimeCell SSP. The bit rate is: F SSPCLK CPSDVSR x (1+SCR) where CPSDVSR is an even value from 2-254, programmed through the SSPCPSR register and SCR is a value from 0-255.
        pub fn SCR(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 16),
            };
        }
        /// SSPCLKOUT phase, applicable to Motorola SPI frame format only. See Motorola SPI frame format on page 2-10.
        pub fn SPH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// SSPCLKOUT polarity, applicable to Motorola SPI frame format only. See Motorola SPI frame format on page 2-10.
        pub fn SPO(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// Frame format: 00 Motorola SPI frame format. 01 TI synchronous serial frame format. 10 National Microwire frame format. 11 Reserved, undefined operation.
        pub fn FRF(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 6),
            };
        }
        /// Data Size Select: 0000 Reserved, undefined operation. 0001 Reserved, undefined operation. 0010 Reserved, undefined operation. 0011 4-bit data. 0100 5-bit data. 0101 6-bit data. 0110 7-bit data. 0111 8-bit data. 1000 9-bit data. 1001 10-bit data. 1010 11-bit data. 1011 12-bit data. 1100 13-bit data. 1101 14-bit data. 1110 15-bit data. 1111 16-bit data.
        pub fn DSS(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 4),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn SCR(self: Result) u8 {
            const mask = comptime helpers.generateMask(8, 16);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SPH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn SPO(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn FRF(self: Result) u2 {
            const mask = comptime helpers.generateMask(4, 6);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DSS(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Serial clock rate. The value SCR is used to generate the transmit and receive bit rate of the PrimeCell SSP. The bit rate is: F SSPCLK CPSDVSR x (1+SCR) where CPSDVSR is an even value from 2-254, programmed through the SSPCPSR register and SCR is a value from 0-255.
    pub fn SCR(v: u8) Value {
        return Value.SCR(.{}, v);
    }
    /// SSPCLKOUT phase, applicable to Motorola SPI frame format only. See Motorola SPI frame format on page 2-10.
    pub fn SPH(v: u1) Value {
        return Value.SPH(.{}, v);
    }
    /// SSPCLKOUT polarity, applicable to Motorola SPI frame format only. See Motorola SPI frame format on page 2-10.
    pub fn SPO(v: u1) Value {
        return Value.SPO(.{}, v);
    }
    /// Frame format: 00 Motorola SPI frame format. 01 TI synchronous serial frame format. 10 National Microwire frame format. 11 Reserved, undefined operation.
    pub fn FRF(v: u2) Value {
        return Value.FRF(.{}, v);
    }
    /// Data Size Select: 0000 Reserved, undefined operation. 0001 Reserved, undefined operation. 0010 Reserved, undefined operation. 0011 4-bit data. 0100 5-bit data. 0101 6-bit data. 0110 7-bit data. 0111 8-bit data. 1000 9-bit data. 1001 10-bit data. 1010 11-bit data. 1011 12-bit data. 1100 13-bit data. 1101 14-bit data. 1110 15-bit data. 1111 16-bit data.
    pub fn DSS(v: u4) Value {
        return Value.DSS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Control register 1, SSPCR1 on page 3-5
pub const SSPCR1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003c004),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Slave-mode output disable. This bit is relevant only in the slave mode, MS=1. In multiple-slave systems, it is possible for an PrimeCell SSP master to broadcast a message to all slaves in the system while ensuring that only one slave drives data onto its serial output line. In such systems the RXD lines from multiple slaves could be tied together. To operate in such systems, the SOD bit can be set if the PrimeCell SSP slave is not supposed to drive the SSPTXD line: 0 SSP can drive the SSPTXD output in slave mode. 1 SSP must not drive the SSPTXD output in slave mode.
        pub fn SOD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Master or slave mode select. This bit can be modified only when the PrimeCell SSP is disabled, SSE=0: 0 Device configured as master, default. 1 Device configured as slave.
        pub fn MS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Synchronous serial port enable: 0 SSP operation disabled. 1 SSP operation enabled.
        pub fn SSE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Loop back mode: 0 Normal serial port operation enabled. 1 Output of transmit serial shifter is connected to input of receive serial shifter internally.
        pub fn LBM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn SOD(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn MS(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SSE(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn LBM(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Slave-mode output disable. This bit is relevant only in the slave mode, MS=1. In multiple-slave systems, it is possible for an PrimeCell SSP master to broadcast a message to all slaves in the system while ensuring that only one slave drives data onto its serial output line. In such systems the RXD lines from multiple slaves could be tied together. To operate in such systems, the SOD bit can be set if the PrimeCell SSP slave is not supposed to drive the SSPTXD line: 0 SSP can drive the SSPTXD output in slave mode. 1 SSP must not drive the SSPTXD output in slave mode.
    pub fn SOD(v: u1) Value {
        return Value.SOD(.{}, v);
    }
    /// Master or slave mode select. This bit can be modified only when the PrimeCell SSP is disabled, SSE=0: 0 Device configured as master, default. 1 Device configured as slave.
    pub fn MS(v: u1) Value {
        return Value.MS(.{}, v);
    }
    /// Synchronous serial port enable: 0 SSP operation disabled. 1 SSP operation enabled.
    pub fn SSE(v: u1) Value {
        return Value.SSE(.{}, v);
    }
    /// Loop back mode: 0 Normal serial port operation enabled. 1 Output of transmit serial shifter is connected to input of receive serial shifter internally.
    pub fn LBM(v: u1) Value {
        return Value.LBM(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Data register, SSPDR on page 3-6
pub const SSPDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003c008),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Status register, SSPSR on page 3-7
pub const SSPSR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003c00c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn BSY(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn RFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn RNE(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn TNF(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn TFE(self: Result) u1 {
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
/// Clock prescale register, SSPCPSR on page 3-8
pub const SSPCPSR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003c010),
    pub fn write(self: @This(), v: u8) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Interrupt mask set or clear register, SSPIMSC on page 3-9
pub const SSPIMSC = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003c014),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Transmit FIFO interrupt mask: 0 Transmit FIFO half empty or less condition interrupt is masked. 1 Transmit FIFO half empty or less condition interrupt is not masked.
        pub fn TXIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Receive FIFO interrupt mask: 0 Receive FIFO half full or less condition interrupt is masked. 1 Receive FIFO half full or less condition interrupt is not masked.
        pub fn RXIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Receive timeout interrupt mask: 0 Receive FIFO not empty and no read prior to timeout period interrupt is masked. 1 Receive FIFO not empty and no read prior to timeout period interrupt is not masked.
        pub fn RTIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Receive overrun interrupt mask: 0 Receive FIFO written to while full condition interrupt is masked. 1 Receive FIFO written to while full condition interrupt is not masked.
        pub fn RORIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn TXIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn RXIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn RTIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn RORIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Transmit FIFO interrupt mask: 0 Transmit FIFO half empty or less condition interrupt is masked. 1 Transmit FIFO half empty or less condition interrupt is not masked.
    pub fn TXIM(v: u1) Value {
        return Value.TXIM(.{}, v);
    }
    /// Receive FIFO interrupt mask: 0 Receive FIFO half full or less condition interrupt is masked. 1 Receive FIFO half full or less condition interrupt is not masked.
    pub fn RXIM(v: u1) Value {
        return Value.RXIM(.{}, v);
    }
    /// Receive timeout interrupt mask: 0 Receive FIFO not empty and no read prior to timeout period interrupt is masked. 1 Receive FIFO not empty and no read prior to timeout period interrupt is not masked.
    pub fn RTIM(v: u1) Value {
        return Value.RTIM(.{}, v);
    }
    /// Receive overrun interrupt mask: 0 Receive FIFO written to while full condition interrupt is masked. 1 Receive FIFO written to while full condition interrupt is not masked.
    pub fn RORIM(v: u1) Value {
        return Value.RORIM(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Raw interrupt status register, SSPRIS on page 3-10
pub const SSPRIS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003c018),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn TXRIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn RXRIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn RTRIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn RORRIS(self: Result) u1 {
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
/// Masked interrupt status register, SSPMIS on page 3-11
pub const SSPMIS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003c01c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn TXMIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn RXMIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn RTMIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn RORMIS(self: Result) u1 {
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
/// Interrupt clear register, SSPICR on page 3-11
pub const SSPICR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003c020),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Clears the SSPRTINTR interrupt
        pub fn RTIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Clears the SSPRORINTR interrupt
        pub fn RORIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn RTIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn RORIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Clears the SSPRTINTR interrupt
    pub fn RTIC(v: u1) Value {
        return Value.RTIC(.{}, v);
    }
    /// Clears the SSPRORINTR interrupt
    pub fn RORIC(v: u1) Value {
        return Value.RORIC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// DMA control register, SSPDMACR on page 3-12
pub const SSPDMACR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003c024),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Transmit DMA Enable. If this bit is set to 1, DMA for the transmit FIFO is enabled.
        pub fn TXDMAE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Receive DMA Enable. If this bit is set to 1, DMA for the receive FIFO is enabled.
        pub fn RXDMAE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn TXDMAE(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn RXDMAE(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Transmit DMA Enable. If this bit is set to 1, DMA for the transmit FIFO is enabled.
    pub fn TXDMAE(v: u1) Value {
        return Value.TXDMAE(.{}, v);
    }
    /// Receive DMA Enable. If this bit is set to 1, DMA for the receive FIFO is enabled.
    pub fn RXDMAE(v: u1) Value {
        return Value.RXDMAE(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Peripheral identification registers, SSPPeriphID0-3 on page 3-13
pub const SSPPERIPHID0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003cfe0),
    pub fn write(self: @This(), v: u8) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Peripheral identification registers, SSPPeriphID0-3 on page 3-13
pub const SSPPERIPHID1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003cfe4),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn DESIGNER0(self: Result) u4 {
            const mask = comptime helpers.generateMask(4, 8);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn PARTNUMBER1(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
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
/// Peripheral identification registers, SSPPeriphID0-3 on page 3-13
pub const SSPPERIPHID2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003cfe8),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn REVISION(self: Result) u4 {
            const mask = comptime helpers.generateMask(4, 8);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DESIGNER1(self: Result) u4 {
            const mask = comptime helpers.generateMask(0, 4);
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
/// Peripheral identification registers, SSPPeriphID0-3 on page 3-13
pub const SSPPERIPHID3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003cfec),
    pub fn write(self: @This(), v: u8) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// PrimeCell identification registers, SSPPCellID0-3 on page 3-16
pub const SSPPCELLID0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003cff0),
    pub fn write(self: @This(), v: u8) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// PrimeCell identification registers, SSPPCellID0-3 on page 3-16
pub const SSPPCELLID1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003cff4),
    pub fn write(self: @This(), v: u8) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// PrimeCell identification registers, SSPPCellID0-3 on page 3-16
pub const SSPPCELLID2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003cff8),
    pub fn write(self: @This(), v: u8) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// PrimeCell identification registers, SSPPCellID0-3 on page 3-16
pub const SSPPCELLID3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003cffc),
    pub fn write(self: @This(), v: u8) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
pub const SPI0_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x4003c000),

    /// Control register 0, SSPCR0 on page 3-4
    SSPCR0: SSPCR0 = .{},
    /// Control register 1, SSPCR1 on page 3-5
    SSPCR1: SSPCR1 = .{},
    /// Data register, SSPDR on page 3-6
    SSPDR: SSPDR = .{},
    /// Status register, SSPSR on page 3-7
    SSPSR: SSPSR = .{},
    /// Clock prescale register, SSPCPSR on page 3-8
    SSPCPSR: SSPCPSR = .{},
    /// Interrupt mask set or clear register, SSPIMSC on page 3-9
    SSPIMSC: SSPIMSC = .{},
    /// Raw interrupt status register, SSPRIS on page 3-10
    SSPRIS: SSPRIS = .{},
    /// Masked interrupt status register, SSPMIS on page 3-11
    SSPMIS: SSPMIS = .{},
    /// Interrupt clear register, SSPICR on page 3-11
    SSPICR: SSPICR = .{},
    /// DMA control register, SSPDMACR on page 3-12
    SSPDMACR: SSPDMACR = .{},
    /// Peripheral identification registers, SSPPeriphID0-3 on page 3-13
    SSPPERIPHID0: SSPPERIPHID0 = .{},
    /// Peripheral identification registers, SSPPeriphID0-3 on page 3-13
    SSPPERIPHID1: SSPPERIPHID1 = .{},
    /// Peripheral identification registers, SSPPeriphID0-3 on page 3-13
    SSPPERIPHID2: SSPPERIPHID2 = .{},
    /// Peripheral identification registers, SSPPeriphID0-3 on page 3-13
    SSPPERIPHID3: SSPPERIPHID3 = .{},
    /// PrimeCell identification registers, SSPPCellID0-3 on page 3-16
    SSPPCELLID0: SSPPCELLID0 = .{},
    /// PrimeCell identification registers, SSPPCellID0-3 on page 3-16
    SSPPCELLID1: SSPPCELLID1 = .{},
    /// PrimeCell identification registers, SSPPCellID0-3 on page 3-16
    SSPPCELLID2: SSPPCELLID2 = .{},
    /// PrimeCell identification registers, SSPPCellID0-3 on page 3-16
    SSPPCELLID3: SSPPCELLID3 = .{},
};
pub const SPI0 = SPI0_p{};
