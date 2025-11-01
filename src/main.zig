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
const Hid = @import("rp2040/usb/hid.zig");
const Timer = @import("rp2040/timer.zig");

const keys = [_]@import("keyboard.zig").Key{
    .{
        .pin = .GPIO29,
        .pos = .{
            .x = 0,
            .y = 0,
        },
    },
    .{
        .pin = .GPIO28,
        .pos = .{
            .x = 1,
            .y = 0,
        },
    },
    .{
        .pin = .GPIO27,
        .pos = .{
            .x = 2,
            .y = 0,
        },
    },
    .{
        .pin = .GPIO26,
        .pos = .{
            .x = 3,
            .y = 0,
        },
    },
    .{
        .pin = .GPIO7,
        .pos = .{
            .x = 4,
            .y = 0,
        },
    },

    .{
        .pin = .GPIO0,
        .pos = .{
            .x = 0,
            .y = 1,
        },
    },
    .{
        .pin = .GPIO21,
        .pos = .{
            .x = 1,
            .y = 1,
        },
    },
    .{
        .pin = .GPIO23,
        .pos = .{
            .x = 2,
            .y = 1,
        },
    },
    .{
        .pin = .GPIO20,
        .pos = .{
            .x = 3,
            .y = 1,
        },
    },
    .{
        .pin = .GPIO22,
        .pos = .{
            .x = 4,
            .y = 1,
        },
    },

    .{
        .pin = .GPIO6,
        .pos = .{
            .x = 0,
            .y = 2,
        },
    },
    .{
        .pin = .GPIO5,
        .pos = .{
            .x = 1,
            .y = 2,
        },
    },
    .{
        .pin = .GPIO4,
        .pos = .{
            .x = 2,
            .y = 2,
        },
    },
    .{
        .pin = .GPIO3,
        .pos = .{
            .x = 3,
            .y = 2,
        },
    },
    .{
        .pin = .GPIO2,
        .pos = .{
            .x = 4,
            .y = 2,
        },
    },

    .{
        .pin = .GPIO9,
        .pos = .{
            .x = 0,
            .y = 3,
        },
    },
    .{
        .pin = .GPIO8,
        .pos = .{
            .x = 1,
            .y = 3,
        },
    },
};

const layout: @import("keyboard.zig").Layout = &.{
    &.{ .KC_a, .KC_f, .KC_o, .KC_u, .KC_j },
    &.{ .KC_y, .KC_h, .KC_a, .KC_e, .KC_i },
    &.{ .KC_k, .KC_p, .KC_dot, .KC_comm, .KC_dash },
    &.{ .KC_shift, .KC_b },
};

// const keyboard = @import("keyboard.zig").MakeKeyboard(&keys, layout);

const keyboard = @import("keyboard.zig").MakeKeyboard(&.{
    .{
        .pin = .GPIO23,
        .pos = .{
            .x = 0,
            .y = 0,
        },
    },
    .{
        .pin = .GPIO24,
        .pos = .{
            .x = 1,
            .y = 0,
        },
    },
}, &.{
    &.{ .KC_a, .KC_b },
});

const base_config = GPIO.GPIOConfig{
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
const pin_config = keyboard.makeGPIOConfig(base_config);

const pins = GPIO.MakePins(pin_config);
var led: GPIO.OutPin = pins.GPIO25;
const button1: GPIO.InPin = pins.GPIO20;
const button2: GPIO.InPin = pins.GPIO23;

const HID = Hid.Make(
    &.{
        USB.EndpointConfig{ .address = .{ .endpoint = 1, .direction = .in }, .endpoint_type = .Interrupt, .interval = 1 },
    },
    &Hid.boot_keyboard,
);

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
    .drivers = &.{
        HID.driver(),
    },
};
const Usb = USB.UsbDevice(usb_config);

var uart: Uart.Uart = undefined;

var hid = HID{};

export fn main() void {
    rp.peripherals.RESETS.RESET.write(comptime rp.RESETS.RESET.IO_BANK0(0));

    setupClocks();
    initWatchdog();
    Uart.initClock();

    rp.peripherals.RESETS.RESET.write(comptime rp.RESETS.RESET.TIMER(0));
    rp.peripherals.TIMER.DBGPAUSE.write(comptime rp.TIMER.DBGPAUSE.DBG0(0).DBG1(0));
    rp.peripherals.TIMER.PAUSE.clear();

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
    var report_buf: [256]u8 = undefined;

    const wd = rp.peripherals.WATCHDOG.TICK.read();
    std.log.debug("watchdog: enable: {d}, running: {d}", .{ wd.ENABLE(), wd.RUNNING() });

    while (true) {
        usb.poll();
        hid.data.keys = @splat(0);
        hid.data.modifiers = @splat(0);
        if (keyboard.task(&hid)) {
            const report_len = hid.serialize(&report_buf);
            std.log.debug("Queuing keyboard report ({d} bytes)", .{report_len});
            usb.queueMessage(.{ .endpoint = 1, .direction = .in }, report_buf[0..report_len]);
        }
        // if (button1.read() == 0) {
        //     r.data.keys = @splat(0);
        //     r.data.modifiers = @splat(0);
        //     const report_len = r.serialize(&report_buf);
        //     usb.queueMessage(.{ .endpoint = 1, .direction = .in }, report_buf[0..report_len]);
        //     led.toggle();
        // }
        // if (button2.read() == 0) {
        //     r.data.modifiers[1] = 1;
        //     r.data.keys[0] = 0x04;
        //     const report_len = r.serialize(&report_buf);
        //     usb.queueMessage(.{ .endpoint = 1, .direction = .in }, report_buf[0..report_len]);
        //     led.toggle();
        // }
        // led.toggle();
        Timer.busyWait(1);
    }
}

fn initWatchdog() void {
    rp.peripherals.WATCHDOG.TICK.write(rp.WATCHDOG.TICK.ENABLE(1).CYCLES(12));
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
    if (true) {
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
}

pub const std_options: std.Options = .{
    .logFn = logFn,
};
