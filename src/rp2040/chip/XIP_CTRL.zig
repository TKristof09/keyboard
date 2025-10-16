const helpers = @import("helpers.zig");
/// Cache control
pub const CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x14000000),
    pub const FieldMasks = struct {
        pub const POWER_DOWN: u32 = helpers.generateMask(3, 4);
        pub const ERR_BADWRITE: u32 = helpers.generateMask(1, 2);
        pub const EN: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// When 1, the cache memories are powered down. They retain state,
        /// but can not be accessed. This reduces static power dissipation.
        /// Writing 1 to this bit forces CTRL_EN to 0, i.e. the cache cannot
        /// be enabled when powered down.
        /// Cache-as-SRAM accesses will produce a bus error response when
        /// the cache is powered down.
        pub fn POWER_DOWN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// When 1, writes to any alias other than 0x0 (caching, allocating)
        /// will produce a bus fault. When 0, these writes are silently ignored.
        /// In either case, writes to the 0x0 alias will deallocate on tag match,
        /// as usual.
        pub fn ERR_BADWRITE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// When 1, enable the cache. When the cache is disabled, all XIP accesses
        /// will go straight to the flash, without querying the cache. When enabled,
        /// cacheable XIP accesses will query the cache, and the flash will
        /// not be accessed if the tag matches and the valid bit is set.
        ///
        /// If the cache is enabled, cache-as-SRAM accesses have no effect on the
        /// cache data RAM, and will produce a bus error response.
        pub fn EN(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn POWER_DOWN(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn ERR_BADWRITE(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn EN(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// When 1, the cache memories are powered down. They retain state,
    /// but can not be accessed. This reduces static power dissipation.
    /// Writing 1 to this bit forces CTRL_EN to 0, i.e. the cache cannot
    /// be enabled when powered down.
    /// Cache-as-SRAM accesses will produce a bus error response when
    /// the cache is powered down.
    pub fn POWER_DOWN(v: u1) Value {
        return Value.POWER_DOWN(.{}, v);
    }
    /// When 1, writes to any alias other than 0x0 (caching, allocating)
    /// will produce a bus fault. When 0, these writes are silently ignored.
    /// In either case, writes to the 0x0 alias will deallocate on tag match,
    /// as usual.
    pub fn ERR_BADWRITE(v: u1) Value {
        return Value.ERR_BADWRITE(.{}, v);
    }
    /// When 1, enable the cache. When the cache is disabled, all XIP accesses
    /// will go straight to the flash, without querying the cache. When enabled,
    /// cacheable XIP accesses will query the cache, and the flash will
    /// not be accessed if the tag matches and the valid bit is set.
    ///
    /// If the cache is enabled, cache-as-SRAM accesses have no effect on the
    /// cache data RAM, and will produce a bus error response.
    pub fn EN(v: u1) Value {
        return Value.EN(.{}, v);
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
/// Cache Flush control
pub const FLUSH = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x14000004),
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
/// Cache Status
pub const STAT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x14000008),
    pub const FieldMasks = struct {
        pub const FIFO_FULL: u32 = helpers.generateMask(2, 3);
        pub const FIFO_EMPTY: u32 = helpers.generateMask(1, 2);
        pub const FLUSH_READY: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn FIFO_FULL(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn FIFO_EMPTY(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn FLUSH_READY(self: Result) u1 {
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
/// Cache Hit counter
pub const CTR_HIT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x1400000c),
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
/// Cache Access counter
pub const CTR_ACC = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x14000010),
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
/// FIFO stream address
pub const STREAM_ADDR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x14000014),
    pub fn write(self: @This(), v: u30) void {
        const mask = comptime helpers.generateMask(2, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 2, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(2, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(2, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u30 {
        const mask = comptime helpers.generateMask(2, 32);
        return @intCast((self.reg.* & mask) >> 2);
    }
};
/// FIFO stream control
pub const STREAM_CTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x14000018),
    pub fn write(self: @This(), v: u22) void {
        const mask = comptime helpers.generateMask(0, 22);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 22);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 22);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u22 {
        const mask = comptime helpers.generateMask(0, 22);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// FIFO stream data
pub const STREAM_FIFO = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x1400001c),
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
/// QSPI flash execute-in-place block
pub const XIP_CTRL_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x14000000),

    /// Cache control
    CTRL: CTRL = .{},
    /// Cache Flush control
    FLUSH: FLUSH = .{},
    /// Cache Status
    STAT: STAT = .{},
    /// Cache Hit counter
    CTR_HIT: CTR_HIT = .{},
    /// Cache Access counter
    CTR_ACC: CTR_ACC = .{},
    /// FIFO stream address
    STREAM_ADDR: STREAM_ADDR = .{},
    /// FIFO stream control
    STREAM_CTR: STREAM_CTR = .{},
    /// FIFO stream data
    STREAM_FIFO: STREAM_FIFO = .{},
};
pub const XIP_CTRL = XIP_CTRL_p{};
