const helpers = @import("helpers.zig");
/// Indicates the type of platform in use
pub const PLATFORM = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4006c000),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn FPGA(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn ASIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Testbench manager. Allows the programmer to know what platform their software is running on.
pub const TBMAN_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x4006c000),

    /// Indicates the type of platform in use
    PLATFORM: PLATFORM = .{},
};
pub const TBMAN = TBMAN_p{};
