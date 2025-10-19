const std = @import("std");
const rp = @import("chip/rp2040.zig");
const Pll = @import("pll.zig");
const interrupts = @import("interrupts.zig");
const descriptors = @import("usb/descriptors.zig");

// TODO: USB DPRAM can be acessed at 8/16/32 bits, our register codegen only
// generates for 32 bit reads/writes as that's what all other registers
// support. So it might be better performance to create a separate abstraction
// for registers in USB DPRAM but for now I'll just keep it simple and use the
// common codegened registers

pub const EndpointConfig = struct {
    endpoint: u4,
    direction: descriptors.Direction,
    endpoint_type: descriptors.Endpoint.TransferType,
    interval: u8 = 1,
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
    device_descriptor: descriptors.Device,
    // TODO: when we support multiple configurations the set_configuration handler has to switch to the correct one
    config_descriptor: descriptors.Configuration,
    strings: []const []const u8,
    endpoints: []const EndpointConfig,
    hid_report: []const u8,
};

const EndpointCtrl = packed struct(u32) {
    buffer_base_address_offset: u16,
    interrupt_nak: u1,
    interrupt_stall: u1,
    reserved: u8 = 0,
    endpoint_type: descriptors.Endpoint.TransferType,
    interrupt_per_double_buff: u1,
    interrupt_per_buf: u1,
    double_buffered: u1,
    enable: u1,
};
const BufCtrl = packed struct(u32) {
    length_0: u10 = 0,
    available_0: u1 = 0,
    stall: u1 = 0,
    reset_buf_select: u1 = 0,
    pid_0: u1 = 0,
    last_0: u1 = 0,
    full_0: u1 = 0,
    length_1: u10 = 0,
    available_1: u1 = 0,
    double_buf_offset: IsochronousOffset = @enumFromInt(0),
    pid_1: u1 = 0,
    last_1: u1 = 0,
    full_1: u1 = 0,

    const IsochronousOffset = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
};

const Endpoint = struct {
    buf: []volatile u8,
    buf_ctrl: *volatile BufCtrl,
    endp_ctrl: ?*volatile EndpointCtrl,
    next_pid: u1,

    pub fn getIndex(num: u4, direction: descriptors.Direction) u5 {
        return 2 * num + (if (direction == .in) @as(u5, 0) else @as(u5, 1));
    }
};

const max_num_endpoints = 2 * 16; // 16 in,out endpoints

fn makeConfigDescriptor(comptime config: Configuration) []const u8 {
    var res: []const u8 = "";
    const interface = descriptors.Interface{
        .interface_idx = 0,
        .alternate_setting = 0,
        .num_endpoints = config.endpoints.len,
        .interface_class = .hid,
        .interface_subclass = .boot_interface,
        .interface_protocol = .keyboard,
        .interface_string_idx = 5,
    };
    res = res ++ std.mem.toBytes(interface);
    const hid = descriptors.HID{
        .bcd_hid = 0x101,
        .country_code = 0,
        .num_descriptors = 1,
        .report_length = config.hid_report.len,
    };
    res = res ++ std.mem.toBytes(hid);
    for (config.endpoints) |endp_conf| {
        const endp = descriptors.Endpoint{
            .address = .{
                .direction = endp_conf.direction,
                .endpoint = endp_conf.endpoint,
            },
            .attributes = .{
                .transfer_type = endp_conf.endpoint_type,
            },
            .interval = endp_conf.interval,
            .max_packet_size = 64,
        };

        res = res ++ std.mem.toBytes(endp);
    }

    var conf = config.config_descriptor;
    conf.total_length = config.config_descriptor.length + res.len;

    res = &std.mem.toBytes(conf) ++ res;
    return res;
}
pub fn UsbDevice(comptime config: Configuration) type {
    return struct {
        addr: u8 = 0,
        should_set_addr: bool = false,
        endpoints: [max_num_endpoints]?Endpoint, // ep0 + whatever is in config

        const device_descriptor: [18]u8 = @bitCast(config.device_descriptor);
        const config_descriptor: []const u8 = makeConfigDescriptor(config);
        const string_descriptors: []const []const u8 = blk: {
            var descs: []const []const u8 = &.{&std.mem.toBytes(descriptors.Language.English)};
            for (config.strings) |s| {
                descs = descs ++ .{descriptors.makeString(s)};
            }

            break :blk descs;
        };
        const hid_report_descriptor: []const u8 = config.hid_report;

        pub fn init() @This() {
            initPll();
            initClk();

            rp.peripherals.RESETS.RESET.write(rp.RESETS.RESET.USBCTRL(1));
            rp.peripherals.RESETS.RESET.write(rp.RESETS.RESET.USBCTRL(0));
            while (rp.peripherals.RESETS.RESET_DONE.read().USBCTRL() == 0) {}

            @memset(@as([*]volatile u32, @ptrCast(rp.peripherals.USB_DPRAM.base_address))[0..4096], 0);

            // interrupts.vector_table.USBCTRL_IRQ = &irq;
            // interrupts.enableInterrupt(.USBCTRL_IRQ);

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
            var endpoints: [max_num_endpoints]?Endpoint = @splat(null);
            endpoints[0] = .{
                .buf = @as([*]volatile u8, @ptrFromInt(@intFromPtr(rp.USB_DPRAM.USB_DPRAM.base_address) + 0x100))[0..0x40],
                .buf_ctrl = @ptrCast(rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.reg),
                .endp_ctrl = null,
                .next_pid = 0,
            };
            endpoints[1] = .{
                .buf = @as([*]volatile u8, @ptrFromInt(@intFromPtr(rp.USB_DPRAM.USB_DPRAM.base_address) + 0x100))[0..0x40],
                .buf_ctrl = @ptrCast(rp.peripherals.USB_DPRAM.EP0_OUT_BUFFER_CONTROL.reg),
                .endp_ctrl = null,
                .next_pid = 0,
            };

            const buf_ctrls: [*]volatile BufCtrl = @ptrCast(rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.reg);
            const endp_ctrls: [*]volatile EndpointCtrl = @ptrCast(rp.peripherals.USB_DPRAM.EP1_IN_CONTROL.reg);
            inline for (config.endpoints) |endp_conf| {
                const idx = Endpoint.getIndex(endp_conf.endpoint, endp_conf.direction);
                const buf_offset = (@as(u16, idx) - 1) * 64; // ep0 only has one buffer shared between in and out
                endpoints[idx] = Endpoint{
                    .buf = @as([*]volatile u8, @ptrFromInt(@intFromPtr(rp.USB_DPRAM.USB_DPRAM.base_address) + buf_offset))[0..64],
                    .buf_ctrl = &buf_ctrls[idx],
                    .endp_ctrl = &endp_ctrls[idx - 2], // no endpoint control register for ep0 in and ep0 out
                    .next_pid = 0,
                };

                endpoints[idx].?.endp_ctrl.?.* = .{
                    .enable = 1,
                    .interrupt_per_buf = 1,
                    .buffer_base_address_offset = buf_offset,
                    .double_buffered = 0,
                    .endpoint_type = endp_conf.endpoint_type,
                    .interrupt_nak = 1,
                    .interrupt_per_double_buff = 0,
                    .interrupt_stall = 1,
                };
                initTransfer(&endpoints[idx].?, &.{}, 0);
            }

            return .{
                .endpoints = endpoints,
            };
        }

        pub fn poll(self: *@This()) void {
            const status = rp.peripherals.USB.INTS.read();
            if (status.SETUP_REQ() == 1) {
                self.handleSetup();
            }
            if (status.BUFF_STATUS() == 1) {
                const buffers = rp.peripherals.USB.BUFF_STATUS.read();
                std.log.debug("Buffers ready: {b:0>32}", .{buffers.val});
                if (buffers.EP0_OUT() == 1) {
                    rp.peripherals.USB.BUFF_STATUS.set(rp.USB.BUFF_STATUS.FieldMasks.EP0_OUT);
                }
                if (buffers.EP0_IN() == 1) {
                    rp.peripherals.USB.BUFF_STATUS.set(rp.USB.BUFF_STATUS.FieldMasks.EP0_IN);
                    if (self.should_set_addr) {
                        self.should_set_addr = false;
                        rp.peripherals.USB.ADDR_ENDP.write(rp.USB.ADDR_ENDP.ADDRESS(@intCast(self.addr)));
                    } else {
                        // std.log.debug("Buf status EP0 IN", .{});
                        rp.peripherals.USB_DPRAM.EP0_OUT_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_OUT_BUFFER_CONTROL
                            .LENGTH_0(0)
                            .PID_1(self.endpoints[0].?.next_pid)
                            .FULL_0(0));

                        asm volatile (
                            \\ nop
                            \\ nop
                            \\ nop
                        );
                        rp.peripherals.USB_DPRAM.EP0_OUT_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_OUT_BUFFER_CONTROL.AVAILABLE_0(1));
                        self.endpoints[0].?.next_pid ^= 1;
                    }
                }
                if (buffers.EP1_IN() == 1) {
                    @breakpoint();
                }
            }
            if (status.BUS_RESET() == 1) {
                self.handleBusReset();
            }
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

        fn handleBusReset(self: *@This()) void {
            rp.peripherals.USB.SIE_STATUS.writeOver(rp.USB.SIE_STATUS.BUS_RESET(1));
            self.addr = 0;
            self.should_set_addr = false;
            rp.peripherals.USB.ADDR_ENDP.write(rp.USB.ADDR_ENDP.ADDRESS(0));
            self.endpoints[0].?.next_pid = 0;
        }

        fn ackOutRequest(self: *@This()) void {
            std.log.debug("Acking OUT request", .{});
            initTransfer(&self.endpoints[0].?, &.{}, 0);
        }
        fn handleSetup(self: *@This()) void {
            rp.peripherals.USB.SIE_STATUS.writeOver(rp.USB.SIE_STATUS.SETUP_REC(1));
            const packet_low = rp.peripherals.USB_DPRAM.SETUP_PACKET_LOW.read();
            const packet_high = rp.peripherals.USB_DPRAM.SETUP_PACKET_HIGH.read();
            const req_type = packet_low.BMREQUESTTYPE();
            const dir: descriptors.Direction = @enumFromInt(req_type >> 7);
            const packet_req = packet_low.BREQUEST();
            const req: Request = @enumFromInt(packet_req);
            const max_len: u16 = packet_high.WLENGTH();
            // for some reason sdk always responds in the setup with pid = 1
            self.endpoints[0].?.next_pid = 1;
            std.log.debug("Received: {t} {t}", .{ dir, req });
            if (dir == .out) {
                if (req == .set_address) {
                    self.addr = @intCast(packet_low.WVALUE() & 0xff);
                    std.log.debug("Set address with: {d}", .{packet_low.WVALUE()});
                    self.should_set_addr = true;
                    self.ackOutRequest();
                } else if (req == .set_configuration) {
                    std.debug.assert(packet_low.WVALUE() == 1);
                    std.log.debug("Set configuration", .{});
                    self.ackOutRequest();
                } else {
                    @breakpoint();
                    self.ackOutRequest();
                }
            } else if (dir == .in) {
                if (req == .get_descriptor) {
                    const descriptor_type: descriptors.Type = @enumFromInt(packet_low.WVALUE() >> 8);
                    std.log.debug("Descriptor type: {t}", .{descriptor_type});
                    switch (descriptor_type) {
                        .device => {
                            initTransfer(&self.endpoints[0].?, &device_descriptor, max_len);
                        },
                        .device_qualifier => {
                            rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_IN_BUFFER_CONTROL.STALL(1));
                            rp.peripherals.USB.EP_STALL_ARM.set(rp.USB.EP_STALL_ARM.FieldMasks.EP0_IN);
                        },
                        .configuration => {
                            std.log.warn("Config length: {d}", .{config_descriptor.len});
                            initTransfer(&self.endpoints[0].?, config_descriptor, max_len);
                        },
                        .string => {
                            const index = packet_low.WVALUE() & 0xff;
                            initTransfer(&self.endpoints[0].?, string_descriptors[index], max_len);
                        },
                        .report => {
                            initTransfer(&self.endpoints[0].?, hid_report_descriptor, max_len);
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

        fn initTransfer(endp: *Endpoint, data: []const u8, max_len: u16) void {
            // TODO: idk yet how to deal with situations when the host asks for less bytes than we want to send
            if (max_len < data.len) {
                std.log.warn("usb.initTransfer called with too much data (data.len = {d}, max_len = {d})", .{ data.len, max_len });
            }

            while (endp.buf_ctrl.available_0 == 1) {}
            std.log.debug("Sending {d} bytes", .{data.len});
            @memcpy(endp.buf[0..data.len], data);

            // rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_IN_BUFFER_CONTROL
            //     .LENGTH_0(@sizeOf(descriptors.Device))
            //     .PID_0(endp.next_pid)
            //     .FULL_0(1));
            endp.buf_ctrl.* = .{
                .length_0 = @min(@as(u10, @intCast(data.len)), max_len),
                .pid_0 = endp.next_pid,
                .full_0 = 1,
            };

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
            // rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_IN_BUFFER_CONTROL.AVAILABLE_0(1));
            endp.buf_ctrl.available_0 = 1;

            endp.next_pid ^= 1;
        }
    };
}
