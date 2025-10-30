const std = @import("std");
const rp = @import("chip/rp2040.zig");

pub const Pin = enum(u5) {
    GPIO0 = 0,
    GPIO1 = 1,
    GPIO2 = 2,
    GPIO3 = 3,
    GPIO4 = 4,
    GPIO5 = 5,
    GPIO6 = 6,
    GPIO7 = 7,
    GPIO8 = 8,
    GPIO9 = 9,
    GPIO10 = 10,
    GPIO11 = 11,
    GPIO12 = 12,
    GPIO13 = 13,
    GPIO14 = 14,
    GPIO15 = 15,
    GPIO16 = 16,
    GPIO17 = 17,
    GPIO18 = 18,
    GPIO19 = 19,
    GPIO20 = 20,
    GPIO21 = 21,
    GPIO22 = 22,
    GPIO23 = 23,
    GPIO24 = 24,
    GPIO25 = 25,
    GPIO26 = 26,
    GPIO27 = 27,
    GPIO28 = 28,
    GPIO29 = 29,
};

const PinDirection = enum {
    in,
    out,
};
const PinPullResistor = enum {
    up,
    down,
};
const PinFunction = enum(u5) {
    spi = 1,
    uart = 2,
    i2c = 3,
    pwm = 4,
    sio = 5,
    pio0 = 6,
    pio1 = 7,
    clock = 8,
    usb = 9,
};

const PinConfig = struct {
    direction: PinDirection,
    pull: ?PinPullResistor = null,
    fun: PinFunction = .sio,
};

pub const GPIOConfig = struct {
    GPIO0: ?PinConfig = null,
    GPIO1: ?PinConfig = null,
    GPIO2: ?PinConfig = null,
    GPIO3: ?PinConfig = null,
    GPIO4: ?PinConfig = null,
    GPIO5: ?PinConfig = null,
    GPIO6: ?PinConfig = null,
    GPIO7: ?PinConfig = null,
    GPIO8: ?PinConfig = null,
    GPIO9: ?PinConfig = null,
    GPIO10: ?PinConfig = null,
    GPIO11: ?PinConfig = null,
    GPIO12: ?PinConfig = null,
    GPIO13: ?PinConfig = null,
    GPIO14: ?PinConfig = null,
    GPIO15: ?PinConfig = null,
    GPIO16: ?PinConfig = null,
    GPIO17: ?PinConfig = null,
    GPIO18: ?PinConfig = null,
    GPIO19: ?PinConfig = null,
    GPIO20: ?PinConfig = null,
    GPIO21: ?PinConfig = null,
    GPIO22: ?PinConfig = null,
    GPIO23: ?PinConfig = null,
    GPIO24: ?PinConfig = null,
    GPIO25: ?PinConfig = null,
    GPIO26: ?PinConfig = null,
    GPIO27: ?PinConfig = null,
    GPIO28: ?PinConfig = null,
    GPIO29: ?PinConfig = null,
};
pub const OutPin = struct {
    pin: PinImpl,

    pub fn toggle(self: *OutPin) void {
        self.pin.toggle();
    }
    pub fn set(self: *OutPin, val: u1) void {
        self.pin.set(val);
    }
};
pub const InPin = struct {
    pin: PinImpl,

    pub fn read(self: InPin) u1 {
        return self.pin.read();
    }
};

const StructField = std.builtin.Type.StructField;
fn MakePinsType(comptime config: GPIOConfig) type {
    var gpios: []const StructField = &.{};
    for (@typeInfo(GPIOConfig).@"struct".fields) |field| {
        if (@field(config, field.name)) |pin_config| {
            var pin = StructField{
                .name = field.name,
                .alignment = @alignOf(field.type),
                .default_value_ptr = null,
                .type = undefined,
                .is_comptime = false,
            };
            switch (pin_config.direction) {
                .out => pin.type = OutPin,
                .in => pin.type = InPin,
            }

            gpios = gpios ++ &[1]StructField{pin};
        }
    }

    return @Type(.{
        .@"struct" = .{
            .layout = .auto,
            .is_tuple = false,
            .fields = gpios,
            .decls = &.{},
        },
    });
}

pub fn MakePins(comptime config: GPIOConfig) MakePinsType(config) {
    var ret: MakePinsType(config) = undefined;
    inline for (@typeInfo(GPIOConfig).@"struct".fields) |field| {
        if (@field(config, field.name)) |pin_config| {
            const pin: PinImpl = @field(PinImpl, field.name);
            switch (pin_config.direction) {
                .out => @field(ret, field.name) = OutPin{
                    .pin = pin,
                },
                .in => @field(ret, field.name) = InPin{
                    .pin = pin,
                },
            }
        }
    }
    return ret;
}
pub fn InitPins(comptime config: GPIOConfig) void {
    inline for (@typeInfo(GPIOConfig).@"struct".fields) |field| {
        if (@field(config, field.name)) |pin_config| {
            const pin: PinImpl = @field(PinImpl, field.name);
            pin.init(pin_config);
        }
    }
}

const PinImpl = enum(u5) {
    GPIO0 = 0,
    GPIO1 = 1,
    GPIO2 = 2,
    GPIO3 = 3,
    GPIO4 = 4,
    GPIO5 = 5,
    GPIO6 = 6,
    GPIO7 = 7,
    GPIO8 = 8,
    GPIO9 = 9,
    GPIO10 = 10,
    GPIO11 = 11,
    GPIO12 = 12,
    GPIO13 = 13,
    GPIO14 = 14,
    GPIO15 = 15,
    GPIO16 = 16,
    GPIO17 = 17,
    GPIO18 = 18,
    GPIO19 = 19,
    GPIO20 = 20,
    GPIO21 = 21,
    GPIO22 = 22,
    GPIO23 = 23,
    GPIO24 = 24,
    GPIO25 = 25,
    GPIO26 = 26,
    GPIO27 = 27,
    GPIO28 = 28,
    GPIO29 = 29,

    pub fn init(comptime self: PinImpl, comptime config: PinConfig) void {
        self.selectFunction(config.fun);
        self.setDir(config.direction);
        if (config.pull) |pull|
            self.setPull(pull);
    }
    pub fn set(self: PinImpl, val: u1) void {
        if (val == 0) {
            rp.peripherals.SIO.GPIO_OUT_CLR.write(self.mask());
        } else {
            rp.peripherals.SIO.GPIO_OUT_SET.write(self.mask());
        }
    }
    pub fn read(self: PinImpl) u1 {
        return if ((rp.peripherals.SIO.GPIO_IN.read() & self.mask()) == 0) 0 else 1;
    }
    pub fn toggle(self: PinImpl) void {
        rp.peripherals.SIO.GPIO_OUT_XOR.write(self.mask());
    }

    fn setDir(comptime self: PinImpl, dir: PinDirection) void {
        const name = std.fmt.comptimePrint("GPIO{d}", .{@intFromEnum(self)});
        switch (dir) {
            .out => {
                @field(rp.peripherals.PADS_BANK0, name).write(@field(rp.PADS_BANK0, name).IE(0).OD(0));
                rp.peripherals.SIO.GPIO_OE_SET.write(self.mask());
            },
            .in => {
                @field(rp.peripherals.PADS_BANK0, name).write(@field(rp.PADS_BANK0, name).IE(1).OD(1));
                rp.peripherals.SIO.GPIO_OE_CLR.write(self.mask());
            },
        }
    }
    fn selectFunction(comptime self: PinImpl, fun: PinFunction) void {
        // TODO: this is so fucked up, figure out a better way for the codegen,
        // maybe an array or something but not sure if it can be detected
        // easily during codegen what registers need to be an array
        const name = std.fmt.comptimePrint("GPIO{d}_CTRL", .{@intFromEnum(self)});
        @field(rp.peripherals.IO_BANK0, name).write(@field(rp.IO_BANK0, name).FUNCSEL(@enumFromInt(@intFromEnum(fun))));
    }
    fn setPull(comptime self: PinImpl, pull: PinPullResistor) void {
        const name = std.fmt.comptimePrint("GPIO{d}", .{@intFromEnum(self)});

        switch (pull) {
            .down => @field(rp.peripherals.PADS_BANK0, name).write(@field(rp.PADS_BANK0, name).PDE(1).PUE(0)),
            .up => @field(rp.peripherals.PADS_BANK0, name).write(@field(rp.PADS_BANK0, name).PDE(0).PUE(1)),
        }
    }

    fn mask(self: PinImpl) u30 {
        return @as(u30, 1) << @intFromEnum(self);
    }
};
