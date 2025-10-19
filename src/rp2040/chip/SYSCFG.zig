const helpers = @import("helpers.zig");
/// Processor core 0 NMI source mask
pub const PROC0_NMI_MASK = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40004000),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u32) void {
        self.reg.* = (helpers.toU32(v) << 0);
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
/// Processor core 1 NMI source mask
pub const PROC1_NMI_MASK = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40004004),
    pub fn write(self: @This(), v: u32) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u32) void {
        self.reg.* = (helpers.toU32(v) << 0);
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
/// Configuration for processors
pub const PROC_CONFIG = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40004008),
    pub const FieldMasks = struct {
        pub const PROC1_DAP_INSTID: u32 = helpers.generateMask(28, 32);
        pub const PROC0_DAP_INSTID: u32 = helpers.generateMask(24, 28);
        pub const PROC1_HALTED: u32 = helpers.generateMask(1, 2);
        pub const PROC0_HALTED: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Configure proc1 DAP instance ID.
        /// Recommend that this is NOT changed until you require debug access in multi-chip environment
        /// WARNING: do not set to 15 as this is reserved for RescueDP
        pub fn PROC1_DAP_INSTID(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 32),
            };
        }
        /// Configure proc0 DAP instance ID.
        /// Recommend that this is NOT changed until you require debug access in multi-chip environment
        /// WARNING: do not set to 15 as this is reserved for RescueDP
        pub fn PROC0_DAP_INSTID(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 28),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn PROC1_DAP_INSTID(self: Result) u4 {
            const mask = comptime helpers.generateMask(28, 32);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn PROC0_DAP_INSTID(self: Result) u4 {
            const mask = comptime helpers.generateMask(24, 28);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn PROC1_HALTED(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn PROC0_HALTED(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Configure proc1 DAP instance ID.
    /// Recommend that this is NOT changed until you require debug access in multi-chip environment
    /// WARNING: do not set to 15 as this is reserved for RescueDP
    pub fn PROC1_DAP_INSTID(v: u4) Value {
        return Value.PROC1_DAP_INSTID(.{}, v);
    }
    /// Configure proc0 DAP instance ID.
    /// Recommend that this is NOT changed until you require debug access in multi-chip environment
    /// WARNING: do not set to 15 as this is reserved for RescueDP
    pub fn PROC0_DAP_INSTID(v: u4) Value {
        return Value.PROC0_DAP_INSTID(.{}, v);
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
/// For each bit, if 1, bypass the input synchronizer between that GPIO
/// and the GPIO input register in the SIO. The input synchronizers should
/// generally be unbypassed, to avoid injecting metastabilities into processors.
/// If you&#39;re feeling brave, you can bypass to save two cycles of input
/// latency. This register applies to GPIO 0...29.
pub const PROC_IN_SYNC_BYPASS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4000400c),
    pub fn write(self: @This(), v: u30) void {
        const mask = comptime helpers.generateMask(0, 30);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u30) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 30);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 30);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u30 {
        const mask = comptime helpers.generateMask(0, 30);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// For each bit, if 1, bypass the input synchronizer between that GPIO
/// and the GPIO input register in the SIO. The input synchronizers should
/// generally be unbypassed, to avoid injecting metastabilities into processors.
/// If you&#39;re feeling brave, you can bypass to save two cycles of input
/// latency. This register applies to GPIO 30...35 (the QSPI IOs).
pub const PROC_IN_SYNC_BYPASS_HI = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40004010),
    pub fn write(self: @This(), v: u6) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u6) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 6);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u6 {
        const mask = comptime helpers.generateMask(0, 6);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// Directly control the SWD debug port of either processor
pub const DBGFORCE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40004014),
    pub const FieldMasks = struct {
        pub const PROC1_ATTACH: u32 = helpers.generateMask(7, 8);
        pub const PROC1_SWCLK: u32 = helpers.generateMask(6, 7);
        pub const PROC1_SWDI: u32 = helpers.generateMask(5, 6);
        pub const PROC1_SWDO: u32 = helpers.generateMask(4, 5);
        pub const PROC0_ATTACH: u32 = helpers.generateMask(3, 4);
        pub const PROC0_SWCLK: u32 = helpers.generateMask(2, 3);
        pub const PROC0_SWDI: u32 = helpers.generateMask(1, 2);
        pub const PROC0_SWDO: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Attach processor 1 debug port to syscfg controls, and disconnect it from external SWD pads.
        pub fn PROC1_ATTACH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// Directly drive processor 1 SWCLK, if PROC1_ATTACH is set
        pub fn PROC1_SWCLK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// Directly drive processor 1 SWDIO input, if PROC1_ATTACH is set
        pub fn PROC1_SWDI(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// Attach processor 0 debug port to syscfg controls, and disconnect it from external SWD pads.
        pub fn PROC0_ATTACH(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// Directly drive processor 0 SWCLK, if PROC0_ATTACH is set
        pub fn PROC0_SWCLK(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// Directly drive processor 0 SWDIO input, if PROC0_ATTACH is set
        pub fn PROC0_SWDI(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn PROC1_ATTACH(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn PROC1_SWCLK(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn PROC1_SWDI(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn PROC1_SWDO(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn PROC0_ATTACH(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn PROC0_SWCLK(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn PROC0_SWDI(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn PROC0_SWDO(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Attach processor 1 debug port to syscfg controls, and disconnect it from external SWD pads.
    pub fn PROC1_ATTACH(v: u1) Value {
        return Value.PROC1_ATTACH(.{}, v);
    }
    /// Directly drive processor 1 SWCLK, if PROC1_ATTACH is set
    pub fn PROC1_SWCLK(v: u1) Value {
        return Value.PROC1_SWCLK(.{}, v);
    }
    /// Directly drive processor 1 SWDIO input, if PROC1_ATTACH is set
    pub fn PROC1_SWDI(v: u1) Value {
        return Value.PROC1_SWDI(.{}, v);
    }
    /// Attach processor 0 debug port to syscfg controls, and disconnect it from external SWD pads.
    pub fn PROC0_ATTACH(v: u1) Value {
        return Value.PROC0_ATTACH(.{}, v);
    }
    /// Directly drive processor 0 SWCLK, if PROC0_ATTACH is set
    pub fn PROC0_SWCLK(v: u1) Value {
        return Value.PROC0_SWCLK(.{}, v);
    }
    /// Directly drive processor 0 SWDIO input, if PROC0_ATTACH is set
    pub fn PROC0_SWDI(v: u1) Value {
        return Value.PROC0_SWDI(.{}, v);
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
/// Control power downs to memories. Set high to power down memories.
/// Use with extreme caution
pub const MEMPOWERDOWN = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40004018),
    pub const FieldMasks = struct {
        pub const ROM: u32 = helpers.generateMask(7, 8);
        pub const USB: u32 = helpers.generateMask(6, 7);
        pub const SRAM5: u32 = helpers.generateMask(5, 6);
        pub const SRAM4: u32 = helpers.generateMask(4, 5);
        pub const SRAM3: u32 = helpers.generateMask(3, 4);
        pub const SRAM2: u32 = helpers.generateMask(2, 3);
        pub const SRAM1: u32 = helpers.generateMask(1, 2);
        pub const SRAM0: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        pub fn ROM(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        pub fn USB(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        pub fn SRAM5(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        pub fn SRAM4(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        pub fn SRAM3(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        pub fn SRAM2(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        pub fn SRAM1(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        pub fn SRAM0(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ROM(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn USB(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn SRAM5(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn SRAM4(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn SRAM3(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn SRAM2(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SRAM1(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn SRAM0(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    pub fn ROM(v: u1) Value {
        return Value.ROM(.{}, v);
    }
    pub fn USB(v: u1) Value {
        return Value.USB(.{}, v);
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
/// Register block for various chip control signals
pub const SYSCFG_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x40004000),

    /// Processor core 0 NMI source mask
    PROC0_NMI_MASK: PROC0_NMI_MASK = .{},
    /// Processor core 1 NMI source mask
    PROC1_NMI_MASK: PROC1_NMI_MASK = .{},
    /// Configuration for processors
    PROC_CONFIG: PROC_CONFIG = .{},
    /// For each bit, if 1, bypass the input synchronizer between that GPIO
    /// and the GPIO input register in the SIO. The input synchronizers should
    /// generally be unbypassed, to avoid injecting metastabilities into processors.
    /// If you&#39;re feeling brave, you can bypass to save two cycles of input
    /// latency. This register applies to GPIO 0...29.
    PROC_IN_SYNC_BYPASS: PROC_IN_SYNC_BYPASS = .{},
    /// For each bit, if 1, bypass the input synchronizer between that GPIO
    /// and the GPIO input register in the SIO. The input synchronizers should
    /// generally be unbypassed, to avoid injecting metastabilities into processors.
    /// If you&#39;re feeling brave, you can bypass to save two cycles of input
    /// latency. This register applies to GPIO 30...35 (the QSPI IOs).
    PROC_IN_SYNC_BYPASS_HI: PROC_IN_SYNC_BYPASS_HI = .{},
    /// Directly control the SWD debug port of either processor
    DBGFORCE: DBGFORCE = .{},
    /// Control power downs to memories. Set high to power down memories.
    /// Use with extreme caution
    MEMPOWERDOWN: MEMPOWERDOWN = .{},
};
pub const SYSCFG = SYSCFG_p{};
