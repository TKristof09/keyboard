const helpers = @import("helpers.zig");
/// Voltage regulator control and status
pub const VREG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40064000),
    pub const FieldMasks = struct {
        pub const ROK: u32 = helpers.generateMask(12, 13);
        pub const VSEL: u32 = helpers.generateMask(4, 8);
        pub const HIZ: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// output voltage select
        /// 0000 to 0101 - 0.80V
        /// 0110         - 0.85V
        /// 0111         - 0.90V
        /// 1000         - 0.95V
        /// 1001         - 1.00V
        /// 1010         - 1.05V
        /// 1011         - 1.10V (default)
        /// 1100         - 1.15V
        /// 1101         - 1.20V
        /// 1110         - 1.25V
        /// 1111         - 1.30V
        pub fn VSEL(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 8),
            };
        }
        /// high impedance mode select
        /// 0=not in high impedance mode, 1=in high impedance mode
        pub fn HIZ(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// enable
        /// 0=not enabled, 1=enabled
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ROK(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn VSEL(self: Result) u4 {
            const mask = comptime helpers.generateMask(4, 8);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn HIZ(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// output voltage select
    /// 0000 to 0101 - 0.80V
    /// 0110         - 0.85V
    /// 0111         - 0.90V
    /// 1000         - 0.95V
    /// 1001         - 1.00V
    /// 1010         - 1.05V
    /// 1011         - 1.10V (default)
    /// 1100         - 1.15V
    /// 1101         - 1.20V
    /// 1110         - 1.25V
    /// 1111         - 1.30V
    pub fn VSEL(v: u4) Value {
        return Value.VSEL(.{}, v);
    }
    /// high impedance mode select
    /// 0=not in high impedance mode, 1=in high impedance mode
    pub fn HIZ(v: u1) Value {
        return Value.HIZ(.{}, v);
    }
    /// enable
    /// 0=not enabled, 1=enabled
    pub fn EN(v: u1) Value {
        return Value.EN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
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
/// brown-out detection control
pub const BOD = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40064004),
    pub const FieldMasks = struct {
        pub const VSEL: u32 = helpers.generateMask(4, 8);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// threshold select
        /// 0000 - 0.473V
        /// 0001 - 0.516V
        /// 0010 - 0.559V
        /// 0011 - 0.602V
        /// 0100 - 0.645V
        /// 0101 - 0.688V
        /// 0110 - 0.731V
        /// 0111 - 0.774V
        /// 1000 - 0.817V
        /// 1001 - 0.860V (default)
        /// 1010 - 0.903V
        /// 1011 - 0.946V
        /// 1100 - 0.989V
        /// 1101 - 1.032V
        /// 1110 - 1.075V
        /// 1111 - 1.118V
        pub fn VSEL(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 8),
            };
        }
        /// enable
        /// 0=not enabled, 1=enabled
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn VSEL(self: Result) u4 {
            const mask = comptime helpers.generateMask(4, 8);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// threshold select
    /// 0000 - 0.473V
    /// 0001 - 0.516V
    /// 0010 - 0.559V
    /// 0011 - 0.602V
    /// 0100 - 0.645V
    /// 0101 - 0.688V
    /// 0110 - 0.731V
    /// 0111 - 0.774V
    /// 1000 - 0.817V
    /// 1001 - 0.860V (default)
    /// 1010 - 0.903V
    /// 1011 - 0.946V
    /// 1100 - 0.989V
    /// 1101 - 1.032V
    /// 1110 - 1.075V
    /// 1111 - 1.118V
    pub fn VSEL(v: u4) Value {
        return Value.VSEL(.{}, v);
    }
    /// enable
    /// 0=not enabled, 1=enabled
    pub fn EN(v: u1) Value {
        return Value.EN(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
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
/// Chip reset control and status
pub const CHIP_RESET = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40064008),
    pub const FieldMasks = struct {
        pub const PSM_RESTART_FLAG: u32 = helpers.generateMask(24, 25);
        pub const HAD_PSM_RESTART: u32 = helpers.generateMask(20, 21);
        pub const HAD_RUN: u32 = helpers.generateMask(16, 17);
        pub const HAD_POR: u32 = helpers.generateMask(8, 9);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// This is set by psm_restart from the debugger.
        /// Its purpose is to branch bootcode to a safe mode when the debugger has issued a psm_restart in order to recover from a boot lock-up.
        /// In the safe mode the debugger can repair the boot code, clear this flag then reboot the processor.
        pub fn PSM_RESTART_FLAG(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn PSM_RESTART_FLAG(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn HAD_PSM_RESTART(self: Result) u1 {
            const mask = comptime helpers.generateMask(20, 21);
            return @intCast((self.val & mask) >> 20);
        }
        pub fn HAD_RUN(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn HAD_POR(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
    };
    /// This is set by psm_restart from the debugger.
    /// Its purpose is to branch bootcode to a safe mode when the debugger has issued a psm_restart in order to recover from a boot lock-up.
    /// In the safe mode the debugger can repair the boot code, clear this flag then reboot the processor.
    pub fn PSM_RESTART_FLAG(v: u1) Value {
        return Value.PSM_RESTART_FLAG(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn writeOver(self: @This(), v: Value) void {
        self.reg.* = v.val;
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
/// control and status for on-chip voltage regulator and chip level reset subsystem
pub const VREG_AND_CHIP_RESET_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x40064000),

    /// Voltage regulator control and status
    VREG: VREG = .{},
    /// brown-out detection control
    BOD: BOD = .{},
    /// Chip reset control and status
    CHIP_RESET: CHIP_RESET = .{},
};
pub const VREG_AND_CHIP_RESET = VREG_AND_CHIP_RESET_p{};
