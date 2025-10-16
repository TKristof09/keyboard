const helpers = @import("helpers.zig");
/// Device address and endpoint control
pub const ADDR_ENDP = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110000),
    pub const FieldMasks = struct {
        pub const ENDPOINT: u32 = helpers.generateMask(16, 20);
        pub const ADDRESS: u32 = helpers.generateMask(0, 7);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Device endpoint to send data to. Only valid for HOST mode.
        pub fn ENDPOINT(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 20),
            };
        }
        /// In device mode, the address that the device should respond to. Set in response to a SET_ADDR setup packet from the host. In host mode set to the address of the device to communicate with.
        pub fn ADDRESS(self: Value, v: u7) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 7),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENDPOINT(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ADDRESS(self: Result) u7 {
            const mask = comptime helpers.generateMask(0, 7);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Device endpoint to send data to. Only valid for HOST mode.
    pub fn ENDPOINT(v: u4) Value {
        return Value.ENDPOINT(.{}, v);
    }
    /// In device mode, the address that the device should respond to. Set in response to a SET_ADDR setup packet from the host. In host mode set to the address of the device to communicate with.
    pub fn ADDRESS(v: u7) Value {
        return Value.ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt endpoint 1. Only valid for HOST mode.
pub const ADDR_ENDP1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110004),
    pub const FieldMasks = struct {
        pub const INTEP_PREAMBLE: u32 = helpers.generateMask(26, 27);
        pub const INTEP_DIR: u32 = helpers.generateMask(25, 26);
        pub const ENDPOINT: u32 = helpers.generateMask(16, 20);
        pub const ADDRESS: u32 = helpers.generateMask(0, 7);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
        pub fn INTEP_PREAMBLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Direction of the interrupt endpoint. In=0, Out=1
        pub fn INTEP_DIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Endpoint number of the interrupt endpoint
        pub fn ENDPOINT(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 20),
            };
        }
        /// Device address
        pub fn ADDRESS(self: Value, v: u7) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 7),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INTEP_PREAMBLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn INTEP_DIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn ENDPOINT(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ADDRESS(self: Result) u7 {
            const mask = comptime helpers.generateMask(0, 7);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
    pub fn INTEP_PREAMBLE(v: u1) Value {
        return Value.INTEP_PREAMBLE(.{}, v);
    }
    /// Direction of the interrupt endpoint. In=0, Out=1
    pub fn INTEP_DIR(v: u1) Value {
        return Value.INTEP_DIR(.{}, v);
    }
    /// Endpoint number of the interrupt endpoint
    pub fn ENDPOINT(v: u4) Value {
        return Value.ENDPOINT(.{}, v);
    }
    /// Device address
    pub fn ADDRESS(v: u7) Value {
        return Value.ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt endpoint 2. Only valid for HOST mode.
pub const ADDR_ENDP2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110008),
    pub const FieldMasks = struct {
        pub const INTEP_PREAMBLE: u32 = helpers.generateMask(26, 27);
        pub const INTEP_DIR: u32 = helpers.generateMask(25, 26);
        pub const ENDPOINT: u32 = helpers.generateMask(16, 20);
        pub const ADDRESS: u32 = helpers.generateMask(0, 7);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
        pub fn INTEP_PREAMBLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Direction of the interrupt endpoint. In=0, Out=1
        pub fn INTEP_DIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Endpoint number of the interrupt endpoint
        pub fn ENDPOINT(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 20),
            };
        }
        /// Device address
        pub fn ADDRESS(self: Value, v: u7) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 7),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INTEP_PREAMBLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn INTEP_DIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn ENDPOINT(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ADDRESS(self: Result) u7 {
            const mask = comptime helpers.generateMask(0, 7);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
    pub fn INTEP_PREAMBLE(v: u1) Value {
        return Value.INTEP_PREAMBLE(.{}, v);
    }
    /// Direction of the interrupt endpoint. In=0, Out=1
    pub fn INTEP_DIR(v: u1) Value {
        return Value.INTEP_DIR(.{}, v);
    }
    /// Endpoint number of the interrupt endpoint
    pub fn ENDPOINT(v: u4) Value {
        return Value.ENDPOINT(.{}, v);
    }
    /// Device address
    pub fn ADDRESS(v: u7) Value {
        return Value.ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt endpoint 3. Only valid for HOST mode.
pub const ADDR_ENDP3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5011000c),
    pub const FieldMasks = struct {
        pub const INTEP_PREAMBLE: u32 = helpers.generateMask(26, 27);
        pub const INTEP_DIR: u32 = helpers.generateMask(25, 26);
        pub const ENDPOINT: u32 = helpers.generateMask(16, 20);
        pub const ADDRESS: u32 = helpers.generateMask(0, 7);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
        pub fn INTEP_PREAMBLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Direction of the interrupt endpoint. In=0, Out=1
        pub fn INTEP_DIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Endpoint number of the interrupt endpoint
        pub fn ENDPOINT(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 20),
            };
        }
        /// Device address
        pub fn ADDRESS(self: Value, v: u7) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 7),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INTEP_PREAMBLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn INTEP_DIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn ENDPOINT(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ADDRESS(self: Result) u7 {
            const mask = comptime helpers.generateMask(0, 7);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
    pub fn INTEP_PREAMBLE(v: u1) Value {
        return Value.INTEP_PREAMBLE(.{}, v);
    }
    /// Direction of the interrupt endpoint. In=0, Out=1
    pub fn INTEP_DIR(v: u1) Value {
        return Value.INTEP_DIR(.{}, v);
    }
    /// Endpoint number of the interrupt endpoint
    pub fn ENDPOINT(v: u4) Value {
        return Value.ENDPOINT(.{}, v);
    }
    /// Device address
    pub fn ADDRESS(v: u7) Value {
        return Value.ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt endpoint 4. Only valid for HOST mode.
pub const ADDR_ENDP4 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110010),
    pub const FieldMasks = struct {
        pub const INTEP_PREAMBLE: u32 = helpers.generateMask(26, 27);
        pub const INTEP_DIR: u32 = helpers.generateMask(25, 26);
        pub const ENDPOINT: u32 = helpers.generateMask(16, 20);
        pub const ADDRESS: u32 = helpers.generateMask(0, 7);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
        pub fn INTEP_PREAMBLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Direction of the interrupt endpoint. In=0, Out=1
        pub fn INTEP_DIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Endpoint number of the interrupt endpoint
        pub fn ENDPOINT(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 20),
            };
        }
        /// Device address
        pub fn ADDRESS(self: Value, v: u7) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 7),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INTEP_PREAMBLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn INTEP_DIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn ENDPOINT(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ADDRESS(self: Result) u7 {
            const mask = comptime helpers.generateMask(0, 7);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
    pub fn INTEP_PREAMBLE(v: u1) Value {
        return Value.INTEP_PREAMBLE(.{}, v);
    }
    /// Direction of the interrupt endpoint. In=0, Out=1
    pub fn INTEP_DIR(v: u1) Value {
        return Value.INTEP_DIR(.{}, v);
    }
    /// Endpoint number of the interrupt endpoint
    pub fn ENDPOINT(v: u4) Value {
        return Value.ENDPOINT(.{}, v);
    }
    /// Device address
    pub fn ADDRESS(v: u7) Value {
        return Value.ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt endpoint 5. Only valid for HOST mode.
pub const ADDR_ENDP5 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110014),
    pub const FieldMasks = struct {
        pub const INTEP_PREAMBLE: u32 = helpers.generateMask(26, 27);
        pub const INTEP_DIR: u32 = helpers.generateMask(25, 26);
        pub const ENDPOINT: u32 = helpers.generateMask(16, 20);
        pub const ADDRESS: u32 = helpers.generateMask(0, 7);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
        pub fn INTEP_PREAMBLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Direction of the interrupt endpoint. In=0, Out=1
        pub fn INTEP_DIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Endpoint number of the interrupt endpoint
        pub fn ENDPOINT(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 20),
            };
        }
        /// Device address
        pub fn ADDRESS(self: Value, v: u7) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 7),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INTEP_PREAMBLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn INTEP_DIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn ENDPOINT(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ADDRESS(self: Result) u7 {
            const mask = comptime helpers.generateMask(0, 7);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
    pub fn INTEP_PREAMBLE(v: u1) Value {
        return Value.INTEP_PREAMBLE(.{}, v);
    }
    /// Direction of the interrupt endpoint. In=0, Out=1
    pub fn INTEP_DIR(v: u1) Value {
        return Value.INTEP_DIR(.{}, v);
    }
    /// Endpoint number of the interrupt endpoint
    pub fn ENDPOINT(v: u4) Value {
        return Value.ENDPOINT(.{}, v);
    }
    /// Device address
    pub fn ADDRESS(v: u7) Value {
        return Value.ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt endpoint 6. Only valid for HOST mode.
pub const ADDR_ENDP6 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110018),
    pub const FieldMasks = struct {
        pub const INTEP_PREAMBLE: u32 = helpers.generateMask(26, 27);
        pub const INTEP_DIR: u32 = helpers.generateMask(25, 26);
        pub const ENDPOINT: u32 = helpers.generateMask(16, 20);
        pub const ADDRESS: u32 = helpers.generateMask(0, 7);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
        pub fn INTEP_PREAMBLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Direction of the interrupt endpoint. In=0, Out=1
        pub fn INTEP_DIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Endpoint number of the interrupt endpoint
        pub fn ENDPOINT(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 20),
            };
        }
        /// Device address
        pub fn ADDRESS(self: Value, v: u7) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 7),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INTEP_PREAMBLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn INTEP_DIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn ENDPOINT(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ADDRESS(self: Result) u7 {
            const mask = comptime helpers.generateMask(0, 7);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
    pub fn INTEP_PREAMBLE(v: u1) Value {
        return Value.INTEP_PREAMBLE(.{}, v);
    }
    /// Direction of the interrupt endpoint. In=0, Out=1
    pub fn INTEP_DIR(v: u1) Value {
        return Value.INTEP_DIR(.{}, v);
    }
    /// Endpoint number of the interrupt endpoint
    pub fn ENDPOINT(v: u4) Value {
        return Value.ENDPOINT(.{}, v);
    }
    /// Device address
    pub fn ADDRESS(v: u7) Value {
        return Value.ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt endpoint 7. Only valid for HOST mode.
pub const ADDR_ENDP7 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5011001c),
    pub const FieldMasks = struct {
        pub const INTEP_PREAMBLE: u32 = helpers.generateMask(26, 27);
        pub const INTEP_DIR: u32 = helpers.generateMask(25, 26);
        pub const ENDPOINT: u32 = helpers.generateMask(16, 20);
        pub const ADDRESS: u32 = helpers.generateMask(0, 7);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
        pub fn INTEP_PREAMBLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Direction of the interrupt endpoint. In=0, Out=1
        pub fn INTEP_DIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Endpoint number of the interrupt endpoint
        pub fn ENDPOINT(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 20),
            };
        }
        /// Device address
        pub fn ADDRESS(self: Value, v: u7) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 7),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INTEP_PREAMBLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn INTEP_DIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn ENDPOINT(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ADDRESS(self: Result) u7 {
            const mask = comptime helpers.generateMask(0, 7);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
    pub fn INTEP_PREAMBLE(v: u1) Value {
        return Value.INTEP_PREAMBLE(.{}, v);
    }
    /// Direction of the interrupt endpoint. In=0, Out=1
    pub fn INTEP_DIR(v: u1) Value {
        return Value.INTEP_DIR(.{}, v);
    }
    /// Endpoint number of the interrupt endpoint
    pub fn ENDPOINT(v: u4) Value {
        return Value.ENDPOINT(.{}, v);
    }
    /// Device address
    pub fn ADDRESS(v: u7) Value {
        return Value.ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt endpoint 8. Only valid for HOST mode.
pub const ADDR_ENDP8 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110020),
    pub const FieldMasks = struct {
        pub const INTEP_PREAMBLE: u32 = helpers.generateMask(26, 27);
        pub const INTEP_DIR: u32 = helpers.generateMask(25, 26);
        pub const ENDPOINT: u32 = helpers.generateMask(16, 20);
        pub const ADDRESS: u32 = helpers.generateMask(0, 7);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
        pub fn INTEP_PREAMBLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Direction of the interrupt endpoint. In=0, Out=1
        pub fn INTEP_DIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Endpoint number of the interrupt endpoint
        pub fn ENDPOINT(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 20),
            };
        }
        /// Device address
        pub fn ADDRESS(self: Value, v: u7) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 7),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INTEP_PREAMBLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn INTEP_DIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn ENDPOINT(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ADDRESS(self: Result) u7 {
            const mask = comptime helpers.generateMask(0, 7);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
    pub fn INTEP_PREAMBLE(v: u1) Value {
        return Value.INTEP_PREAMBLE(.{}, v);
    }
    /// Direction of the interrupt endpoint. In=0, Out=1
    pub fn INTEP_DIR(v: u1) Value {
        return Value.INTEP_DIR(.{}, v);
    }
    /// Endpoint number of the interrupt endpoint
    pub fn ENDPOINT(v: u4) Value {
        return Value.ENDPOINT(.{}, v);
    }
    /// Device address
    pub fn ADDRESS(v: u7) Value {
        return Value.ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt endpoint 9. Only valid for HOST mode.
pub const ADDR_ENDP9 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110024),
    pub const FieldMasks = struct {
        pub const INTEP_PREAMBLE: u32 = helpers.generateMask(26, 27);
        pub const INTEP_DIR: u32 = helpers.generateMask(25, 26);
        pub const ENDPOINT: u32 = helpers.generateMask(16, 20);
        pub const ADDRESS: u32 = helpers.generateMask(0, 7);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
        pub fn INTEP_PREAMBLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Direction of the interrupt endpoint. In=0, Out=1
        pub fn INTEP_DIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Endpoint number of the interrupt endpoint
        pub fn ENDPOINT(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 20),
            };
        }
        /// Device address
        pub fn ADDRESS(self: Value, v: u7) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 7),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INTEP_PREAMBLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn INTEP_DIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn ENDPOINT(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ADDRESS(self: Result) u7 {
            const mask = comptime helpers.generateMask(0, 7);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
    pub fn INTEP_PREAMBLE(v: u1) Value {
        return Value.INTEP_PREAMBLE(.{}, v);
    }
    /// Direction of the interrupt endpoint. In=0, Out=1
    pub fn INTEP_DIR(v: u1) Value {
        return Value.INTEP_DIR(.{}, v);
    }
    /// Endpoint number of the interrupt endpoint
    pub fn ENDPOINT(v: u4) Value {
        return Value.ENDPOINT(.{}, v);
    }
    /// Device address
    pub fn ADDRESS(v: u7) Value {
        return Value.ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt endpoint 10. Only valid for HOST mode.
pub const ADDR_ENDP10 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110028),
    pub const FieldMasks = struct {
        pub const INTEP_PREAMBLE: u32 = helpers.generateMask(26, 27);
        pub const INTEP_DIR: u32 = helpers.generateMask(25, 26);
        pub const ENDPOINT: u32 = helpers.generateMask(16, 20);
        pub const ADDRESS: u32 = helpers.generateMask(0, 7);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
        pub fn INTEP_PREAMBLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Direction of the interrupt endpoint. In=0, Out=1
        pub fn INTEP_DIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Endpoint number of the interrupt endpoint
        pub fn ENDPOINT(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 20),
            };
        }
        /// Device address
        pub fn ADDRESS(self: Value, v: u7) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 7),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INTEP_PREAMBLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn INTEP_DIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn ENDPOINT(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ADDRESS(self: Result) u7 {
            const mask = comptime helpers.generateMask(0, 7);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
    pub fn INTEP_PREAMBLE(v: u1) Value {
        return Value.INTEP_PREAMBLE(.{}, v);
    }
    /// Direction of the interrupt endpoint. In=0, Out=1
    pub fn INTEP_DIR(v: u1) Value {
        return Value.INTEP_DIR(.{}, v);
    }
    /// Endpoint number of the interrupt endpoint
    pub fn ENDPOINT(v: u4) Value {
        return Value.ENDPOINT(.{}, v);
    }
    /// Device address
    pub fn ADDRESS(v: u7) Value {
        return Value.ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt endpoint 11. Only valid for HOST mode.
pub const ADDR_ENDP11 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5011002c),
    pub const FieldMasks = struct {
        pub const INTEP_PREAMBLE: u32 = helpers.generateMask(26, 27);
        pub const INTEP_DIR: u32 = helpers.generateMask(25, 26);
        pub const ENDPOINT: u32 = helpers.generateMask(16, 20);
        pub const ADDRESS: u32 = helpers.generateMask(0, 7);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
        pub fn INTEP_PREAMBLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Direction of the interrupt endpoint. In=0, Out=1
        pub fn INTEP_DIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Endpoint number of the interrupt endpoint
        pub fn ENDPOINT(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 20),
            };
        }
        /// Device address
        pub fn ADDRESS(self: Value, v: u7) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 7),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INTEP_PREAMBLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn INTEP_DIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn ENDPOINT(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ADDRESS(self: Result) u7 {
            const mask = comptime helpers.generateMask(0, 7);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
    pub fn INTEP_PREAMBLE(v: u1) Value {
        return Value.INTEP_PREAMBLE(.{}, v);
    }
    /// Direction of the interrupt endpoint. In=0, Out=1
    pub fn INTEP_DIR(v: u1) Value {
        return Value.INTEP_DIR(.{}, v);
    }
    /// Endpoint number of the interrupt endpoint
    pub fn ENDPOINT(v: u4) Value {
        return Value.ENDPOINT(.{}, v);
    }
    /// Device address
    pub fn ADDRESS(v: u7) Value {
        return Value.ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt endpoint 12. Only valid for HOST mode.
pub const ADDR_ENDP12 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110030),
    pub const FieldMasks = struct {
        pub const INTEP_PREAMBLE: u32 = helpers.generateMask(26, 27);
        pub const INTEP_DIR: u32 = helpers.generateMask(25, 26);
        pub const ENDPOINT: u32 = helpers.generateMask(16, 20);
        pub const ADDRESS: u32 = helpers.generateMask(0, 7);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
        pub fn INTEP_PREAMBLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Direction of the interrupt endpoint. In=0, Out=1
        pub fn INTEP_DIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Endpoint number of the interrupt endpoint
        pub fn ENDPOINT(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 20),
            };
        }
        /// Device address
        pub fn ADDRESS(self: Value, v: u7) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 7),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INTEP_PREAMBLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn INTEP_DIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn ENDPOINT(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ADDRESS(self: Result) u7 {
            const mask = comptime helpers.generateMask(0, 7);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
    pub fn INTEP_PREAMBLE(v: u1) Value {
        return Value.INTEP_PREAMBLE(.{}, v);
    }
    /// Direction of the interrupt endpoint. In=0, Out=1
    pub fn INTEP_DIR(v: u1) Value {
        return Value.INTEP_DIR(.{}, v);
    }
    /// Endpoint number of the interrupt endpoint
    pub fn ENDPOINT(v: u4) Value {
        return Value.ENDPOINT(.{}, v);
    }
    /// Device address
    pub fn ADDRESS(v: u7) Value {
        return Value.ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt endpoint 13. Only valid for HOST mode.
pub const ADDR_ENDP13 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110034),
    pub const FieldMasks = struct {
        pub const INTEP_PREAMBLE: u32 = helpers.generateMask(26, 27);
        pub const INTEP_DIR: u32 = helpers.generateMask(25, 26);
        pub const ENDPOINT: u32 = helpers.generateMask(16, 20);
        pub const ADDRESS: u32 = helpers.generateMask(0, 7);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
        pub fn INTEP_PREAMBLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Direction of the interrupt endpoint. In=0, Out=1
        pub fn INTEP_DIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Endpoint number of the interrupt endpoint
        pub fn ENDPOINT(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 20),
            };
        }
        /// Device address
        pub fn ADDRESS(self: Value, v: u7) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 7),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INTEP_PREAMBLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn INTEP_DIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn ENDPOINT(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ADDRESS(self: Result) u7 {
            const mask = comptime helpers.generateMask(0, 7);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
    pub fn INTEP_PREAMBLE(v: u1) Value {
        return Value.INTEP_PREAMBLE(.{}, v);
    }
    /// Direction of the interrupt endpoint. In=0, Out=1
    pub fn INTEP_DIR(v: u1) Value {
        return Value.INTEP_DIR(.{}, v);
    }
    /// Endpoint number of the interrupt endpoint
    pub fn ENDPOINT(v: u4) Value {
        return Value.ENDPOINT(.{}, v);
    }
    /// Device address
    pub fn ADDRESS(v: u7) Value {
        return Value.ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt endpoint 14. Only valid for HOST mode.
pub const ADDR_ENDP14 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110038),
    pub const FieldMasks = struct {
        pub const INTEP_PREAMBLE: u32 = helpers.generateMask(26, 27);
        pub const INTEP_DIR: u32 = helpers.generateMask(25, 26);
        pub const ENDPOINT: u32 = helpers.generateMask(16, 20);
        pub const ADDRESS: u32 = helpers.generateMask(0, 7);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
        pub fn INTEP_PREAMBLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Direction of the interrupt endpoint. In=0, Out=1
        pub fn INTEP_DIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Endpoint number of the interrupt endpoint
        pub fn ENDPOINT(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 20),
            };
        }
        /// Device address
        pub fn ADDRESS(self: Value, v: u7) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 7),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INTEP_PREAMBLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn INTEP_DIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn ENDPOINT(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ADDRESS(self: Result) u7 {
            const mask = comptime helpers.generateMask(0, 7);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
    pub fn INTEP_PREAMBLE(v: u1) Value {
        return Value.INTEP_PREAMBLE(.{}, v);
    }
    /// Direction of the interrupt endpoint. In=0, Out=1
    pub fn INTEP_DIR(v: u1) Value {
        return Value.INTEP_DIR(.{}, v);
    }
    /// Endpoint number of the interrupt endpoint
    pub fn ENDPOINT(v: u4) Value {
        return Value.ENDPOINT(.{}, v);
    }
    /// Device address
    pub fn ADDRESS(v: u7) Value {
        return Value.ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt endpoint 15. Only valid for HOST mode.
pub const ADDR_ENDP15 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5011003c),
    pub const FieldMasks = struct {
        pub const INTEP_PREAMBLE: u32 = helpers.generateMask(26, 27);
        pub const INTEP_DIR: u32 = helpers.generateMask(25, 26);
        pub const ENDPOINT: u32 = helpers.generateMask(16, 20);
        pub const ADDRESS: u32 = helpers.generateMask(0, 7);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
        pub fn INTEP_PREAMBLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Direction of the interrupt endpoint. In=0, Out=1
        pub fn INTEP_DIR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Endpoint number of the interrupt endpoint
        pub fn ENDPOINT(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 20),
            };
        }
        /// Device address
        pub fn ADDRESS(self: Value, v: u7) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 7),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn INTEP_PREAMBLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn INTEP_DIR(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn ENDPOINT(self: Result) u4 {
            const mask = comptime helpers.generateMask(16, 20);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ADDRESS(self: Result) u7 {
            const mask = comptime helpers.generateMask(0, 7);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Interrupt EP requires preamble (is a low speed device on a full speed hub)
    pub fn INTEP_PREAMBLE(v: u1) Value {
        return Value.INTEP_PREAMBLE(.{}, v);
    }
    /// Direction of the interrupt endpoint. In=0, Out=1
    pub fn INTEP_DIR(v: u1) Value {
        return Value.INTEP_DIR(.{}, v);
    }
    /// Endpoint number of the interrupt endpoint
    pub fn ENDPOINT(v: u4) Value {
        return Value.ENDPOINT(.{}, v);
    }
    /// Device address
    pub fn ADDRESS(v: u7) Value {
        return Value.ADDRESS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Main control register
pub const MAIN_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110040),
    pub const FieldMasks = struct {
        pub const SIM_TIMING: u32 = helpers.generateMask(31, 32);
        pub const HOST_NDEVICE: u32 = helpers.generateMask(1, 2);
        pub const CONTROLLER_EN: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Reduced timings for simulation
        pub fn SIM_TIMING(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Device mode = 0, Host mode = 1
        pub fn HOST_NDEVICE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Enable controller
        pub fn CONTROLLER_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn SIM_TIMING(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn HOST_NDEVICE(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn CONTROLLER_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Reduced timings for simulation
    pub fn SIM_TIMING(v: u1) Value {
        return Value.SIM_TIMING(.{}, v);
    }
    /// Device mode = 0, Host mode = 1
    pub fn HOST_NDEVICE(v: u1) Value {
        return Value.HOST_NDEVICE(.{}, v);
    }
    /// Enable controller
    pub fn CONTROLLER_EN(v: u1) Value {
        return Value.CONTROLLER_EN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Set the SOF (Start of Frame) frame number in the host controller. The SOF packet is sent every 1ms and the host will increment the frame number by 1 each time.
pub const SOF_WR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110044),
    pub fn write(self: @This(), v: u11) void {
        const mask = comptime helpers.generateMask(0, 11);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 11);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 11);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u11 {
        const mask = comptime helpers.generateMask(0, 11);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Read the last SOF (Start of Frame) frame number seen. In device mode the last SOF received from the host. In host mode the last SOF sent by the host.
pub const SOF_RD = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110048),
    pub fn write(self: @This(), v: u11) void {
        const mask = comptime helpers.generateMask(0, 11);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 11);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 11);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u11 {
        const mask = comptime helpers.generateMask(0, 11);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// SIE control register
pub const SIE_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5011004c),
    pub const FieldMasks = struct {
        pub const EP0_INT_STALL: u32 = helpers.generateMask(31, 32);
        pub const EP0_DOUBLE_BUF: u32 = helpers.generateMask(30, 31);
        pub const EP0_INT_1BUF: u32 = helpers.generateMask(29, 30);
        pub const EP0_INT_2BUF: u32 = helpers.generateMask(28, 29);
        pub const EP0_INT_NAK: u32 = helpers.generateMask(27, 28);
        pub const DIRECT_EN: u32 = helpers.generateMask(26, 27);
        pub const DIRECT_DP: u32 = helpers.generateMask(25, 26);
        pub const DIRECT_DM: u32 = helpers.generateMask(24, 25);
        pub const TRANSCEIVER_PD: u32 = helpers.generateMask(18, 19);
        pub const RPU_OPT: u32 = helpers.generateMask(17, 18);
        pub const PULLUP_EN: u32 = helpers.generateMask(16, 17);
        pub const PULLDOWN_EN: u32 = helpers.generateMask(15, 16);
        pub const RESET_BUS: u32 = helpers.generateMask(13, 14);
        pub const RESUME: u32 = helpers.generateMask(12, 13);
        pub const VBUS_EN: u32 = helpers.generateMask(11, 12);
        pub const KEEP_ALIVE_EN: u32 = helpers.generateMask(10, 11);
        pub const SOF_EN: u32 = helpers.generateMask(9, 10);
        pub const SOF_SYNC: u32 = helpers.generateMask(8, 9);
        pub const PREAMBLE_EN: u32 = helpers.generateMask(6, 7);
        pub const STOP_TRANS: u32 = helpers.generateMask(4, 5);
        pub const RECEIVE_DATA: u32 = helpers.generateMask(3, 4);
        pub const SEND_DATA: u32 = helpers.generateMask(2, 3);
        pub const SEND_SETUP: u32 = helpers.generateMask(1, 2);
        pub const START_TRANS: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Device: Set bit in EP_STATUS_STALL_NAK when EP0 sends a STALL
        pub fn EP0_INT_STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Device: EP0 single buffered = 0, double buffered = 1
        pub fn EP0_DOUBLE_BUF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Device: Set bit in BUFF_STATUS for every buffer completed on EP0
        pub fn EP0_INT_1BUF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Device: Set bit in BUFF_STATUS for every 2 buffers completed on EP0
        pub fn EP0_INT_2BUF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        /// Device: Set bit in EP_STATUS_STALL_NAK when EP0 sends a NAK
        pub fn EP0_INT_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        /// Direct bus drive enable
        pub fn DIRECT_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Direct control of DP
        pub fn DIRECT_DP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Direct control of DM
        pub fn DIRECT_DM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        /// Power down bus transceiver
        pub fn TRANSCEIVER_PD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        /// Device: Pull-up strength (0=1K2, 1=2k3)
        pub fn RPU_OPT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Device: Enable pull up resistor
        pub fn PULLUP_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// Host: Enable pull down resistors
        pub fn PULLDOWN_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Host: Reset bus
        pub fn RESET_BUS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Device: Remote wakeup. Device can initiate its own resume after suspend.
        pub fn RESUME(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Host: Enable VBUS
        pub fn VBUS_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Host: Enable keep alive packet (for low speed bus)
        pub fn KEEP_ALIVE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Host: Enable SOF generation (for full speed bus)
        pub fn SOF_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        /// Host: Delay packet(s) until after SOF
        pub fn SOF_SYNC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        /// Host: Preable enable for LS device on FS hub
        pub fn PREAMBLE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// Host: Stop transaction
        pub fn STOP_TRANS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Host: Receive transaction (IN to host)
        pub fn RECEIVE_DATA(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Host: Send transaction (OUT from host)
        pub fn SEND_DATA(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Host: Send Setup packet
        pub fn SEND_SETUP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Host: Start transaction
        pub fn START_TRANS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn EP0_INT_STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn EP0_DOUBLE_BUF(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn EP0_INT_1BUF(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn EP0_INT_2BUF(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn EP0_INT_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn DIRECT_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn DIRECT_DP(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn DIRECT_DM(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn TRANSCEIVER_PD(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn RPU_OPT(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn PULLUP_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn PULLDOWN_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn VBUS_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn KEEP_ALIVE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn SOF_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn SOF_SYNC(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn PREAMBLE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn RECEIVE_DATA(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn SEND_DATA(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SEND_SETUP(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
    };
    /// Device: Set bit in EP_STATUS_STALL_NAK when EP0 sends a STALL
    pub fn EP0_INT_STALL(v: u1) Value {
        return Value.EP0_INT_STALL(.{}, v);
    }
    /// Device: EP0 single buffered = 0, double buffered = 1
    pub fn EP0_DOUBLE_BUF(v: u1) Value {
        return Value.EP0_DOUBLE_BUF(.{}, v);
    }
    /// Device: Set bit in BUFF_STATUS for every buffer completed on EP0
    pub fn EP0_INT_1BUF(v: u1) Value {
        return Value.EP0_INT_1BUF(.{}, v);
    }
    /// Device: Set bit in BUFF_STATUS for every 2 buffers completed on EP0
    pub fn EP0_INT_2BUF(v: u1) Value {
        return Value.EP0_INT_2BUF(.{}, v);
    }
    /// Device: Set bit in EP_STATUS_STALL_NAK when EP0 sends a NAK
    pub fn EP0_INT_NAK(v: u1) Value {
        return Value.EP0_INT_NAK(.{}, v);
    }
    /// Direct bus drive enable
    pub fn DIRECT_EN(v: u1) Value {
        return Value.DIRECT_EN(.{}, v);
    }
    /// Direct control of DP
    pub fn DIRECT_DP(v: u1) Value {
        return Value.DIRECT_DP(.{}, v);
    }
    /// Direct control of DM
    pub fn DIRECT_DM(v: u1) Value {
        return Value.DIRECT_DM(.{}, v);
    }
    /// Power down bus transceiver
    pub fn TRANSCEIVER_PD(v: u1) Value {
        return Value.TRANSCEIVER_PD(.{}, v);
    }
    /// Device: Pull-up strength (0=1K2, 1=2k3)
    pub fn RPU_OPT(v: u1) Value {
        return Value.RPU_OPT(.{}, v);
    }
    /// Device: Enable pull up resistor
    pub fn PULLUP_EN(v: u1) Value {
        return Value.PULLUP_EN(.{}, v);
    }
    /// Host: Enable pull down resistors
    pub fn PULLDOWN_EN(v: u1) Value {
        return Value.PULLDOWN_EN(.{}, v);
    }
    /// Host: Reset bus
    pub fn RESET_BUS(v: u1) Value {
        return Value.RESET_BUS(.{}, v);
    }
    /// Device: Remote wakeup. Device can initiate its own resume after suspend.
    pub fn RESUME(v: u1) Value {
        return Value.RESUME(.{}, v);
    }
    /// Host: Enable VBUS
    pub fn VBUS_EN(v: u1) Value {
        return Value.VBUS_EN(.{}, v);
    }
    /// Host: Enable keep alive packet (for low speed bus)
    pub fn KEEP_ALIVE_EN(v: u1) Value {
        return Value.KEEP_ALIVE_EN(.{}, v);
    }
    /// Host: Enable SOF generation (for full speed bus)
    pub fn SOF_EN(v: u1) Value {
        return Value.SOF_EN(.{}, v);
    }
    /// Host: Delay packet(s) until after SOF
    pub fn SOF_SYNC(v: u1) Value {
        return Value.SOF_SYNC(.{}, v);
    }
    /// Host: Preable enable for LS device on FS hub
    pub fn PREAMBLE_EN(v: u1) Value {
        return Value.PREAMBLE_EN(.{}, v);
    }
    /// Host: Stop transaction
    pub fn STOP_TRANS(v: u1) Value {
        return Value.STOP_TRANS(.{}, v);
    }
    /// Host: Receive transaction (IN to host)
    pub fn RECEIVE_DATA(v: u1) Value {
        return Value.RECEIVE_DATA(.{}, v);
    }
    /// Host: Send transaction (OUT from host)
    pub fn SEND_DATA(v: u1) Value {
        return Value.SEND_DATA(.{}, v);
    }
    /// Host: Send Setup packet
    pub fn SEND_SETUP(v: u1) Value {
        return Value.SEND_SETUP(.{}, v);
    }
    /// Host: Start transaction
    pub fn START_TRANS(v: u1) Value {
        return Value.START_TRANS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// SIE status register
pub const SIE_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110050),
    pub const FieldMasks = struct {
        pub const DATA_SEQ_ERROR: u32 = helpers.generateMask(31, 32);
        pub const ACK_REC: u32 = helpers.generateMask(30, 31);
        pub const STALL_REC: u32 = helpers.generateMask(29, 30);
        pub const NAK_REC: u32 = helpers.generateMask(28, 29);
        pub const RX_TIMEOUT: u32 = helpers.generateMask(27, 28);
        pub const RX_OVERFLOW: u32 = helpers.generateMask(26, 27);
        pub const BIT_STUFF_ERROR: u32 = helpers.generateMask(25, 26);
        pub const CRC_ERROR: u32 = helpers.generateMask(24, 25);
        pub const BUS_RESET: u32 = helpers.generateMask(19, 20);
        pub const TRANS_COMPLETE: u32 = helpers.generateMask(18, 19);
        pub const SETUP_REC: u32 = helpers.generateMask(17, 18);
        pub const CONNECTED: u32 = helpers.generateMask(16, 17);
        pub const RESUME: u32 = helpers.generateMask(11, 12);
        pub const VBUS_OVER_CURR: u32 = helpers.generateMask(10, 11);
        pub const SPEED: u32 = helpers.generateMask(8, 10);
        pub const SUSPENDED: u32 = helpers.generateMask(4, 5);
        pub const LINE_STATE: u32 = helpers.generateMask(2, 4);
        pub const VBUS_DETECTED: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Data Sequence Error.
        ///
        /// The device can raise a sequence error in the following conditions:
        ///
        /// * A SETUP packet is received followed by a DATA1 packet (data phase should always be DATA0) * An OUT packet is received from the host but doesn&#39;t match the data pid in the buffer control register read from DPSRAM
        ///
        /// The host can raise a data sequence error in the following conditions:
        ///
        /// * An IN packet from the device has the wrong data PID
        pub fn DATA_SEQ_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// ACK received. Raised by both host and device.
        pub fn ACK_REC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Host: STALL received
        pub fn STALL_REC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Host: NAK received
        pub fn NAK_REC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        /// RX timeout is raised by both the host and device if an ACK is not received in the maximum time specified by the USB spec.
        pub fn RX_TIMEOUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        /// RX overflow is raised by the Serial RX engine if the incoming data is too fast.
        pub fn RX_OVERFLOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Bit Stuff Error. Raised by the Serial RX engine.
        pub fn BIT_STUFF_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// CRC Error. Raised by the Serial RX engine.
        pub fn CRC_ERROR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        /// Device: bus reset received
        pub fn BUS_RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        /// Transaction complete.
        ///
        /// Raised by device if:
        ///
        /// * An IN or OUT packet is sent with the `LAST_BUFF` bit set in the buffer control register
        ///
        /// Raised by host if:
        ///
        /// * A setup packet is sent when no data in or data out transaction follows * An IN packet is received and the `LAST_BUFF` bit is set in the buffer control register * An IN packet is received with zero length * An OUT packet is sent and the `LAST_BUFF` bit is set
        pub fn TRANS_COMPLETE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        /// Device: Setup packet received
        pub fn SETUP_REC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Host: Device has initiated a remote resume. Device: host has initiated a resume.
        pub fn RESUME(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn DATA_SEQ_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn ACK_REC(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn STALL_REC(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn NAK_REC(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn RX_TIMEOUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn RX_OVERFLOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn BIT_STUFF_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn CRC_ERROR(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn BUS_RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn TRANS_COMPLETE(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn SETUP_REC(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn CONNECTED(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn RESUME(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn VBUS_OVER_CURR(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn SPEED(self: Result) u2 {
            const mask = comptime helpers.generateMask(8, 10);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SUSPENDED(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn LINE_STATE(self: Result) u2 {
            const mask = comptime helpers.generateMask(2, 4);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn VBUS_DETECTED(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Data Sequence Error.
    ///
    /// The device can raise a sequence error in the following conditions:
    ///
    /// * A SETUP packet is received followed by a DATA1 packet (data phase should always be DATA0) * An OUT packet is received from the host but doesn&#39;t match the data pid in the buffer control register read from DPSRAM
    ///
    /// The host can raise a data sequence error in the following conditions:
    ///
    /// * An IN packet from the device has the wrong data PID
    pub fn DATA_SEQ_ERROR(v: u1) Value {
        return Value.DATA_SEQ_ERROR(.{}, v);
    }
    /// ACK received. Raised by both host and device.
    pub fn ACK_REC(v: u1) Value {
        return Value.ACK_REC(.{}, v);
    }
    /// Host: STALL received
    pub fn STALL_REC(v: u1) Value {
        return Value.STALL_REC(.{}, v);
    }
    /// Host: NAK received
    pub fn NAK_REC(v: u1) Value {
        return Value.NAK_REC(.{}, v);
    }
    /// RX timeout is raised by both the host and device if an ACK is not received in the maximum time specified by the USB spec.
    pub fn RX_TIMEOUT(v: u1) Value {
        return Value.RX_TIMEOUT(.{}, v);
    }
    /// RX overflow is raised by the Serial RX engine if the incoming data is too fast.
    pub fn RX_OVERFLOW(v: u1) Value {
        return Value.RX_OVERFLOW(.{}, v);
    }
    /// Bit Stuff Error. Raised by the Serial RX engine.
    pub fn BIT_STUFF_ERROR(v: u1) Value {
        return Value.BIT_STUFF_ERROR(.{}, v);
    }
    /// CRC Error. Raised by the Serial RX engine.
    pub fn CRC_ERROR(v: u1) Value {
        return Value.CRC_ERROR(.{}, v);
    }
    /// Device: bus reset received
    pub fn BUS_RESET(v: u1) Value {
        return Value.BUS_RESET(.{}, v);
    }
    /// Transaction complete.
    ///
    /// Raised by device if:
    ///
    /// * An IN or OUT packet is sent with the `LAST_BUFF` bit set in the buffer control register
    ///
    /// Raised by host if:
    ///
    /// * A setup packet is sent when no data in or data out transaction follows * An IN packet is received and the `LAST_BUFF` bit is set in the buffer control register * An IN packet is received with zero length * An OUT packet is sent and the `LAST_BUFF` bit is set
    pub fn TRANS_COMPLETE(v: u1) Value {
        return Value.TRANS_COMPLETE(.{}, v);
    }
    /// Device: Setup packet received
    pub fn SETUP_REC(v: u1) Value {
        return Value.SETUP_REC(.{}, v);
    }
    /// Host: Device has initiated a remote resume. Device: host has initiated a resume.
    pub fn RESUME(v: u1) Value {
        return Value.RESUME(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// interrupt endpoint control register
pub const INT_EP_CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110054),
    pub fn write(self: @This(), v: u15) void {
        const mask = comptime helpers.generateMask(1, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 1, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(1, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(1, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u15 {
        const mask = comptime helpers.generateMask(1, 16);
        return @intCast((self.reg.* & mask) >> 1);
    }
};
/// Buffer status register. A bit set here indicates that a buffer has completed on the endpoint (if the buffer interrupt is enabled). It is possible for 2 buffers to be completed, so clearing the buffer status bit may instantly re set it on the next clock cycle.
pub const BUFF_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110058),
    pub const FieldMasks = struct {
        pub const EP15_OUT: u32 = helpers.generateMask(31, 32);
        pub const EP15_IN: u32 = helpers.generateMask(30, 31);
        pub const EP14_OUT: u32 = helpers.generateMask(29, 30);
        pub const EP14_IN: u32 = helpers.generateMask(28, 29);
        pub const EP13_OUT: u32 = helpers.generateMask(27, 28);
        pub const EP13_IN: u32 = helpers.generateMask(26, 27);
        pub const EP12_OUT: u32 = helpers.generateMask(25, 26);
        pub const EP12_IN: u32 = helpers.generateMask(24, 25);
        pub const EP11_OUT: u32 = helpers.generateMask(23, 24);
        pub const EP11_IN: u32 = helpers.generateMask(22, 23);
        pub const EP10_OUT: u32 = helpers.generateMask(21, 22);
        pub const EP10_IN: u32 = helpers.generateMask(20, 21);
        pub const EP9_OUT: u32 = helpers.generateMask(19, 20);
        pub const EP9_IN: u32 = helpers.generateMask(18, 19);
        pub const EP8_OUT: u32 = helpers.generateMask(17, 18);
        pub const EP8_IN: u32 = helpers.generateMask(16, 17);
        pub const EP7_OUT: u32 = helpers.generateMask(15, 16);
        pub const EP7_IN: u32 = helpers.generateMask(14, 15);
        pub const EP6_OUT: u32 = helpers.generateMask(13, 14);
        pub const EP6_IN: u32 = helpers.generateMask(12, 13);
        pub const EP5_OUT: u32 = helpers.generateMask(11, 12);
        pub const EP5_IN: u32 = helpers.generateMask(10, 11);
        pub const EP4_OUT: u32 = helpers.generateMask(9, 10);
        pub const EP4_IN: u32 = helpers.generateMask(8, 9);
        pub const EP3_OUT: u32 = helpers.generateMask(7, 8);
        pub const EP3_IN: u32 = helpers.generateMask(6, 7);
        pub const EP2_OUT: u32 = helpers.generateMask(5, 6);
        pub const EP2_IN: u32 = helpers.generateMask(4, 5);
        pub const EP1_OUT: u32 = helpers.generateMask(3, 4);
        pub const EP1_IN: u32 = helpers.generateMask(2, 3);
        pub const EP0_OUT: u32 = helpers.generateMask(1, 2);
        pub const EP0_IN: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn EP15_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn EP15_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn EP14_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn EP14_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn EP13_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn EP13_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn EP12_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn EP12_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn EP11_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn EP11_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn EP10_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn EP10_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn EP9_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn EP9_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn EP8_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn EP8_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn EP7_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn EP7_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn EP6_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn EP6_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn EP5_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn EP5_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn EP4_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn EP4_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn EP3_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn EP3_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn EP2_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn EP2_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn EP1_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn EP1_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn EP0_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn EP0_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn EP15_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn EP15_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn EP14_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn EP14_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn EP13_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn EP13_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn EP12_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn EP12_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn EP11_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn EP11_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn EP10_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn EP10_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn EP9_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn EP9_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn EP8_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn EP8_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn EP7_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn EP7_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn EP6_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn EP6_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn EP5_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn EP5_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn EP4_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn EP4_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn EP3_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn EP3_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn EP2_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn EP2_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn EP1_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn EP1_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn EP0_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EP0_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn EP15_OUT(v: u1) Value {
        return Value.EP15_OUT(.{}, v);
    }
    pub fn EP15_IN(v: u1) Value {
        return Value.EP15_IN(.{}, v);
    }
    pub fn EP14_OUT(v: u1) Value {
        return Value.EP14_OUT(.{}, v);
    }
    pub fn EP14_IN(v: u1) Value {
        return Value.EP14_IN(.{}, v);
    }
    pub fn EP13_OUT(v: u1) Value {
        return Value.EP13_OUT(.{}, v);
    }
    pub fn EP13_IN(v: u1) Value {
        return Value.EP13_IN(.{}, v);
    }
    pub fn EP12_OUT(v: u1) Value {
        return Value.EP12_OUT(.{}, v);
    }
    pub fn EP12_IN(v: u1) Value {
        return Value.EP12_IN(.{}, v);
    }
    pub fn EP11_OUT(v: u1) Value {
        return Value.EP11_OUT(.{}, v);
    }
    pub fn EP11_IN(v: u1) Value {
        return Value.EP11_IN(.{}, v);
    }
    pub fn EP10_OUT(v: u1) Value {
        return Value.EP10_OUT(.{}, v);
    }
    pub fn EP10_IN(v: u1) Value {
        return Value.EP10_IN(.{}, v);
    }
    pub fn EP9_OUT(v: u1) Value {
        return Value.EP9_OUT(.{}, v);
    }
    pub fn EP9_IN(v: u1) Value {
        return Value.EP9_IN(.{}, v);
    }
    pub fn EP8_OUT(v: u1) Value {
        return Value.EP8_OUT(.{}, v);
    }
    pub fn EP8_IN(v: u1) Value {
        return Value.EP8_IN(.{}, v);
    }
    pub fn EP7_OUT(v: u1) Value {
        return Value.EP7_OUT(.{}, v);
    }
    pub fn EP7_IN(v: u1) Value {
        return Value.EP7_IN(.{}, v);
    }
    pub fn EP6_OUT(v: u1) Value {
        return Value.EP6_OUT(.{}, v);
    }
    pub fn EP6_IN(v: u1) Value {
        return Value.EP6_IN(.{}, v);
    }
    pub fn EP5_OUT(v: u1) Value {
        return Value.EP5_OUT(.{}, v);
    }
    pub fn EP5_IN(v: u1) Value {
        return Value.EP5_IN(.{}, v);
    }
    pub fn EP4_OUT(v: u1) Value {
        return Value.EP4_OUT(.{}, v);
    }
    pub fn EP4_IN(v: u1) Value {
        return Value.EP4_IN(.{}, v);
    }
    pub fn EP3_OUT(v: u1) Value {
        return Value.EP3_OUT(.{}, v);
    }
    pub fn EP3_IN(v: u1) Value {
        return Value.EP3_IN(.{}, v);
    }
    pub fn EP2_OUT(v: u1) Value {
        return Value.EP2_OUT(.{}, v);
    }
    pub fn EP2_IN(v: u1) Value {
        return Value.EP2_IN(.{}, v);
    }
    pub fn EP1_OUT(v: u1) Value {
        return Value.EP1_OUT(.{}, v);
    }
    pub fn EP1_IN(v: u1) Value {
        return Value.EP1_IN(.{}, v);
    }
    pub fn EP0_OUT(v: u1) Value {
        return Value.EP0_OUT(.{}, v);
    }
    pub fn EP0_IN(v: u1) Value {
        return Value.EP0_IN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Which of the double buffers should be handled. Only valid if using an interrupt per buffer (i.e. not per 2 buffers). Not valid for host interrupt endpoint polling because they are only single buffered.
pub const BUFF_CPU_SHOULD_HANDLE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5011005c),
    pub const FieldMasks = struct {
        pub const EP15_OUT: u32 = helpers.generateMask(31, 32);
        pub const EP15_IN: u32 = helpers.generateMask(30, 31);
        pub const EP14_OUT: u32 = helpers.generateMask(29, 30);
        pub const EP14_IN: u32 = helpers.generateMask(28, 29);
        pub const EP13_OUT: u32 = helpers.generateMask(27, 28);
        pub const EP13_IN: u32 = helpers.generateMask(26, 27);
        pub const EP12_OUT: u32 = helpers.generateMask(25, 26);
        pub const EP12_IN: u32 = helpers.generateMask(24, 25);
        pub const EP11_OUT: u32 = helpers.generateMask(23, 24);
        pub const EP11_IN: u32 = helpers.generateMask(22, 23);
        pub const EP10_OUT: u32 = helpers.generateMask(21, 22);
        pub const EP10_IN: u32 = helpers.generateMask(20, 21);
        pub const EP9_OUT: u32 = helpers.generateMask(19, 20);
        pub const EP9_IN: u32 = helpers.generateMask(18, 19);
        pub const EP8_OUT: u32 = helpers.generateMask(17, 18);
        pub const EP8_IN: u32 = helpers.generateMask(16, 17);
        pub const EP7_OUT: u32 = helpers.generateMask(15, 16);
        pub const EP7_IN: u32 = helpers.generateMask(14, 15);
        pub const EP6_OUT: u32 = helpers.generateMask(13, 14);
        pub const EP6_IN: u32 = helpers.generateMask(12, 13);
        pub const EP5_OUT: u32 = helpers.generateMask(11, 12);
        pub const EP5_IN: u32 = helpers.generateMask(10, 11);
        pub const EP4_OUT: u32 = helpers.generateMask(9, 10);
        pub const EP4_IN: u32 = helpers.generateMask(8, 9);
        pub const EP3_OUT: u32 = helpers.generateMask(7, 8);
        pub const EP3_IN: u32 = helpers.generateMask(6, 7);
        pub const EP2_OUT: u32 = helpers.generateMask(5, 6);
        pub const EP2_IN: u32 = helpers.generateMask(4, 5);
        pub const EP1_OUT: u32 = helpers.generateMask(3, 4);
        pub const EP1_IN: u32 = helpers.generateMask(2, 3);
        pub const EP0_OUT: u32 = helpers.generateMask(1, 2);
        pub const EP0_IN: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn EP15_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn EP15_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn EP14_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn EP14_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn EP13_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn EP13_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn EP12_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn EP12_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn EP11_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn EP11_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn EP10_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn EP10_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn EP9_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn EP9_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn EP8_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn EP8_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn EP7_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn EP7_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn EP6_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn EP6_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn EP5_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn EP5_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn EP4_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn EP4_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn EP3_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn EP3_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn EP2_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn EP2_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn EP1_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn EP1_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn EP0_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EP0_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Device only: Can be set to ignore the buffer control register for this endpoint in case you would like to revoke a buffer. A NAK will be sent for every access to the endpoint until this bit is cleared. A corresponding bit in `EP_ABORT_DONE` is set when it is safe to modify the buffer control register.
pub const EP_ABORT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110060),
    pub const FieldMasks = struct {
        pub const EP15_OUT: u32 = helpers.generateMask(31, 32);
        pub const EP15_IN: u32 = helpers.generateMask(30, 31);
        pub const EP14_OUT: u32 = helpers.generateMask(29, 30);
        pub const EP14_IN: u32 = helpers.generateMask(28, 29);
        pub const EP13_OUT: u32 = helpers.generateMask(27, 28);
        pub const EP13_IN: u32 = helpers.generateMask(26, 27);
        pub const EP12_OUT: u32 = helpers.generateMask(25, 26);
        pub const EP12_IN: u32 = helpers.generateMask(24, 25);
        pub const EP11_OUT: u32 = helpers.generateMask(23, 24);
        pub const EP11_IN: u32 = helpers.generateMask(22, 23);
        pub const EP10_OUT: u32 = helpers.generateMask(21, 22);
        pub const EP10_IN: u32 = helpers.generateMask(20, 21);
        pub const EP9_OUT: u32 = helpers.generateMask(19, 20);
        pub const EP9_IN: u32 = helpers.generateMask(18, 19);
        pub const EP8_OUT: u32 = helpers.generateMask(17, 18);
        pub const EP8_IN: u32 = helpers.generateMask(16, 17);
        pub const EP7_OUT: u32 = helpers.generateMask(15, 16);
        pub const EP7_IN: u32 = helpers.generateMask(14, 15);
        pub const EP6_OUT: u32 = helpers.generateMask(13, 14);
        pub const EP6_IN: u32 = helpers.generateMask(12, 13);
        pub const EP5_OUT: u32 = helpers.generateMask(11, 12);
        pub const EP5_IN: u32 = helpers.generateMask(10, 11);
        pub const EP4_OUT: u32 = helpers.generateMask(9, 10);
        pub const EP4_IN: u32 = helpers.generateMask(8, 9);
        pub const EP3_OUT: u32 = helpers.generateMask(7, 8);
        pub const EP3_IN: u32 = helpers.generateMask(6, 7);
        pub const EP2_OUT: u32 = helpers.generateMask(5, 6);
        pub const EP2_IN: u32 = helpers.generateMask(4, 5);
        pub const EP1_OUT: u32 = helpers.generateMask(3, 4);
        pub const EP1_IN: u32 = helpers.generateMask(2, 3);
        pub const EP0_OUT: u32 = helpers.generateMask(1, 2);
        pub const EP0_IN: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn EP15_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn EP15_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn EP14_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn EP14_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn EP13_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn EP13_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn EP12_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn EP12_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn EP11_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn EP11_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn EP10_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn EP10_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn EP9_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn EP9_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn EP8_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn EP8_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn EP7_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn EP7_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn EP6_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn EP6_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn EP5_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn EP5_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn EP4_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn EP4_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn EP3_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn EP3_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn EP2_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn EP2_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn EP1_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn EP1_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn EP0_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn EP0_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn EP15_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn EP15_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn EP14_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn EP14_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn EP13_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn EP13_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn EP12_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn EP12_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn EP11_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn EP11_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn EP10_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn EP10_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn EP9_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn EP9_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn EP8_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn EP8_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn EP7_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn EP7_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn EP6_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn EP6_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn EP5_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn EP5_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn EP4_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn EP4_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn EP3_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn EP3_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn EP2_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn EP2_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn EP1_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn EP1_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn EP0_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EP0_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn EP15_OUT(v: u1) Value {
        return Value.EP15_OUT(.{}, v);
    }
    pub fn EP15_IN(v: u1) Value {
        return Value.EP15_IN(.{}, v);
    }
    pub fn EP14_OUT(v: u1) Value {
        return Value.EP14_OUT(.{}, v);
    }
    pub fn EP14_IN(v: u1) Value {
        return Value.EP14_IN(.{}, v);
    }
    pub fn EP13_OUT(v: u1) Value {
        return Value.EP13_OUT(.{}, v);
    }
    pub fn EP13_IN(v: u1) Value {
        return Value.EP13_IN(.{}, v);
    }
    pub fn EP12_OUT(v: u1) Value {
        return Value.EP12_OUT(.{}, v);
    }
    pub fn EP12_IN(v: u1) Value {
        return Value.EP12_IN(.{}, v);
    }
    pub fn EP11_OUT(v: u1) Value {
        return Value.EP11_OUT(.{}, v);
    }
    pub fn EP11_IN(v: u1) Value {
        return Value.EP11_IN(.{}, v);
    }
    pub fn EP10_OUT(v: u1) Value {
        return Value.EP10_OUT(.{}, v);
    }
    pub fn EP10_IN(v: u1) Value {
        return Value.EP10_IN(.{}, v);
    }
    pub fn EP9_OUT(v: u1) Value {
        return Value.EP9_OUT(.{}, v);
    }
    pub fn EP9_IN(v: u1) Value {
        return Value.EP9_IN(.{}, v);
    }
    pub fn EP8_OUT(v: u1) Value {
        return Value.EP8_OUT(.{}, v);
    }
    pub fn EP8_IN(v: u1) Value {
        return Value.EP8_IN(.{}, v);
    }
    pub fn EP7_OUT(v: u1) Value {
        return Value.EP7_OUT(.{}, v);
    }
    pub fn EP7_IN(v: u1) Value {
        return Value.EP7_IN(.{}, v);
    }
    pub fn EP6_OUT(v: u1) Value {
        return Value.EP6_OUT(.{}, v);
    }
    pub fn EP6_IN(v: u1) Value {
        return Value.EP6_IN(.{}, v);
    }
    pub fn EP5_OUT(v: u1) Value {
        return Value.EP5_OUT(.{}, v);
    }
    pub fn EP5_IN(v: u1) Value {
        return Value.EP5_IN(.{}, v);
    }
    pub fn EP4_OUT(v: u1) Value {
        return Value.EP4_OUT(.{}, v);
    }
    pub fn EP4_IN(v: u1) Value {
        return Value.EP4_IN(.{}, v);
    }
    pub fn EP3_OUT(v: u1) Value {
        return Value.EP3_OUT(.{}, v);
    }
    pub fn EP3_IN(v: u1) Value {
        return Value.EP3_IN(.{}, v);
    }
    pub fn EP2_OUT(v: u1) Value {
        return Value.EP2_OUT(.{}, v);
    }
    pub fn EP2_IN(v: u1) Value {
        return Value.EP2_IN(.{}, v);
    }
    pub fn EP1_OUT(v: u1) Value {
        return Value.EP1_OUT(.{}, v);
    }
    pub fn EP1_IN(v: u1) Value {
        return Value.EP1_IN(.{}, v);
    }
    pub fn EP0_OUT(v: u1) Value {
        return Value.EP0_OUT(.{}, v);
    }
    pub fn EP0_IN(v: u1) Value {
        return Value.EP0_IN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Device only: Used in conjunction with `EP_ABORT`. Set once an endpoint is idle so the programmer knows it is safe to modify the buffer control register.
pub const EP_ABORT_DONE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110064),
    pub const FieldMasks = struct {
        pub const EP15_OUT: u32 = helpers.generateMask(31, 32);
        pub const EP15_IN: u32 = helpers.generateMask(30, 31);
        pub const EP14_OUT: u32 = helpers.generateMask(29, 30);
        pub const EP14_IN: u32 = helpers.generateMask(28, 29);
        pub const EP13_OUT: u32 = helpers.generateMask(27, 28);
        pub const EP13_IN: u32 = helpers.generateMask(26, 27);
        pub const EP12_OUT: u32 = helpers.generateMask(25, 26);
        pub const EP12_IN: u32 = helpers.generateMask(24, 25);
        pub const EP11_OUT: u32 = helpers.generateMask(23, 24);
        pub const EP11_IN: u32 = helpers.generateMask(22, 23);
        pub const EP10_OUT: u32 = helpers.generateMask(21, 22);
        pub const EP10_IN: u32 = helpers.generateMask(20, 21);
        pub const EP9_OUT: u32 = helpers.generateMask(19, 20);
        pub const EP9_IN: u32 = helpers.generateMask(18, 19);
        pub const EP8_OUT: u32 = helpers.generateMask(17, 18);
        pub const EP8_IN: u32 = helpers.generateMask(16, 17);
        pub const EP7_OUT: u32 = helpers.generateMask(15, 16);
        pub const EP7_IN: u32 = helpers.generateMask(14, 15);
        pub const EP6_OUT: u32 = helpers.generateMask(13, 14);
        pub const EP6_IN: u32 = helpers.generateMask(12, 13);
        pub const EP5_OUT: u32 = helpers.generateMask(11, 12);
        pub const EP5_IN: u32 = helpers.generateMask(10, 11);
        pub const EP4_OUT: u32 = helpers.generateMask(9, 10);
        pub const EP4_IN: u32 = helpers.generateMask(8, 9);
        pub const EP3_OUT: u32 = helpers.generateMask(7, 8);
        pub const EP3_IN: u32 = helpers.generateMask(6, 7);
        pub const EP2_OUT: u32 = helpers.generateMask(5, 6);
        pub const EP2_IN: u32 = helpers.generateMask(4, 5);
        pub const EP1_OUT: u32 = helpers.generateMask(3, 4);
        pub const EP1_IN: u32 = helpers.generateMask(2, 3);
        pub const EP0_OUT: u32 = helpers.generateMask(1, 2);
        pub const EP0_IN: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn EP15_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn EP15_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn EP14_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn EP14_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn EP13_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn EP13_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn EP12_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn EP12_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn EP11_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn EP11_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn EP10_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn EP10_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn EP9_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn EP9_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn EP8_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn EP8_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn EP7_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn EP7_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn EP6_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn EP6_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn EP5_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn EP5_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn EP4_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn EP4_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn EP3_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn EP3_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn EP2_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn EP2_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn EP1_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn EP1_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn EP0_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn EP0_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn EP15_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn EP15_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn EP14_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn EP14_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn EP13_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn EP13_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn EP12_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn EP12_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn EP11_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn EP11_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn EP10_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn EP10_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn EP9_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn EP9_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn EP8_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn EP8_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn EP7_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn EP7_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn EP6_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn EP6_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn EP5_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn EP5_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn EP4_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn EP4_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn EP3_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn EP3_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn EP2_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn EP2_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn EP1_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn EP1_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn EP0_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EP0_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn EP15_OUT(v: u1) Value {
        return Value.EP15_OUT(.{}, v);
    }
    pub fn EP15_IN(v: u1) Value {
        return Value.EP15_IN(.{}, v);
    }
    pub fn EP14_OUT(v: u1) Value {
        return Value.EP14_OUT(.{}, v);
    }
    pub fn EP14_IN(v: u1) Value {
        return Value.EP14_IN(.{}, v);
    }
    pub fn EP13_OUT(v: u1) Value {
        return Value.EP13_OUT(.{}, v);
    }
    pub fn EP13_IN(v: u1) Value {
        return Value.EP13_IN(.{}, v);
    }
    pub fn EP12_OUT(v: u1) Value {
        return Value.EP12_OUT(.{}, v);
    }
    pub fn EP12_IN(v: u1) Value {
        return Value.EP12_IN(.{}, v);
    }
    pub fn EP11_OUT(v: u1) Value {
        return Value.EP11_OUT(.{}, v);
    }
    pub fn EP11_IN(v: u1) Value {
        return Value.EP11_IN(.{}, v);
    }
    pub fn EP10_OUT(v: u1) Value {
        return Value.EP10_OUT(.{}, v);
    }
    pub fn EP10_IN(v: u1) Value {
        return Value.EP10_IN(.{}, v);
    }
    pub fn EP9_OUT(v: u1) Value {
        return Value.EP9_OUT(.{}, v);
    }
    pub fn EP9_IN(v: u1) Value {
        return Value.EP9_IN(.{}, v);
    }
    pub fn EP8_OUT(v: u1) Value {
        return Value.EP8_OUT(.{}, v);
    }
    pub fn EP8_IN(v: u1) Value {
        return Value.EP8_IN(.{}, v);
    }
    pub fn EP7_OUT(v: u1) Value {
        return Value.EP7_OUT(.{}, v);
    }
    pub fn EP7_IN(v: u1) Value {
        return Value.EP7_IN(.{}, v);
    }
    pub fn EP6_OUT(v: u1) Value {
        return Value.EP6_OUT(.{}, v);
    }
    pub fn EP6_IN(v: u1) Value {
        return Value.EP6_IN(.{}, v);
    }
    pub fn EP5_OUT(v: u1) Value {
        return Value.EP5_OUT(.{}, v);
    }
    pub fn EP5_IN(v: u1) Value {
        return Value.EP5_IN(.{}, v);
    }
    pub fn EP4_OUT(v: u1) Value {
        return Value.EP4_OUT(.{}, v);
    }
    pub fn EP4_IN(v: u1) Value {
        return Value.EP4_IN(.{}, v);
    }
    pub fn EP3_OUT(v: u1) Value {
        return Value.EP3_OUT(.{}, v);
    }
    pub fn EP3_IN(v: u1) Value {
        return Value.EP3_IN(.{}, v);
    }
    pub fn EP2_OUT(v: u1) Value {
        return Value.EP2_OUT(.{}, v);
    }
    pub fn EP2_IN(v: u1) Value {
        return Value.EP2_IN(.{}, v);
    }
    pub fn EP1_OUT(v: u1) Value {
        return Value.EP1_OUT(.{}, v);
    }
    pub fn EP1_IN(v: u1) Value {
        return Value.EP1_IN(.{}, v);
    }
    pub fn EP0_OUT(v: u1) Value {
        return Value.EP0_OUT(.{}, v);
    }
    pub fn EP0_IN(v: u1) Value {
        return Value.EP0_IN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Device: this bit must be set in conjunction with the `STALL` bit in the buffer control register to send a STALL on EP0. The device controller clears these bits when a SETUP packet is received because the USB spec requires that a STALL condition is cleared when a SETUP packet is received.
pub const EP_STALL_ARM = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110068),
    pub const FieldMasks = struct {
        pub const EP0_OUT: u32 = helpers.generateMask(1, 2);
        pub const EP0_IN: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn EP0_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn EP0_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn EP0_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EP0_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn EP0_OUT(v: u1) Value {
        return Value.EP0_OUT(.{}, v);
    }
    pub fn EP0_IN(v: u1) Value {
        return Value.EP0_IN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Used by the host controller. Sets the wait time in microseconds before trying again if the device replies with a NAK.
pub const NAK_POLL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5011006c),
    pub const FieldMasks = struct {
        pub const DELAY_FS: u32 = helpers.generateMask(16, 26);
        pub const DELAY_LS: u32 = helpers.generateMask(0, 10);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// NAK polling interval for a full speed device
        pub fn DELAY_FS(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 26),
            };
        }
        /// NAK polling interval for a low speed device
        pub fn DELAY_LS(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn DELAY_FS(self: Result) u10 {
            const mask = comptime helpers.generateMask(16, 26);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn DELAY_LS(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// NAK polling interval for a full speed device
    pub fn DELAY_FS(v: u10) Value {
        return Value.DELAY_FS(.{}, v);
    }
    /// NAK polling interval for a low speed device
    pub fn DELAY_LS(v: u10) Value {
        return Value.DELAY_LS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Device: bits are set when the `IRQ_ON_NAK` or `IRQ_ON_STALL` bits are set. For EP0 this comes from `SIE_CTRL`. For all other endpoints it comes from the endpoint control register.
pub const EP_STATUS_STALL_NAK = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110070),
    pub const FieldMasks = struct {
        pub const EP15_OUT: u32 = helpers.generateMask(31, 32);
        pub const EP15_IN: u32 = helpers.generateMask(30, 31);
        pub const EP14_OUT: u32 = helpers.generateMask(29, 30);
        pub const EP14_IN: u32 = helpers.generateMask(28, 29);
        pub const EP13_OUT: u32 = helpers.generateMask(27, 28);
        pub const EP13_IN: u32 = helpers.generateMask(26, 27);
        pub const EP12_OUT: u32 = helpers.generateMask(25, 26);
        pub const EP12_IN: u32 = helpers.generateMask(24, 25);
        pub const EP11_OUT: u32 = helpers.generateMask(23, 24);
        pub const EP11_IN: u32 = helpers.generateMask(22, 23);
        pub const EP10_OUT: u32 = helpers.generateMask(21, 22);
        pub const EP10_IN: u32 = helpers.generateMask(20, 21);
        pub const EP9_OUT: u32 = helpers.generateMask(19, 20);
        pub const EP9_IN: u32 = helpers.generateMask(18, 19);
        pub const EP8_OUT: u32 = helpers.generateMask(17, 18);
        pub const EP8_IN: u32 = helpers.generateMask(16, 17);
        pub const EP7_OUT: u32 = helpers.generateMask(15, 16);
        pub const EP7_IN: u32 = helpers.generateMask(14, 15);
        pub const EP6_OUT: u32 = helpers.generateMask(13, 14);
        pub const EP6_IN: u32 = helpers.generateMask(12, 13);
        pub const EP5_OUT: u32 = helpers.generateMask(11, 12);
        pub const EP5_IN: u32 = helpers.generateMask(10, 11);
        pub const EP4_OUT: u32 = helpers.generateMask(9, 10);
        pub const EP4_IN: u32 = helpers.generateMask(8, 9);
        pub const EP3_OUT: u32 = helpers.generateMask(7, 8);
        pub const EP3_IN: u32 = helpers.generateMask(6, 7);
        pub const EP2_OUT: u32 = helpers.generateMask(5, 6);
        pub const EP2_IN: u32 = helpers.generateMask(4, 5);
        pub const EP1_OUT: u32 = helpers.generateMask(3, 4);
        pub const EP1_IN: u32 = helpers.generateMask(2, 3);
        pub const EP0_OUT: u32 = helpers.generateMask(1, 2);
        pub const EP0_IN: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn EP15_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        pub fn EP15_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        pub fn EP14_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        pub fn EP14_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        pub fn EP13_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 27),
                .mask = self.mask | comptime helpers.generateMask(27, 28),
            };
        }
        pub fn EP13_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        pub fn EP12_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        pub fn EP12_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        pub fn EP11_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 23),
                .mask = self.mask | comptime helpers.generateMask(23, 24),
            };
        }
        pub fn EP11_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 22),
                .mask = self.mask | comptime helpers.generateMask(22, 23),
            };
        }
        pub fn EP10_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 21),
                .mask = self.mask | comptime helpers.generateMask(21, 22),
            };
        }
        pub fn EP10_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 20),
                .mask = self.mask | comptime helpers.generateMask(20, 21),
            };
        }
        pub fn EP9_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        pub fn EP9_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        pub fn EP8_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        pub fn EP8_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn EP7_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn EP7_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn EP6_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn EP6_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn EP5_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn EP5_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn EP4_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn EP4_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn EP3_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn EP3_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn EP2_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn EP2_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn EP1_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn EP1_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn EP0_OUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn EP0_IN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn EP15_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn EP15_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn EP14_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn EP14_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn EP13_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(27, 28);
            return @intCast((self.val & mask) >> 27);
        }
        pub fn EP13_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn EP12_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn EP12_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn EP11_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(23, 24);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn EP11_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn EP10_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn EP10_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn EP9_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn EP9_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn EP8_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn EP8_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn EP7_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn EP7_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn EP6_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn EP6_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn EP5_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn EP5_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn EP4_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn EP4_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn EP3_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn EP3_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn EP2_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn EP2_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn EP1_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn EP1_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn EP0_OUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EP0_IN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn EP15_OUT(v: u1) Value {
        return Value.EP15_OUT(.{}, v);
    }
    pub fn EP15_IN(v: u1) Value {
        return Value.EP15_IN(.{}, v);
    }
    pub fn EP14_OUT(v: u1) Value {
        return Value.EP14_OUT(.{}, v);
    }
    pub fn EP14_IN(v: u1) Value {
        return Value.EP14_IN(.{}, v);
    }
    pub fn EP13_OUT(v: u1) Value {
        return Value.EP13_OUT(.{}, v);
    }
    pub fn EP13_IN(v: u1) Value {
        return Value.EP13_IN(.{}, v);
    }
    pub fn EP12_OUT(v: u1) Value {
        return Value.EP12_OUT(.{}, v);
    }
    pub fn EP12_IN(v: u1) Value {
        return Value.EP12_IN(.{}, v);
    }
    pub fn EP11_OUT(v: u1) Value {
        return Value.EP11_OUT(.{}, v);
    }
    pub fn EP11_IN(v: u1) Value {
        return Value.EP11_IN(.{}, v);
    }
    pub fn EP10_OUT(v: u1) Value {
        return Value.EP10_OUT(.{}, v);
    }
    pub fn EP10_IN(v: u1) Value {
        return Value.EP10_IN(.{}, v);
    }
    pub fn EP9_OUT(v: u1) Value {
        return Value.EP9_OUT(.{}, v);
    }
    pub fn EP9_IN(v: u1) Value {
        return Value.EP9_IN(.{}, v);
    }
    pub fn EP8_OUT(v: u1) Value {
        return Value.EP8_OUT(.{}, v);
    }
    pub fn EP8_IN(v: u1) Value {
        return Value.EP8_IN(.{}, v);
    }
    pub fn EP7_OUT(v: u1) Value {
        return Value.EP7_OUT(.{}, v);
    }
    pub fn EP7_IN(v: u1) Value {
        return Value.EP7_IN(.{}, v);
    }
    pub fn EP6_OUT(v: u1) Value {
        return Value.EP6_OUT(.{}, v);
    }
    pub fn EP6_IN(v: u1) Value {
        return Value.EP6_IN(.{}, v);
    }
    pub fn EP5_OUT(v: u1) Value {
        return Value.EP5_OUT(.{}, v);
    }
    pub fn EP5_IN(v: u1) Value {
        return Value.EP5_IN(.{}, v);
    }
    pub fn EP4_OUT(v: u1) Value {
        return Value.EP4_OUT(.{}, v);
    }
    pub fn EP4_IN(v: u1) Value {
        return Value.EP4_IN(.{}, v);
    }
    pub fn EP3_OUT(v: u1) Value {
        return Value.EP3_OUT(.{}, v);
    }
    pub fn EP3_IN(v: u1) Value {
        return Value.EP3_IN(.{}, v);
    }
    pub fn EP2_OUT(v: u1) Value {
        return Value.EP2_OUT(.{}, v);
    }
    pub fn EP2_IN(v: u1) Value {
        return Value.EP2_IN(.{}, v);
    }
    pub fn EP1_OUT(v: u1) Value {
        return Value.EP1_OUT(.{}, v);
    }
    pub fn EP1_IN(v: u1) Value {
        return Value.EP1_IN(.{}, v);
    }
    pub fn EP0_OUT(v: u1) Value {
        return Value.EP0_OUT(.{}, v);
    }
    pub fn EP0_IN(v: u1) Value {
        return Value.EP0_IN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Where to connect the USB controller. Should be to_phy by default.
pub const USB_MUXING = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110074),
    pub const FieldMasks = struct {
        pub const SOFTCON: u32 = helpers.generateMask(3, 4);
        pub const TO_DIGITAL_PAD: u32 = helpers.generateMask(2, 3);
        pub const TO_EXTPHY: u32 = helpers.generateMask(1, 2);
        pub const TO_PHY: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn SOFTCON(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn TO_DIGITAL_PAD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn TO_EXTPHY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn TO_PHY(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn SOFTCON(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn TO_DIGITAL_PAD(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn TO_EXTPHY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn TO_PHY(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn SOFTCON(v: u1) Value {
        return Value.SOFTCON(.{}, v);
    }
    pub fn TO_DIGITAL_PAD(v: u1) Value {
        return Value.TO_DIGITAL_PAD(.{}, v);
    }
    pub fn TO_EXTPHY(v: u1) Value {
        return Value.TO_EXTPHY(.{}, v);
    }
    pub fn TO_PHY(v: u1) Value {
        return Value.TO_PHY(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Overrides for the power signals in the event that the VBUS signals are not hooked up to GPIO. Set the value of the override and then the override enable so switch over to the override value.
pub const USB_PWR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110078),
    pub const FieldMasks = struct {
        pub const OVERCURR_DETECT_EN: u32 = helpers.generateMask(5, 6);
        pub const OVERCURR_DETECT: u32 = helpers.generateMask(4, 5);
        pub const VBUS_DETECT_OVERRIDE_EN: u32 = helpers.generateMask(3, 4);
        pub const VBUS_DETECT: u32 = helpers.generateMask(2, 3);
        pub const VBUS_EN_OVERRIDE_EN: u32 = helpers.generateMask(1, 2);
        pub const VBUS_EN: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn OVERCURR_DETECT_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn OVERCURR_DETECT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn VBUS_DETECT_OVERRIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn VBUS_DETECT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn VBUS_EN_OVERRIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn VBUS_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn OVERCURR_DETECT_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn OVERCURR_DETECT(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn VBUS_DETECT_OVERRIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn VBUS_DETECT(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn VBUS_EN_OVERRIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn VBUS_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn OVERCURR_DETECT_EN(v: u1) Value {
        return Value.OVERCURR_DETECT_EN(.{}, v);
    }
    pub fn OVERCURR_DETECT(v: u1) Value {
        return Value.OVERCURR_DETECT(.{}, v);
    }
    pub fn VBUS_DETECT_OVERRIDE_EN(v: u1) Value {
        return Value.VBUS_DETECT_OVERRIDE_EN(.{}, v);
    }
    pub fn VBUS_DETECT(v: u1) Value {
        return Value.VBUS_DETECT(.{}, v);
    }
    pub fn VBUS_EN_OVERRIDE_EN(v: u1) Value {
        return Value.VBUS_EN_OVERRIDE_EN(.{}, v);
    }
    pub fn VBUS_EN(v: u1) Value {
        return Value.VBUS_EN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Note that most functions are driven directly from usb_fsls controller.  This register allows more detailed control/status from the USB PHY. Useful for debug but not expected to be used in normal operation
/// Use in conjunction with usbphy_direct_override register
pub const USBPHY_DIRECT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5011007c),
    pub const FieldMasks = struct {
        pub const DM_OVV: u32 = helpers.generateMask(22, 23);
        pub const DP_OVV: u32 = helpers.generateMask(21, 22);
        pub const DM_OVCN: u32 = helpers.generateMask(20, 21);
        pub const DP_OVCN: u32 = helpers.generateMask(19, 20);
        pub const RX_DM: u32 = helpers.generateMask(18, 19);
        pub const RX_DP: u32 = helpers.generateMask(17, 18);
        pub const RX_DD: u32 = helpers.generateMask(16, 17);
        pub const TX_DIFFMODE: u32 = helpers.generateMask(15, 16);
        pub const TX_FSSLEW: u32 = helpers.generateMask(14, 15);
        pub const TX_PD: u32 = helpers.generateMask(13, 14);
        pub const RX_PD: u32 = helpers.generateMask(12, 13);
        pub const TX_DM: u32 = helpers.generateMask(11, 12);
        pub const TX_DP: u32 = helpers.generateMask(10, 11);
        pub const TX_DM_OE: u32 = helpers.generateMask(9, 10);
        pub const TX_DP_OE: u32 = helpers.generateMask(8, 9);
        pub const DM_PULLDN_EN: u32 = helpers.generateMask(6, 7);
        pub const DM_PULLUP_EN: u32 = helpers.generateMask(5, 6);
        pub const DM_PULLUP_HISEL: u32 = helpers.generateMask(4, 5);
        pub const DP_PULLDN_EN: u32 = helpers.generateMask(2, 3);
        pub const DP_PULLUP_EN: u32 = helpers.generateMask(1, 2);
        pub const DP_PULLUP_HISEL: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn TX_DIFFMODE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn TX_FSSLEW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn TX_PD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn RX_PD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Value to drive to USB PHY when override enable is set (which will override the default value or value driven from USB controller
        /// TX_SEMODE=0, Ignored
        /// TX_SEMODE=1, Drives DPM only. TX_DM_OE=1 to enable drive. DPM=TX_DM
        pub fn TX_DM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Value to drive to USB PHY when override enable is set (which will override the default value or value driven from USB controller
        /// TX_SEMODE=0, Drives DPP/DPM diff pair. TX_DP_OE=1 to enable drive. DPP=TX_DP, DPM=~TX_DP
        /// TX_SEMODE=1, Drives DPP only. TX_DP_OE=1 to enable drive. DPP=TX_DP
        pub fn TX_DP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Value to drive to USB PHY when override enable is set (which will override the default value or value driven from USB controller
        /// TX_SEMODE=0, Ignored.
        /// TX_SEMODE=1, OE for DPM only. 0 - DPM in Hi-Z state; 1 - DPM driving
        pub fn TX_DM_OE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        /// Value to drive to USB PHY when override enable is set (which will override the default value or value driven from USB controller
        /// TX_SEMODE=0, OE for DPP/DPM diff pair. 0 - DPP/DPM in Hi-Z state; 1 - DPP/DPM driving
        /// TX_SEMODE=1, OE for DPP only. 0 - DPP in Hi-Z state; 1 - DPP driving
        pub fn TX_DP_OE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        /// Value to drive to USB PHY when override enable is set (which will override the default value or value driven from USB controller
        /// 1 - Enable Rpd on DPM
        pub fn DM_PULLDN_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// Value to drive to USB PHY when override enable is set (which will override the default value or value driven from USB controller
        /// 1 - Enable Rpu on DPM
        pub fn DM_PULLUP_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// when dm_pullup_en is set high, this enables second resistor. 0 - Pull = Rpu2; 1 - Pull = Rpu1 + Rpu2
        pub fn DM_PULLUP_HISEL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Value to drive to USB PHY when override enable is set (which will override the default value or value driven from USB controller
        /// 1 - Enable Rpd on DPP
        pub fn DP_PULLDN_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Value to drive to USB PHY when override enable is set (which will override the default value or value driven from USB controller
        pub fn DP_PULLUP_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// when dp_pullup_en is set high, this enables second resistor. 0 - Pull = Rpu2; 1 - Pull = Rpu1 + Rpu2
        pub fn DP_PULLUP_HISEL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn DM_OVV(self: Result) u1 {
            const mask = comptime helpers.generateMask(22, 23);
            return @intCast((self.val & mask) >> 22);
        }
        pub fn DP_OVV(self: Result) u1 {
            const mask = comptime helpers.generateMask(21, 22);
            return @intCast((self.val & mask) >> 21);
        }
        pub fn DM_OVCN(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn DP_OVCN(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn RX_DM(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn RX_DP(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn RX_DD(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn TX_DIFFMODE(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn TX_FSSLEW(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn TX_PD(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn RX_PD(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn TX_DM(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn TX_DP(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn TX_DM_OE(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn TX_DP_OE(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn DM_PULLDN_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn DM_PULLUP_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn DM_PULLUP_HISEL(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DP_PULLDN_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn DP_PULLUP_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn DP_PULLUP_HISEL(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn TX_DIFFMODE(v: u1) Value {
        return Value.TX_DIFFMODE(.{}, v);
    }
    pub fn TX_FSSLEW(v: u1) Value {
        return Value.TX_FSSLEW(.{}, v);
    }
    pub fn TX_PD(v: u1) Value {
        return Value.TX_PD(.{}, v);
    }
    pub fn RX_PD(v: u1) Value {
        return Value.RX_PD(.{}, v);
    }
    /// Value to drive to USB PHY when override enable is set (which will override the default value or value driven from USB controller
    /// TX_SEMODE=0, Ignored
    /// TX_SEMODE=1, Drives DPM only. TX_DM_OE=1 to enable drive. DPM=TX_DM
    pub fn TX_DM(v: u1) Value {
        return Value.TX_DM(.{}, v);
    }
    /// Value to drive to USB PHY when override enable is set (which will override the default value or value driven from USB controller
    /// TX_SEMODE=0, Drives DPP/DPM diff pair. TX_DP_OE=1 to enable drive. DPP=TX_DP, DPM=~TX_DP
    /// TX_SEMODE=1, Drives DPP only. TX_DP_OE=1 to enable drive. DPP=TX_DP
    pub fn TX_DP(v: u1) Value {
        return Value.TX_DP(.{}, v);
    }
    /// Value to drive to USB PHY when override enable is set (which will override the default value or value driven from USB controller
    /// TX_SEMODE=0, Ignored.
    /// TX_SEMODE=1, OE for DPM only. 0 - DPM in Hi-Z state; 1 - DPM driving
    pub fn TX_DM_OE(v: u1) Value {
        return Value.TX_DM_OE(.{}, v);
    }
    /// Value to drive to USB PHY when override enable is set (which will override the default value or value driven from USB controller
    /// TX_SEMODE=0, OE for DPP/DPM diff pair. 0 - DPP/DPM in Hi-Z state; 1 - DPP/DPM driving
    /// TX_SEMODE=1, OE for DPP only. 0 - DPP in Hi-Z state; 1 - DPP driving
    pub fn TX_DP_OE(v: u1) Value {
        return Value.TX_DP_OE(.{}, v);
    }
    /// Value to drive to USB PHY when override enable is set (which will override the default value or value driven from USB controller
    /// 1 - Enable Rpd on DPM
    pub fn DM_PULLDN_EN(v: u1) Value {
        return Value.DM_PULLDN_EN(.{}, v);
    }
    /// Value to drive to USB PHY when override enable is set (which will override the default value or value driven from USB controller
    /// 1 - Enable Rpu on DPM
    pub fn DM_PULLUP_EN(v: u1) Value {
        return Value.DM_PULLUP_EN(.{}, v);
    }
    /// when dm_pullup_en is set high, this enables second resistor. 0 - Pull = Rpu2; 1 - Pull = Rpu1 + Rpu2
    pub fn DM_PULLUP_HISEL(v: u1) Value {
        return Value.DM_PULLUP_HISEL(.{}, v);
    }
    /// Value to drive to USB PHY when override enable is set (which will override the default value or value driven from USB controller
    /// 1 - Enable Rpd on DPP
    pub fn DP_PULLDN_EN(v: u1) Value {
        return Value.DP_PULLDN_EN(.{}, v);
    }
    /// Value to drive to USB PHY when override enable is set (which will override the default value or value driven from USB controller
    pub fn DP_PULLUP_EN(v: u1) Value {
        return Value.DP_PULLUP_EN(.{}, v);
    }
    /// when dp_pullup_en is set high, this enables second resistor. 0 - Pull = Rpu2; 1 - Pull = Rpu1 + Rpu2
    pub fn DP_PULLUP_HISEL(v: u1) Value {
        return Value.DP_PULLUP_HISEL(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
pub const USBPHY_DIRECT_OVERRIDE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110080),
    pub const FieldMasks = struct {
        pub const TX_DIFFMODE_OVERRIDE_EN: u32 = helpers.generateMask(15, 16);
        pub const DM_PULLUP_OVERRIDE_EN: u32 = helpers.generateMask(12, 13);
        pub const TX_FSSLEW_OVERRIDE_EN: u32 = helpers.generateMask(11, 12);
        pub const TX_PD_OVERRIDE_EN: u32 = helpers.generateMask(10, 11);
        pub const RX_PD_OVERRIDE_EN: u32 = helpers.generateMask(9, 10);
        pub const TX_DM_OVERRIDE_EN: u32 = helpers.generateMask(8, 9);
        pub const TX_DP_OVERRIDE_EN: u32 = helpers.generateMask(7, 8);
        pub const TX_DM_OE_OVERRIDE_EN: u32 = helpers.generateMask(6, 7);
        pub const TX_DP_OE_OVERRIDE_EN: u32 = helpers.generateMask(5, 6);
        pub const DM_PULLDN_EN_OVERRIDE_EN: u32 = helpers.generateMask(4, 5);
        pub const DP_PULLDN_EN_OVERRIDE_EN: u32 = helpers.generateMask(3, 4);
        pub const DP_PULLUP_EN_OVERRIDE_EN: u32 = helpers.generateMask(2, 3);
        pub const DM_PULLUP_HISEL_OVERRIDE_EN: u32 = helpers.generateMask(1, 2);
        pub const DP_PULLUP_HISEL_OVERRIDE_EN: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn TX_DIFFMODE_OVERRIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn DM_PULLUP_OVERRIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn TX_FSSLEW_OVERRIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn TX_PD_OVERRIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn RX_PD_OVERRIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        /// Override default value or value driven from USB Controller to PHY
        pub fn TX_DM_OVERRIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        /// Override default value or value driven from USB Controller to PHY
        pub fn TX_DP_OVERRIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Override default value or value driven from USB Controller to PHY
        pub fn TX_DM_OE_OVERRIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// Override default value or value driven from USB Controller to PHY
        pub fn TX_DP_OE_OVERRIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// Override default value or value driven from USB Controller to PHY
        pub fn DM_PULLDN_EN_OVERRIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Override default value or value driven from USB Controller to PHY
        pub fn DP_PULLDN_EN_OVERRIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Override default value or value driven from USB Controller to PHY
        pub fn DP_PULLUP_EN_OVERRIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn DM_PULLUP_HISEL_OVERRIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn DP_PULLUP_HISEL_OVERRIDE_EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn TX_DIFFMODE_OVERRIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn DM_PULLUP_OVERRIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn TX_FSSLEW_OVERRIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn TX_PD_OVERRIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn RX_PD_OVERRIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn TX_DM_OVERRIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn TX_DP_OVERRIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn TX_DM_OE_OVERRIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn TX_DP_OE_OVERRIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn DM_PULLDN_EN_OVERRIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DP_PULLDN_EN_OVERRIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn DP_PULLUP_EN_OVERRIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn DM_PULLUP_HISEL_OVERRIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn DP_PULLUP_HISEL_OVERRIDE_EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn TX_DIFFMODE_OVERRIDE_EN(v: u1) Value {
        return Value.TX_DIFFMODE_OVERRIDE_EN(.{}, v);
    }
    pub fn DM_PULLUP_OVERRIDE_EN(v: u1) Value {
        return Value.DM_PULLUP_OVERRIDE_EN(.{}, v);
    }
    pub fn TX_FSSLEW_OVERRIDE_EN(v: u1) Value {
        return Value.TX_FSSLEW_OVERRIDE_EN(.{}, v);
    }
    pub fn TX_PD_OVERRIDE_EN(v: u1) Value {
        return Value.TX_PD_OVERRIDE_EN(.{}, v);
    }
    pub fn RX_PD_OVERRIDE_EN(v: u1) Value {
        return Value.RX_PD_OVERRIDE_EN(.{}, v);
    }
    /// Override default value or value driven from USB Controller to PHY
    pub fn TX_DM_OVERRIDE_EN(v: u1) Value {
        return Value.TX_DM_OVERRIDE_EN(.{}, v);
    }
    /// Override default value or value driven from USB Controller to PHY
    pub fn TX_DP_OVERRIDE_EN(v: u1) Value {
        return Value.TX_DP_OVERRIDE_EN(.{}, v);
    }
    /// Override default value or value driven from USB Controller to PHY
    pub fn TX_DM_OE_OVERRIDE_EN(v: u1) Value {
        return Value.TX_DM_OE_OVERRIDE_EN(.{}, v);
    }
    /// Override default value or value driven from USB Controller to PHY
    pub fn TX_DP_OE_OVERRIDE_EN(v: u1) Value {
        return Value.TX_DP_OE_OVERRIDE_EN(.{}, v);
    }
    /// Override default value or value driven from USB Controller to PHY
    pub fn DM_PULLDN_EN_OVERRIDE_EN(v: u1) Value {
        return Value.DM_PULLDN_EN_OVERRIDE_EN(.{}, v);
    }
    /// Override default value or value driven from USB Controller to PHY
    pub fn DP_PULLDN_EN_OVERRIDE_EN(v: u1) Value {
        return Value.DP_PULLDN_EN_OVERRIDE_EN(.{}, v);
    }
    /// Override default value or value driven from USB Controller to PHY
    pub fn DP_PULLUP_EN_OVERRIDE_EN(v: u1) Value {
        return Value.DP_PULLUP_EN_OVERRIDE_EN(.{}, v);
    }
    pub fn DM_PULLUP_HISEL_OVERRIDE_EN(v: u1) Value {
        return Value.DM_PULLUP_HISEL_OVERRIDE_EN(.{}, v);
    }
    pub fn DP_PULLUP_HISEL_OVERRIDE_EN(v: u1) Value {
        return Value.DP_PULLUP_HISEL_OVERRIDE_EN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Note that most functions are driven directly from usb_fsls controller.  This register allows more detailed control/status from the USB PHY. Useful for debug but not expected to be used in normal operation
pub const USBPHY_TRIM = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110084),
    pub const FieldMasks = struct {
        pub const DM_PULLDN_TRIM: u32 = helpers.generateMask(8, 13);
        pub const DP_PULLDN_TRIM: u32 = helpers.generateMask(0, 5);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Value to drive to USB PHY
        /// DM pulldown resistor trim control
        /// Experimental data suggests that the reset value will work, but this register allows adjustment if required
        pub fn DM_PULLDN_TRIM(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 13),
            };
        }
        /// Value to drive to USB PHY
        /// DP pulldown resistor trim control
        /// Experimental data suggests that the reset value will work, but this register allows adjustment if required
        pub fn DP_PULLDN_TRIM(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 5),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn DM_PULLDN_TRIM(self: Result) u5 {
            const mask = comptime helpers.generateMask(8, 13);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn DP_PULLDN_TRIM(self: Result) u5 {
            const mask = comptime helpers.generateMask(0, 5);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Value to drive to USB PHY
    /// DM pulldown resistor trim control
    /// Experimental data suggests that the reset value will work, but this register allows adjustment if required
    pub fn DM_PULLDN_TRIM(v: u5) Value {
        return Value.DM_PULLDN_TRIM(.{}, v);
    }
    /// Value to drive to USB PHY
    /// DP pulldown resistor trim control
    /// Experimental data suggests that the reset value will work, but this register allows adjustment if required
    pub fn DP_PULLDN_TRIM(v: u5) Value {
        return Value.DP_PULLDN_TRIM(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Raw Interrupts
pub const INTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x5011008c),
    pub const FieldMasks = struct {
        pub const EP_STALL_NAK: u32 = helpers.generateMask(19, 20);
        pub const ABORT_DONE: u32 = helpers.generateMask(18, 19);
        pub const DEV_SOF: u32 = helpers.generateMask(17, 18);
        pub const SETUP_REQ: u32 = helpers.generateMask(16, 17);
        pub const DEV_RESUME_FROM_HOST: u32 = helpers.generateMask(15, 16);
        pub const DEV_SUSPEND: u32 = helpers.generateMask(14, 15);
        pub const DEV_CONN_DIS: u32 = helpers.generateMask(13, 14);
        pub const BUS_RESET: u32 = helpers.generateMask(12, 13);
        pub const VBUS_DETECT: u32 = helpers.generateMask(11, 12);
        pub const STALL: u32 = helpers.generateMask(10, 11);
        pub const ERROR_CRC: u32 = helpers.generateMask(9, 10);
        pub const ERROR_BIT_STUFF: u32 = helpers.generateMask(8, 9);
        pub const ERROR_RX_OVERFLOW: u32 = helpers.generateMask(7, 8);
        pub const ERROR_RX_TIMEOUT: u32 = helpers.generateMask(6, 7);
        pub const ERROR_DATA_SEQ: u32 = helpers.generateMask(5, 6);
        pub const BUFF_STATUS: u32 = helpers.generateMask(4, 5);
        pub const TRANS_COMPLETE: u32 = helpers.generateMask(3, 4);
        pub const HOST_SOF: u32 = helpers.generateMask(2, 3);
        pub const HOST_RESUME: u32 = helpers.generateMask(1, 2);
        pub const HOST_CONN_DIS: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn EP_STALL_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn ABORT_DONE(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn DEV_SOF(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn SETUP_REQ(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn DEV_RESUME_FROM_HOST(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn DEV_SUSPEND(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn DEV_CONN_DIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn BUS_RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn VBUS_DETECT(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn ERROR_CRC(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn ERROR_BIT_STUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn ERROR_RX_OVERFLOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn ERROR_RX_TIMEOUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn ERROR_DATA_SEQ(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn BUFF_STATUS(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn TRANS_COMPLETE(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn HOST_SOF(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn HOST_RESUME(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn HOST_CONN_DIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Enable
pub const INTE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110090),
    pub const FieldMasks = struct {
        pub const EP_STALL_NAK: u32 = helpers.generateMask(19, 20);
        pub const ABORT_DONE: u32 = helpers.generateMask(18, 19);
        pub const DEV_SOF: u32 = helpers.generateMask(17, 18);
        pub const SETUP_REQ: u32 = helpers.generateMask(16, 17);
        pub const DEV_RESUME_FROM_HOST: u32 = helpers.generateMask(15, 16);
        pub const DEV_SUSPEND: u32 = helpers.generateMask(14, 15);
        pub const DEV_CONN_DIS: u32 = helpers.generateMask(13, 14);
        pub const BUS_RESET: u32 = helpers.generateMask(12, 13);
        pub const VBUS_DETECT: u32 = helpers.generateMask(11, 12);
        pub const STALL: u32 = helpers.generateMask(10, 11);
        pub const ERROR_CRC: u32 = helpers.generateMask(9, 10);
        pub const ERROR_BIT_STUFF: u32 = helpers.generateMask(8, 9);
        pub const ERROR_RX_OVERFLOW: u32 = helpers.generateMask(7, 8);
        pub const ERROR_RX_TIMEOUT: u32 = helpers.generateMask(6, 7);
        pub const ERROR_DATA_SEQ: u32 = helpers.generateMask(5, 6);
        pub const BUFF_STATUS: u32 = helpers.generateMask(4, 5);
        pub const TRANS_COMPLETE: u32 = helpers.generateMask(3, 4);
        pub const HOST_SOF: u32 = helpers.generateMask(2, 3);
        pub const HOST_RESUME: u32 = helpers.generateMask(1, 2);
        pub const HOST_CONN_DIS: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Raised when any bit in EP_STATUS_STALL_NAK is set. Clear by clearing all bits in EP_STATUS_STALL_NAK.
        pub fn EP_STALL_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        /// Raised when any bit in ABORT_DONE is set. Clear by clearing all bits in ABORT_DONE.
        pub fn ABORT_DONE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        /// Set every time the device receives a SOF (Start of Frame) packet. Cleared by reading SOF_RD
        pub fn DEV_SOF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Device. Source: SIE_STATUS.SETUP_REC
        pub fn SETUP_REQ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// Set when the device receives a resume from the host. Cleared by writing to SIE_STATUS.RESUME_REMOTE
        pub fn DEV_RESUME_FROM_HOST(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Set when the device suspend state changes. Cleared by writing to SIE_STATUS.SUSPENDED
        pub fn DEV_SUSPEND(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// Set when the device connection state changes. Cleared by writing to SIE_STATUS.CONNECTED
        pub fn DEV_CONN_DIS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Source: SIE_STATUS.BUS_RESET
        pub fn BUS_RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Source: SIE_STATUS.VBUS_DETECT
        pub fn VBUS_DETECT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Source: SIE_STATUS.STALL_REC
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Source: SIE_STATUS.CRC_ERROR
        pub fn ERROR_CRC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        /// Source: SIE_STATUS.BIT_STUFF_ERROR
        pub fn ERROR_BIT_STUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        /// Source: SIE_STATUS.RX_OVERFLOW
        pub fn ERROR_RX_OVERFLOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Source: SIE_STATUS.RX_TIMEOUT
        pub fn ERROR_RX_TIMEOUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// Source: SIE_STATUS.DATA_SEQ_ERROR
        pub fn ERROR_DATA_SEQ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// Raised when any bit in BUFF_STATUS is set. Clear by clearing all bits in BUFF_STATUS.
        pub fn BUFF_STATUS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Raised every time SIE_STATUS.TRANS_COMPLETE is set. Clear by writing to this bit.
        pub fn TRANS_COMPLETE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Host: raised every time the host sends a SOF (Start of Frame). Cleared by reading SOF_RD
        pub fn HOST_SOF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Host: raised when a device wakes up the host. Cleared by writing to SIE_STATUS.RESUME_REMOTE
        pub fn HOST_RESUME(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Host: raised when a device is connected or disconnected (i.e. when SIE_STATUS.SPEED changes). Cleared by writing to SIE_STATUS.SPEED
        pub fn HOST_CONN_DIS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn EP_STALL_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn ABORT_DONE(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn DEV_SOF(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn SETUP_REQ(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn DEV_RESUME_FROM_HOST(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn DEV_SUSPEND(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn DEV_CONN_DIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn BUS_RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn VBUS_DETECT(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn ERROR_CRC(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn ERROR_BIT_STUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn ERROR_RX_OVERFLOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn ERROR_RX_TIMEOUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn ERROR_DATA_SEQ(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn BUFF_STATUS(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn TRANS_COMPLETE(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn HOST_SOF(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn HOST_RESUME(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn HOST_CONN_DIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Raised when any bit in EP_STATUS_STALL_NAK is set. Clear by clearing all bits in EP_STATUS_STALL_NAK.
    pub fn EP_STALL_NAK(v: u1) Value {
        return Value.EP_STALL_NAK(.{}, v);
    }
    /// Raised when any bit in ABORT_DONE is set. Clear by clearing all bits in ABORT_DONE.
    pub fn ABORT_DONE(v: u1) Value {
        return Value.ABORT_DONE(.{}, v);
    }
    /// Set every time the device receives a SOF (Start of Frame) packet. Cleared by reading SOF_RD
    pub fn DEV_SOF(v: u1) Value {
        return Value.DEV_SOF(.{}, v);
    }
    /// Device. Source: SIE_STATUS.SETUP_REC
    pub fn SETUP_REQ(v: u1) Value {
        return Value.SETUP_REQ(.{}, v);
    }
    /// Set when the device receives a resume from the host. Cleared by writing to SIE_STATUS.RESUME_REMOTE
    pub fn DEV_RESUME_FROM_HOST(v: u1) Value {
        return Value.DEV_RESUME_FROM_HOST(.{}, v);
    }
    /// Set when the device suspend state changes. Cleared by writing to SIE_STATUS.SUSPENDED
    pub fn DEV_SUSPEND(v: u1) Value {
        return Value.DEV_SUSPEND(.{}, v);
    }
    /// Set when the device connection state changes. Cleared by writing to SIE_STATUS.CONNECTED
    pub fn DEV_CONN_DIS(v: u1) Value {
        return Value.DEV_CONN_DIS(.{}, v);
    }
    /// Source: SIE_STATUS.BUS_RESET
    pub fn BUS_RESET(v: u1) Value {
        return Value.BUS_RESET(.{}, v);
    }
    /// Source: SIE_STATUS.VBUS_DETECT
    pub fn VBUS_DETECT(v: u1) Value {
        return Value.VBUS_DETECT(.{}, v);
    }
    /// Source: SIE_STATUS.STALL_REC
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Source: SIE_STATUS.CRC_ERROR
    pub fn ERROR_CRC(v: u1) Value {
        return Value.ERROR_CRC(.{}, v);
    }
    /// Source: SIE_STATUS.BIT_STUFF_ERROR
    pub fn ERROR_BIT_STUFF(v: u1) Value {
        return Value.ERROR_BIT_STUFF(.{}, v);
    }
    /// Source: SIE_STATUS.RX_OVERFLOW
    pub fn ERROR_RX_OVERFLOW(v: u1) Value {
        return Value.ERROR_RX_OVERFLOW(.{}, v);
    }
    /// Source: SIE_STATUS.RX_TIMEOUT
    pub fn ERROR_RX_TIMEOUT(v: u1) Value {
        return Value.ERROR_RX_TIMEOUT(.{}, v);
    }
    /// Source: SIE_STATUS.DATA_SEQ_ERROR
    pub fn ERROR_DATA_SEQ(v: u1) Value {
        return Value.ERROR_DATA_SEQ(.{}, v);
    }
    /// Raised when any bit in BUFF_STATUS is set. Clear by clearing all bits in BUFF_STATUS.
    pub fn BUFF_STATUS(v: u1) Value {
        return Value.BUFF_STATUS(.{}, v);
    }
    /// Raised every time SIE_STATUS.TRANS_COMPLETE is set. Clear by writing to this bit.
    pub fn TRANS_COMPLETE(v: u1) Value {
        return Value.TRANS_COMPLETE(.{}, v);
    }
    /// Host: raised every time the host sends a SOF (Start of Frame). Cleared by reading SOF_RD
    pub fn HOST_SOF(v: u1) Value {
        return Value.HOST_SOF(.{}, v);
    }
    /// Host: raised when a device wakes up the host. Cleared by writing to SIE_STATUS.RESUME_REMOTE
    pub fn HOST_RESUME(v: u1) Value {
        return Value.HOST_RESUME(.{}, v);
    }
    /// Host: raised when a device is connected or disconnected (i.e. when SIE_STATUS.SPEED changes). Cleared by writing to SIE_STATUS.SPEED
    pub fn HOST_CONN_DIS(v: u1) Value {
        return Value.HOST_CONN_DIS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt Force
pub const INTF = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110094),
    pub const FieldMasks = struct {
        pub const EP_STALL_NAK: u32 = helpers.generateMask(19, 20);
        pub const ABORT_DONE: u32 = helpers.generateMask(18, 19);
        pub const DEV_SOF: u32 = helpers.generateMask(17, 18);
        pub const SETUP_REQ: u32 = helpers.generateMask(16, 17);
        pub const DEV_RESUME_FROM_HOST: u32 = helpers.generateMask(15, 16);
        pub const DEV_SUSPEND: u32 = helpers.generateMask(14, 15);
        pub const DEV_CONN_DIS: u32 = helpers.generateMask(13, 14);
        pub const BUS_RESET: u32 = helpers.generateMask(12, 13);
        pub const VBUS_DETECT: u32 = helpers.generateMask(11, 12);
        pub const STALL: u32 = helpers.generateMask(10, 11);
        pub const ERROR_CRC: u32 = helpers.generateMask(9, 10);
        pub const ERROR_BIT_STUFF: u32 = helpers.generateMask(8, 9);
        pub const ERROR_RX_OVERFLOW: u32 = helpers.generateMask(7, 8);
        pub const ERROR_RX_TIMEOUT: u32 = helpers.generateMask(6, 7);
        pub const ERROR_DATA_SEQ: u32 = helpers.generateMask(5, 6);
        pub const BUFF_STATUS: u32 = helpers.generateMask(4, 5);
        pub const TRANS_COMPLETE: u32 = helpers.generateMask(3, 4);
        pub const HOST_SOF: u32 = helpers.generateMask(2, 3);
        pub const HOST_RESUME: u32 = helpers.generateMask(1, 2);
        pub const HOST_CONN_DIS: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Raised when any bit in EP_STATUS_STALL_NAK is set. Clear by clearing all bits in EP_STATUS_STALL_NAK.
        pub fn EP_STALL_NAK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 19),
                .mask = self.mask | comptime helpers.generateMask(19, 20),
            };
        }
        /// Raised when any bit in ABORT_DONE is set. Clear by clearing all bits in ABORT_DONE.
        pub fn ABORT_DONE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 18),
                .mask = self.mask | comptime helpers.generateMask(18, 19),
            };
        }
        /// Set every time the device receives a SOF (Start of Frame) packet. Cleared by reading SOF_RD
        pub fn DEV_SOF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 17),
                .mask = self.mask | comptime helpers.generateMask(17, 18),
            };
        }
        /// Device. Source: SIE_STATUS.SETUP_REC
        pub fn SETUP_REQ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        /// Set when the device receives a resume from the host. Cleared by writing to SIE_STATUS.RESUME_REMOTE
        pub fn DEV_RESUME_FROM_HOST(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        /// Set when the device suspend state changes. Cleared by writing to SIE_STATUS.SUSPENDED
        pub fn DEV_SUSPEND(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        /// Set when the device connection state changes. Cleared by writing to SIE_STATUS.CONNECTED
        pub fn DEV_CONN_DIS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        /// Source: SIE_STATUS.BUS_RESET
        pub fn BUS_RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// Source: SIE_STATUS.VBUS_DETECT
        pub fn VBUS_DETECT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// Source: SIE_STATUS.STALL_REC
        pub fn STALL(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// Source: SIE_STATUS.CRC_ERROR
        pub fn ERROR_CRC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        /// Source: SIE_STATUS.BIT_STUFF_ERROR
        pub fn ERROR_BIT_STUFF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        /// Source: SIE_STATUS.RX_OVERFLOW
        pub fn ERROR_RX_OVERFLOW(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Source: SIE_STATUS.RX_TIMEOUT
        pub fn ERROR_RX_TIMEOUT(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// Source: SIE_STATUS.DATA_SEQ_ERROR
        pub fn ERROR_DATA_SEQ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// Raised when any bit in BUFF_STATUS is set. Clear by clearing all bits in BUFF_STATUS.
        pub fn BUFF_STATUS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Raised every time SIE_STATUS.TRANS_COMPLETE is set. Clear by writing to this bit.
        pub fn TRANS_COMPLETE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Host: raised every time the host sends a SOF (Start of Frame). Cleared by reading SOF_RD
        pub fn HOST_SOF(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Host: raised when a device wakes up the host. Cleared by writing to SIE_STATUS.RESUME_REMOTE
        pub fn HOST_RESUME(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Host: raised when a device is connected or disconnected (i.e. when SIE_STATUS.SPEED changes). Cleared by writing to SIE_STATUS.SPEED
        pub fn HOST_CONN_DIS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn EP_STALL_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn ABORT_DONE(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn DEV_SOF(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn SETUP_REQ(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn DEV_RESUME_FROM_HOST(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn DEV_SUSPEND(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn DEV_CONN_DIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn BUS_RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn VBUS_DETECT(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn ERROR_CRC(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn ERROR_BIT_STUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn ERROR_RX_OVERFLOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn ERROR_RX_TIMEOUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn ERROR_DATA_SEQ(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn BUFF_STATUS(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn TRANS_COMPLETE(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn HOST_SOF(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn HOST_RESUME(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn HOST_CONN_DIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Raised when any bit in EP_STATUS_STALL_NAK is set. Clear by clearing all bits in EP_STATUS_STALL_NAK.
    pub fn EP_STALL_NAK(v: u1) Value {
        return Value.EP_STALL_NAK(.{}, v);
    }
    /// Raised when any bit in ABORT_DONE is set. Clear by clearing all bits in ABORT_DONE.
    pub fn ABORT_DONE(v: u1) Value {
        return Value.ABORT_DONE(.{}, v);
    }
    /// Set every time the device receives a SOF (Start of Frame) packet. Cleared by reading SOF_RD
    pub fn DEV_SOF(v: u1) Value {
        return Value.DEV_SOF(.{}, v);
    }
    /// Device. Source: SIE_STATUS.SETUP_REC
    pub fn SETUP_REQ(v: u1) Value {
        return Value.SETUP_REQ(.{}, v);
    }
    /// Set when the device receives a resume from the host. Cleared by writing to SIE_STATUS.RESUME_REMOTE
    pub fn DEV_RESUME_FROM_HOST(v: u1) Value {
        return Value.DEV_RESUME_FROM_HOST(.{}, v);
    }
    /// Set when the device suspend state changes. Cleared by writing to SIE_STATUS.SUSPENDED
    pub fn DEV_SUSPEND(v: u1) Value {
        return Value.DEV_SUSPEND(.{}, v);
    }
    /// Set when the device connection state changes. Cleared by writing to SIE_STATUS.CONNECTED
    pub fn DEV_CONN_DIS(v: u1) Value {
        return Value.DEV_CONN_DIS(.{}, v);
    }
    /// Source: SIE_STATUS.BUS_RESET
    pub fn BUS_RESET(v: u1) Value {
        return Value.BUS_RESET(.{}, v);
    }
    /// Source: SIE_STATUS.VBUS_DETECT
    pub fn VBUS_DETECT(v: u1) Value {
        return Value.VBUS_DETECT(.{}, v);
    }
    /// Source: SIE_STATUS.STALL_REC
    pub fn STALL(v: u1) Value {
        return Value.STALL(.{}, v);
    }
    /// Source: SIE_STATUS.CRC_ERROR
    pub fn ERROR_CRC(v: u1) Value {
        return Value.ERROR_CRC(.{}, v);
    }
    /// Source: SIE_STATUS.BIT_STUFF_ERROR
    pub fn ERROR_BIT_STUFF(v: u1) Value {
        return Value.ERROR_BIT_STUFF(.{}, v);
    }
    /// Source: SIE_STATUS.RX_OVERFLOW
    pub fn ERROR_RX_OVERFLOW(v: u1) Value {
        return Value.ERROR_RX_OVERFLOW(.{}, v);
    }
    /// Source: SIE_STATUS.RX_TIMEOUT
    pub fn ERROR_RX_TIMEOUT(v: u1) Value {
        return Value.ERROR_RX_TIMEOUT(.{}, v);
    }
    /// Source: SIE_STATUS.DATA_SEQ_ERROR
    pub fn ERROR_DATA_SEQ(v: u1) Value {
        return Value.ERROR_DATA_SEQ(.{}, v);
    }
    /// Raised when any bit in BUFF_STATUS is set. Clear by clearing all bits in BUFF_STATUS.
    pub fn BUFF_STATUS(v: u1) Value {
        return Value.BUFF_STATUS(.{}, v);
    }
    /// Raised every time SIE_STATUS.TRANS_COMPLETE is set. Clear by writing to this bit.
    pub fn TRANS_COMPLETE(v: u1) Value {
        return Value.TRANS_COMPLETE(.{}, v);
    }
    /// Host: raised every time the host sends a SOF (Start of Frame). Cleared by reading SOF_RD
    pub fn HOST_SOF(v: u1) Value {
        return Value.HOST_SOF(.{}, v);
    }
    /// Host: raised when a device wakes up the host. Cleared by writing to SIE_STATUS.RESUME_REMOTE
    pub fn HOST_RESUME(v: u1) Value {
        return Value.HOST_RESUME(.{}, v);
    }
    /// Host: raised when a device is connected or disconnected (i.e. when SIE_STATUS.SPEED changes). Cleared by writing to SIE_STATUS.SPEED
    pub fn HOST_CONN_DIS(v: u1) Value {
        return Value.HOST_CONN_DIS(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Interrupt status after masking &amp; forcing
pub const INTS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x50110098),
    pub const FieldMasks = struct {
        pub const EP_STALL_NAK: u32 = helpers.generateMask(19, 20);
        pub const ABORT_DONE: u32 = helpers.generateMask(18, 19);
        pub const DEV_SOF: u32 = helpers.generateMask(17, 18);
        pub const SETUP_REQ: u32 = helpers.generateMask(16, 17);
        pub const DEV_RESUME_FROM_HOST: u32 = helpers.generateMask(15, 16);
        pub const DEV_SUSPEND: u32 = helpers.generateMask(14, 15);
        pub const DEV_CONN_DIS: u32 = helpers.generateMask(13, 14);
        pub const BUS_RESET: u32 = helpers.generateMask(12, 13);
        pub const VBUS_DETECT: u32 = helpers.generateMask(11, 12);
        pub const STALL: u32 = helpers.generateMask(10, 11);
        pub const ERROR_CRC: u32 = helpers.generateMask(9, 10);
        pub const ERROR_BIT_STUFF: u32 = helpers.generateMask(8, 9);
        pub const ERROR_RX_OVERFLOW: u32 = helpers.generateMask(7, 8);
        pub const ERROR_RX_TIMEOUT: u32 = helpers.generateMask(6, 7);
        pub const ERROR_DATA_SEQ: u32 = helpers.generateMask(5, 6);
        pub const BUFF_STATUS: u32 = helpers.generateMask(4, 5);
        pub const TRANS_COMPLETE: u32 = helpers.generateMask(3, 4);
        pub const HOST_SOF: u32 = helpers.generateMask(2, 3);
        pub const HOST_RESUME: u32 = helpers.generateMask(1, 2);
        pub const HOST_CONN_DIS: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn EP_STALL_NAK(self: Result) u1 {
            const mask = comptime helpers.generateMask(19, 20);
            return @intCast((self.val & mask) >> 19);
        }
        pub fn ABORT_DONE(self: Result) u1 {
            const mask = comptime helpers.generateMask(18, 19);
            return @intCast((self.val & mask) >> 18);
        }
        pub fn DEV_SOF(self: Result) u1 {
            const mask = comptime helpers.generateMask(17, 18);
            return @intCast((self.val & mask) >> 17);
        }
        pub fn SETUP_REQ(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn DEV_RESUME_FROM_HOST(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn DEV_SUSPEND(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn DEV_CONN_DIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn BUS_RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn VBUS_DETECT(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn STALL(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn ERROR_CRC(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn ERROR_BIT_STUFF(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn ERROR_RX_OVERFLOW(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn ERROR_RX_TIMEOUT(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn ERROR_DATA_SEQ(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn BUFF_STATUS(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn TRANS_COMPLETE(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn HOST_SOF(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn HOST_RESUME(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn HOST_CONN_DIS(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn clear(self: @This(), mask: u32) void {
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This(), mask: u32) void {
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// USB FS/LS controller device registers
pub const USB_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x50110000),

    /// Device address and endpoint control
    ADDR_ENDP: ADDR_ENDP = .{},
    /// Interrupt endpoint 1. Only valid for HOST mode.
    ADDR_ENDP1: ADDR_ENDP1 = .{},
    /// Interrupt endpoint 2. Only valid for HOST mode.
    ADDR_ENDP2: ADDR_ENDP2 = .{},
    /// Interrupt endpoint 3. Only valid for HOST mode.
    ADDR_ENDP3: ADDR_ENDP3 = .{},
    /// Interrupt endpoint 4. Only valid for HOST mode.
    ADDR_ENDP4: ADDR_ENDP4 = .{},
    /// Interrupt endpoint 5. Only valid for HOST mode.
    ADDR_ENDP5: ADDR_ENDP5 = .{},
    /// Interrupt endpoint 6. Only valid for HOST mode.
    ADDR_ENDP6: ADDR_ENDP6 = .{},
    /// Interrupt endpoint 7. Only valid for HOST mode.
    ADDR_ENDP7: ADDR_ENDP7 = .{},
    /// Interrupt endpoint 8. Only valid for HOST mode.
    ADDR_ENDP8: ADDR_ENDP8 = .{},
    /// Interrupt endpoint 9. Only valid for HOST mode.
    ADDR_ENDP9: ADDR_ENDP9 = .{},
    /// Interrupt endpoint 10. Only valid for HOST mode.
    ADDR_ENDP10: ADDR_ENDP10 = .{},
    /// Interrupt endpoint 11. Only valid for HOST mode.
    ADDR_ENDP11: ADDR_ENDP11 = .{},
    /// Interrupt endpoint 12. Only valid for HOST mode.
    ADDR_ENDP12: ADDR_ENDP12 = .{},
    /// Interrupt endpoint 13. Only valid for HOST mode.
    ADDR_ENDP13: ADDR_ENDP13 = .{},
    /// Interrupt endpoint 14. Only valid for HOST mode.
    ADDR_ENDP14: ADDR_ENDP14 = .{},
    /// Interrupt endpoint 15. Only valid for HOST mode.
    ADDR_ENDP15: ADDR_ENDP15 = .{},
    /// Main control register
    MAIN_CTRL: MAIN_CTRL = .{},
    /// Set the SOF (Start of Frame) frame number in the host controller. The SOF packet is sent every 1ms and the host will increment the frame number by 1 each time.
    SOF_WR: SOF_WR = .{},
    /// Read the last SOF (Start of Frame) frame number seen. In device mode the last SOF received from the host. In host mode the last SOF sent by the host.
    SOF_RD: SOF_RD = .{},
    /// SIE control register
    SIE_CTRL: SIE_CTRL = .{},
    /// SIE status register
    SIE_STATUS: SIE_STATUS = .{},
    /// interrupt endpoint control register
    INT_EP_CTRL: INT_EP_CTRL = .{},
    /// Buffer status register. A bit set here indicates that a buffer has completed on the endpoint (if the buffer interrupt is enabled). It is possible for 2 buffers to be completed, so clearing the buffer status bit may instantly re set it on the next clock cycle.
    BUFF_STATUS: BUFF_STATUS = .{},
    /// Which of the double buffers should be handled. Only valid if using an interrupt per buffer (i.e. not per 2 buffers). Not valid for host interrupt endpoint polling because they are only single buffered.
    BUFF_CPU_SHOULD_HANDLE: BUFF_CPU_SHOULD_HANDLE = .{},
    /// Device only: Can be set to ignore the buffer control register for this endpoint in case you would like to revoke a buffer. A NAK will be sent for every access to the endpoint until this bit is cleared. A corresponding bit in `EP_ABORT_DONE` is set when it is safe to modify the buffer control register.
    EP_ABORT: EP_ABORT = .{},
    /// Device only: Used in conjunction with `EP_ABORT`. Set once an endpoint is idle so the programmer knows it is safe to modify the buffer control register.
    EP_ABORT_DONE: EP_ABORT_DONE = .{},
    /// Device: this bit must be set in conjunction with the `STALL` bit in the buffer control register to send a STALL on EP0. The device controller clears these bits when a SETUP packet is received because the USB spec requires that a STALL condition is cleared when a SETUP packet is received.
    EP_STALL_ARM: EP_STALL_ARM = .{},
    /// Used by the host controller. Sets the wait time in microseconds before trying again if the device replies with a NAK.
    NAK_POLL: NAK_POLL = .{},
    /// Device: bits are set when the `IRQ_ON_NAK` or `IRQ_ON_STALL` bits are set. For EP0 this comes from `SIE_CTRL`. For all other endpoints it comes from the endpoint control register.
    EP_STATUS_STALL_NAK: EP_STATUS_STALL_NAK = .{},
    /// Where to connect the USB controller. Should be to_phy by default.
    USB_MUXING: USB_MUXING = .{},
    /// Overrides for the power signals in the event that the VBUS signals are not hooked up to GPIO. Set the value of the override and then the override enable so switch over to the override value.
    USB_PWR: USB_PWR = .{},
    /// Note that most functions are driven directly from usb_fsls controller.  This register allows more detailed control/status from the USB PHY. Useful for debug but not expected to be used in normal operation
    /// Use in conjunction with usbphy_direct_override register
    USBPHY_DIRECT: USBPHY_DIRECT = .{},
    USBPHY_DIRECT_OVERRIDE: USBPHY_DIRECT_OVERRIDE = .{},
    /// Note that most functions are driven directly from usb_fsls controller.  This register allows more detailed control/status from the USB PHY. Useful for debug but not expected to be used in normal operation
    USBPHY_TRIM: USBPHY_TRIM = .{},
    /// Raw Interrupts
    INTR: INTR = .{},
    /// Interrupt Enable
    INTE: INTE = .{},
    /// Interrupt Force
    INTF: INTF = .{},
    /// Interrupt status after masking &amp; forcing
    INTS: INTS = .{},
};
pub const USB = USB_p{};
