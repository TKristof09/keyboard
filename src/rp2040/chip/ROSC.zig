const helpers = @import("helpers.zig");
/// Ring Oscillator control
pub const CTRL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40060000),
    pub const FieldMasks = struct {
        pub const ENABLE: u32 = helpers.generateMask(12, 24);
        pub const FREQ_RANGE: u32 = helpers.generateMask(0, 12);
    };
    const ENABLE_e = enum(u12) {
        DISABLE = 3358,
        ENABLE = 4011,
    };
    const FREQ_RANGE_e = enum(u12) {
        LOW = 4004,
        MEDIUM = 4005,
        HIGH = 4007,
        TOOHIGH = 4006,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// On power-up this field is initialised to ENABLE
        /// The system clock must be switched to another source before setting this field to DISABLE otherwise the chip will lock up
        /// The 12-bit code is intended to give some protection against accidental writes. An invalid setting will enable the oscillator.
        pub fn ENABLE(self: Value, v: ENABLE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 24),
            };
        }
        /// Controls the number of delay stages in the ROSC ring
        /// LOW uses stages 0 to 7
        /// MEDIUM uses stages 2 to 7
        /// HIGH uses stages 4 to 7
        /// TOOHIGH uses stages 6 to 7 and should not be used because its frequency exceeds design specifications
        /// The clock output will not glitch when changing the range up one step at a time
        /// The clock output will glitch when changing the range down
        /// Note: the values here are gray coded which is why HIGH comes before TOOHIGH
        pub fn FREQ_RANGE(self: Value, v: FREQ_RANGE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 12),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn ENABLE(self: Result) ENABLE_e {
            const mask = comptime helpers.generateMask(12, 24);
            const val: @typeInfo(ENABLE_e).@"enum".tag_type = @intCast((self.val & mask) >> 12);
            return @enumFromInt(val);
        }
        pub fn FREQ_RANGE(self: Result) FREQ_RANGE_e {
            const mask = comptime helpers.generateMask(0, 12);
            const val: @typeInfo(FREQ_RANGE_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
        }
    };
    /// On power-up this field is initialised to ENABLE
    /// The system clock must be switched to another source before setting this field to DISABLE otherwise the chip will lock up
    /// The 12-bit code is intended to give some protection against accidental writes. An invalid setting will enable the oscillator.
    pub fn ENABLE(v: ENABLE_e) Value {
        return Value.ENABLE(.{}, v);
    }
    /// Controls the number of delay stages in the ROSC ring
    /// LOW uses stages 0 to 7
    /// MEDIUM uses stages 2 to 7
    /// HIGH uses stages 4 to 7
    /// TOOHIGH uses stages 6 to 7 and should not be used because its frequency exceeds design specifications
    /// The clock output will not glitch when changing the range up one step at a time
    /// The clock output will glitch when changing the range down
    /// Note: the values here are gray coded which is why HIGH comes before TOOHIGH
    pub fn FREQ_RANGE(v: FREQ_RANGE_e) Value {
        return Value.FREQ_RANGE(.{}, v);
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
/// The FREQA &amp; FREQB registers control the frequency by controlling the drive strength of each stage
/// The drive strength has 4 levels determined by the number of bits set
/// Increasing the number of bits set increases the drive strength and increases the oscillation frequency
/// 0 bits set is the default drive strength
/// 1 bit set doubles the drive strength
/// 2 bits set triples drive strength
/// 3 bits set quadruples drive strength
pub const FREQA = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40060004),
    pub const FieldMasks = struct {
        pub const PASSWD: u32 = helpers.generateMask(16, 32);
        pub const DS3: u32 = helpers.generateMask(12, 15);
        pub const DS2: u32 = helpers.generateMask(8, 11);
        pub const DS1: u32 = helpers.generateMask(4, 7);
        pub const DS0: u32 = helpers.generateMask(0, 3);
    };
    const PASSWD_e = enum(u16) {
        PASS = 38550,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Set to 0x9696 to apply the settings
        /// Any other value in this field will set all drive strengths to 0
        pub fn PASSWD(self: Value, v: PASSWD_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        /// Stage 3 drive strength
        pub fn DS3(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 15),
            };
        }
        /// Stage 2 drive strength
        pub fn DS2(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 11),
            };
        }
        /// Stage 1 drive strength
        pub fn DS1(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 7),
            };
        }
        /// Stage 0 drive strength
        pub fn DS0(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 3),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn PASSWD(self: Result) PASSWD_e {
            const mask = comptime helpers.generateMask(16, 32);
            const val: @typeInfo(PASSWD_e).@"enum".tag_type = @intCast((self.val & mask) >> 16);
            return @enumFromInt(val);
        }
        pub fn DS3(self: Result) u3 {
            const mask = comptime helpers.generateMask(12, 15);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn DS2(self: Result) u3 {
            const mask = comptime helpers.generateMask(8, 11);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn DS1(self: Result) u3 {
            const mask = comptime helpers.generateMask(4, 7);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DS0(self: Result) u3 {
            const mask = comptime helpers.generateMask(0, 3);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Set to 0x9696 to apply the settings
    /// Any other value in this field will set all drive strengths to 0
    pub fn PASSWD(v: PASSWD_e) Value {
        return Value.PASSWD(.{}, v);
    }
    /// Stage 3 drive strength
    pub fn DS3(v: u3) Value {
        return Value.DS3(.{}, v);
    }
    /// Stage 2 drive strength
    pub fn DS2(v: u3) Value {
        return Value.DS2(.{}, v);
    }
    /// Stage 1 drive strength
    pub fn DS1(v: u3) Value {
        return Value.DS1(.{}, v);
    }
    /// Stage 0 drive strength
    pub fn DS0(v: u3) Value {
        return Value.DS0(.{}, v);
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
/// For a detailed description see freqa register
pub const FREQB = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40060008),
    pub const FieldMasks = struct {
        pub const PASSWD: u32 = helpers.generateMask(16, 32);
        pub const DS7: u32 = helpers.generateMask(12, 15);
        pub const DS6: u32 = helpers.generateMask(8, 11);
        pub const DS5: u32 = helpers.generateMask(4, 7);
        pub const DS4: u32 = helpers.generateMask(0, 3);
    };
    const PASSWD_e = enum(u16) {
        PASS = 38550,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Set to 0x9696 to apply the settings
        /// Any other value in this field will set all drive strengths to 0
        pub fn PASSWD(self: Value, v: PASSWD_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 32),
            };
        }
        /// Stage 7 drive strength
        pub fn DS7(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 15),
            };
        }
        /// Stage 6 drive strength
        pub fn DS6(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 11),
            };
        }
        /// Stage 5 drive strength
        pub fn DS5(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 7),
            };
        }
        /// Stage 4 drive strength
        pub fn DS4(self: Value, v: u3) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 3),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn PASSWD(self: Result) PASSWD_e {
            const mask = comptime helpers.generateMask(16, 32);
            const val: @typeInfo(PASSWD_e).@"enum".tag_type = @intCast((self.val & mask) >> 16);
            return @enumFromInt(val);
        }
        pub fn DS7(self: Result) u3 {
            const mask = comptime helpers.generateMask(12, 15);
            return @intCast((self.val & mask) >> 12);
        }
        pub fn DS6(self: Result) u3 {
            const mask = comptime helpers.generateMask(8, 11);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn DS5(self: Result) u3 {
            const mask = comptime helpers.generateMask(4, 7);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn DS4(self: Result) u3 {
            const mask = comptime helpers.generateMask(0, 3);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Set to 0x9696 to apply the settings
    /// Any other value in this field will set all drive strengths to 0
    pub fn PASSWD(v: PASSWD_e) Value {
        return Value.PASSWD(.{}, v);
    }
    /// Stage 7 drive strength
    pub fn DS7(v: u3) Value {
        return Value.DS7(.{}, v);
    }
    /// Stage 6 drive strength
    pub fn DS6(v: u3) Value {
        return Value.DS6(.{}, v);
    }
    /// Stage 5 drive strength
    pub fn DS5(v: u3) Value {
        return Value.DS5(.{}, v);
    }
    /// Stage 4 drive strength
    pub fn DS4(v: u3) Value {
        return Value.DS4(.{}, v);
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
/// Ring Oscillator pause control
pub const DORMANT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4006000c),
    const DORMANT_e = enum(u32) {
        dormant = 1668246881,
        WAKE = 2002873189,
    };
    pub fn write(self: @This(), v: DORMANT_e) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwWriteMasked(self.reg, helpers.toU32(@intFromEnum(v)) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: DORMANT_e) void {
        self.reg.* = (helpers.toU32(@intFromEnum(v)) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 32);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) DORMANT_e {
        const mask = comptime helpers.generateMask(0, 32);
        return @enumFromInt((self.reg.* & mask) >> 0);
    }
};
/// Controls the output divider
pub const DIV = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40060010),
    const DIV_e = enum(u12) {
        PASS = 2720,
    };
    pub fn write(self: @This(), v: DIV_e) void {
        const mask = comptime helpers.generateMask(0, 12);
        helpers.hwWriteMasked(self.reg, helpers.toU32(@intFromEnum(v)) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: DIV_e) void {
        self.reg.* = (helpers.toU32(@intFromEnum(v)) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 12);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 12);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) DIV_e {
        const mask = comptime helpers.generateMask(0, 12);
        return @enumFromInt((self.reg.* & mask) >> 0);
    }
};
/// Controls the phase shifted output
pub const PHASE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40060014),
    pub const FieldMasks = struct {
        pub const PASSWD: u32 = helpers.generateMask(4, 12);
        pub const ENABLE: u32 = helpers.generateMask(3, 4);
        pub const FLIP: u32 = helpers.generateMask(2, 3);
        pub const SHIFT: u32 = helpers.generateMask(0, 2);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// set to 0xaa
        /// any other value enables the output with shift=0
        pub fn PASSWD(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 12),
            };
        }
        /// enable the phase-shifted output
        /// this can be changed on-the-fly
        pub fn ENABLE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// invert the phase-shifted output
        /// this is ignored when div=1
        pub fn FLIP(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// phase shift the phase-shifted output by SHIFT input clocks
        /// this can be changed on-the-fly
        /// must be set to 0 before setting div=1
        pub fn SHIFT(self: Value, v: u2) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 2),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn PASSWD(self: Result) u8 {
            const mask = comptime helpers.generateMask(4, 12);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn ENABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(3, 4);
            return @intCast((self.val & mask) >> 3);
        }
        pub fn FLIP(self: Result) u1 {
            const mask = comptime helpers.generateMask(2, 3);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn SHIFT(self: Result) u2 {
            const mask = comptime helpers.generateMask(0, 2);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// set to 0xaa
    /// any other value enables the output with shift=0
    pub fn PASSWD(v: u8) Value {
        return Value.PASSWD(.{}, v);
    }
    /// enable the phase-shifted output
    /// this can be changed on-the-fly
    pub fn ENABLE(v: u1) Value {
        return Value.ENABLE(.{}, v);
    }
    /// invert the phase-shifted output
    /// this is ignored when div=1
    pub fn FLIP(v: u1) Value {
        return Value.FLIP(.{}, v);
    }
    /// phase shift the phase-shifted output by SHIFT input clocks
    /// this can be changed on-the-fly
    /// must be set to 0 before setting div=1
    pub fn SHIFT(v: u2) Value {
        return Value.SHIFT(.{}, v);
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
/// Ring Oscillator Status
pub const STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40060018),
    pub const FieldMasks = struct {
        pub const STABLE: u32 = helpers.generateMask(31, 32);
        pub const BADWRITE: u32 = helpers.generateMask(24, 25);
        pub const DIV_RUNNING: u32 = helpers.generateMask(16, 17);
        pub const ENABLED: u32 = helpers.generateMask(12, 13);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// An invalid value has been written to CTRL_ENABLE or CTRL_FREQ_RANGE or FREQA or FREQB or DIV or PHASE or DORMANT
        pub fn BADWRITE(self: Value, v: u1) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 24),
                .mask = self.mask | comptime helpers.generateMask(24, 25),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn STABLE(self: Result) u1 {
            const mask = comptime helpers.generateMask(31, 32);
            return @intCast((self.val & mask) >> 31);
        }
        pub fn BADWRITE(self: Result) u1 {
            const mask = comptime helpers.generateMask(24, 25);
            return @intCast((self.val & mask) >> 24);
        }
        pub fn DIV_RUNNING(self: Result) u1 {
            const mask = comptime helpers.generateMask(16, 17);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn ENABLED(self: Result) u1 {
            const mask = comptime helpers.generateMask(12, 13);
            return @intCast((self.val & mask) >> 12);
        }
    };
    /// An invalid value has been written to CTRL_ENABLE or CTRL_FREQ_RANGE or FREQA or FREQB or DIV or PHASE or DORMANT
    pub fn BADWRITE(v: u1) Value {
        return Value.BADWRITE(.{}, v);
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
/// This just reads the state of the oscillator output so randomness is compromised if the ring oscillator is stopped or run at a harmonic of the bus frequency
pub const RANDOMBIT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4006001c),
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
/// A down counter running at the ROSC frequency which counts to zero and stops.
/// To start the counter write a non-zero value.
/// Can be used for short software pauses when setting up time sensitive hardware.
pub const COUNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40060020),
    pub fn write(self: @This(), v: u8) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u8) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 8);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u8 {
        const mask = comptime helpers.generateMask(0, 8);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
pub const ROSC_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x40060000),

    /// Ring Oscillator control
    CTRL: CTRL = .{},
    /// The FREQA &amp; FREQB registers control the frequency by controlling the drive strength of each stage
    /// The drive strength has 4 levels determined by the number of bits set
    /// Increasing the number of bits set increases the drive strength and increases the oscillation frequency
    /// 0 bits set is the default drive strength
    /// 1 bit set doubles the drive strength
    /// 2 bits set triples drive strength
    /// 3 bits set quadruples drive strength
    FREQA: FREQA = .{},
    /// For a detailed description see freqa register
    FREQB: FREQB = .{},
    /// Ring Oscillator pause control
    DORMANT: DORMANT = .{},
    /// Controls the output divider
    DIV: DIV = .{},
    /// Controls the phase shifted output
    PHASE: PHASE = .{},
    /// Ring Oscillator Status
    STATUS: STATUS = .{},
    /// This just reads the state of the oscillator output so randomness is compromised if the ring oscillator is stopped or run at a harmonic of the bus frequency
    RANDOMBIT: RANDOMBIT = .{},
    /// A down counter running at the ROSC frequency which counts to zero and stops.
    /// To start the counter write a non-zero value.
    /// Can be used for short software pauses when setting up time sensitive hardware.
    COUNT: COUNT = .{},
};
pub const ROSC = ROSC_p{};
