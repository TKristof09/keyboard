// these modules need to be imported at comptime because they have code that
// needs to be run (patching the bootrom and exporting _start function)
comptime {
    _ = @import("bootrom/bootrom.zig");
    _ = @import("startup.zig");
}

const std = @import("std");
const GPIO = @import("rp2040/gpio.zig");
const rp = @import("rp2040/chip/rp2040.zig");
const Xosc = @import("rp2040/xosc.zig").Xosc;
const Pll = @import("rp2040/pll.zig");
const USB = @import("rp2040/usb.zig");
const Uart = @import("rp2040/uart.zig");

const pin_config = GPIO.GPIOConfig{
    .GPIO0 = .{
        .direction = .out,
        .fun = .uart,
    },
    .GPIO1 = .{
        .direction = .in,
        .fun = .uart,
    },
    .GPIO25 = .{
        .direction = .out,
    },
};

const pins = GPIO.MakePins(pin_config);
var led: GPIO.OutPin = pins.GPIO25;

fn wait() void {
    for (0..20000) |_| {
        rp.peripherals.XOSC.COUNT.write(0xFF);
        while (rp.peripherals.XOSC.COUNT.read() > 0) {
            std.mem.doNotOptimizeAway(0);
        }
    }
}

fn setupClocks() void {
    Xosc.init();

    rp.peripherals.CLOCKS.CLK_REF_CTRL.write(comptime rp.CLOCKS.CLK_REF_CTRL.SRC(.xosc_clksrc));
    while (rp.peripherals.CLOCKS.CLK_REF_SELECTED.read() == 0) {}

    // rp.peripherals.RESETS.RESET.write(comptime rp.RESETS.RESET.PLL_SYS(0));
    // // make sure aux source isnt selected
    rp.peripherals.CLOCKS.CLK_SYS_CTRL.write(comptime rp.CLOCKS.CLK_SYS_CTRL.SRC(.clk_ref));
    while (rp.peripherals.CLOCKS.CLK_SYS_SELECTED.read() == 0) {}

    // // set up plls
    // // see section 2.18.1 for the values
    // // 125 mhz sys clock
    Pll.setupSys(.{
        .fbdiv = 125,
        .post_div1 = 6,
        .post_div2 = 2,
    });

    rp.peripherals.CLOCKS.CLK_SYS_CTRL.write(comptime rp.CLOCKS.CLK_SYS_CTRL.AUXSRC(.clksrc_pll_sys));
    while (rp.peripherals.CLOCKS.CLK_SYS_SELECTED.read() == 0) {}

    rp.peripherals.CLOCKS.CLK_SYS_CTRL.write(comptime rp.CLOCKS.CLK_SYS_CTRL.SRC(.clksrc_clk_sys_aux));
    while (rp.peripherals.CLOCKS.CLK_SYS_SELECTED.read() == 0) {}
}


const usb_config = USB.Configuration{
    .device_descriptor = .{
        .bcd_usb = 0x0200,
        .device_class = .unspecified,
        .device_subclass = 0,
        .device_protocol = 0,
        .max_packet_size = 64,
        .vendor_id = 0x1234,
        .product_id = 0x5678,
        .bcd_device = 0x0100,
        .manufacturer_string_idx = 1,
        .product_string_idx = 2,
        .serial_number_string_idx = 3,
        .num_configurations = 1,
    },

    .config_descriptor = .{
        .total_length = 9,
        .num_interfaces = 1,
        .configuration_value = 1,
        .configuration_string_idx = 4,
        .attributes = .{
            .self_powered = 0,
            .remote_wakeup = 0,
        },
        .max_power = .from_mA(50),
    },
    .strings = &.{
        "Kristof",
        "Fancy pico stuff",
        "v. -infinity",
        "just the default config",
        "test interface",
    },

    .endpoints = &.{
        USB.EndpointConfig{ .endpoint = 1, .direction = .in, .endpoint_type = .Interrupt, .interval = 1 },
    },
    .hid_report = "",
};
const Usb = USB.UsbDevice(usb_config);

var uart: Uart.Uart = undefined;


export fn main() void {
    rp.peripherals.RESETS.RESET.write(comptime rp.RESETS.RESET.IO_BANK0(0));

    setupClocks();
    Uart.initClock();

    var usb = Usb.init();

    GPIO.InitPins(pin_config);
    uart = Uart.Uart.init(.uart0, 115200);

    {
        // clear screen of picom and send a separator to make it easier to see this run's messages
        const esc = "\x1B";
        const csi = esc ++ "[";
        uart.sendString(csi ++ "2J");
        uart.sendString(csi ++ "H");
        uart.sendString("=" ** 100 ++ "\r\n");
    }

    std.log.info("Hello {s}", .{"logger"});
    std.log.info("{any}", .{Report.report});

    while (true) {
        usb.poll();
        led.toggle();
        wait();
    }
}

const LogError = error{};
fn uartWriterFunc(ctx: Uart.Uart, bytes: []const u8) LogError!usize {
    ctx.sendString(bytes);
    return bytes.len;
}
const UartWriter = std.io.GenericWriter(Uart.Uart, LogError, uartWriterFunc);

fn logFn(
    comptime level: std.log.Level,
    comptime scope: @Type(.enum_literal),
    comptime fmt: []const u8,
    args: anytype,
) void {
    const level_str = comptime switch (level) {
        .debug => "[DEBUG]",
        .info => "[INFO ]",
        .warn => "[WARN ]",
        .err => "[ERROR]",
    };
    const scope_str = if (scope == .default) ":" else "(" ++ @tagName(scope) ++ "):";
    std.fmt.format(
        UartWriter{ .context = uart },
        level_str ++ " " ++ scope_str ++ " " ++ fmt ++ "\r\n",
        args,
    ) catch unreachable;
}

pub const std_options: std.Options = .{
    .logFn = logFn,
};
