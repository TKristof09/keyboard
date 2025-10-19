const helpers = @import("helpers.zig");
/// Reset control. If a bit is set it means the peripheral is in reset. 0 means the peripheral&#39;s reset is deasserted.
pub const RESET = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4000c000),
    pub const FieldMasks = struct {
        pub const USBCTRL: u32 = helpers.generateMask(24, 25);
        pub const UART1: u32 = helpers.generateMask(23, 24);
        pub const UART0: u32 = helpers.generateMask(22, 23);
        pub const TIMER: u32 = helpers.generateMask(21, 22);
        pub const TBMAN: u32 = helpers.generateMask(20, 21);
        pub const SYSINFO: u32 = helpers.generateMask(19, 20);
        pub const SYSCFG: u32 = helpers.generateMask(18, 19);
        pub const SPI1: u32 = helpers.generateMask(17, 18);
        pub const SPI0: u32 = helpers.generateMask(16, 17);
        pub const RTC: u32 = helpers.generateMask(15, 16);
        pub const PWM: u32 = helpers.generateMask(14, 15);
        pub const PLL_USB: u32 = helpers.generateMask(13, 14);
        pub const PLL_SYS: u32 = helpers.generateMask(12, 13);
        pub const PIO1: u32 = helpers.generateMask(11, 12);
        pub const PIO0: u32 = helpers.generateMask(10, 11);
        pub const PADS_QSPI: u32 = helpers.generateMask(9, 10);
        pub const PADS_BANK0: u32 = helpers.generateMask(8, 9);
        pub const JTAG: u32 = helpers.generateMask(7, 8);
        pub const IO_QSPI: u32 = helpers.generateMask(6, 7);
        pub const IO_BANK0: u32 = helpers.generateMask(5, 6);
        pub const I2C1: u32 = helpers.generateMask(4, 5);
        pub const I2C0: u32 = helpers.generateMask(3, 4);
        pub const DMA: u32 = helpers.generateMask(2, 3);
        pub const BUSCTRL: u32 = helpers.generateMask(1, 2);
        pub const ADC: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn USBCTRL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn UART1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn UART0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn TIMER(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn TBMAN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn SYSINFO(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn SYSCFG(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn SPI1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn SPI0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn RTC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn PWM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn PLL_USB(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn PLL_SYS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn PIO1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn PIO0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn PADS_QSPI(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn PADS_BANK0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn JTAG(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn IO_QSPI(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn IO_BANK0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn I2C1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn I2C0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn DMA(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn BUSCTRL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn ADC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn USBCTRL(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn UART1(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn UART0(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn TIMER(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn TBMAN(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn SYSINFO(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn SYSCFG(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn SPI1(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn SPI0(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn RTC(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn PWM(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PLL_USB(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn PLL_SYS(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn PIO1(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn PIO0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn PADS_QSPI(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn PADS_BANK0(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn JTAG(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn IO_QSPI(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn IO_BANK0(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn I2C1(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn I2C0(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn DMA(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn BUSCTRL(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn ADC(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn USBCTRL(v: u1) Value {
        return Value.USBCTRL(.{}, v);
    }
    pub fn UART1(v: u1) Value {
        return Value.UART1(.{}, v);
    }
    pub fn UART0(v: u1) Value {
        return Value.UART0(.{}, v);
    }
    pub fn TIMER(v: u1) Value {
        return Value.TIMER(.{}, v);
    }
    pub fn TBMAN(v: u1) Value {
        return Value.TBMAN(.{}, v);
    }
    pub fn SYSINFO(v: u1) Value {
        return Value.SYSINFO(.{}, v);
    }
    pub fn SYSCFG(v: u1) Value {
        return Value.SYSCFG(.{}, v);
    }
    pub fn SPI1(v: u1) Value {
        return Value.SPI1(.{}, v);
    }
    pub fn SPI0(v: u1) Value {
        return Value.SPI0(.{}, v);
    }
    pub fn RTC(v: u1) Value {
        return Value.RTC(.{}, v);
    }
    pub fn PWM(v: u1) Value {
        return Value.PWM(.{}, v);
    }
    pub fn PLL_USB(v: u1) Value {
        return Value.PLL_USB(.{}, v);
    }
    pub fn PLL_SYS(v: u1) Value {
        return Value.PLL_SYS(.{}, v);
    }
    pub fn PIO1(v: u1) Value {
        return Value.PIO1(.{}, v);
    }
    pub fn PIO0(v: u1) Value {
        return Value.PIO0(.{}, v);
    }
    pub fn PADS_QSPI(v: u1) Value {
        return Value.PADS_QSPI(.{}, v);
    }
    pub fn PADS_BANK0(v: u1) Value {
        return Value.PADS_BANK0(.{}, v);
    }
    pub fn JTAG(v: u1) Value {
        return Value.JTAG(.{}, v);
    }
    pub fn IO_QSPI(v: u1) Value {
        return Value.IO_QSPI(.{}, v);
    }
    pub fn IO_BANK0(v: u1) Value {
        return Value.IO_BANK0(.{}, v);
    }
    pub fn I2C1(v: u1) Value {
        return Value.I2C1(.{}, v);
    }
    pub fn I2C0(v: u1) Value {
        return Value.I2C0(.{}, v);
    }
    pub fn DMA(v: u1) Value {
        return Value.DMA(.{}, v);
    }
    pub fn BUSCTRL(v: u1) Value {
        return Value.BUSCTRL(.{}, v);
    }
    pub fn ADC(v: u1) Value {
        return Value.ADC(.{}, v);
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
/// Watchdog select. If a bit is set then the watchdog will reset this peripheral when the watchdog fires.
pub const WDSEL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4000c004),
    pub const FieldMasks = struct {
        pub const USBCTRL: u32 = helpers.generateMask(24, 25);
        pub const UART1: u32 = helpers.generateMask(23, 24);
        pub const UART0: u32 = helpers.generateMask(22, 23);
        pub const TIMER: u32 = helpers.generateMask(21, 22);
        pub const TBMAN: u32 = helpers.generateMask(20, 21);
        pub const SYSINFO: u32 = helpers.generateMask(19, 20);
        pub const SYSCFG: u32 = helpers.generateMask(18, 19);
        pub const SPI1: u32 = helpers.generateMask(17, 18);
        pub const SPI0: u32 = helpers.generateMask(16, 17);
        pub const RTC: u32 = helpers.generateMask(15, 16);
        pub const PWM: u32 = helpers.generateMask(14, 15);
        pub const PLL_USB: u32 = helpers.generateMask(13, 14);
        pub const PLL_SYS: u32 = helpers.generateMask(12, 13);
        pub const PIO1: u32 = helpers.generateMask(11, 12);
        pub const PIO0: u32 = helpers.generateMask(10, 11);
        pub const PADS_QSPI: u32 = helpers.generateMask(9, 10);
        pub const PADS_BANK0: u32 = helpers.generateMask(8, 9);
        pub const JTAG: u32 = helpers.generateMask(7, 8);
        pub const IO_QSPI: u32 = helpers.generateMask(6, 7);
        pub const IO_BANK0: u32 = helpers.generateMask(5, 6);
        pub const I2C1: u32 = helpers.generateMask(4, 5);
        pub const I2C0: u32 = helpers.generateMask(3, 4);
        pub const DMA: u32 = helpers.generateMask(2, 3);
        pub const BUSCTRL: u32 = helpers.generateMask(1, 2);
        pub const ADC: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn USBCTRL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn UART1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn UART0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn TIMER(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn TBMAN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn SYSINFO(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn SYSCFG(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn SPI1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn SPI0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn RTC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn PWM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn PLL_USB(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn PLL_SYS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn PIO1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn PIO0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn PADS_QSPI(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn PADS_BANK0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn JTAG(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn IO_QSPI(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn IO_BANK0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn I2C1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn I2C0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn DMA(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn BUSCTRL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn ADC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn USBCTRL(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn UART1(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn UART0(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn TIMER(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn TBMAN(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn SYSINFO(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn SYSCFG(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn SPI1(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn SPI0(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn RTC(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn PWM(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PLL_USB(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn PLL_SYS(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn PIO1(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn PIO0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn PADS_QSPI(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn PADS_BANK0(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn JTAG(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn IO_QSPI(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn IO_BANK0(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn I2C1(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn I2C0(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn DMA(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn BUSCTRL(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn ADC(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn USBCTRL(v: u1) Value {
        return Value.USBCTRL(.{}, v);
    }
    pub fn UART1(v: u1) Value {
        return Value.UART1(.{}, v);
    }
    pub fn UART0(v: u1) Value {
        return Value.UART0(.{}, v);
    }
    pub fn TIMER(v: u1) Value {
        return Value.TIMER(.{}, v);
    }
    pub fn TBMAN(v: u1) Value {
        return Value.TBMAN(.{}, v);
    }
    pub fn SYSINFO(v: u1) Value {
        return Value.SYSINFO(.{}, v);
    }
    pub fn SYSCFG(v: u1) Value {
        return Value.SYSCFG(.{}, v);
    }
    pub fn SPI1(v: u1) Value {
        return Value.SPI1(.{}, v);
    }
    pub fn SPI0(v: u1) Value {
        return Value.SPI0(.{}, v);
    }
    pub fn RTC(v: u1) Value {
        return Value.RTC(.{}, v);
    }
    pub fn PWM(v: u1) Value {
        return Value.PWM(.{}, v);
    }
    pub fn PLL_USB(v: u1) Value {
        return Value.PLL_USB(.{}, v);
    }
    pub fn PLL_SYS(v: u1) Value {
        return Value.PLL_SYS(.{}, v);
    }
    pub fn PIO1(v: u1) Value {
        return Value.PIO1(.{}, v);
    }
    pub fn PIO0(v: u1) Value {
        return Value.PIO0(.{}, v);
    }
    pub fn PADS_QSPI(v: u1) Value {
        return Value.PADS_QSPI(.{}, v);
    }
    pub fn PADS_BANK0(v: u1) Value {
        return Value.PADS_BANK0(.{}, v);
    }
    pub fn JTAG(v: u1) Value {
        return Value.JTAG(.{}, v);
    }
    pub fn IO_QSPI(v: u1) Value {
        return Value.IO_QSPI(.{}, v);
    }
    pub fn IO_BANK0(v: u1) Value {
        return Value.IO_BANK0(.{}, v);
    }
    pub fn I2C1(v: u1) Value {
        return Value.I2C1(.{}, v);
    }
    pub fn I2C0(v: u1) Value {
        return Value.I2C0(.{}, v);
    }
    pub fn DMA(v: u1) Value {
        return Value.DMA(.{}, v);
    }
    pub fn BUSCTRL(v: u1) Value {
        return Value.BUSCTRL(.{}, v);
    }
    pub fn ADC(v: u1) Value {
        return Value.ADC(.{}, v);
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
/// Reset done. If a bit is set then a reset done signal has been returned by the peripheral. This indicates that the peripheral&#39;s registers are ready to be accessed.
pub const RESET_DONE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4000c008),
    pub const FieldMasks = struct {
        pub const USBCTRL: u32 = helpers.generateMask(24, 25);
        pub const UART1: u32 = helpers.generateMask(23, 24);
        pub const UART0: u32 = helpers.generateMask(22, 23);
        pub const TIMER: u32 = helpers.generateMask(21, 22);
        pub const TBMAN: u32 = helpers.generateMask(20, 21);
        pub const SYSINFO: u32 = helpers.generateMask(19, 20);
        pub const SYSCFG: u32 = helpers.generateMask(18, 19);
        pub const SPI1: u32 = helpers.generateMask(17, 18);
        pub const SPI0: u32 = helpers.generateMask(16, 17);
        pub const RTC: u32 = helpers.generateMask(15, 16);
        pub const PWM: u32 = helpers.generateMask(14, 15);
        pub const PLL_USB: u32 = helpers.generateMask(13, 14);
        pub const PLL_SYS: u32 = helpers.generateMask(12, 13);
        pub const PIO1: u32 = helpers.generateMask(11, 12);
        pub const PIO0: u32 = helpers.generateMask(10, 11);
        pub const PADS_QSPI: u32 = helpers.generateMask(9, 10);
        pub const PADS_BANK0: u32 = helpers.generateMask(8, 9);
        pub const JTAG: u32 = helpers.generateMask(7, 8);
        pub const IO_QSPI: u32 = helpers.generateMask(6, 7);
        pub const IO_BANK0: u32 = helpers.generateMask(5, 6);
        pub const I2C1: u32 = helpers.generateMask(4, 5);
        pub const I2C0: u32 = helpers.generateMask(3, 4);
        pub const DMA: u32 = helpers.generateMask(2, 3);
        pub const BUSCTRL: u32 = helpers.generateMask(1, 2);
        pub const ADC: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn USBCTRL(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn UART1(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn UART0(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn TIMER(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn TBMAN(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn SYSINFO(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn SYSCFG(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn SPI1(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn SPI0(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn RTC(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn PWM(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PLL_USB(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn PLL_SYS(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn PIO1(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn PIO0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn PADS_QSPI(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn PADS_BANK0(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn JTAG(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn IO_QSPI(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn IO_BANK0(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn I2C1(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn I2C0(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn DMA(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn BUSCTRL(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn ADC(self: Result) u1 {
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
pub const RESETS_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x4000c000),

    /// Reset control. If a bit is set it means the peripheral is in reset. 0 means the peripheral&#39;s reset is deasserted.
    RESET: RESET = .{},
    /// Watchdog select. If a bit is set then the watchdog will reset this peripheral when the watchdog fires.
    WDSEL: WDSEL = .{},
    /// Reset done. If a bit is set then a reset done signal has been returned by the peripheral. This indicates that the peripheral&#39;s registers are ready to be accessed.
    RESET_DONE: RESET_DONE = .{},
};
pub const RESETS = RESETS_p{};
