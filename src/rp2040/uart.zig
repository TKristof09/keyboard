const rp = @import("chip/rp2040.zig");
const std = @import("std");

const Interface = enum {
    uart0,
    uart1,
};

const uart_clk: u32 = 12_000_000;

pub fn initClock() void {
    rp.peripherals.CLOCKS.CLK_PERI_CTRL.write(comptime rp.CLOCKS.CLK_PERI_CTRL.ENABLE(0));
    const sys_frequency = 125_000_000;
    const delay: u32 = (sys_frequency / uart_clk + 1) * 3;
    rp.busy_wait_at_least_cycles(delay);

    rp.peripherals.CLOCKS.CLK_PERI_CTRL.write(comptime rp.CLOCKS.CLK_PERI_CTRL.AUXSRC(.xosc_clksrc));
    rp.peripherals.CLOCKS.CLK_PERI_CTRL.write(comptime rp.CLOCKS.CLK_PERI_CTRL.ENABLE(1));
}

pub const Uart = struct {
    interface: Interface,

    pub fn init(interface: Interface, baud_rate: u32) Uart {
        initInterface(interface, baud_rate);
        return .{
            .interface = interface,
        };
    }

    pub fn send(self: Uart, char: u8) void {
        // we might not need to do the register abstraction's read-modify-write
        // and could just do a write since all the other fields in the register
        // are read only anyway
        switch (self.interface) {
            .uart0 => {
                rp.peripherals.UART0.UARTDR.write(rp.UART0.UARTDR.DATA(char));
            },
            .uart1 => {
                rp.peripherals.UART1.UARTDR.write(rp.UART1.UARTDR.DATA(char));
            },
        }
    }

    pub fn sendString(self: Uart, str: []const u8) void {
        for (str) |c| {
            switch (self.interface) {
                .uart0 => while (rp.peripherals.UART0.UARTFR.read().TXFF() == 1) {},
                .uart1 => while (rp.peripherals.UART1.UARTFR.read().TXFF() == 1) {},
            }
            self.send(c);
        }
    }

    fn initInterface(interface: Interface, baud_rate: u32) void {
        switch (interface) {
            .uart0 => {
                rp.peripherals.RESETS.RESET.write(rp.RESETS.RESET.UART0(0));
            },
            .uart1 => {
                rp.peripherals.RESETS.RESET.write(rp.RESETS.RESET.UART1(0));
            },
        }

        const baud_divisor: f32 = uart_clk / (16.0 * @as(f32, @floatFromInt(baud_rate)));
        const ibaud_divisor: u16 = @intFromFloat(@floor(baud_divisor));
        const fractional: u6 = @intFromFloat(@floor((baud_divisor - @as(f32, @floatFromInt(ibaud_divisor))) * 64.0 + 0.5));
        switch (interface) {
            .uart0 => {
                rp.peripherals.UART0.UARTIBRD.write(ibaud_divisor);
                rp.peripherals.UART0.UARTFBRD.write(fractional);
            },
            .uart1 => {
                rp.peripherals.UART1.UARTIBRD.write(ibaud_divisor);
                rp.peripherals.UART1.UARTFBRD.write(fractional);
            },
        }

        // enable: fifo, no parity, 8 bits per transmission frame
        switch (interface) {
            .uart0 => {
                rp.peripherals.UART0.UARTLCR_H.write(rp.UART0.UARTLCR_H.FEN(1).PEN(0).WLEN(0b11));
            },
            .uart1 => {
                rp.peripherals.UART1.UARTLCR_H.write(rp.UART1.UARTLCR_H.FEN(1).PEN(0).WLEN(0b11));
            },
        }

        // no harware flow control for now
        switch (interface) {
            .uart0 => {
                rp.peripherals.UART0.UARTCR.write(rp.UART0.UARTCR.RTSEN(0).CTSEN(0));
            },
            .uart1 => {
                rp.peripherals.UART1.UARTCR.write(rp.UART1.UARTCR.RTSEN(0).CTSEN(0));
            },
        }

        // TODO: add receive functionality
        switch (interface) {
            .uart0 => {
                rp.peripherals.UART0.UARTCR.write(rp.UART0.UARTCR.UARTEN(1).TXE(1));
            },
            .uart1 => {
                rp.peripherals.UART1.UARTCR.write(rp.UART1.UARTCR.UARTEN(1).TXE(1));
            },
        }
    }
};
