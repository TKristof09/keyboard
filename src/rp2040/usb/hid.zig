const std = @import("std");
const packed_int = @import("../../packed_int_array.zig");

const Usage = enum(u8) {
    keyboard = 0x06,
};
const UsagePage = enum(u8) {
    generic_desktop = 0x01,
    keyboard = 0x07,
};
const Input = packed struct(u8) {
    data_const: u1,
    array_variable: u1,
    absolute_relative: u1,
    no_wrap_wrap: u1,
    linear_non_linear: u1,
    preferred_state_no_preferred: u1,
    no_null_null_state: u1,
    reserved: u1 = 0,
    // bit_field_byte_stream: u1,
};

const Output = packed struct(u8) {
    date_const: u1,
    array_variable: u1,
    absolute_relative: u1,
    no_wrap_wrap: u1,
    linear_non_linear: u1,
    preferred_state_no_preferred: u1,
    no_null_null_state: u1,
    non_volatile_volatile: u1 = 0,
    // bit_field_byte_stream: u1,
};
fn Named(comptime T: type) type {
    return struct {
        name: [:0]const u8,
        data: T,
    };
}

const Collection = struct {
    collection_type: Type,
    items: []const Item,
    const Type = enum(u8) {
        physical = 0x00,
        application = 0x01,
        logical = 0x02,
        report = 0x03,
        named_array = 0x04,
        usage_switch = 0x05,
        usage_modifier = 0x06,
    };
};
const Main = union(enum) {
    input: Named(Input),
    output: Named(Output),
    collection: Collection,

    pub fn serialize(comptime self: Main) []const u8 {
        switch (self) {
            .input => |input| {
                const header: u8 = 0b1000_0001;
                const inp: u8 = @bitCast(input.data);
                return &.{ header, inp };
            },
            .output => |output| {
                const header: u8 = 0b1001_0001;
                const out: u8 = @bitCast(output.data);
                return &.{ header, out };
            },
            .collection => |c| {
                const header: u8 = 0b1010_0001;
                const end_header: u8 = 0b1100_0000;
                var items_serialized: []const u8 = "";
                inline for (c.items) |i| {
                    items_serialized = items_serialized ++ i.serialize();
                }
                return &[2]u8{ header, @intFromEnum(c.collection_type) } ++ items_serialized ++ &[1]u8{end_header};
            },
        }
    }
};
const Global = union(enum) {
    usage_page: UsagePage,
    logical_min: u8,
    logical_max: u8,
    report_size: u8,
    report_count: u8,

    pub fn serialize(comptime self: Global) []const u8 {
        switch (self) {
            .usage_page => |usage_page| {
                const header: u8 = 0b0000_0101;
                return &.{ header, @intFromEnum(usage_page) };
            },
            .logical_min => |v| {
                const header: u8 = 0b0001_0101;
                return &.{ header, v };
            },
            .logical_max => |v| {
                const header: u8 = 0b0010_0101;
                return &.{ header, v };
            },
            .report_size => |v| {
                const header: u8 = 0b0111_0101;
                return &.{ header, v };
            },
            .report_count => |v| {
                const header: u8 = 0b1001_0101;
                return &.{ header, v };
            },
        }
    }
};

const Local = union(enum) {
    usage: Usage,
    usage_min: u8,
    usage_max: u8,

    pub fn serialize(comptime self: Local) []const u8 {
        switch (self) {
            .usage => |usage| {
                const header: u8 = 0b0000_1001;
                return &.{ header, @intFromEnum(usage) };
            },
            .usage_min => |v| {
                const header: u8 = 0b0001_1001;
                return &.{ header, v };
            },
            .usage_max => |v| {
                const header: u8 = 0b0010_1001;
                return &.{ header, v };
            },
        }
    }
};
pub const Item = union(enum) {
    main: Main,
    global: Global,
    local: Local,

    pub fn serialize(comptime self: Item) []const u8 {
        switch (self) {
            inline else => |item| {
                return item.serialize();
            },
        }
    }
};

const StructField = std.builtin.Type.StructField;
fn getFields(comptime items: []const Item) []const StructField {
    var fields: []const StructField = &.{};
    var size = 0;
    var count = 0;
    for (items) |item| {
        switch (item) {
            .main => |m| {
                switch (m) {
                    .collection => |c| {
                        fields = fields ++ getFields(c.items);
                    },
                    .input => |input| {
                        const typ = @Type(.{ .array = .{
                            .child = std.meta.Int(.unsigned, size),
                            .len = count,
                            .sentinel_ptr = null,
                        } });
                        const f = StructField{
                            .name = input.name,
                            .type = typ,
                            .alignment = @alignOf(typ),
                            .default_value_ptr = null,
                            .is_comptime = false,
                        };
                        fields = fields ++ &[1]StructField{f};
                    },
                    else => {},
                }
            },
            .global => |g| {
                switch (g) {
                    .report_size => |s| size = s,
                    .report_count => |c| count = c,
                    else => {},
                }
            },
            else => {},
        }
    }
    return fields;
}
pub fn MakeStruct(comptime items: []const Item) type {
    const Data = @Type(.{
        .@"struct" = .{
            .layout = .auto,
            .is_tuple = false,
            .fields = getFields(items),
            .decls = &.{},
        },
    });
    return struct {
        pub const report = blk: {
            var report_desc: []const u8 = "";

            for (items) |item| {
                report_desc = report_desc ++ item.serialize();
            }
            break :blk report_desc;
        };

        // zero out the data arrays by default so the user can default init the struct
        data: Data = std.mem.zeroes(Data),

        pub fn serialize(self: @This(), buf: []u8) usize {
            var curr_offset: usize = 0;
            inline for (std.meta.fields(Data)) |f| {
                const data = @field(self.data, f.name);
                const ChildType = @typeInfo(f.type).array.child;

                // note that in zig []u1 are aligned to bytes so we can't
                // simply memcpy them, we have to pack small uints into bytes
                packed_int.writePackedSlice(ChildType, buf, &data, curr_offset);
                curr_offset += data.len * @bitSizeOf(ChildType);
            }
            std.debug.assert(curr_offset % 8 == 0);
            return curr_offset / 8;
        }
    };
}

pub const boot_keyboard = [_]Item{
    .{ .global = .{ .usage_page = .generic_desktop } }, .{ .local = .{ .usage = .keyboard } },
    .{
        .main = .{
            .collection = .{
                .collection_type = .application,
                .items = &[_]Item{
                    .{ .global = .{ .usage_page = .keyboard } },
                    // modifier bitmask
                    .{ .local = .{ .usage_min = 0xE0 } },
                    .{ .local = .{ .usage_max = 0xE7 } },
                    .{ .global = .{ .logical_min = 0 } },
                    .{ .global = .{ .logical_max = 1 } },
                    .{ .global = .{ .report_size = 1 } },
                    .{ .global = .{ .report_count = 8 } },
                    .{ .main = .{ .input = .{
                        .name = "modifiers",
                        .data = .{
                            .data_const = 0,
                            .array_variable = 1,
                            .absolute_relative = 0,
                            .no_wrap_wrap = 0,
                            .linear_non_linear = 0,
                            .preferred_state_no_preferred = 0,
                            .no_null_null_state = 0,
                        },
                    } } },
                    // reserved byte
                    .{ .global = .{ .report_count = 1 } },
                    .{ .global = .{ .report_size = 8 } },
                    .{ .main = .{ .input = .{
                        .name = "reserved",
                        .data = .{
                            .data_const = 1,
                            .array_variable = 0,
                            .absolute_relative = 0,
                            .no_wrap_wrap = 0,
                            .linear_non_linear = 0,
                            .preferred_state_no_preferred = 0,
                            .no_null_null_state = 0,
                        },
                    } } },
                    // 6kro keypresses
                    .{ .global = .{ .report_count = 6 } },
                    .{ .global = .{ .report_size = 8 } },
                    .{ .global = .{ .logical_min = 0 } },
                    .{ .global = .{ .logical_max = 101 } },
                    .{ .local = .{ .usage_min = 0 } },
                    .{ .local = .{ .usage_max = 101 } },
                    .{ .main = .{ .input = .{
                        .name = "keys",
                        .data = .{
                            .data_const = 0,
                            .array_variable = 0,
                            .absolute_relative = 0,
                            .no_wrap_wrap = 0,
                            .linear_non_linear = 0,
                            .preferred_state_no_preferred = 0,
                            .no_null_null_state = 0,
                        },
                    } } },
                },
            },
        },
    },
};
