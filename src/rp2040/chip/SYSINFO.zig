const helpers = @import("helpers.zig");
/// JEDEC JEP-106 compliant chip identifier.
pub const CHIP_ID = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40000000),
    pub const FieldMasks = struct {
        pub const REVISION: u32 = helpers.generateMask(28, 32);
        pub const PART: u32 = helpers.generateMask(12, 28);
        pub const MANUFACTURER: u32 = helpers.generateMask(0, 12);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn REVISION(self: Result) u4 {
            const mask = comptime helpers.generateMask(28, 32);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn PART(self: Result) u16 {
            const mask = comptime helpers.generateMask(12, 28);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn MANUFACTURER(self: Result) u12 {
            const mask = comptime helpers.generateMask(0, 12);
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
/// Platform register. Allows software to know what environment it is running in.
pub const PLATFORM = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40000004),
    pub const FieldMasks = struct {
        pub const ASIC: u32 = helpers.generateMask(1, 2);
        pub const FPGA: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn ASIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn FPGA(self: Result) u1 {
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
/// Git hash of the chip source. Used to identify chip version.
pub const GITREF_RP2040 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40000010),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u32 {
        const mask = comptime helpers.generateMask(0, 32);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
pub const SYSINFO_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x40000000),

    /// JEDEC JEP-106 compliant chip identifier.
    CHIP_ID: CHIP_ID = .{},
    /// Platform register. Allows software to know what environment it is running in.
    PLATFORM: PLATFORM = .{},
    /// Git hash of the chip source. Used to identify chip version.
    GITREF_RP2040: GITREF_RP2040 = .{},
};
pub const SYSINFO = SYSINFO_p{};
