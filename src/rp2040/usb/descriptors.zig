const std = @import("std");

pub const Type = enum(u8) {
    device = 1,
    configuration = 2,
    string = 3,
    interface = 4,
    endpoint = 5,
    device_qualifier = 6,
    other_speed_configuration = 7,
    interface_power = 8,

    hid = 0x21,
    report = 0x22,
    physical = 0x23,
};

pub const Direction = enum(u1) {
    out = 0,
    in = 1,
};

pub const Device = extern struct {
    length: u8 = @sizeOf(@This()),
    descriptor_type: Type = .device,
    bcd_usb: u16 align(1), // usb hid spec release??
    device_class: ClassCode,
    device_subclass: u8,
    device_protocol: u8,
    max_packet_size: u8,
    vendor_id: u16 align(1),
    product_id: u16 align(1),
    bcd_device: u16 align(1),
    manufacturer_string_idx: u8,
    product_string_idx: u8,
    serial_number_string_idx: u8,
    num_configurations: u8,

    // https://www.usb.org/defined-class-codes

    pub const ClassCode = enum(u8) {
        unspecified = 0,
        cdc = 0x2,
        hid = 3,
        _,
    };
    comptime {
        std.debug.assert(@sizeOf(@This()) == 18);
        std.debug.assert(@alignOf(@This()) == 1);
    }
};

pub const DeviceQualifier = extern struct {
    length: u8 = @sizeOf(@This()),
    descriptor_type: Type = .device_qualifier,
    bcd_usb: u16, // usb hid spec release??
    device_class: Device.ClassCode,
    device_subclass: u8,
    device_protocol: u8,
    max_packet_size: u8,
    num_configurations: u8,
    reserved: u8 = 0,

    comptime {
        std.debug.assert(@sizeOf(@This()) == 10);
        std.debug.assert(@alignOf(@This()) == 1);
    }
};

pub const Configuration = extern struct {
    length: u8 = @sizeOf(@This()),
    descriptor_type: Type = .configuration,
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
        std.debug.assert(@alignOf(@This()) == 1);
    }
};
pub const Interface = extern struct {
    length: u8 = @sizeOf(@This()),
    descriptor_type: Type = .interface,
    interface_idx: u8,
    alternate_setting: u8,
    num_endpoints: u8,
    interface_class: ClassCode,
    interface_subclass: Subclass,
    interface_protocol: Protocol,
    interface_string_idx: u8,

    pub const ClassCode = enum(u8) {
        hid = 0x3,
        _,
    };

    pub const Subclass = enum(u8) {
        none = 0,
        boot_interface = 1,
        _,
    };

    pub const Protocol = enum(u8) {
        none = 0,
        keyboard = 1,
        mouse = 2,
        _,
    };

    comptime {
        std.debug.assert(@sizeOf(@This()) == 9);
        std.debug.assert(@alignOf(@This()) == 1);
    }
};

pub const Endpoint = extern struct {
    length: u8 = @sizeOf(@This()),
    descriptor_type: Type = .endpoint,
    address: Address,
    attributes: Attributes,
    max_packet_size: u16 align(1),
    /// in milliseconds
    interval: u8,

    const Attributes = packed struct(u8) {
        transfer_type: TransferType,
        synchronisation: Synchronisation = .none,
        usage: Usage = .data,
        reserved: u2 = 0,

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

    pub const TransferType = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Address = packed struct(u8) {
        endpoint: u4,
        _reserved: u3 = 0,
        direction: Direction,
    };
    comptime {
        std.debug.assert(@sizeOf(@This()) == 7);
        std.debug.assert(@alignOf(@This()) == 1);
    }
};

pub const Language = extern struct {
    length: u8,
    descriptor_type: Type = .string,
    string: u16 align(1),

    pub const English: Language = .{ .length = 4, .string = 0x0409 };
};
pub fn makeString(comptime str: []const u8) []const u8 {
    const encoded: []const u8 = @ptrCast(std.unicode.utf8ToUtf16LeStringLiteral(str));
    return &[2]u8{ encoded.len + 2, @intFromEnum(Type.string) } ++ encoded;
}

pub const HID = extern struct {
    length: u8 = @sizeOf(@This()),
    descriptor_type: Type = .hid,
    bcd_hid: u16 align(1) = 0x101,
    country_code: u8,
    num_descriptors: u8,
    report_type: Type = .report,
    report_length: u16 align(1),

    comptime {
        std.debug.assert(@sizeOf(@This()) == 9);
        std.debug.assert(@alignOf(@This()) == 1);
    }
};




};
