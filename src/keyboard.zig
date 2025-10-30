const std = @import("std");
const GPIO = @import("rp2040/gpio.zig");
const rp = @import("rp2040/chip/rp2040.zig");
const Keycode = @import("keycodes.zig").Keycode;

pub const Layout = []const []const Keycode;

pub const Key = struct {
    pos: struct {
        x: u8,
        y: u8,
    },
    pin: GPIO.Pin,
};

pub fn MakeKeyboard(comptime keyboard_matrix: []const Key, comptime layout: Layout) type {
    comptime {
        var used_pins: std.EnumSet(GPIO.Pin) = .{};
        for (keyboard_matrix) |key| {
            if (used_pins.contains(key.pin)) {
                @compileError(std.fmt.comptimePrint("Pin {t} is used multiple times in matrix definition, this is not supported and is probably a bug.", .{key.pin}));
            } else {
                used_pins.insert(key.pin);
            }
        }
    }

    return struct {
        const key_matrix = keyboard_matrix;
        const keyboard_layout = blk: {
            var l: [key_matrix.len]Keycode = undefined;
            for (key_matrix, &l) |key, *kc| {
                kc.* = layout[key.pos.y][key.pos.x];
            }
            break :blk l;
        };

        var matrix: [keyboard_matrix.len]bool = @splat(false);
        var last_matrix: [keyboard_matrix.len]bool = @splat(false);

        var changes: [keyboard_matrix.len]bool = @splat(false);

        pub fn makeGPIOConfig(comptime base_config: GPIO.GPIOConfig) GPIO.GPIOConfig {
            var new_config = base_config;
            inline for (key_matrix) |key| {
                @field(new_config, @tagName(key.pin)) = .{
                    .direction = .in,
                    .pull = .up,
                };
            }
            return new_config;
        }

        pub fn task(report: anytype) bool {
            const did_change = scanMatrix();
            var i: u8 = 0;
            if (did_change) {
                for (changes, keyboard_layout) |d, key| {
                    if (d) {
                        if (key.isModifier()) {
                            switch (key) {
                                .KC_shift => {
                                    report.data.modifiers[1] = 1;
                                },
                                else => {},
                            }
                        } else {
                            report.data.keys[i] = @intCast(@intFromEnum(key));
                            i += 1;
                        }
                    }
                }
                return true;
            }

            return false;
        }

        fn scanMatrix() bool {
            const gpios = rp.peripherals.SIO.GPIO_IN.read();
            last_matrix = matrix;
            inline for (&matrix, key_matrix) |*m, key| {
                m.* = (gpios & (1 << @intFromEnum(key.pin))) == 0;
            }

            var did_change = false;
            for (last_matrix, matrix, &changes) |last, curr, *change| {
                change.* = curr;
                if (last != curr) {
                    did_change = true;
                }
            }
            return did_change;
        }
    };
}
