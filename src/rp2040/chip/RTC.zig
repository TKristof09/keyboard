const helpers = @import("helpers.zig");
/// Divider minus 1 for the 1 second counter. Safe to change the value when RTC is not enabled.
pub const CLKDIV_M1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005c000),
    pub fn write(self: @This(), v: u16) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u16) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 16);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u16 {
        const mask = comptime helpers.generateMask(0, 16);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// RTC setup register 0
pub const SETUP_0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005c004),
    pub const FieldMasks = struct {
        pub const YEAR: u32 = helpers.generateMask(12, 24);
        pub const MONTH: u32 = helpers.generateMask(8, 12);
        pub const DAY: u32 = helpers.generateMask(0, 5);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Year
        pub fn YEAR(self: Value, v: u12) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 24),
            };
        }
        /// Month (1..12)
        pub fn MONTH(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 12),
            };
        }
        /// Day of the month (1..31)
        pub fn DAY(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 5),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn YEAR(self: Result) u12 {
            const mask = comptime helpers.generateMask(12, 24);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn MONTH(self: Result) u4 {
            const mask = comptime helpers.generateMask(8, 12);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn DAY(self: Result) u5 {
            const mask = comptime helpers.generateMask(0, 5);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Year
    pub fn YEAR(v: u12) Value {
        return Value.YEAR(.{}, v);
    }
    /// Month (1..12)
    pub fn MONTH(v: u4) Value {
        return Value.MONTH(.{}, v);
    }
    /// Day of the month (1..31)
    pub fn DAY(v: u5) Value {
        return Value.DAY(.{}, v);
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
/// RTC setup register 1
pub const SETUP_1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005c008),
    pub const FieldMasks = struct {
        pub const DOTW: u32 = helpers.generateMask(24, 27);
        pub const HOUR: u32 = helpers.generateMask(16, 21);
        pub const MIN: u32 = helpers.generateMask(8, 14);
        pub const SEC: u32 = helpers.generateMask(0, 6);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Day of the week: 1-Monday...0-Sunday ISO 8601 mod 7
        pub fn DOTW(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 27),
            };
        }
        /// Hours
        pub fn HOUR(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 21),
            };
        }
        /// Minutes
        pub fn MIN(self: Value, v: u6) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 14),
            };
        }
        /// Seconds
        pub fn SEC(self: Value, v: u6) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 6),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn DOTW(self: Result) u3 {
            const mask = comptime helpers.generateMask(24, 27);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn HOUR(self: Result) u5 {
            const mask = comptime helpers.generateMask(16, 21);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn MIN(self: Result) u6 {
            const mask = comptime helpers.generateMask(8, 14);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SEC(self: Result) u6 {
            const mask = comptime helpers.generateMask(0, 6);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Day of the week: 1-Monday...0-Sunday ISO 8601 mod 7
    pub fn DOTW(v: u3) Value {
        return Value.DOTW(.{}, v);
    }
    /// Hours
    pub fn HOUR(v: u5) Value {
        return Value.HOUR(.{}, v);
    }
    /// Minutes
    pub fn MIN(v: u6) Value {
        return Value.MIN(.{}, v);
    }
    /// Seconds
    pub fn SEC(v: u6) Value {
        return Value.SEC(.{}, v);
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
/// RTC Control and status
pub const CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005c00c),
    pub const FieldMasks = struct {
        pub const FORCE_NOTLEAPYEAR: u32 = helpers.generateMask(8, 9);
        pub const LOAD: u32 = helpers.generateMask(4, 5);
        pub const RTC_ACTIVE: u32 = helpers.generateMask(1, 2);
        pub const RTC_ENABLE: u32 = helpers.generateMask(0, 1);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// If set, leapyear is forced off.
        /// Useful for years divisible by 100 but not by 400
        pub fn FORCE_NOTLEAPYEAR(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        /// Load RTC
        pub fn LOAD(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// Enable RTC
        pub fn RTC_ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FORCE_NOTLEAPYEAR(self: Result) u1 {
            const mask = comptime helpers.generateMask(8, 9);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn RTC_ACTIVE(self: Result) u1 {
            const mask = comptime helpers.generateMask(1, 2);
            return @intCast((self.val & mask) >> 1);
        }
        pub fn RTC_ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(0, 1);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// If set, leapyear is forced off.
    /// Useful for years divisible by 100 but not by 400
    pub fn FORCE_NOTLEAPYEAR(v: u1) Value {
        return Value.FORCE_NOTLEAPYEAR(.{}, v);
    }
    /// Load RTC
    pub fn LOAD(v: u1) Value {
        return Value.LOAD(.{}, v);
    }
    /// Enable RTC
    pub fn RTC_ENABLE(v: u1) Value {
        return Value.RTC_ENABLE(.{}, v);
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
/// Interrupt setup register 0
pub const IRQ_SETUP_0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005c010),
    pub const FieldMasks = struct {
        pub const MATCH_ACTIVE: u32 = helpers.generateMask(29, 30);
        pub const MATCH_ENA: u32 = helpers.generateMask(28, 29);
        pub const YEAR_ENA: u32 = helpers.generateMask(26, 27);
        pub const MONTH_ENA: u32 = helpers.generateMask(25, 26);
        pub const DAY_ENA: u32 = helpers.generateMask(24, 25);
        pub const YEAR: u32 = helpers.generateMask(12, 24);
        pub const MONTH: u32 = helpers.generateMask(8, 12);
        pub const DAY: u32 = helpers.generateMask(0, 5);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Global match enable. Don&#39;t change any other value while this one is enabled
        pub fn MATCH_ENA(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        /// Enable year matching
        pub fn YEAR_ENA(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 26),
                .mask = self.mask | comptime helpers.generateMask(26, 27),
            };
        }
        /// Enable month matching
        pub fn MONTH_ENA(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 25),
                .mask = self.mask | comptime helpers.generateMask(25, 26),
            };
        }
        /// Enable day matching
        pub fn DAY_ENA(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
        /// Year
        pub fn YEAR(self: Value, v: u12) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 24),
            };
        }
        /// Month (1..12)
        pub fn MONTH(self: Value, v: u4) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 12),
            };
        }
        /// Day of the month (1..31)
        pub fn DAY(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 5),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn MATCH_ACTIVE(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn MATCH_ENA(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn YEAR_ENA(self: Result) u1 {
            const mask = comptime helpers.generateMask(26, 27);
            return @intCast((self.val & mask) >> 26);
        }
        pub fn MONTH_ENA(self: Result) u1 {
            const mask = comptime helpers.generateMask(25, 26);
            return @intCast((self.val & mask) >> 25);
        }
        pub fn DAY_ENA(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn YEAR(self: Result) u12 {
            const mask = comptime helpers.generateMask(12, 24);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn MONTH(self: Result) u4 {
            const mask = comptime helpers.generateMask(8, 12);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn DAY(self: Result) u5 {
            const mask = comptime helpers.generateMask(0, 5);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Global match enable. Don&#39;t change any other value while this one is enabled
    pub fn MATCH_ENA(v: u1) Value {
        return Value.MATCH_ENA(.{}, v);
    }
    /// Enable year matching
    pub fn YEAR_ENA(v: u1) Value {
        return Value.YEAR_ENA(.{}, v);
    }
    /// Enable month matching
    pub fn MONTH_ENA(v: u1) Value {
        return Value.MONTH_ENA(.{}, v);
    }
    /// Enable day matching
    pub fn DAY_ENA(v: u1) Value {
        return Value.DAY_ENA(.{}, v);
    }
    /// Year
    pub fn YEAR(v: u12) Value {
        return Value.YEAR(.{}, v);
    }
    /// Month (1..12)
    pub fn MONTH(v: u4) Value {
        return Value.MONTH(.{}, v);
    }
    /// Day of the month (1..31)
    pub fn DAY(v: u5) Value {
        return Value.DAY(.{}, v);
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
/// Interrupt setup register 1
pub const IRQ_SETUP_1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005c014),
    pub const FieldMasks = struct {
        pub const DOTW_ENA: u32 = helpers.generateMask(31, 32);
        pub const HOUR_ENA: u32 = helpers.generateMask(30, 31);
        pub const MIN_ENA: u32 = helpers.generateMask(29, 30);
        pub const SEC_ENA: u32 = helpers.generateMask(28, 29);
        pub const DOTW: u32 = helpers.generateMask(24, 27);
        pub const HOUR: u32 = helpers.generateMask(16, 21);
        pub const MIN: u32 = helpers.generateMask(8, 14);
        pub const SEC: u32 = helpers.generateMask(0, 6);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Enable day of the week matching
        pub fn DOTW_ENA(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 31),
                .mask = self.mask | comptime helpers.generateMask(31, 32),
            };
        }
        /// Enable hour matching
        pub fn HOUR_ENA(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 30),
                .mask = self.mask | comptime helpers.generateMask(30, 31),
            };
        }
        /// Enable minute matching
        pub fn MIN_ENA(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 29),
                .mask = self.mask | comptime helpers.generateMask(29, 30),
            };
        }
        /// Enable second matching
        pub fn SEC_ENA(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 28),
                .mask = self.mask | comptime helpers.generateMask(28, 29),
            };
        }
        /// Day of the week
        pub fn DOTW(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 27),
            };
        }
        /// Hours
        pub fn HOUR(self: Value, v: u5) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 21),
            };
        }
        /// Minutes
        pub fn MIN(self: Value, v: u6) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 14),
            };
        }
        /// Seconds
        pub fn SEC(self: Value, v: u6) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 6),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn DOTW_ENA(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn HOUR_ENA(self: Result) u1 {
            const mask = comptime helpers.generateMask(30, 31);
            return @intCast((self.val & mask) >> 30);
        }
        pub fn MIN_ENA(self: Result) u1 {
            const mask = comptime helpers.generateMask(29, 30);
            return @intCast((self.val & mask) >> 29);
        }
        pub fn SEC_ENA(self: Result) u1 {
            const mask = comptime helpers.generateMask(28, 29);
            return @intCast((self.val & mask) >> 28);
        }
        pub fn DOTW(self: Result) u3 {
            const mask = comptime helpers.generateMask(24, 27);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn HOUR(self: Result) u5 {
            const mask = comptime helpers.generateMask(16, 21);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn MIN(self: Result) u6 {
            const mask = comptime helpers.generateMask(8, 14);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SEC(self: Result) u6 {
            const mask = comptime helpers.generateMask(0, 6);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Enable day of the week matching
    pub fn DOTW_ENA(v: u1) Value {
        return Value.DOTW_ENA(.{}, v);
    }
    /// Enable hour matching
    pub fn HOUR_ENA(v: u1) Value {
        return Value.HOUR_ENA(.{}, v);
    }
    /// Enable minute matching
    pub fn MIN_ENA(v: u1) Value {
        return Value.MIN_ENA(.{}, v);
    }
    /// Enable second matching
    pub fn SEC_ENA(v: u1) Value {
        return Value.SEC_ENA(.{}, v);
    }
    /// Day of the week
    pub fn DOTW(v: u3) Value {
        return Value.DOTW(.{}, v);
    }
    /// Hours
    pub fn HOUR(v: u5) Value {
        return Value.HOUR(.{}, v);
    }
    /// Minutes
    pub fn MIN(v: u6) Value {
        return Value.MIN(.{}, v);
    }
    /// Seconds
    pub fn SEC(v: u6) Value {
        return Value.SEC(.{}, v);
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
/// RTC register 1.
pub const RTC_1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005c018),
    pub const FieldMasks = struct {
        pub const YEAR: u32 = helpers.generateMask(12, 24);
        pub const MONTH: u32 = helpers.generateMask(8, 12);
        pub const DAY: u32 = helpers.generateMask(0, 5);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn YEAR(self: Result) u12 {
            const mask = comptime helpers.generateMask(12, 24);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn MONTH(self: Result) u4 {
            const mask = comptime helpers.generateMask(8, 12);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn DAY(self: Result) u5 {
            const mask = comptime helpers.generateMask(0, 5);
            return @intCast((self.val & mask) >> 0);
        }
    };
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
/// RTC register 0
/// Read this before RTC 1!
pub const RTC_0 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005c01c),
    pub const FieldMasks = struct {
        pub const DOTW: u32 = helpers.generateMask(24, 27);
        pub const HOUR: u32 = helpers.generateMask(16, 21);
        pub const MIN: u32 = helpers.generateMask(8, 14);
        pub const SEC: u32 = helpers.generateMask(0, 6);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn DOTW(self: Result) u3 {
            const mask = comptime helpers.generateMask(24, 27);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn HOUR(self: Result) u5 {
            const mask = comptime helpers.generateMask(16, 21);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn MIN(self: Result) u6 {
            const mask = comptime helpers.generateMask(8, 14);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn SEC(self: Result) u6 {
            const mask = comptime helpers.generateMask(0, 6);
            return @intCast((self.val & mask) >> 0);
        }
    };
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
/// Raw Interrupts
pub const INTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005c020),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u1) void {
        self.reg.* = (helpers.toU32(v) << 0);
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
/// Interrupt Enable
pub const INTE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005c024),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u1) void {
        self.reg.* = (helpers.toU32(v) << 0);
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
/// Interrupt Force
pub const INTF = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005c028),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u1) void {
        self.reg.* = (helpers.toU32(v) << 0);
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
/// Interrupt status after masking &amp; forcing
pub const INTS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4005c02c),
    pub fn write(self: @This(), v: u1) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u1) void {
        self.reg.* = (helpers.toU32(v) << 0);
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
/// Register block to control RTC
pub const RTC_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x4005c000),

    /// Divider minus 1 for the 1 second counter. Safe to change the value when RTC is not enabled.
    CLKDIV_M1: CLKDIV_M1 = .{},
    /// RTC setup register 0
    SETUP_0: SETUP_0 = .{},
    /// RTC setup register 1
    SETUP_1: SETUP_1 = .{},
    /// RTC Control and status
    CTRL: CTRL = .{},
    /// Interrupt setup register 0
    IRQ_SETUP_0: IRQ_SETUP_0 = .{},
    /// Interrupt setup register 1
    IRQ_SETUP_1: IRQ_SETUP_1 = .{},
    /// RTC register 1.
    RTC_1: RTC_1 = .{},
    /// RTC register 0
    /// Read this before RTC 1!
    RTC_0: RTC_0 = .{},
    /// Raw Interrupts
    INTR: INTR = .{},
    /// Interrupt Enable
    INTE: INTE = .{},
    /// Interrupt Force
    INTF: INTF = .{},
    /// Interrupt status after masking &amp; forcing
    INTS: INTS = .{},
};
pub const RTC = RTC_p{};
