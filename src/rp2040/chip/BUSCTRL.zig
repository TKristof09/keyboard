const helpers = @import("helpers.zig");
/// Set the priority of each master for bus arbitration.
pub const BUS_PRIORITY = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40030000),
    pub const FieldMasks = struct {
        pub const DMA_W: u32 = helpers.generateMask(12, 13);
        pub const DMA_R: u32 = helpers.generateMask(8, 9);
        pub const PROC1: u32 = helpers.generateMask(4, 5);
        pub const PROC0: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// 0 - low priority, 1 - high priority
        pub fn DMA_W(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// 0 - low priority, 1 - high priority
        pub fn DMA_R(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        /// 0 - low priority, 1 - high priority
        pub fn PROC1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// 0 - low priority, 1 - high priority
        pub fn PROC0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn DMA_W(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn DMA_R(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn PROC1(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn PROC0(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// 0 - low priority, 1 - high priority
    pub fn DMA_W(v: u1) Value {
        return Value.DMA_W(.{}, v);
    }
    /// 0 - low priority, 1 - high priority
    pub fn DMA_R(v: u1) Value {
        return Value.DMA_R(.{}, v);
    }
    /// 0 - low priority, 1 - high priority
    pub fn PROC1(v: u1) Value {
        return Value.PROC1(.{}, v);
    }
    /// 0 - low priority, 1 - high priority
    pub fn PROC0(v: u1) Value {
        return Value.PROC0(.{}, v);
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
/// Bus priority acknowledge
pub const BUS_PRIORITY_ACK = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40030004),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u1 {
        const mask = comptime helpers.generateMask(0, 1);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Bus fabric performance counter 0
pub const PERFCTR0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40030008),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 24);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 24);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u24 {
        const mask = comptime helpers.generateMask(0, 24);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Bus fabric performance event select for PERFCTR0
pub const PERFSEL0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003000c),
    const PERFSEL0_e = enum(u5) {
        apb_contested = 0,
        apb = 1,
        fastperi_contested = 2,
        fastperi = 3,
        sram5_contested = 4,
        sram5 = 5,
        sram4_contested = 6,
        sram4 = 7,
        sram3_contested = 8,
        sram3 = 9,
        sram2_contested = 10,
        sram2 = 11,
        sram1_contested = 12,
        sram1 = 13,
        sram0_contested = 14,
        sram0 = 15,
        xip_main_contested = 16,
        xip_main = 17,
        rom_contested = 18,
        rom = 19,
    };
    pub fn write(self: @This(), v: PERFSEL0_e) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwWriteMasked(self.reg, helpers.toU32(@intFromEnum(v)) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) PERFSEL0_e {
        const mask = comptime helpers.generateMask(0, 5);
        return @enumFromInt((self.reg.* & mask) >> 0);
    }
};
/// Bus fabric performance counter 1
pub const PERFCTR1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40030010),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 24);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 24);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u24 {
        const mask = comptime helpers.generateMask(0, 24);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Bus fabric performance event select for PERFCTR1
pub const PERFSEL1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40030014),
    const PERFSEL1_e = enum(u5) {
        apb_contested = 0,
        apb = 1,
        fastperi_contested = 2,
        fastperi = 3,
        sram5_contested = 4,
        sram5 = 5,
        sram4_contested = 6,
        sram4 = 7,
        sram3_contested = 8,
        sram3 = 9,
        sram2_contested = 10,
        sram2 = 11,
        sram1_contested = 12,
        sram1 = 13,
        sram0_contested = 14,
        sram0 = 15,
        xip_main_contested = 16,
        xip_main = 17,
        rom_contested = 18,
        rom = 19,
    };
    pub fn write(self: @This(), v: PERFSEL1_e) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwWriteMasked(self.reg, helpers.toU32(@intFromEnum(v)) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) PERFSEL1_e {
        const mask = comptime helpers.generateMask(0, 5);
        return @enumFromInt((self.reg.* & mask) >> 0);
    }
};
/// Bus fabric performance counter 2
pub const PERFCTR2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40030018),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 24);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 24);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u24 {
        const mask = comptime helpers.generateMask(0, 24);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Bus fabric performance event select for PERFCTR2
pub const PERFSEL2 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4003001c),
    const PERFSEL2_e = enum(u5) {
        apb_contested = 0,
        apb = 1,
        fastperi_contested = 2,
        fastperi = 3,
        sram5_contested = 4,
        sram5 = 5,
        sram4_contested = 6,
        sram4 = 7,
        sram3_contested = 8,
        sram3 = 9,
        sram2_contested = 10,
        sram2 = 11,
        sram1_contested = 12,
        sram1 = 13,
        sram0_contested = 14,
        sram0 = 15,
        xip_main_contested = 16,
        xip_main = 17,
        rom_contested = 18,
        rom = 19,
    };
    pub fn write(self: @This(), v: PERFSEL2_e) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwWriteMasked(self.reg, helpers.toU32(@intFromEnum(v)) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) PERFSEL2_e {
        const mask = comptime helpers.generateMask(0, 5);
        return @enumFromInt((self.reg.* & mask) >> 0);
    }
};
/// Bus fabric performance counter 3
pub const PERFCTR3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40030020),
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 24);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 24);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u24 {
        const mask = comptime helpers.generateMask(0, 24);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Bus fabric performance event select for PERFCTR3
pub const PERFSEL3 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40030024),
    const PERFSEL3_e = enum(u5) {
        apb_contested = 0,
        apb = 1,
        fastperi_contested = 2,
        fastperi = 3,
        sram5_contested = 4,
        sram5 = 5,
        sram4_contested = 6,
        sram4 = 7,
        sram3_contested = 8,
        sram3 = 9,
        sram2_contested = 10,
        sram2 = 11,
        sram1_contested = 12,
        sram1 = 13,
        sram0_contested = 14,
        sram0 = 15,
        xip_main_contested = 16,
        xip_main = 17,
        rom_contested = 18,
        rom = 19,
    };
    pub fn write(self: @This(), v: PERFSEL3_e) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwWriteMasked(self.reg, helpers.toU32(@intFromEnum(v)) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) PERFSEL3_e {
        const mask = comptime helpers.generateMask(0, 5);
        return @enumFromInt((self.reg.* & mask) >> 0);
    }
};
/// Register block for busfabric control signals and performance counters
pub const BUSCTRL_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x40030000),

    /// Set the priority of each master for bus arbitration.
    BUS_PRIORITY: BUS_PRIORITY = .{},
    /// Bus priority acknowledge
    BUS_PRIORITY_ACK: BUS_PRIORITY_ACK = .{},
    /// Bus fabric performance counter 0
    PERFCTR0: PERFCTR0 = .{},
    /// Bus fabric performance event select for PERFCTR0
    PERFSEL0: PERFSEL0 = .{},
    /// Bus fabric performance counter 1
    PERFCTR1: PERFCTR1 = .{},
    /// Bus fabric performance event select for PERFCTR1
    PERFSEL1: PERFSEL1 = .{},
    /// Bus fabric performance counter 2
    PERFCTR2: PERFCTR2 = .{},
    /// Bus fabric performance event select for PERFCTR2
    PERFSEL2: PERFSEL2 = .{},
    /// Bus fabric performance counter 3
    PERFCTR3: PERFCTR3 = .{},
    /// Bus fabric performance event select for PERFCTR3
    PERFSEL3: PERFSEL3 = .{},
};
pub const BUSCTRL = BUSCTRL_p{};
