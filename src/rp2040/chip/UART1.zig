const helpers = @import("helpers.zig");
/// Data Register, UARTDR
pub const UARTDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038000),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Receive (read) data character. Transmit (write) data character.
        pub fn DATA(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn OE(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn BE(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn PE(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn FE(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn DATA(self: Result) u8 {
            const mask = comptime helpers.generateMask(0, 8);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Receive (read) data character. Transmit (write) data character.
    pub fn DATA(v: u8) Value {
        return Value.DATA(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Receive Status Register/Error Clear Register, UARTRSR/UARTECR
pub const UARTRSR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038004),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Overrun error. This bit is set to 1 if data is received and the FIFO is already full. This bit is cleared to 0 by a write to UARTECR. The FIFO contents remain valid because no more data is written when the FIFO is full, only the contents of the shift register are overwritten. The CPU must now read the data, to empty the FIFO.
        pub fn OE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Break error. This bit is set to 1 if a break condition was detected, indicating that the received data input was held LOW for longer than a full-word transmission time (defined as start, data, parity, and stop bits). This bit is cleared to 0 after a write to UARTECR. In FIFO mode, this error is associated with the character at the top of the FIFO. When a break occurs, only one 0 character is loaded into the FIFO. The next character is only enabled after the receive data input goes to a 1 (marking state) and the next valid start bit is received.
        pub fn BE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Parity error. When set to 1, it indicates that the parity of the received data character does not match the parity that the EPS and SPS bits in the Line Control Register, UARTLCR_H. This bit is cleared to 0 by a write to UARTECR. In FIFO mode, this error is associated with the character at the top of the FIFO.
        pub fn PE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Framing error. When set to 1, it indicates that the received character did not have a valid stop bit (a valid stop bit is 1). This bit is cleared to 0 by a write to UARTECR. In FIFO mode, this error is associated with the character at the top of the FIFO.
        pub fn FE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn OE(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn BE(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn PE(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn FE(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Overrun error. This bit is set to 1 if data is received and the FIFO is already full. This bit is cleared to 0 by a write to UARTECR. The FIFO contents remain valid because no more data is written when the FIFO is full, only the contents of the shift register are overwritten. The CPU must now read the data, to empty the FIFO.
    pub fn OE(v: u1) Value {
        return Value.OE(.{}, v);
    }
    /// Break error. This bit is set to 1 if a break condition was detected, indicating that the received data input was held LOW for longer than a full-word transmission time (defined as start, data, parity, and stop bits). This bit is cleared to 0 after a write to UARTECR. In FIFO mode, this error is associated with the character at the top of the FIFO. When a break occurs, only one 0 character is loaded into the FIFO. The next character is only enabled after the receive data input goes to a 1 (marking state) and the next valid start bit is received.
    pub fn BE(v: u1) Value {
        return Value.BE(.{}, v);
    }
    /// Parity error. When set to 1, it indicates that the parity of the received data character does not match the parity that the EPS and SPS bits in the Line Control Register, UARTLCR_H. This bit is cleared to 0 by a write to UARTECR. In FIFO mode, this error is associated with the character at the top of the FIFO.
    pub fn PE(v: u1) Value {
        return Value.PE(.{}, v);
    }
    /// Framing error. When set to 1, it indicates that the received character did not have a valid stop bit (a valid stop bit is 1). This bit is cleared to 0 by a write to UARTECR. In FIFO mode, this error is associated with the character at the top of the FIFO.
    pub fn FE(v: u1) Value {
        return Value.FE(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Flag Register, UARTFR
pub const UARTFR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038018),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn RI(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn TXFE(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn RXFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn TXFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn RXFE(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn BUSY(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn DCD(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn DSR(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn CTS(self: Result) u1 {
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
/// IrDA Low-Power Counter Register, UARTILPR
pub const UARTILPR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038020),
    pub fn write(self: @This(), v: u8) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Integer Baud Rate Register, UARTIBRD
pub const UARTIBRD = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038024),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Fractional Baud Rate Register, UARTFBRD
pub const UARTFBRD = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038028),
    pub fn write(self: @This(), v: u6) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Line Control Register, UARTLCR_H
pub const UARTLCR_H = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003802c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Stick parity select. 0 = stick parity is disabled 1 = either: * if the EPS bit is 0 then the parity bit is transmitted and checked as a 1 * if the EPS bit is 1 then the parity bit is transmitted and checked as a 0. This bit has no effect when the PEN bit disables parity checking and generation.
        pub fn SPS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Word length. These bits indicate the number of data bits transmitted or received in a frame as follows: b11 = 8 bits b10 = 7 bits b01 = 6 bits b00 = 5 bits.
        pub fn WLEN(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 7),
            };
        }
        /// Enable FIFOs: 0 = FIFOs are disabled (character mode) that is, the FIFOs become 1-byte-deep holding registers 1 = transmit and receive FIFO buffers are enabled (FIFO mode).
        pub fn FEN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Two stop bits select. If this bit is set to 1, two stop bits are transmitted at the end of the frame. The receive logic does not check for two stop bits being received.
        pub fn STP2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Even parity select. Controls the type of parity the UART uses during transmission and reception: 0 = odd parity. The UART generates or checks for an odd number of 1s in the data and parity bits. 1 = even parity. The UART generates or checks for an even number of 1s in the data and parity bits. This bit has no effect when the PEN bit disables parity checking and generation.
        pub fn EPS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Parity enable: 0 = parity is disabled and no parity bit added to the data frame 1 = parity checking and generation is enabled.
        pub fn PEN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Send break. If this bit is set to 1, a low-level is continually output on the UARTTXD output, after completing transmission of the current character. For the proper execution of the break command, the software must set this bit for at least two complete frames. For normal use, this bit must be cleared to 0.
        pub fn BRK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn SPS(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn WLEN(self: Result) u2 {
            const mask = comptime helpers.generateMask(5, 7);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn FEN(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn STP2(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn EPS(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn PEN(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn BRK(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Stick parity select. 0 = stick parity is disabled 1 = either: * if the EPS bit is 0 then the parity bit is transmitted and checked as a 1 * if the EPS bit is 1 then the parity bit is transmitted and checked as a 0. This bit has no effect when the PEN bit disables parity checking and generation.
    pub fn SPS(v: u1) Value {
        return Value.SPS(.{}, v);
    }
    /// Word length. These bits indicate the number of data bits transmitted or received in a frame as follows: b11 = 8 bits b10 = 7 bits b01 = 6 bits b00 = 5 bits.
    pub fn WLEN(v: u2) Value {
        return Value.WLEN(.{}, v);
    }
    /// Enable FIFOs: 0 = FIFOs are disabled (character mode) that is, the FIFOs become 1-byte-deep holding registers 1 = transmit and receive FIFO buffers are enabled (FIFO mode).
    pub fn FEN(v: u1) Value {
        return Value.FEN(.{}, v);
    }
    /// Two stop bits select. If this bit is set to 1, two stop bits are transmitted at the end of the frame. The receive logic does not check for two stop bits being received.
    pub fn STP2(v: u1) Value {
        return Value.STP2(.{}, v);
    }
    /// Even parity select. Controls the type of parity the UART uses during transmission and reception: 0 = odd parity. The UART generates or checks for an odd number of 1s in the data and parity bits. 1 = even parity. The UART generates or checks for an even number of 1s in the data and parity bits. This bit has no effect when the PEN bit disables parity checking and generation.
    pub fn EPS(v: u1) Value {
        return Value.EPS(.{}, v);
    }
    /// Parity enable: 0 = parity is disabled and no parity bit added to the data frame 1 = parity checking and generation is enabled.
    pub fn PEN(v: u1) Value {
        return Value.PEN(.{}, v);
    }
    /// Send break. If this bit is set to 1, a low-level is continually output on the UARTTXD output, after completing transmission of the current character. For the proper execution of the break command, the software must set this bit for at least two complete frames. For normal use, this bit must be cleared to 0.
    pub fn BRK(v: u1) Value {
        return Value.BRK(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Control Register, UARTCR
pub const UARTCR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038030),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// CTS hardware flow control enable. If this bit is set to 1, CTS hardware flow control is enabled. Data is only transmitted when the nUARTCTS signal is asserted.
        pub fn CTSEN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// RTS hardware flow control enable. If this bit is set to 1, RTS hardware flow control is enabled. Data is only requested when there is space in the receive FIFO for it to be received.
        pub fn RTSEN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// This bit is the complement of the UART Out2 (nUARTOut2) modem status output. That is, when the bit is programmed to a 1, the output is 0. For DTE this can be used as Ring Indicator (RI).
        pub fn OUT2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// This bit is the complement of the UART Out1 (nUARTOut1) modem status output. That is, when the bit is programmed to a 1 the output is 0. For DTE this can be used as Data Carrier Detect (DCD).
        pub fn OUT1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Request to send. This bit is the complement of the UART request to send, nUARTRTS, modem status output. That is, when the bit is programmed to a 1 then nUARTRTS is LOW.
        pub fn RTS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Data transmit ready. This bit is the complement of the UART data transmit ready, nUARTDTR, modem status output. That is, when the bit is programmed to a 1 then nUARTDTR is LOW.
        pub fn DTR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Receive enable. If this bit is set to 1, the receive section of the UART is enabled. Data reception occurs for either UART signals or SIR signals depending on the setting of the SIREN bit. When the UART is disabled in the middle of reception, it completes the current character before stopping.
        pub fn RXE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        /// Transmit enable. If this bit is set to 1, the transmit section of the UART is enabled. Data transmission occurs for either UART signals, or SIR signals depending on the setting of the SIREN bit. When the UART is disabled in the middle of transmission, it completes the current character before stopping.
        pub fn TXE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        /// Loopback enable. If this bit is set to 1 and the SIREN bit is set to 1 and the SIRTEST bit in the Test Control Register, UARTTCR is set to 1, then the nSIROUT path is inverted, and fed through to the SIRIN path. The SIRTEST bit in the test register must be set to 1 to override the normal half-duplex SIR operation. This must be the requirement for accessing the test registers during normal operation, and SIRTEST must be cleared to 0 when loopback testing is finished. This feature reduces the amount of external coupling required during system test. If this bit is set to 1, and the SIRTEST bit is set to 0, the UARTTXD path is fed through to the UARTRXD path. In either SIR mode or UART mode, when this bit is set, the modem outputs are also fed through to the modem inputs. This bit is cleared to 0 on reset, to disable loopback.
        pub fn LBE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// SIR low-power IrDA mode. This bit selects the IrDA encoding mode. If this bit is cleared to 0, low-level bits are transmitted as an active high pulse with a width of 3 / 16th of the bit period. If this bit is set to 1, low-level bits are transmitted with a pulse width that is 3 times the period of the IrLPBaud16 input signal, regardless of the selected bit rate. Setting this bit uses less power, but might reduce transmission distances.
        pub fn SIRLP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// SIR enable: 0 = IrDA SIR ENDEC is disabled. nSIROUT remains LOW (no light pulse generated), and signal transitions on SIRIN have no effect. 1 = IrDA SIR ENDEC is enabled. Data is transmitted and received on nSIROUT and SIRIN. UARTTXD remains HIGH, in the marking state. Signal transitions on UARTRXD or modem status inputs have no effect. This bit has no effect if the UARTEN bit disables the UART.
        pub fn SIREN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// UART enable: 0 = UART is disabled. If the UART is disabled in the middle of transmission or reception, it completes the current character before stopping. 1 = the UART is enabled. Data transmission and reception occurs for either UART signals or SIR signals depending on the setting of the SIREN bit.
        pub fn UARTEN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn CTSEN(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn RTSEN(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn OUT2(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn OUT1(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn RTS(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn DTR(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn RXE(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn TXE(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn LBE(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn SIRLP(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SIREN(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn UARTEN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// CTS hardware flow control enable. If this bit is set to 1, CTS hardware flow control is enabled. Data is only transmitted when the nUARTCTS signal is asserted.
    pub fn CTSEN(v: u1) Value {
        return Value.CTSEN(.{}, v);
    }
    /// RTS hardware flow control enable. If this bit is set to 1, RTS hardware flow control is enabled. Data is only requested when there is space in the receive FIFO for it to be received.
    pub fn RTSEN(v: u1) Value {
        return Value.RTSEN(.{}, v);
    }
    /// This bit is the complement of the UART Out2 (nUARTOut2) modem status output. That is, when the bit is programmed to a 1, the output is 0. For DTE this can be used as Ring Indicator (RI).
    pub fn OUT2(v: u1) Value {
        return Value.OUT2(.{}, v);
    }
    /// This bit is the complement of the UART Out1 (nUARTOut1) modem status output. That is, when the bit is programmed to a 1 the output is 0. For DTE this can be used as Data Carrier Detect (DCD).
    pub fn OUT1(v: u1) Value {
        return Value.OUT1(.{}, v);
    }
    /// Request to send. This bit is the complement of the UART request to send, nUARTRTS, modem status output. That is, when the bit is programmed to a 1 then nUARTRTS is LOW.
    pub fn RTS(v: u1) Value {
        return Value.RTS(.{}, v);
    }
    /// Data transmit ready. This bit is the complement of the UART data transmit ready, nUARTDTR, modem status output. That is, when the bit is programmed to a 1 then nUARTDTR is LOW.
    pub fn DTR(v: u1) Value {
        return Value.DTR(.{}, v);
    }
    /// Receive enable. If this bit is set to 1, the receive section of the UART is enabled. Data reception occurs for either UART signals or SIR signals depending on the setting of the SIREN bit. When the UART is disabled in the middle of reception, it completes the current character before stopping.
    pub fn RXE(v: u1) Value {
        return Value.RXE(.{}, v);
    }
    /// Transmit enable. If this bit is set to 1, the transmit section of the UART is enabled. Data transmission occurs for either UART signals, or SIR signals depending on the setting of the SIREN bit. When the UART is disabled in the middle of transmission, it completes the current character before stopping.
    pub fn TXE(v: u1) Value {
        return Value.TXE(.{}, v);
    }
    /// Loopback enable. If this bit is set to 1 and the SIREN bit is set to 1 and the SIRTEST bit in the Test Control Register, UARTTCR is set to 1, then the nSIROUT path is inverted, and fed through to the SIRIN path. The SIRTEST bit in the test register must be set to 1 to override the normal half-duplex SIR operation. This must be the requirement for accessing the test registers during normal operation, and SIRTEST must be cleared to 0 when loopback testing is finished. This feature reduces the amount of external coupling required during system test. If this bit is set to 1, and the SIRTEST bit is set to 0, the UARTTXD path is fed through to the UARTRXD path. In either SIR mode or UART mode, when this bit is set, the modem outputs are also fed through to the modem inputs. This bit is cleared to 0 on reset, to disable loopback.
    pub fn LBE(v: u1) Value {
        return Value.LBE(.{}, v);
    }
    /// SIR low-power IrDA mode. This bit selects the IrDA encoding mode. If this bit is cleared to 0, low-level bits are transmitted as an active high pulse with a width of 3 / 16th of the bit period. If this bit is set to 1, low-level bits are transmitted with a pulse width that is 3 times the period of the IrLPBaud16 input signal, regardless of the selected bit rate. Setting this bit uses less power, but might reduce transmission distances.
    pub fn SIRLP(v: u1) Value {
        return Value.SIRLP(.{}, v);
    }
    /// SIR enable: 0 = IrDA SIR ENDEC is disabled. nSIROUT remains LOW (no light pulse generated), and signal transitions on SIRIN have no effect. 1 = IrDA SIR ENDEC is enabled. Data is transmitted and received on nSIROUT and SIRIN. UARTTXD remains HIGH, in the marking state. Signal transitions on UARTRXD or modem status inputs have no effect. This bit has no effect if the UARTEN bit disables the UART.
    pub fn SIREN(v: u1) Value {
        return Value.SIREN(.{}, v);
    }
    /// UART enable: 0 = UART is disabled. If the UART is disabled in the middle of transmission or reception, it completes the current character before stopping. 1 = the UART is enabled. Data transmission and reception occurs for either UART signals or SIR signals depending on the setting of the SIREN bit.
    pub fn UARTEN(v: u1) Value {
        return Value.UARTEN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt FIFO Level Select Register, UARTIFLS
pub const UARTIFLS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038034),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Receive interrupt FIFO level select. The trigger points for the receive interrupt are as follows: b000 = Receive FIFO becomes &gt;= 1 / 8 full b001 = Receive FIFO becomes &gt;= 1 / 4 full b010 = Receive FIFO becomes &gt;= 1 / 2 full b011 = Receive FIFO becomes &gt;= 3 / 4 full b100 = Receive FIFO becomes &gt;= 7 / 8 full b101-b111 = reserved.
        pub fn RXIFLSEL(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 6),
            };
        }
        /// Transmit interrupt FIFO level select. The trigger points for the transmit interrupt are as follows: b000 = Transmit FIFO becomes &lt;= 1 / 8 full b001 = Transmit FIFO becomes &lt;= 1 / 4 full b010 = Transmit FIFO becomes &lt;= 1 / 2 full b011 = Transmit FIFO becomes &lt;= 3 / 4 full b100 = Transmit FIFO becomes &lt;= 7 / 8 full b101-b111 = reserved.
        pub fn TXIFLSEL(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 3),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn RXIFLSEL(self: Result) u3 {
            const mask = comptime helpers.generateMask(3, 6);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn TXIFLSEL(self: Result) u3 {
            const mask = comptime helpers.generateMask(0, 3);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Receive interrupt FIFO level select. The trigger points for the receive interrupt are as follows: b000 = Receive FIFO becomes &gt;= 1 / 8 full b001 = Receive FIFO becomes &gt;= 1 / 4 full b010 = Receive FIFO becomes &gt;= 1 / 2 full b011 = Receive FIFO becomes &gt;= 3 / 4 full b100 = Receive FIFO becomes &gt;= 7 / 8 full b101-b111 = reserved.
    pub fn RXIFLSEL(v: u3) Value {
        return Value.RXIFLSEL(.{}, v);
    }
    /// Transmit interrupt FIFO level select. The trigger points for the transmit interrupt are as follows: b000 = Transmit FIFO becomes &lt;= 1 / 8 full b001 = Transmit FIFO becomes &lt;= 1 / 4 full b010 = Transmit FIFO becomes &lt;= 1 / 2 full b011 = Transmit FIFO becomes &lt;= 3 / 4 full b100 = Transmit FIFO becomes &lt;= 7 / 8 full b101-b111 = reserved.
    pub fn TXIFLSEL(v: u3) Value {
        return Value.TXIFLSEL(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Mask Set/Clear Register, UARTIMSC
pub const UARTIMSC = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038038),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Overrun error interrupt mask. A read returns the current mask for the UARTOEINTR interrupt. On a write of 1, the mask of the UARTOEINTR interrupt is set. A write of 0 clears the mask.
        pub fn OEIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Break error interrupt mask. A read returns the current mask for the UARTBEINTR interrupt. On a write of 1, the mask of the UARTBEINTR interrupt is set. A write of 0 clears the mask.
        pub fn BEIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        /// Parity error interrupt mask. A read returns the current mask for the UARTPEINTR interrupt. On a write of 1, the mask of the UARTPEINTR interrupt is set. A write of 0 clears the mask.
        pub fn PEIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        /// Framing error interrupt mask. A read returns the current mask for the UARTFEINTR interrupt. On a write of 1, the mask of the UARTFEINTR interrupt is set. A write of 0 clears the mask.
        pub fn FEIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Receive timeout interrupt mask. A read returns the current mask for the UARTRTINTR interrupt. On a write of 1, the mask of the UARTRTINTR interrupt is set. A write of 0 clears the mask.
        pub fn RTIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// Transmit interrupt mask. A read returns the current mask for the UARTTXINTR interrupt. On a write of 1, the mask of the UARTTXINTR interrupt is set. A write of 0 clears the mask.
        pub fn TXIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// Receive interrupt mask. A read returns the current mask for the UARTRXINTR interrupt. On a write of 1, the mask of the UARTRXINTR interrupt is set. A write of 0 clears the mask.
        pub fn RXIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// nUARTDSR modem interrupt mask. A read returns the current mask for the UARTDSRINTR interrupt. On a write of 1, the mask of the UARTDSRINTR interrupt is set. A write of 0 clears the mask.
        pub fn DSRMIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// nUARTDCD modem interrupt mask. A read returns the current mask for the UARTDCDINTR interrupt. On a write of 1, the mask of the UARTDCDINTR interrupt is set. A write of 0 clears the mask.
        pub fn DCDMIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// nUARTCTS modem interrupt mask. A read returns the current mask for the UARTCTSINTR interrupt. On a write of 1, the mask of the UARTCTSINTR interrupt is set. A write of 0 clears the mask.
        pub fn CTSMIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// nUARTRI modem interrupt mask. A read returns the current mask for the UARTRIINTR interrupt. On a write of 1, the mask of the UARTRIINTR interrupt is set. A write of 0 clears the mask.
        pub fn RIMIM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn OEIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn BEIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn PEIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn FEIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn RTIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn TXIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn RXIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DSRMIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn DCDMIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn CTSMIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn RIMIM(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Overrun error interrupt mask. A read returns the current mask for the UARTOEINTR interrupt. On a write of 1, the mask of the UARTOEINTR interrupt is set. A write of 0 clears the mask.
    pub fn OEIM(v: u1) Value {
        return Value.OEIM(.{}, v);
    }
    /// Break error interrupt mask. A read returns the current mask for the UARTBEINTR interrupt. On a write of 1, the mask of the UARTBEINTR interrupt is set. A write of 0 clears the mask.
    pub fn BEIM(v: u1) Value {
        return Value.BEIM(.{}, v);
    }
    /// Parity error interrupt mask. A read returns the current mask for the UARTPEINTR interrupt. On a write of 1, the mask of the UARTPEINTR interrupt is set. A write of 0 clears the mask.
    pub fn PEIM(v: u1) Value {
        return Value.PEIM(.{}, v);
    }
    /// Framing error interrupt mask. A read returns the current mask for the UARTFEINTR interrupt. On a write of 1, the mask of the UARTFEINTR interrupt is set. A write of 0 clears the mask.
    pub fn FEIM(v: u1) Value {
        return Value.FEIM(.{}, v);
    }
    /// Receive timeout interrupt mask. A read returns the current mask for the UARTRTINTR interrupt. On a write of 1, the mask of the UARTRTINTR interrupt is set. A write of 0 clears the mask.
    pub fn RTIM(v: u1) Value {
        return Value.RTIM(.{}, v);
    }
    /// Transmit interrupt mask. A read returns the current mask for the UARTTXINTR interrupt. On a write of 1, the mask of the UARTTXINTR interrupt is set. A write of 0 clears the mask.
    pub fn TXIM(v: u1) Value {
        return Value.TXIM(.{}, v);
    }
    /// Receive interrupt mask. A read returns the current mask for the UARTRXINTR interrupt. On a write of 1, the mask of the UARTRXINTR interrupt is set. A write of 0 clears the mask.
    pub fn RXIM(v: u1) Value {
        return Value.RXIM(.{}, v);
    }
    /// nUARTDSR modem interrupt mask. A read returns the current mask for the UARTDSRINTR interrupt. On a write of 1, the mask of the UARTDSRINTR interrupt is set. A write of 0 clears the mask.
    pub fn DSRMIM(v: u1) Value {
        return Value.DSRMIM(.{}, v);
    }
    /// nUARTDCD modem interrupt mask. A read returns the current mask for the UARTDCDINTR interrupt. On a write of 1, the mask of the UARTDCDINTR interrupt is set. A write of 0 clears the mask.
    pub fn DCDMIM(v: u1) Value {
        return Value.DCDMIM(.{}, v);
    }
    /// nUARTCTS modem interrupt mask. A read returns the current mask for the UARTCTSINTR interrupt. On a write of 1, the mask of the UARTCTSINTR interrupt is set. A write of 0 clears the mask.
    pub fn CTSMIM(v: u1) Value {
        return Value.CTSMIM(.{}, v);
    }
    /// nUARTRI modem interrupt mask. A read returns the current mask for the UARTRIINTR interrupt. On a write of 1, the mask of the UARTRIINTR interrupt is set. A write of 0 clears the mask.
    pub fn RIMIM(v: u1) Value {
        return Value.RIMIM(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Raw Interrupt Status Register, UARTRIS
pub const UARTRIS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003803c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn OERIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn BERIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn PERIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn FERIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn RTRIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn TXRIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn RXRIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DSRRMIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn DCDRMIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn CTSRMIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn RIRMIS(self: Result) u1 {
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
/// Masked Interrupt Status Register, UARTMIS
pub const UARTMIS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038040),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn OEMIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn BEMIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn PEMIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn FEMIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn RTMIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn TXMIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn RXMIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DSRMMIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn DCDMMIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn CTSMMIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn RIMMIS(self: Result) u1 {
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
/// Interrupt Clear Register, UARTICR
pub const UARTICR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038044),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Overrun error interrupt clear. Clears the UARTOEINTR interrupt.
        pub fn OEIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Break error interrupt clear. Clears the UARTBEINTR interrupt.
        pub fn BEIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        /// Parity error interrupt clear. Clears the UARTPEINTR interrupt.
        pub fn PEIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        /// Framing error interrupt clear. Clears the UARTFEINTR interrupt.
        pub fn FEIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Receive timeout interrupt clear. Clears the UARTRTINTR interrupt.
        pub fn RTIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// Transmit interrupt clear. Clears the UARTTXINTR interrupt.
        pub fn TXIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// Receive interrupt clear. Clears the UARTRXINTR interrupt.
        pub fn RXIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// nUARTDSR modem interrupt clear. Clears the UARTDSRINTR interrupt.
        pub fn DSRMIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// nUARTDCD modem interrupt clear. Clears the UARTDCDINTR interrupt.
        pub fn DCDMIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// nUARTCTS modem interrupt clear. Clears the UARTCTSINTR interrupt.
        pub fn CTSMIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// nUARTRI modem interrupt clear. Clears the UARTRIINTR interrupt.
        pub fn RIMIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn OEIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn BEIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn PEIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn FEIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn RTIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn TXIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn RXIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DSRMIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn DCDMIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn CTSMIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn RIMIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Overrun error interrupt clear. Clears the UARTOEINTR interrupt.
    pub fn OEIC(v: u1) Value {
        return Value.OEIC(.{}, v);
    }
    /// Break error interrupt clear. Clears the UARTBEINTR interrupt.
    pub fn BEIC(v: u1) Value {
        return Value.BEIC(.{}, v);
    }
    /// Parity error interrupt clear. Clears the UARTPEINTR interrupt.
    pub fn PEIC(v: u1) Value {
        return Value.PEIC(.{}, v);
    }
    /// Framing error interrupt clear. Clears the UARTFEINTR interrupt.
    pub fn FEIC(v: u1) Value {
        return Value.FEIC(.{}, v);
    }
    /// Receive timeout interrupt clear. Clears the UARTRTINTR interrupt.
    pub fn RTIC(v: u1) Value {
        return Value.RTIC(.{}, v);
    }
    /// Transmit interrupt clear. Clears the UARTTXINTR interrupt.
    pub fn TXIC(v: u1) Value {
        return Value.TXIC(.{}, v);
    }
    /// Receive interrupt clear. Clears the UARTRXINTR interrupt.
    pub fn RXIC(v: u1) Value {
        return Value.RXIC(.{}, v);
    }
    /// nUARTDSR modem interrupt clear. Clears the UARTDSRINTR interrupt.
    pub fn DSRMIC(v: u1) Value {
        return Value.DSRMIC(.{}, v);
    }
    /// nUARTDCD modem interrupt clear. Clears the UARTDCDINTR interrupt.
    pub fn DCDMIC(v: u1) Value {
        return Value.DCDMIC(.{}, v);
    }
    /// nUARTCTS modem interrupt clear. Clears the UARTCTSINTR interrupt.
    pub fn CTSMIC(v: u1) Value {
        return Value.CTSMIC(.{}, v);
    }
    /// nUARTRI modem interrupt clear. Clears the UARTRIINTR interrupt.
    pub fn RIMIC(v: u1) Value {
        return Value.RIMIC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// DMA Control Register, UARTDMACR
pub const UARTDMACR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038048),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// DMA on error. If this bit is set to 1, the DMA receive request outputs, UARTRXDMASREQ or UARTRXDMABREQ, are disabled when the UART error interrupt is asserted.
        pub fn DMAONERR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Transmit DMA enable. If this bit is set to 1, DMA for the transmit FIFO is enabled.
        pub fn TXDMAE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Receive DMA enable. If this bit is set to 1, DMA for the receive FIFO is enabled.
        pub fn RXDMAE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn DMAONERR(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn TXDMAE(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn RXDMAE(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// DMA on error. If this bit is set to 1, the DMA receive request outputs, UARTRXDMASREQ or UARTRXDMABREQ, are disabled when the UART error interrupt is asserted.
    pub fn DMAONERR(v: u1) Value {
        return Value.DMAONERR(.{}, v);
    }
    /// Transmit DMA enable. If this bit is set to 1, DMA for the transmit FIFO is enabled.
    pub fn TXDMAE(v: u1) Value {
        return Value.TXDMAE(.{}, v);
    }
    /// Receive DMA enable. If this bit is set to 1, DMA for the receive FIFO is enabled.
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
/// UARTPeriphID0 Register
pub const UARTPERIPHID0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038fe0),
    pub fn write(self: @This(), v: u8) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// UARTPeriphID1 Register
pub const UARTPERIPHID1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038fe4),
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
/// UARTPeriphID2 Register
pub const UARTPERIPHID2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038fe8),
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
/// UARTPeriphID3 Register
pub const UARTPERIPHID3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038fec),
    pub fn write(self: @This(), v: u8) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// UARTPCellID0 Register
pub const UARTPCELLID0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038ff0),
    pub fn write(self: @This(), v: u8) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// UARTPCellID1 Register
pub const UARTPCELLID1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038ff4),
    pub fn write(self: @This(), v: u8) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// UARTPCellID2 Register
pub const UARTPCELLID2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038ff8),
    pub fn write(self: @This(), v: u8) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// UARTPCellID3 Register
pub const UARTPCELLID3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40038ffc),
    pub fn write(self: @This(), v: u8) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
pub const UART1_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x40038000),

    /// Data Register, UARTDR
    UARTDR: UARTDR = .{},
    /// Receive Status Register/Error Clear Register, UARTRSR/UARTECR
    UARTRSR: UARTRSR = .{},
    /// Flag Register, UARTFR
    UARTFR: UARTFR = .{},
    /// IrDA Low-Power Counter Register, UARTILPR
    UARTILPR: UARTILPR = .{},
    /// Integer Baud Rate Register, UARTIBRD
    UARTIBRD: UARTIBRD = .{},
    /// Fractional Baud Rate Register, UARTFBRD
    UARTFBRD: UARTFBRD = .{},
    /// Line Control Register, UARTLCR_H
    UARTLCR_H: UARTLCR_H = .{},
    /// Control Register, UARTCR
    UARTCR: UARTCR = .{},
    /// Interrupt FIFO Level Select Register, UARTIFLS
    UARTIFLS: UARTIFLS = .{},
    /// Interrupt Mask Set/Clear Register, UARTIMSC
    UARTIMSC: UARTIMSC = .{},
    /// Raw Interrupt Status Register, UARTRIS
    UARTRIS: UARTRIS = .{},
    /// Masked Interrupt Status Register, UARTMIS
    UARTMIS: UARTMIS = .{},
    /// Interrupt Clear Register, UARTICR
    UARTICR: UARTICR = .{},
    /// DMA Control Register, UARTDMACR
    UARTDMACR: UARTDMACR = .{},
    /// UARTPeriphID0 Register
    UARTPERIPHID0: UARTPERIPHID0 = .{},
    /// UARTPeriphID1 Register
    UARTPERIPHID1: UARTPERIPHID1 = .{},
    /// UARTPeriphID2 Register
    UARTPERIPHID2: UARTPERIPHID2 = .{},
    /// UARTPeriphID3 Register
    UARTPERIPHID3: UARTPERIPHID3 = .{},
    /// UARTPCellID0 Register
    UARTPCELLID0: UARTPCELLID0 = .{},
    /// UARTPCellID1 Register
    UARTPCELLID1: UARTPCELLID1 = .{},
    /// UARTPCellID2 Register
    UARTPCELLID2: UARTPCELLID2 = .{},
    /// UARTPCellID3 Register
    UARTPCELLID3: UARTPCELLID3 = .{},
};
pub const UART1 = UART1_p{};
