const helpers = @import("helpers.zig");
/// Force block out of reset (i.e. power it on)
pub const FRCE_ON = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40010000),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn PROC1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn PROC0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn SIO(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn VREG_AND_CHIP_RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn XIP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn SRAM5(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn SRAM4(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn SRAM3(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn SRAM2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn SRAM1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn SRAM0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn ROM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn BUSFABRIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn RESETS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn CLOCKS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn XOSC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn ROSC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn PROC1(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn PROC0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn SIO(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn VREG_AND_CHIP_RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn XIP(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn SRAM5(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn SRAM4(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn SRAM3(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn SRAM2(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SRAM1(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn SRAM0(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn ROM(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn BUSFABRIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn RESETS(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn CLOCKS(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn XOSC(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn ROSC(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn PROC1(v: u1) Value {
        return Value.PROC1(.{}, v);
    }
    pub fn PROC0(v: u1) Value {
        return Value.PROC0(.{}, v);
    }
    pub fn SIO(v: u1) Value {
        return Value.SIO(.{}, v);
    }
    pub fn VREG_AND_CHIP_RESET(v: u1) Value {
        return Value.VREG_AND_CHIP_RESET(.{}, v);
    }
    pub fn XIP(v: u1) Value {
        return Value.XIP(.{}, v);
    }
    pub fn SRAM5(v: u1) Value {
        return Value.SRAM5(.{}, v);
    }
    pub fn SRAM4(v: u1) Value {
        return Value.SRAM4(.{}, v);
    }
    pub fn SRAM3(v: u1) Value {
        return Value.SRAM3(.{}, v);
    }
    pub fn SRAM2(v: u1) Value {
        return Value.SRAM2(.{}, v);
    }
    pub fn SRAM1(v: u1) Value {
        return Value.SRAM1(.{}, v);
    }
    pub fn SRAM0(v: u1) Value {
        return Value.SRAM0(.{}, v);
    }
    pub fn ROM(v: u1) Value {
        return Value.ROM(.{}, v);
    }
    pub fn BUSFABRIC(v: u1) Value {
        return Value.BUSFABRIC(.{}, v);
    }
    pub fn RESETS(v: u1) Value {
        return Value.RESETS(.{}, v);
    }
    pub fn CLOCKS(v: u1) Value {
        return Value.CLOCKS(.{}, v);
    }
    pub fn XOSC(v: u1) Value {
        return Value.XOSC(.{}, v);
    }
    pub fn ROSC(v: u1) Value {
        return Value.ROSC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Force into reset (i.e. power it off)
pub const FRCE_OFF = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40010004),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn PROC1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn PROC0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn SIO(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn VREG_AND_CHIP_RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn XIP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn SRAM5(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn SRAM4(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn SRAM3(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn SRAM2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn SRAM1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn SRAM0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn ROM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn BUSFABRIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn RESETS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn CLOCKS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn XOSC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn ROSC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn PROC1(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn PROC0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn SIO(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn VREG_AND_CHIP_RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn XIP(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn SRAM5(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn SRAM4(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn SRAM3(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn SRAM2(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SRAM1(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn SRAM0(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn ROM(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn BUSFABRIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn RESETS(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn CLOCKS(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn XOSC(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn ROSC(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn PROC1(v: u1) Value {
        return Value.PROC1(.{}, v);
    }
    pub fn PROC0(v: u1) Value {
        return Value.PROC0(.{}, v);
    }
    pub fn SIO(v: u1) Value {
        return Value.SIO(.{}, v);
    }
    pub fn VREG_AND_CHIP_RESET(v: u1) Value {
        return Value.VREG_AND_CHIP_RESET(.{}, v);
    }
    pub fn XIP(v: u1) Value {
        return Value.XIP(.{}, v);
    }
    pub fn SRAM5(v: u1) Value {
        return Value.SRAM5(.{}, v);
    }
    pub fn SRAM4(v: u1) Value {
        return Value.SRAM4(.{}, v);
    }
    pub fn SRAM3(v: u1) Value {
        return Value.SRAM3(.{}, v);
    }
    pub fn SRAM2(v: u1) Value {
        return Value.SRAM2(.{}, v);
    }
    pub fn SRAM1(v: u1) Value {
        return Value.SRAM1(.{}, v);
    }
    pub fn SRAM0(v: u1) Value {
        return Value.SRAM0(.{}, v);
    }
    pub fn ROM(v: u1) Value {
        return Value.ROM(.{}, v);
    }
    pub fn BUSFABRIC(v: u1) Value {
        return Value.BUSFABRIC(.{}, v);
    }
    pub fn RESETS(v: u1) Value {
        return Value.RESETS(.{}, v);
    }
    pub fn CLOCKS(v: u1) Value {
        return Value.CLOCKS(.{}, v);
    }
    pub fn XOSC(v: u1) Value {
        return Value.XOSC(.{}, v);
    }
    pub fn ROSC(v: u1) Value {
        return Value.ROSC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Set to 1 if this peripheral should be reset when the watchdog fires.
pub const WDSEL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40010008),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn PROC1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 17),
            };
        }
        pub fn PROC0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 15),
                .mask = self.mask | comptime helpers.generateMask(15, 16),
            };
        }
        pub fn SIO(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 14),
                .mask = self.mask | comptime helpers.generateMask(14, 15),
            };
        }
        pub fn VREG_AND_CHIP_RESET(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 13),
                .mask = self.mask | comptime helpers.generateMask(13, 14),
            };
        }
        pub fn XIP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        pub fn SRAM5(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        pub fn SRAM4(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        pub fn SRAM3(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        pub fn SRAM2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        pub fn SRAM1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn SRAM0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn ROM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn BUSFABRIC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn RESETS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn CLOCKS(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn XOSC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn ROSC(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn PROC1(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn PROC0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn SIO(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn VREG_AND_CHIP_RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn XIP(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn SRAM5(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn SRAM4(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn SRAM3(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn SRAM2(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SRAM1(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn SRAM0(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn ROM(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn BUSFABRIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn RESETS(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn CLOCKS(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn XOSC(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn ROSC(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn PROC1(v: u1) Value {
        return Value.PROC1(.{}, v);
    }
    pub fn PROC0(v: u1) Value {
        return Value.PROC0(.{}, v);
    }
    pub fn SIO(v: u1) Value {
        return Value.SIO(.{}, v);
    }
    pub fn VREG_AND_CHIP_RESET(v: u1) Value {
        return Value.VREG_AND_CHIP_RESET(.{}, v);
    }
    pub fn XIP(v: u1) Value {
        return Value.XIP(.{}, v);
    }
    pub fn SRAM5(v: u1) Value {
        return Value.SRAM5(.{}, v);
    }
    pub fn SRAM4(v: u1) Value {
        return Value.SRAM4(.{}, v);
    }
    pub fn SRAM3(v: u1) Value {
        return Value.SRAM3(.{}, v);
    }
    pub fn SRAM2(v: u1) Value {
        return Value.SRAM2(.{}, v);
    }
    pub fn SRAM1(v: u1) Value {
        return Value.SRAM1(.{}, v);
    }
    pub fn SRAM0(v: u1) Value {
        return Value.SRAM0(.{}, v);
    }
    pub fn ROM(v: u1) Value {
        return Value.ROM(.{}, v);
    }
    pub fn BUSFABRIC(v: u1) Value {
        return Value.BUSFABRIC(.{}, v);
    }
    pub fn RESETS(v: u1) Value {
        return Value.RESETS(.{}, v);
    }
    pub fn CLOCKS(v: u1) Value {
        return Value.CLOCKS(.{}, v);
    }
    pub fn XOSC(v: u1) Value {
        return Value.XOSC(.{}, v);
    }
    pub fn ROSC(v: u1) Value {
        return Value.ROSC(.{}, v);
    }
    pub fn write(self: @This(), v: Value) void {
        helpers.hwWriteMasked(self.reg, v.val, v.mask);
    }
    pub fn read(self: @This()) Result {
        return .{ .val = self.reg.* };
    }
};
/// Indicates the peripheral&#39;s registers are ready to access.
pub const DONE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4001000c),
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn PROC1(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn PROC0(self: Result) u1 {
            const mask = comptime helpers.generateMask(15, 16);
            return @intCast((self.val & mask) >> 15);
        }
        pub fn SIO(self: Result) u1 {
            const mask = comptime helpers.generateMask(14, 15);
            return @intCast((self.val & mask) >> 14);
        }
        pub fn VREG_AND_CHIP_RESET(self: Result) u1 {
            const mask = comptime helpers.generateMask(13, 14);
            return @intCast((self.val & mask) >> 13);
        }
        pub fn XIP(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn SRAM5(self: Result) u1 {
            const mask = comptime helpers.generateMask(11, 12);
            return @intCast((self.val & mask) >> 11);
        }
        pub fn SRAM4(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn SRAM3(self: Result) u1 {
            const mask = comptime helpers.generateMask(9, 10);
            return @intCast((self.val & mask) >> 9);
        }
        pub fn SRAM2(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SRAM1(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn SRAM0(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn ROM(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn BUSFABRIC(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn RESETS(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn CLOCKS(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn XOSC(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn ROSC(self: Result) u1 {
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
pub const PSM_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x40010000),

    /// Force block out of reset (i.e. power it on)
    FRCE_ON: FRCE_ON = .{},
    /// Force into reset (i.e. power it off)
    FRCE_OFF: FRCE_OFF = .{},
    /// Set to 1 if this peripheral should be reset when the watchdog fires.
    WDSEL: WDSEL = .{},
    /// Indicates the peripheral&#39;s registers are ready to access.
    DONE: DONE = .{},
};
pub const PSM = PSM_p{};
