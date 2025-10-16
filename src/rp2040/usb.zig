const rp = @import("chip/rp2040.zig");
const Pll = @import("pll.zig");
const interrupts = @import("interrupts.zig");
const std = @import("std");

// TODO: USB DPRAM can be acessed at 8/16/32 bits, our register codegen only
// generates for 32 bit reads/writes as that's what all other registers
// support. So it might be better performance to create a separate abstraction
// for registers in USB DPRAM but for now I'll just keep it simple and use the
// common codegened registers

pub const DescriptorType = enum(u8) {
    device = 1,
    configuration = 2,
    string = 3,
    interface = 4,
    endpoint = 5,
    device_qualifier = 6,
    other_speed_configuration = 7,
    interface_power = 8,
};

// https://www.usb.org/defined-class-codes
pub const DeviceClassCode = enum(u8) {
    unspecified = 0,
    hid = 3,
    _,
};
pub const InterfaceClassCode = enum(u8) {
    hid = 3,
    _,
};

pub const InterfaceSubclass = enum(u8) {
    none = 0,
    boot_interface = 1,
    _,
};

pub const InterfaceProtocol = enum(u8) {
    none = 0,
    keyboard = 1,
    mouse = 2,
    _,
};

pub const TransferType = enum(u2) {
    Control = 0,
    Isochronous = 1,
    Bulk = 2,
    Interrupt = 3,
};

pub const DeviceDescriptor = extern struct {
    length: u8 = 18,
    descriptor_type: DescriptorType = .device,
    bcd_usb: u16, // usb hid spec release??
    device_class: DeviceClassCode,
    device_subclass: u8,
    device_protocol: u8,
    max_packet_size: u8,
    vendor_id: u16,
    product_id: u16,
    bcd_device: u16,
    manufacturer_string_idx: u8,
    product_string_idx: u8,
    serial_number_string_idx: u8,
    num_configurations: u8,

    comptime {
        std.debug.assert(@sizeOf(@This()) == 18);
    }
};

pub const DeviceQualifierDescriptor = extern struct {
    length: u8 = 10,
    descriptor_type: DescriptorType = .device_qualifier,
    bcd_usb: u16, // usb hid spec release??
    device_class: DeviceClassCode,
    device_subclass: u8,
    device_protocol: u8,
    max_packet_size: u8,
    num_configurations: u8,
    reserved: u8 = 0,

    comptime {
        std.debug.assert(@sizeOf(@This()) == 10);
    }
};

pub const ConfigurationDescriptor = extern struct {
    length: u8 = 9,
    descriptor_type: DescriptorType = .configuration,
    /// Total length of data returned for this configuration. Includes the
    /// combined length of all descriptors (configuration, interface, endpoint,
    /// and class- or vendor-specific) returned for this configuration
    total_length: u16 align(1),
    num_interfaces: u8,
    configuration_value: u8,
    configuration_string_idx: u8,
    attributes: Attributes,
    max_power: DevicePower,

    const Attributes = packed struct(u8) {
        _reserved: u5 = 0,
        remote_wakeup: u1,
        self_powered: u1,
        _reserved2: u1 = 1,
    };

    const DevicePower = packed struct(u8) {
        /// expressed in 2mA units (e.g. 50 == 100 mA)
        power: u8,

        pub fn from_mA(mA: u8) DevicePower {
            return .{ .power = (mA +| 1) >> 1 };
        }
    };

    comptime {
        std.debug.assert(@sizeOf(@This()) == 9);
    }
};

const LanguageDescriptor = extern struct {
    length: u8,
    descriptor_type: DescriptorType = .string,
    string: u16,

    pub fn makeEnglish() LanguageDescriptor {
        return .{
            .length = 4,
            .string = 0x0409, // english
        };
    }
};
fn makeStringDescriptor(buf: []align(2) u8, str: []const u8) !void {
    @setEvalBranchQuota(10000);
    const encoded = try std.unicode.utf8ToUtf16Le(@ptrCast(buf[2..]), str);
    buf[0] = @intCast(encoded * 2 + 2);
    buf[1] = @intFromEnum(DescriptorType.string);
}
pub const InterfaceDescriptor = extern struct {
    length: u8 = 9,
    descriptor_type: DescriptorType = .interface,
    interface_idx: u8,
    alternate_setting: u8,
    num_endpoints: u8,
    interface_class: InterfaceClassCode,
    interface_subclass: InterfaceSubclass,
    interface_protocol: InterfaceProtocol,
    interface_string_idx: u8,
    comptime {
        std.debug.assert(@sizeOf(@This()) == 9);
    }
};

pub const EndpointDescriptor = extern struct {
    length: u8 = 7,
    descriptor_type: DescriptorType = .endpoint,
    address: u8,
    attributes: Attributes,
    max_packet_size: u16,
    /// in milliseconds
    interval: u8,

    const Attributes = packed struct(u8) {
        transfer_type: TransferType,
        synchronisation: Synchronisation,
        usage: Usage,
        reserved: u2,

        const Synchronisation = enum(u2) {
            none = 0,
            asynchronous = 1,
            adaptive = 2,
            synchronous = 3,
        };
        const Usage = enum(u2) {
            data = 0,
            feedback = 1,
            implicit_feedback_data = 2,
            _,
        };
    };

    const Address = packed struct(u8) {
        endpoint: u4,
        _reserved: u3 = 0,
        direction: Direction,
    };
    comptime {
        std.debug.assert(@sizeOf(@This()) == 7);
    }
};

const Direction = enum(u1) {
    out = 0,
    in = 1,
};

const Request = enum(u8) {
    get_status = 0,
    clear_feature = 1,
    set_feature = 3,
    set_address = 5,
    get_descriptor = 6,
    set_descriptor = 7,
    get_configuration = 8,
    set_configuration = 9,
    get_interface = 10,
    set_interface = 11,
    synch_frame = 12,
};

pub const Configuration = struct {
    device_descriptor: DeviceDescriptor,
    // TODO: when we support multiple configurations the set_configuration handler has to switch to the correct one
    config_descriptor: ConfigurationDescriptor,
    strings: []const []const u8,
};

const Endpoint = struct {
    buf: []volatile u8,
    next_pid: u1,
};

var configuration: Configuration = undefined;

var endpoints = [1]Endpoint{
    .{
        .buf = @as([*]volatile u8, @ptrFromInt(@intFromPtr(rp.USB_DPRAM.USB_DPRAM.base_address) + 0x100))[0..0x40],
        .next_pid = 0,
    },
};
var addr: u8 = 0;
var should_set_addr = false;
var current_config: ConfigurationDescriptor = undefined;

const BufCtrl = packed struct(u16) {
    len: u10,
    available: u1,
    stall: u1,
    reset_select: u1,
    pid: u1,
    last: u1,
    full: u1,
};

pub fn init(config: Configuration) void {
    initPll();
    initClk();

    rp.peripherals.RESETS.RESET.write(rp.RESETS.RESET.USBCTRL(1));
    rp.peripherals.RESETS.RESET.write(rp.RESETS.RESET.USBCTRL(0));
    while (rp.peripherals.RESETS.RESET_DONE.read().USBCTRL() == 0) {}

    @memset(@as([*]volatile u32, @ptrCast(rp.peripherals.USB_DPRAM.base_address))[0..4096], 0);

    interrupts.vector_table.USBCTRL_IRQ = &irq;
    interrupts.enableInterrupt(.USBCTRL_IRQ);
    // memset dpram to 0?
    // what is this softcon?
    rp.peripherals.USB.USB_MUXING.write(rp.USB.USB_MUXING.TO_PHY(1).SOFTCON(1));
    // force vbus detect to make it think that it is plugged in (my pico has no vbus detect as far as i know)
    rp.peripherals.USB.USB_PWR.write(rp.USB.USB_PWR.VBUS_DETECT(1).VBUS_DETECT_OVERRIDE_EN(1));
    rp.peripherals.USB.MAIN_CTRL.write(rp.USB.MAIN_CTRL.CONTROLLER_EN(1));

    // enable interrupt stuff
    rp.peripherals.USB.SIE_CTRL.write(rp.USB.SIE_CTRL.EP0_INT_1BUF(1));
    rp.peripherals.USB.INTE.write(rp.USB.INTE.BUFF_STATUS(1).BUS_RESET(1).SETUP_REQ(1));

    // enable pull-up to present to host as a full speed device
    rp.peripherals.USB.SIE_CTRL.write(rp.USB.SIE_CTRL.PULLUP_EN(1));

    configuration = config;
}

fn initClk() void {
    rp.peripherals.CLOCKS.CLK_USB_CTRL.write(rp.CLOCKS.CLK_USB_CTRL.ENABLE(0));
    // wait for a 3 cycles of the target (usb) clock, taken from sdk
    // assumes that sys is already running at 125Mhz, TODO: make it not hardcoded maybe
    const sys_frequency = 125_000_000;
    const delay: u32 = (sys_frequency / 48_000_000 + 1) * 3;
    rp.busy_wait_at_least_cycles(delay);
    rp.peripherals.CLOCKS.CLK_USB_CTRL.write(rp.CLOCKS.CLK_USB_CTRL.AUXSRC(.clksrc_pll_usb));
    rp.peripherals.CLOCKS.CLK_USB_CTRL.write(rp.CLOCKS.CLK_USB_CTRL.ENABLE(1));
}
fn initPll() void {
    rp.peripherals.RESETS.RESET.write(comptime rp.RESETS.RESET.PLL_USB(1));
    // 48mhz usb clock
    Pll.setupUSB(.{
        .fbdiv = 120,
        .post_div1 = 6,
        .post_div2 = 5,
    });
}

fn handleBusReset() callconv(.c) void {
    rp.peripherals.USB.SIE_STATUS.reg.* = rp.USB.SIE_STATUS.FieldMasks.BUS_RESET;
    addr = 0;
    should_set_addr = false;
    rp.peripherals.USB.ADDR_ENDP.write(rp.USB.ADDR_ENDP.ADDRESS(0));
    endpoints[0].next_pid = 0;
}

fn ackOutRequest() void {
    std.log.debug("Acking OUT request", .{});
    rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_IN_BUFFER_CONTROL
        .LENGTH_0(0)
        .PID_0(endpoints[0].next_pid)
        .FULL_0(1));
    asm volatile (
        \\ nop
        \\ nop
        \\ nop
    );
    rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_IN_BUFFER_CONTROL.AVAILABLE_0(1));
    endpoints[0].next_pid ^= 1;
}
fn handleSetup() callconv(.c) void {
    rp.peripherals.USB.SIE_STATUS.reg.* = rp.USB.SIE_STATUS.FieldMasks.SETUP_REC;
    const packet_low = rp.peripherals.USB_DPRAM.SETUP_PACKET_LOW.read();
    const req_type = packet_low.BMREQUESTTYPE();
    const dir: Direction = @enumFromInt(req_type >> 7);
    const packet_req = packet_low.BREQUEST();
    const req: Request = @enumFromInt(packet_req);
    // for some reason sdk always responds in the setup with pid = 1
    endpoints[0].next_pid = 1;
    std.log.debug("Received: {t} {t}", .{ dir, req });
    if (dir == .out) {
        if (req == .set_address) {
            addr = @intCast(packet_low.WVALUE() & 0xff);
            std.log.debug("Set address with: {d}", .{packet_low.WVALUE()});
            should_set_addr = true;
            ackOutRequest();
        } else if (req == .set_configuration) {
            std.log.debug("Set configuration to index: {d}", .{packet_low.WVALUE()});
            current_config = configuration.config_descriptor;
            ackOutRequest();
        } else {
            @breakpoint();
            ackOutRequest();
        }
    } else if (dir == .in) {
        if (req == .get_descriptor) {
            const descriptor_type: DescriptorType = @enumFromInt(packet_low.WVALUE() >> 8);
            std.log.debug("Descriptor type: {t}", .{descriptor_type});
            switch (descriptor_type) {
                .device => {
                    // endpoints[0].next_pid = 1;
                    while (rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.read().AVAILABLE_0() == 1) {}
                    @memset(endpoints[0].buf, 0);
                    @memcpy(endpoints[0].buf[0..18], std.mem.asBytes(&configuration.device_descriptor)[0..18]);

                    std.debug.assert(configuration.device_descriptor.length == @sizeOf(DeviceDescriptor));

                    rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_IN_BUFFER_CONTROL
                        .LENGTH_0(@sizeOf(DeviceDescriptor))
                        .PID_0(endpoints[0].next_pid)
                        .FULL_0(1));

                    // datasheet says:
                    // nop for some clk_sys cycles to ensure that at least one
                    // clk_usb cycle has passed. For example if clk_sys was
                    // running at 125MHz and clk_usb was running at 48MHz then
                    // 125/48 rounded up would be 3 nop instructions
                    asm volatile (
                        \\ nop
                        \\ nop
                        \\ nop
                    );
                    rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_IN_BUFFER_CONTROL.AVAILABLE_0(1));

                    endpoints[0].next_pid ^= 1;
                },
                .device_qualifier => {
                    rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_IN_BUFFER_CONTROL.STALL(1));
                    rp.peripherals.USB.EP_STALL_ARM.set(rp.USB.EP_STALL_ARM.FieldMasks.EP0_IN);
                },
                .configuration => {
                    // while (rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.read().AVAILABLE_0() == 1) {}
                    @memset(endpoints[0].buf, 0);
                    @memcpy(endpoints[0].buf[0..9], std.mem.asBytes(&configuration.config_descriptor)[0..9]);

                    std.debug.assert(configuration.config_descriptor.length == @sizeOf(ConfigurationDescriptor));

                    rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_IN_BUFFER_CONTROL
                        .LENGTH_0(@sizeOf(ConfigurationDescriptor))
                        .PID_0(endpoints[0].next_pid)
                        .FULL_0(1));

                    asm volatile (
                        \\ nop
                        \\ nop
                        \\ nop
                    );
                    rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_IN_BUFFER_CONTROL.AVAILABLE_0(1));

                    endpoints[0].next_pid ^= 1;
                },
                .string => {
                    const index = packet_low.WVALUE() & 0xff;
                    if (index == 0) {
                        const desc = LanguageDescriptor.makeEnglish();
                        @memset(endpoints[0].buf, 0);
                        @memcpy(endpoints[0].buf[0..desc.length], std.mem.asBytes(&desc)[0..desc.length]);

                        rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_IN_BUFFER_CONTROL
                            .LENGTH_0(desc.length)
                            .PID_0(endpoints[0].next_pid)
                            .FULL_0(1));

                        asm volatile (
                            \\ nop
                            \\ nop
                            \\ nop
                        );
                        rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_IN_BUFFER_CONTROL.AVAILABLE_0(1));

                        endpoints[0].next_pid ^= 1;
                    } else {
                        const str = configuration.strings[index - 1];
                        // it could take 255 bytes long but there are 2 bytes
                        // of header values and then a utf16 string, so the
                        // last byte cant be filled anyway and zig complains if
                        // I pass a slice with uneven length to the utf8 to
                        // utf16 conversion function
                        var buf: [254]u8 align(2) = undefined;
                        makeStringDescriptor(&buf, str) catch {
                            return;
                        };
                        const len = buf[0];
                        @memset(endpoints[0].buf, 0);
                        @memcpy(endpoints[0].buf[0..len], buf[0..len]);

                        rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_IN_BUFFER_CONTROL
                            .LENGTH_0(len)
                            .PID_0(endpoints[0].next_pid)
                            .FULL_0(1));

                        asm volatile (
                            \\ nop
                            \\ nop
                            \\ nop
                        );
                        rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_IN_BUFFER_CONTROL.AVAILABLE_0(1));

                        endpoints[0].next_pid ^= 1;
                    }
                },
                else => {
                    @breakpoint();
                },
            }
        }
    } else {
        @breakpoint();
    }
}

pub fn irq() callconv(.c) void {
    const status = rp.peripherals.USB.INTS.read();
    if (status.SETUP_REQ() == 1) {
        handleSetup();
    }
    if (status.BUFF_STATUS() == 1) {
        const buffers = rp.peripherals.USB.BUFF_STATUS.read();
        if (buffers.EP0_OUT() == 1) {
            rp.peripherals.USB.BUFF_STATUS.set(rp.USB.BUFF_STATUS.FieldMasks.EP0_OUT);
        }
        if (buffers.EP0_IN() == 1) {
            rp.peripherals.USB.BUFF_STATUS.set(rp.USB.BUFF_STATUS.FieldMasks.EP0_IN);
            if (should_set_addr) {
                should_set_addr = false;
                rp.peripherals.USB.ADDR_ENDP.write(rp.USB.ADDR_ENDP.ADDRESS(@intCast(addr)));
            } else {
                // std.log.debug("Buf status EP0 IN", .{});
                rp.peripherals.USB_DPRAM.EP0_OUT_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_OUT_BUFFER_CONTROL
                    .LENGTH_0(0)
                    .PID_1(endpoints[0].next_pid)
                    .FULL_0(0));

                asm volatile (
                    \\ nop
                    \\ nop
                    \\ nop
                );
                rp.peripherals.USB_DPRAM.EP0_OUT_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_OUT_BUFFER_CONTROL.AVAILABLE_0(1));
                endpoints[0].next_pid ^= 1;
            }
        }
    }
    if (status.BUS_RESET() == 1) {
        handleBusReset();
    }
}
