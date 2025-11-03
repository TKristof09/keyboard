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
    address: Address,
    endpoint_type: descriptors.Endpoint.TransferType,
    interval: u8 = 1,

    const Address = struct {
        endpoint: u4,
        direction: descriptors.Direction,
    };
};

pub const DriverInterface = struct {
    endpoints: []const EndpointConfig,
    num_interfaces: u8,
    fn_handle_interface_setup_req: *const fn (setup_packet: SetupPacket, data: ?[]const u8) ?[]const u8,
    fn_get_descriptors: *const fn (comptime first_interface: u8) []const u8,
};

pub const Configuration = struct {
    device_descriptor: descriptors.Device,
    // TODO: when we support multiple configurations the set_configuration handler has to switch to the correct one
    config_descriptor: descriptors.Configuration,
    strings: []const []const u8,
    drivers: []const DriverInterface,
};

pub const SetupPacket = struct {
    recipient: Recipient,
    request_type: RequestType,
    dir: Direction,

    request: u8,
    value: u16,
    index: u16,
    length: u16,

    const Recipient = enum(u4) {
        device = 0,
        interface = 1,
        endpoint = 2,
        other = 3,
        _,
    };
    const RequestType = enum(u2) {
        standard = 0,
        class = 1,
        vendor = 2,
        _,
    };
    const Direction = enum(u1) {
        out = 0,
        in = 1,
    };
};

const DeviceRequest = enum(u8) {
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
const Request = union(enum) {
    standard: enum(u8) {
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
    },
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
const Driver = struct {
    descriptor: []const u8,
    fn_handle_interface_setup_req: *const fn (setup_packet: SetupPacket, data: ?[]const u8) ?[]const u8,
};

const max_num_endpoints = 2 * 16; // 16 in,out endpoints

fn makeConfigDescriptor(comptime config: Configuration, drivers: []const Driver) []const u8 {
    var driver_descriptors: []const u8 = "";
    for (drivers) |driver| {
        driver_descriptors = driver_descriptors ++ driver.descriptor;
    }
    var num_interfaces = 0;
    for (config.drivers) |driver| {
        num_interfaces += driver.num_interfaces;
    }
    var conf = config.config_descriptor;
    conf.total_length = config.config_descriptor.length + driver_descriptors.len;
    conf.num_interfaces = num_interfaces;

    return &std.mem.toBytes(conf) ++ driver_descriptors;
}

const State = enum {
    idle,
    data_in,
    data_out,
    status_in,
    status_out,
};

pub fn UsbDevice(comptime config: Configuration) type {
    return struct {
        addr: u8 = 0,
        should_set_addr: bool = false,
        endpoints: [max_num_endpoints]?Endpoint, // ep0 + whatever is in config
        state: State = .idle,
        setup_req: SetupPacket = undefined,
        setup_data: [64]u8 = undefined,

        const device_descriptor: [18]u8 = @bitCast(config.device_descriptor);
        const config_descriptor: []const u8 = makeConfigDescriptor(config, &drivers);
        const string_descriptors: []const []const u8 = blk: {
            var descs: []const []const u8 = &.{&std.mem.toBytes(descriptors.Language.English)};
            for (config.strings) |s| {
                descs = descs ++ .{descriptors.makeString(s)};
            }

            break :blk descs;
        };
        const drivers = blk: {
            var drvs: [config.drivers.len]Driver = undefined;
            var curr_interface: u8 = 0;
            for (config.drivers, 0..) |driver, i| {
                drvs[i] = .{
                    .descriptor = driver.fn_get_descriptors(curr_interface),
                    .fn_handle_interface_setup_req = driver.fn_handle_interface_setup_req,
                };
                curr_interface += driver.num_interfaces;
            }
            break :blk drvs;
        };

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
            inline for (config.drivers) |driver| {
                inline for (driver.endpoints) |endp_conf| {
                    const idx = Endpoint.getIndex(endp_conf.address.endpoint, endp_conf.address.direction);
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
                    @memset(endpoints[idx].?.buf, 0);
                }
            }

            return .{
                .endpoints = endpoints,
            };
        }

        pub fn poll(self: *@This()) void {
            checkErrors();

            const status = rp.peripherals.USB.INTS.read();

            if (status.BUS_RESET() == 1) {
                self.handleBusReset();
                return;
            }

            if (status.SETUP_REQ() == 1) {
                self.handleSetup();
                return;
            }

            if (status.BUFF_STATUS() == 1) {
                const buffers = rp.peripherals.USB.BUFF_STATUS.read();
                if (buffers.EP0_OUT() == 1) {
                    self.handleEp0OutComplete();
                    rp.peripherals.USB.BUFF_STATUS.set(rp.USB.BUFF_STATUS.FieldMasks.EP0_OUT);
                }
                if (buffers.EP0_IN() == 1) {
                    rp.peripherals.USB.BUFF_STATUS.set(rp.USB.BUFF_STATUS.FieldMasks.EP0_IN);
                    self.handleEp0InComplete();
                }
                return;
            }
        }

        pub fn queueMessage(self: *@This(), endp: EndpointConfig.Address, msg: []const u8) void {
            const endp_idx = Endpoint.getIndex(endp.endpoint, endp.direction);
            if (self.endpoints[endp_idx]) |*endpoint| {
                initTransfer(endpoint, msg, 64);
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
            initTransfer(&self.endpoints[0].?, "", 0);
        }
        fn handleSetup(self: *@This()) void {
            rp.peripherals.USB.SIE_STATUS.writeOver(rp.USB.SIE_STATUS.SETUP_REC(1));
            const packet_low = rp.peripherals.USB_DPRAM.SETUP_PACKET_LOW.read();
            const packet_high = rp.peripherals.USB_DPRAM.SETUP_PACKET_HIGH.read();
            const bm_req_type = packet_low.BMREQUESTTYPE();

            self.setup_req = SetupPacket{
                .dir = @enumFromInt(bm_req_type >> 7),
                .request_type = @enumFromInt((bm_req_type >> 5) & 0b11),
                .recipient = @enumFromInt(bm_req_type & 0b1111),
                .index = packet_high.WINDEX(),
                .length = packet_high.WLENGTH(),
                .request = packet_low.BREQUEST(),
                .value = packet_low.WVALUE(),
            };

            // Reset PIDs, it always starts with PID 1 for setup packets
            self.endpoints[0].?.next_pid = 1;
            self.endpoints[1].?.next_pid = 1;

            if (self.setup_req.dir == .out and self.setup_req.length > 0) {
                std.log.debug("Setup request with data phase: {d} bytes", .{self.setup_req.length});
                self.prepareEp0RX(@intCast(self.setup_req.length));

                std.debug.assert(self.setup_req.length <= 64); // don't want to deal with more data for now.

                self.state = .data_out;
                // if data phase we will handle it after the data has arrived
                return;
            }

            // if no data phase we can already handle it
            self.processSetupRequest(null);
        }
        fn processSetupRequest(self: *@This(), data: ?[]const u8) void {
            switch (self.setup_req.recipient) {
                .device => {
                    const req: DeviceRequest = @enumFromInt(self.setup_req.request);
                    std.log.debug("Received: {t} {t}", .{ self.setup_req.dir, req });
                    switch (req) {
                        .set_address => {
                            self.addr = @intCast(self.setup_req.value & 0xff);
                            self.should_set_addr = true;

                            self.state = .status_in;
                            self.ackOutRequest();
                        },
                        .set_configuration => {
                            std.debug.assert(self.setup_req.value == 1);
                            std.log.debug("Set configuration", .{});
                            self.state = .status_in;
                            self.ackOutRequest();
                        },
                        .get_descriptor => {
                            const descriptor_type: descriptors.Type = @enumFromInt(self.setup_req.value >> 8);
                            std.log.debug("Descriptor type: {t}", .{descriptor_type});
                            self.state = .data_in;
                            switch (descriptor_type) {
                                .device => {
                                    initTransfer(&self.endpoints[0].?, &device_descriptor, self.setup_req.length);
                                },
                                .device_qualifier => {
                                    rp.peripherals.USB_DPRAM.EP0_IN_BUFFER_CONTROL.write(rp.USB_DPRAM.EP0_IN_BUFFER_CONTROL.STALL(1));
                                    rp.peripherals.USB.EP_STALL_ARM.set(rp.USB.EP_STALL_ARM.FieldMasks.EP0_IN);
                                },
                                .configuration => {
                                    std.log.info("Config length: {d}", .{config_descriptor.len});
                                    // in the usb protocol the host first asks
                                    // for the "header" of the config
                                    // descriptor which tells it how long it
                                    // is, then it asks for the entire config
                                    // descriptor
                                    if (self.setup_req.length == 9) {
                                        initTransfer(&self.endpoints[0].?, config_descriptor[0..9], self.setup_req.length);
                                    } else {
                                        initTransfer(&self.endpoints[0].?, config_descriptor, self.setup_req.length);
                                    }
                                },
                                .string => {
                                    const index = self.setup_req.value & 0xff;
                                    initTransfer(&self.endpoints[0].?, string_descriptors[index], self.setup_req.length);
                                },
                                else => {
                                    std.log.err("Unknown descriptor type", .{});
                                },
                            }
                        },
                        else => {
                            std.log.warn("Unhandled device request: {}", .{req});
                            self.ackOutRequest();
                        },
                    }
                },
                .interface => {
                    std.log.debug("Interface request: {t} {any}", .{ self.setup_req.dir, self.setup_req.request });
                    const idx = self.setup_req.index;
                    if (drivers[idx].fn_handle_interface_setup_req(self.setup_req, data)) |response_data| {
                        initTransfer(&self.endpoints[0].?, response_data, self.setup_req.length);
                        self.state = .data_in;
                    } else {
                        std.debug.assert(self.setup_req.dir == .out); // IN requests should always send back data
                        self.state = .status_in;
                        self.ackOutRequest();
                    }
                },
                else => unreachable,
            }
        }

        fn handleEp0InComplete(self: *@This()) void {
            switch (self.state) {
                .data_in => {
                    self.prepareEp0RX(0);
                    self.state = .status_out;
                },
                .status_in => {
                    std.log.debug("Status IN complete", .{});
                    self.state = .idle;
                    if (self.should_set_addr) {
                        self.should_set_addr = false;
                        rp.peripherals.USB.ADDR_ENDP.write(rp.USB.ADDR_ENDP.ADDRESS(@intCast(self.addr)));
                        std.log.debug("Address set to {d}", .{self.addr});
                    }
                },
                else => {
                    std.log.err("Unexpected EP0 IN in state {}", .{self.state});
                },
            }
        }
        fn handleEp0OutComplete(self: *@This()) void {
            switch (self.state) {
                .data_out => {
                    const len = self.setup_req.length;
                    @memcpy(self.setup_data[0..len], self.endpoints[1].?.buf[0..len]);
                    std.log.debug("Received {d} bytes", .{len});
                    self.processSetupRequest(&self.setup_data);
                },
                .status_out => {
                    std.log.debug("Status OUT complete", .{});
                    self.state = .idle;
                    if (self.should_set_addr) {
                        self.should_set_addr = false;
                        rp.peripherals.USB.ADDR_ENDP.write(rp.USB.ADDR_ENDP.ADDRESS(@intCast(self.addr)));
                        std.log.debug("Address set to {d}", .{self.addr});
                    }
                },
                else => {
                    std.log.err("Unexpected EP0 OUT in state {}", .{self.state});
                },
            }
        }

        fn prepareEp0RX(self: *@This(), length: u10) void {
            @memset(self.endpoints[1].?.buf, 0);
            self.endpoints[1].?.buf_ctrl.* = .{
                .full_0 = 0,
                .length_0 = length,
                .pid_0 = self.endpoints[1].?.next_pid,
            };

            asm volatile (
                \\ nop
                \\ nop
                \\ nop
            );
            self.endpoints[1].?.buf_ctrl.available_0 = 1;
            self.endpoints[1].?.next_pid ^= 1;
        }

        fn initTransfer(endp: *Endpoint, data: []const u8, max_len: u16) void {
            // TODO: idk yet how to deal with situations when the host asks for less bytes than we want to send
            if (max_len < data.len) {
                std.log.warn("usb.initTransfer called with too much data (data.len = {d}, max_len = {d})", .{ data.len, max_len });
            }

            if (data.len == 0) {
                endp.buf_ctrl.* = .{
                    .length_0 = 0,
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
                endp.buf_ctrl.available_0 = 1;
                endp.next_pid ^= 1;
            } else {
                var curr_end: usize = 0;

                // TODO: I feel like looping like this isn't ideal. Maybe it
                // would be better to continue the packet at the next poll()?
                // this would need the usb handler to be a kind of state
                // machine (which would kind of make sense since the usb
                // protocol is described that way anyhow)
                while (curr_end < data.len) {
                    const curr_start = curr_end;
                    curr_end = @min(curr_end + 64, data.len);
                    const curr_data = data[curr_start..curr_end];

                    // FIXME: we probably don't want to loop on the available_0, it can easily lead to
                    // infinite looping. Better way would probably be to return an
                    // error and let the caller decide what to do. For now we'll
                    // only do it when we have to split up packets
                    if (data.len > 64) {
                        while (endp.buf_ctrl.available_0 == 1) {}
                    }
                    std.log.debug("Sending {d} bytes", .{curr_data.len});
                    @memcpy(endp.buf[0..curr_data.len], curr_data);

                    endp.buf_ctrl.* = .{
                        .length_0 = @min(@as(u10, @intCast(curr_data.len)), max_len),
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
                    endp.buf_ctrl.available_0 = 1;
                    endp.next_pid ^= 1;
                }
            }
        }

        fn checkErrors() void {
            const sie = rp.peripherals.USB.SIE_STATUS.read();
            if (sie.DATA_SEQ_ERROR() == 1) {
                rp.peripherals.USB.SIE_STATUS.writeOver(rp.USB.SIE_STATUS.DATA_SEQ_ERROR(1));
                std.log.err("USB Data Sequence error", .{});
            }
            if (sie.RX_OVERFLOW() == 1) {
                rp.peripherals.USB.SIE_STATUS.writeOver(rp.USB.SIE_STATUS.RX_OVERFLOW(1));
                std.log.err("USB RX Overflow error", .{});
            }
            if (sie.RX_TIMEOUT() == 1) {
                rp.peripherals.USB.SIE_STATUS.writeOver(rp.USB.SIE_STATUS.RX_TIMEOUT(1));
                std.log.err("USB RX Timeout error", .{});
            }
        }
    };
}
