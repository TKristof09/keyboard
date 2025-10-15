const helpers = @import("helpers.zig");
/// Bytes 0-3 of the SETUP packet from the host.
pub const SETUP_PACKET_LOW = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100000),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn WVALUE(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        pub fn BREQUEST(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 16),
            };
        }
        pub fn BMREQUESTTYPE(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn WVALUE(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BREQUEST(self: Result) u8 {
            const mask = comptime helpers.generateMask(8, 16);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn BMREQUESTTYPE(self: Result) u8 {
            const mask = comptime helpers.generateMask(0, 8);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn WVALUE(v: u16) Value {
        return Value.WVALUE(.{}, v);
    }
    pub fn BREQUEST(v: u8) Value {
        return Value.BREQUEST(.{}, v);
    }
    pub fn BMREQUESTTYPE(v: u8) Value {
        return Value.BMREQUESTTYPE(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Bytes 4-7 of the setup packet from the host.
pub const SETUP_PACKET_HIGH = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100004),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn WLENGTH(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        pub fn WINDEX(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn WLENGTH(self: Result) u16 {
            const mask = comptime helpers.generateMask(16, 32);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn WINDEX(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn WLENGTH(v: u16) Value {
        return Value.WLENGTH(.{}, v);
    }
    pub fn WINDEX(v: u16) Value {
        return Value.WINDEX(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP1_IN_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100008),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP1_OUT_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5010000c),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP2_IN_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100010),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP2_OUT_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100014),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP3_IN_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100018),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP3_OUT_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5010001c),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP4_IN_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100020),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP4_OUT_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100024),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP5_IN_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100028),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP5_OUT_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5010002c),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP6_IN_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100030),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP6_OUT_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100034),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP7_IN_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100038),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP7_OUT_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5010003c),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP8_IN_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100040),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP8_OUT_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100044),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP9_IN_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100048),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP9_OUT_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5010004c),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP10_IN_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100050),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP10_OUT_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100054),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP11_IN_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100058),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP11_OUT_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5010005c),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP12_IN_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100060),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP12_OUT_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100064),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP13_IN_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100068),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP13_OUT_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5010006c),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP14_IN_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100070),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP14_OUT_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100074),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP15_IN_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100078),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const EP15_OUT_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5010007c),
    const ENDPOINT_TYPE_e = enum(u2) {
        Control = 0,
        Isochronous = 1,
        Bulk = 2,
        Interrupt = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// This endpoint is double buffered.
        pub fn DOUBLE_BUFFERED(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Trigger an interrupt each time a buffer is done.
        pub fn INTERRUPT_PER_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn ENDPOINT_TYPE(self: Value, v: ENDPOINT_TYPE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 28),
            };
        }
        /// Trigger an interrupt if a STALL is sent. Intended for debug only.
        pub fn INTERRUPT_ON_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Trigger an interrupt if a NAK is sent. Intended for debug only.
        pub fn INTERRUPT_ON_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
        pub fn BUFFER_ADDRESS(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn DOUBLE_BUFFERED(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn INTERRUPT_PER_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn INTERRUPT_PER_DOUBLE_BUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn ENDPOINT_TYPE(self: Result) ENDPOINT_TYPE_e {
            const mask = comptime helpers.generateMask(26, 28);
            const val: @typeInfo(ENDPOINT_TYPE_e).@"enum".tag_type = @intCast((self.val & mask) >> 26);
            return @enumFromInt(val);
        }
        pub fn INTERRUPT_ON_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn INTERRUPT_ON_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn BUFFER_ADDRESS(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable this endpoint. The device will not reply to any packets for this endpoint if this bit is not set.
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// This endpoint is double buffered.
    pub fn DOUBLE_BUFFERED(v: u1) Value {
        return Value.DOUBLE_BUFFERED(.{}, v);
    }
    /// Trigger an interrupt each time a buffer is done.
    pub fn INTERRUPT_PER_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_BUFF(.{}, v);
    }
    /// Trigger an interrupt each time both buffers are done. Only valid in double buffered mode.
    pub fn INTERRUPT_PER_DOUBLE_BUFF(v: u1) Value {
        return Value.INTERRUPT_PER_DOUBLE_BUFF(.{}, v);
    }
    pub fn ENDPOINT_TYPE(v: ENDPOINT_TYPE_e) Value {
        return Value.ENDPOINT_TYPE(.{}, v);
    }
    /// Trigger an interrupt if a STALL is sent. Intended for debug only.
    pub fn INTERRUPT_ON_STALL(v: u1) Value {
        return Value.INTERRUPT_ON_STALL(.{}, v);
    }
    /// Trigger an interrupt if a NAK is sent. Intended for debug only.
    pub fn INTERRUPT_ON_NAK(v: u1) Value {
        return Value.INTERRUPT_ON_NAK(.{}, v);
    }
    /// 64 byte aligned buffer address for this EP (bits 0-5 are ignored). Relative to the start of the DPRAM.
    pub fn BUFFER_ADDRESS(v: u16) Value {
        return Value.BUFFER_ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP0_IN_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100080),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP0_OUT_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100084),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP1_IN_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100088),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP1_OUT_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5010008c),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP2_IN_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100090),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP2_OUT_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100094),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP3_IN_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50100098),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP3_OUT_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5010009c),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP4_IN_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000a0),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP4_OUT_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000a4),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP5_IN_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000a8),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP5_OUT_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000ac),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP6_IN_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000b0),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP6_OUT_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000b4),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP7_IN_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000b8),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP7_OUT_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000bc),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP8_IN_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000c0),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP8_OUT_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000c4),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP9_IN_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000c8),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP9_OUT_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000cc),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP10_IN_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000d0),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP10_OUT_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000d4),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP11_IN_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000d8),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP11_OUT_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000dc),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP12_IN_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000e0),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP12_OUT_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000e4),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP13_IN_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000e8),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP13_OUT_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000ec),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP14_IN_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000f0),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP14_OUT_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000f4),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP15_IN_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000f8),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
/// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
pub const EP15_OUT_BUFFER_CONTROL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x501000fc),
    const DOUBLE_BUFFER_ISO_OFFSET_e = enum(u2) {
        @"128" = 0,
        @"256" = 1,
        @"512" = 2,
        @"1024" = 3,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Buffer 1 is the last buffer of the transfer.
        pub fn LAST_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// The data pid of buffer 1.
        pub fn PID_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
        /// For a non Isochronous endpoint the offset is always 64 bytes.
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Value, v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 29),
            };
        }
        /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// The length of the data in buffer 1.
        pub fn LENGTH_1(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
        pub fn FULL_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Buffer 0 is the last buffer of the transfer.
        pub fn LAST_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// The data pid of buffer 0.
        pub fn PID_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Reset the buffer selector to buffer 0.
        pub fn RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Reply with a stall (valid for both buffers).
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
        pub fn AVAILABLE_0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// The length of the data in buffer 0.
        pub fn LENGTH_0(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FULL_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn LAST_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn PID_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn DOUBLE_BUFFER_ISO_OFFSET(self: Result) DOUBLE_BUFFER_ISO_OFFSET_e {
            const mask = comptime helpers.generateMask(27, 29);
            const val: @typeInfo(DOUBLE_BUFFER_ISO_OFFSET_e).@"enum".tag_type = @intCast((self.val & mask) >> 27);
            return @enumFromInt(val);
        }
        pub fn AVAILABLE_1(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn LENGTH_1(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn FULL_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn LAST_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn PID_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn AVAILABLE_0(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn LENGTH_0(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Buffer 1 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_1(v: u1) Value {
        return Value.FULL_1(.{}, v);
    }
    /// Buffer 1 is the last buffer of the transfer.
    pub fn LAST_1(v: u1) Value {
        return Value.LAST_1(.{}, v);
    }
    /// The data pid of buffer 1.
    pub fn PID_1(v: u1) Value {
        return Value.PID_1(.{}, v);
    }
    /// The number of bytes buffer 1 is offset from buffer 0 in Isochronous mode. Only valid in double buffered mode for an Isochronous endpoint.
    /// For a non Isochronous endpoint the offset is always 64 bytes.
    pub fn DOUBLE_BUFFER_ISO_OFFSET(v: DOUBLE_BUFFER_ISO_OFFSET_e) Value {
        return Value.DOUBLE_BUFFER_ISO_OFFSET(.{}, v);
    }
    /// Buffer 1 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_1(v: u1) Value {
        return Value.AVAILABLE_1(.{}, v);
    }
    /// The length of the data in buffer 1.
    pub fn LENGTH_1(v: u10) Value {
        return Value.LENGTH_1(.{}, v);
    }
    /// Buffer 0 is full. For an IN transfer (TX to the host) the bit is set to indicate the data is valid. For an OUT transfer (RX from the host) this bit should be left as a 0. The host will set it when it has filled the buffer with data.
    pub fn FULL_0(v: u1) Value {
        return Value.FULL_0(.{}, v);
    }
    /// Buffer 0 is the last buffer of the transfer.
    pub fn LAST_0(v: u1) Value {
        return Value.LAST_0(.{}, v);
    }
    /// The data pid of buffer 0.
    pub fn PID_0(v: u1) Value {
        return Value.PID_0(.{}, v);
    }
    /// Reset the buffer selector to buffer 0.
    pub fn RESET(v: u1) Value {
        return Value.RESET(.{}, v);
    }
    /// Reply with a stall (valid for both buffers).
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Buffer 0 is available. This bit is set to indicate the buffer can be used by the controller. The controller clears the available bit when writing the status back.
    pub fn AVAILABLE_0(v: u1) Value {
        return Value.AVAILABLE_0(.{}, v);
    }
    /// The length of the data in buffer 0.
    pub fn LENGTH_0(v: u10) Value {
        return Value.LENGTH_0(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// DPRAM layout for USB device.
pub const USB_DPRAM_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x50100000),

    /// Bytes 0-3 of the SETUP packet from the host.
    SETUP_PACKET_LOW: SETUP_PACKET_LOW = .{},
    /// Bytes 4-7 of the setup packet from the host.
    SETUP_PACKET_HIGH: SETUP_PACKET_HIGH = .{},
    EP1_IN_CONTROL: EP1_IN_CONTROL = .{},
    EP1_OUT_CONTROL: EP1_OUT_CONTROL = .{},
    EP2_IN_CONTROL: EP2_IN_CONTROL = .{},
    EP2_OUT_CONTROL: EP2_OUT_CONTROL = .{},
    EP3_IN_CONTROL: EP3_IN_CONTROL = .{},
    EP3_OUT_CONTROL: EP3_OUT_CONTROL = .{},
    EP4_IN_CONTROL: EP4_IN_CONTROL = .{},
    EP4_OUT_CONTROL: EP4_OUT_CONTROL = .{},
    EP5_IN_CONTROL: EP5_IN_CONTROL = .{},
    EP5_OUT_CONTROL: EP5_OUT_CONTROL = .{},
    EP6_IN_CONTROL: EP6_IN_CONTROL = .{},
    EP6_OUT_CONTROL: EP6_OUT_CONTROL = .{},
    EP7_IN_CONTROL: EP7_IN_CONTROL = .{},
    EP7_OUT_CONTROL: EP7_OUT_CONTROL = .{},
    EP8_IN_CONTROL: EP8_IN_CONTROL = .{},
    EP8_OUT_CONTROL: EP8_OUT_CONTROL = .{},
    EP9_IN_CONTROL: EP9_IN_CONTROL = .{},
    EP9_OUT_CONTROL: EP9_OUT_CONTROL = .{},
    EP10_IN_CONTROL: EP10_IN_CONTROL = .{},
    EP10_OUT_CONTROL: EP10_OUT_CONTROL = .{},
    EP11_IN_CONTROL: EP11_IN_CONTROL = .{},
    EP11_OUT_CONTROL: EP11_OUT_CONTROL = .{},
    EP12_IN_CONTROL: EP12_IN_CONTROL = .{},
    EP12_OUT_CONTROL: EP12_OUT_CONTROL = .{},
    EP13_IN_CONTROL: EP13_IN_CONTROL = .{},
    EP13_OUT_CONTROL: EP13_OUT_CONTROL = .{},
    EP14_IN_CONTROL: EP14_IN_CONTROL = .{},
    EP14_OUT_CONTROL: EP14_OUT_CONTROL = .{},
    EP15_IN_CONTROL: EP15_IN_CONTROL = .{},
    EP15_OUT_CONTROL: EP15_OUT_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP0_IN_BUFFER_CONTROL: EP0_IN_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP0_OUT_BUFFER_CONTROL: EP0_OUT_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP1_IN_BUFFER_CONTROL: EP1_IN_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP1_OUT_BUFFER_CONTROL: EP1_OUT_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP2_IN_BUFFER_CONTROL: EP2_IN_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP2_OUT_BUFFER_CONTROL: EP2_OUT_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP3_IN_BUFFER_CONTROL: EP3_IN_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP3_OUT_BUFFER_CONTROL: EP3_OUT_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP4_IN_BUFFER_CONTROL: EP4_IN_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP4_OUT_BUFFER_CONTROL: EP4_OUT_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP5_IN_BUFFER_CONTROL: EP5_IN_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP5_OUT_BUFFER_CONTROL: EP5_OUT_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP6_IN_BUFFER_CONTROL: EP6_IN_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP6_OUT_BUFFER_CONTROL: EP6_OUT_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP7_IN_BUFFER_CONTROL: EP7_IN_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP7_OUT_BUFFER_CONTROL: EP7_OUT_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP8_IN_BUFFER_CONTROL: EP8_IN_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP8_OUT_BUFFER_CONTROL: EP8_OUT_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP9_IN_BUFFER_CONTROL: EP9_IN_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP9_OUT_BUFFER_CONTROL: EP9_OUT_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP10_IN_BUFFER_CONTROL: EP10_IN_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP10_OUT_BUFFER_CONTROL: EP10_OUT_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP11_IN_BUFFER_CONTROL: EP11_IN_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP11_OUT_BUFFER_CONTROL: EP11_OUT_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP12_IN_BUFFER_CONTROL: EP12_IN_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP12_OUT_BUFFER_CONTROL: EP12_OUT_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP13_IN_BUFFER_CONTROL: EP13_IN_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP13_OUT_BUFFER_CONTROL: EP13_OUT_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP14_IN_BUFFER_CONTROL: EP14_IN_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP14_OUT_BUFFER_CONTROL: EP14_OUT_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP15_IN_BUFFER_CONTROL: EP15_IN_BUFFER_CONTROL = .{},
    /// Buffer control for both buffers of an endpoint. Fields ending in a _1 are for buffer 1.
    /// Fields ending in a _0 are for buffer 0. Buffer 1 controls are only valid if the endpoint is in double buffered mode.
    EP15_OUT_BUFFER_CONTROL: EP15_OUT_BUFFER_CONTROL = .{},
};
pub const USB_DPRAM = USB_DPRAM_p{};
