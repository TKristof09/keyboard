const helpers = @import("helpers.zig");
/// I2C Control Register. This register can be written only when the DW_apb_i2c is disabled, which corresponds to the IC_ENABLE[0] register being set to 0. Writes at other times have no effect.
///
/// Read/Write Access: - bit 10 is read only. - bit 11 is read only - bit 16 is read only - bit 17 is read only - bits 18 and 19 are read only.
pub const IC_CON = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048000),
    pub const FieldMasks = struct {
        pub const STOP_DET_IF_MASTER_ACTIVE: u32 = helpers.generateMask(10, 11);
        pub const RX_FIFO_FULL_HLD_CTRL: u32 = helpers.generateMask(9, 10);
        pub const TX_EMPTY_CTRL: u32 = helpers.generateMask(8, 9);
        pub const STOP_DET_IFADDRESSED: u32 = helpers.generateMask(7, 8);
        pub const IC_SLAVE_DISABLE: u32 = helpers.generateMask(6, 7);
        pub const IC_RESTART_EN: u32 = helpers.generateMask(5, 6);
        pub const IC_10BITADDR_MASTER: u32 = helpers.generateMask(4, 5);
        pub const IC_10BITADDR_SLAVE: u32 = helpers.generateMask(3, 4);
        pub const SPEED: u32 = helpers.generateMask(1, 3);
        pub const MASTER_MODE: u32 = helpers.generateMask(0, 1);
    };
    const RX_FIFO_FULL_HLD_CTRL_e = enum(u1) {
        DISABLED = 0,
        ENABLED = 1,
    };
    const TX_EMPTY_CTRL_e = enum(u1) {
        DISABLED = 0,
        ENABLED = 1,
    };
    const STOP_DET_IFADDRESSED_e = enum(u1) {
        DISABLED = 0,
        ENABLED = 1,
    };
    const IC_SLAVE_DISABLE_e = enum(u1) {
        SLAVE_ENABLED = 0,
        SLAVE_DISABLED = 1,
    };
    const IC_RESTART_EN_e = enum(u1) {
        DISABLED = 0,
        ENABLED = 1,
    };
    const IC_10BITADDR_MASTER_e = enum(u1) {
        ADDR_7BITS = 0,
        ADDR_10BITS = 1,
    };
    const IC_10BITADDR_SLAVE_e = enum(u1) {
        ADDR_7BITS = 0,
        ADDR_10BITS = 1,
    };
    const SPEED_e = enum(u2) {
        STANDARD = 1,
        FAST = 2,
        HIGH = 3,
    };
    const MASTER_MODE_e = enum(u1) {
        DISABLED = 0,
        ENABLED = 1,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// This bit controls whether DW_apb_i2c should hold the bus when the Rx FIFO is physically full to its RX_BUFFER_DEPTH, as described in the IC_RX_FULL_HLD_BUS_EN parameter.
        ///
        /// Reset value: 0x0.
        pub fn RX_FIFO_FULL_HLD_CTRL(self: Value, v: RX_FIFO_FULL_HLD_CTRL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        /// This bit controls the generation of the TX_EMPTY interrupt, as described in the IC_RAW_INTR_STAT register.
        ///
        /// Reset value: 0x0.
        pub fn TX_EMPTY_CTRL(self: Value, v: TX_EMPTY_CTRL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        /// In slave mode: - 1&#39;b1:  issues the STOP_DET interrupt only when it is addressed. - 1&#39;b0:  issues the STOP_DET irrespective of whether it&#39;s addressed or not. Reset value: 0x0
        ///
        /// NOTE: During a general call address, this slave does not issue the STOP_DET interrupt if STOP_DET_IF_ADDRESSED = 1&#39;b1, even if the slave responds to the general call address by generating ACK. The STOP_DET interrupt is generated only when the transmitted address matches the slave address (SAR).
        pub fn STOP_DET_IFADDRESSED(self: Value, v: STOP_DET_IFADDRESSED_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// This bit controls whether I2C has its slave disabled, which means once the presetn signal is applied, then this bit is set and the slave is disabled.
        ///
        /// If this bit is set (slave is disabled), DW_apb_i2c functions only as a master and does not perform any action that requires a slave.
        ///
        /// NOTE: Software should ensure that if this bit is written with 0, then bit 0 should also be written with a 0.
        pub fn IC_SLAVE_DISABLE(self: Value, v: IC_SLAVE_DISABLE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// Determines whether RESTART conditions may be sent when acting as a master. Some older slaves do not support handling RESTART conditions; however, RESTART conditions are used in several DW_apb_i2c operations. When RESTART is disabled, the master is prohibited from performing the following functions: - Sending a START BYTE - Performing any high-speed mode operation - High-speed mode operation - Performing direction changes in combined format mode - Performing a read operation with a 10-bit address By replacing RESTART condition followed by a STOP and a subsequent START condition, split operations are broken down into multiple DW_apb_i2c transfers. If the above operations are performed, it will result in setting bit 6 (TX_ABRT) of the IC_RAW_INTR_STAT register.
        ///
        /// Reset value: ENABLED
        pub fn IC_RESTART_EN(self: Value, v: IC_RESTART_EN_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// Controls whether the DW_apb_i2c starts its transfers in 7- or 10-bit addressing mode when acting as a master. - 0: 7-bit addressing - 1: 10-bit addressing
        pub fn IC_10BITADDR_MASTER(self: Value, v: IC_10BITADDR_MASTER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// When acting as a slave, this bit controls whether the DW_apb_i2c responds to 7- or 10-bit addresses. - 0: 7-bit addressing. The DW_apb_i2c ignores transactions that involve 10-bit addressing; for 7-bit addressing, only the lower 7 bits of the IC_SAR register are compared. - 1: 10-bit addressing. The DW_apb_i2c responds to only 10-bit addressing transfers that match the full 10 bits of the IC_SAR register.
        pub fn IC_10BITADDR_SLAVE(self: Value, v: IC_10BITADDR_SLAVE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// These bits control at which speed the DW_apb_i2c operates; its setting is relevant only if one is operating the DW_apb_i2c in master mode. Hardware protects against illegal values being programmed by software. These bits must be programmed appropriately for slave mode also, as it is used to capture correct value of spike filter as per the speed mode.
        ///
        /// This register should be programmed only with a value in the range of 1 to IC_MAX_SPEED_MODE; otherwise, hardware updates this register with the value of IC_MAX_SPEED_MODE.
        ///
        /// 1: standard mode (100 kbit/s)
        ///
        /// 2: fast mode (&lt;=400 kbit/s) or fast mode plus (&lt;=1000Kbit/s)
        ///
        /// 3: high speed mode (3.4 Mbit/s)
        ///
        /// Note: This field is not applicable when IC_ULTRA_FAST_MODE=1
        pub fn SPEED(self: Value, v: SPEED_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 3),
            };
        }
        /// This bit controls whether the DW_apb_i2c master is enabled.
        ///
        /// NOTE: Software should ensure that if this bit is written with &#39;1&#39; then bit 6 should also be written with a &#39;1&#39;.
        pub fn MASTER_MODE(self: Value, v: MASTER_MODE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn STOP_DET_IF_MASTER_ACTIVE(self: Result) u1 {
            const mask = comptime helpers.generateMask(10, 11);
            return @intCast((self.val & mask) >> 10);
        }
        pub fn RX_FIFO_FULL_HLD_CTRL(self: Result) RX_FIFO_FULL_HLD_CTRL_e {
            const mask = comptime helpers.generateMask(9, 10);
            const val: @typeInfo(RX_FIFO_FULL_HLD_CTRL_e).@"enum".tag_type = @intCast((self.val & mask) >> 9);
            return @enumFromInt(val);
        }
        pub fn TX_EMPTY_CTRL(self: Result) TX_EMPTY_CTRL_e {
            const mask = comptime helpers.generateMask(8, 9);
            const val: @typeInfo(TX_EMPTY_CTRL_e).@"enum".tag_type = @intCast((self.val & mask) >> 8);
            return @enumFromInt(val);
        }
        pub fn STOP_DET_IFADDRESSED(self: Result) STOP_DET_IFADDRESSED_e {
            const mask = comptime helpers.generateMask(7, 8);
            const val: @typeInfo(STOP_DET_IFADDRESSED_e).@"enum".tag_type = @intCast((self.val & mask) >> 7);
            return @enumFromInt(val);
        }
        pub fn IC_SLAVE_DISABLE(self: Result) IC_SLAVE_DISABLE_e {
            const mask = comptime helpers.generateMask(6, 7);
            const val: @typeInfo(IC_SLAVE_DISABLE_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn IC_RESTART_EN(self: Result) IC_RESTART_EN_e {
            const mask = comptime helpers.generateMask(5, 6);
            const val: @typeInfo(IC_RESTART_EN_e).@"enum".tag_type = @intCast((self.val & mask) >> 5);
            return @enumFromInt(val);
        }
        pub fn IC_10BITADDR_MASTER(self: Result) IC_10BITADDR_MASTER_e {
            const mask = comptime helpers.generateMask(4, 5);
            const val: @typeInfo(IC_10BITADDR_MASTER_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn IC_10BITADDR_SLAVE(self: Result) IC_10BITADDR_SLAVE_e {
            const mask = comptime helpers.generateMask(3, 4);
            const val: @typeInfo(IC_10BITADDR_SLAVE_e).@"enum".tag_type = @intCast((self.val & mask) >> 3);
            return @enumFromInt(val);
        }
        pub fn SPEED(self: Result) SPEED_e {
            const mask = comptime helpers.generateMask(1, 3);
            const val: @typeInfo(SPEED_e).@"enum".tag_type = @intCast((self.val & mask) >> 1);
            return @enumFromInt(val);
        }
        pub fn MASTER_MODE(self: Result) MASTER_MODE_e {
            const mask = comptime helpers.generateMask(0, 1);
            const val: @typeInfo(MASTER_MODE_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
        }
    };
    /// This bit controls whether DW_apb_i2c should hold the bus when the Rx FIFO is physically full to its RX_BUFFER_DEPTH, as described in the IC_RX_FULL_HLD_BUS_EN parameter.
    ///
    /// Reset value: 0x0.
    pub fn RX_FIFO_FULL_HLD_CTRL(v: RX_FIFO_FULL_HLD_CTRL_e) Value {
        return Value.RX_FIFO_FULL_HLD_CTRL(.{}, v);
    }
    /// This bit controls the generation of the TX_EMPTY interrupt, as described in the IC_RAW_INTR_STAT register.
    ///
    /// Reset value: 0x0.
    pub fn TX_EMPTY_CTRL(v: TX_EMPTY_CTRL_e) Value {
        return Value.TX_EMPTY_CTRL(.{}, v);
    }
    /// In slave mode: - 1&#39;b1:  issues the STOP_DET interrupt only when it is addressed. - 1&#39;b0:  issues the STOP_DET irrespective of whether it&#39;s addressed or not. Reset value: 0x0
    ///
    /// NOTE: During a general call address, this slave does not issue the STOP_DET interrupt if STOP_DET_IF_ADDRESSED = 1&#39;b1, even if the slave responds to the general call address by generating ACK. The STOP_DET interrupt is generated only when the transmitted address matches the slave address (SAR).
    pub fn STOP_DET_IFADDRESSED(v: STOP_DET_IFADDRESSED_e) Value {
        return Value.STOP_DET_IFADDRESSED(.{}, v);
    }
    /// This bit controls whether I2C has its slave disabled, which means once the presetn signal is applied, then this bit is set and the slave is disabled.
    ///
    /// If this bit is set (slave is disabled), DW_apb_i2c functions only as a master and does not perform any action that requires a slave.
    ///
    /// NOTE: Software should ensure that if this bit is written with 0, then bit 0 should also be written with a 0.
    pub fn IC_SLAVE_DISABLE(v: IC_SLAVE_DISABLE_e) Value {
        return Value.IC_SLAVE_DISABLE(.{}, v);
    }
    /// Determines whether RESTART conditions may be sent when acting as a master. Some older slaves do not support handling RESTART conditions; however, RESTART conditions are used in several DW_apb_i2c operations. When RESTART is disabled, the master is prohibited from performing the following functions: - Sending a START BYTE - Performing any high-speed mode operation - High-speed mode operation - Performing direction changes in combined format mode - Performing a read operation with a 10-bit address By replacing RESTART condition followed by a STOP and a subsequent START condition, split operations are broken down into multiple DW_apb_i2c transfers. If the above operations are performed, it will result in setting bit 6 (TX_ABRT) of the IC_RAW_INTR_STAT register.
    ///
    /// Reset value: ENABLED
    pub fn IC_RESTART_EN(v: IC_RESTART_EN_e) Value {
        return Value.IC_RESTART_EN(.{}, v);
    }
    /// Controls whether the DW_apb_i2c starts its transfers in 7- or 10-bit addressing mode when acting as a master. - 0: 7-bit addressing - 1: 10-bit addressing
    pub fn IC_10BITADDR_MASTER(v: IC_10BITADDR_MASTER_e) Value {
        return Value.IC_10BITADDR_MASTER(.{}, v);
    }
    /// When acting as a slave, this bit controls whether the DW_apb_i2c responds to 7- or 10-bit addresses. - 0: 7-bit addressing. The DW_apb_i2c ignores transactions that involve 10-bit addressing; for 7-bit addressing, only the lower 7 bits of the IC_SAR register are compared. - 1: 10-bit addressing. The DW_apb_i2c responds to only 10-bit addressing transfers that match the full 10 bits of the IC_SAR register.
    pub fn IC_10BITADDR_SLAVE(v: IC_10BITADDR_SLAVE_e) Value {
        return Value.IC_10BITADDR_SLAVE(.{}, v);
    }
    /// These bits control at which speed the DW_apb_i2c operates; its setting is relevant only if one is operating the DW_apb_i2c in master mode. Hardware protects against illegal values being programmed by software. These bits must be programmed appropriately for slave mode also, as it is used to capture correct value of spike filter as per the speed mode.
    ///
    /// This register should be programmed only with a value in the range of 1 to IC_MAX_SPEED_MODE; otherwise, hardware updates this register with the value of IC_MAX_SPEED_MODE.
    ///
    /// 1: standard mode (100 kbit/s)
    ///
    /// 2: fast mode (&lt;=400 kbit/s) or fast mode plus (&lt;=1000Kbit/s)
    ///
    /// 3: high speed mode (3.4 Mbit/s)
    ///
    /// Note: This field is not applicable when IC_ULTRA_FAST_MODE=1
    pub fn SPEED(v: SPEED_e) Value {
        return Value.SPEED(.{}, v);
    }
    /// This bit controls whether the DW_apb_i2c master is enabled.
    ///
    /// NOTE: Software should ensure that if this bit is written with &#39;1&#39; then bit 6 should also be written with a &#39;1&#39;.
    pub fn MASTER_MODE(v: MASTER_MODE_e) Value {
        return Value.MASTER_MODE(.{}, v);
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
/// I2C Target Address Register
///
/// This register is 12 bits wide, and bits 31:12 are reserved. This register can be written to only when IC_ENABLE[0] is set to 0.
///
/// Note: If the software or application is aware that the DW_apb_i2c is not using the TAR address for the pending commands in the Tx FIFO, then it is possible to update the TAR address even while the Tx FIFO has entries (IC_STATUS[2]= 0). - It is not necessary to perform any write to this register if DW_apb_i2c is enabled as an I2C slave only.
pub const IC_TAR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048004),
    pub const FieldMasks = struct {
        pub const SPECIAL: u32 = helpers.generateMask(11, 12);
        pub const GC_OR_START: u32 = helpers.generateMask(10, 11);
        pub const IC_TAR: u32 = helpers.generateMask(0, 10);
    };
    const SPECIAL_e = enum(u1) {
        DISABLED = 0,
        ENABLED = 1,
    };
    const GC_OR_START_e = enum(u1) {
        GENERAL_CALL = 0,
        START_BYTE = 1,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// This bit indicates whether software performs a Device-ID or General Call or START BYTE command. - 0: ignore bit 10 GC_OR_START and use IC_TAR normally - 1: perform special I2C command as specified in Device_ID or GC_OR_START bit Reset value: 0x0
        pub fn SPECIAL(self: Value, v: SPECIAL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// If bit 11 (SPECIAL) is set to 1 and bit 13(Device-ID) is set to 0, then this bit indicates whether a General Call or START byte command is to be performed by the DW_apb_i2c. - 0: General Call Address - after issuing a General Call, only writes may be performed. Attempting to issue a read command results in setting bit 6 (TX_ABRT) of the IC_RAW_INTR_STAT register. The DW_apb_i2c remains in General Call mode until the SPECIAL bit value (bit 11) is cleared. - 1: START BYTE Reset value: 0x0
        pub fn GC_OR_START(self: Value, v: GC_OR_START_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// This is the target address for any master transaction. When transmitting a General Call, these bits are ignored. To generate a START BYTE, the CPU needs to write only once into these bits.
        ///
        /// If the IC_TAR and IC_SAR are the same, loopback exists but the FIFOs are shared between master and slave, so full loopback is not feasible. Only one direction loopback mode is supported (simplex), not duplex. A master cannot transmit to itself; it can transmit to only a slave.
        pub fn IC_TAR(self: Value, v: u10) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 10),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn SPECIAL(self: Result) SPECIAL_e {
            const mask = comptime helpers.generateMask(11, 12);
            const val: @typeInfo(SPECIAL_e).@"enum".tag_type = @intCast((self.val & mask) >> 11);
            return @enumFromInt(val);
        }
        pub fn GC_OR_START(self: Result) GC_OR_START_e {
            const mask = comptime helpers.generateMask(10, 11);
            const val: @typeInfo(GC_OR_START_e).@"enum".tag_type = @intCast((self.val & mask) >> 10);
            return @enumFromInt(val);
        }
        pub fn IC_TAR(self: Result) u10 {
            const mask = comptime helpers.generateMask(0, 10);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// This bit indicates whether software performs a Device-ID or General Call or START BYTE command. - 0: ignore bit 10 GC_OR_START and use IC_TAR normally - 1: perform special I2C command as specified in Device_ID or GC_OR_START bit Reset value: 0x0
    pub fn SPECIAL(v: SPECIAL_e) Value {
        return Value.SPECIAL(.{}, v);
    }
    /// If bit 11 (SPECIAL) is set to 1 and bit 13(Device-ID) is set to 0, then this bit indicates whether a General Call or START byte command is to be performed by the DW_apb_i2c. - 0: General Call Address - after issuing a General Call, only writes may be performed. Attempting to issue a read command results in setting bit 6 (TX_ABRT) of the IC_RAW_INTR_STAT register. The DW_apb_i2c remains in General Call mode until the SPECIAL bit value (bit 11) is cleared. - 1: START BYTE Reset value: 0x0
    pub fn GC_OR_START(v: GC_OR_START_e) Value {
        return Value.GC_OR_START(.{}, v);
    }
    /// This is the target address for any master transaction. When transmitting a General Call, these bits are ignored. To generate a START BYTE, the CPU needs to write only once into these bits.
    ///
    /// If the IC_TAR and IC_SAR are the same, loopback exists but the FIFOs are shared between master and slave, so full loopback is not feasible. Only one direction loopback mode is supported (simplex), not duplex. A master cannot transmit to itself; it can transmit to only a slave.
    pub fn IC_TAR(v: u10) Value {
        return Value.IC_TAR(.{}, v);
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
/// I2C Slave Address Register
pub const IC_SAR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048008),
    pub fn write(self: @This(), v: u10) void {
        const mask = comptime helpers.generateMask(0, 10);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u10) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 10);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 10);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u10 {
        const mask = comptime helpers.generateMask(0, 10);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// I2C Rx/Tx Data Buffer and Command Register; this is the register the CPU writes to when filling the TX FIFO and the CPU reads from when retrieving bytes from RX FIFO.
///
/// The size of the register changes as follows:
///
/// Write: - 11 bits when IC_EMPTYFIFO_HOLD_MASTER_EN=1 - 9 bits when IC_EMPTYFIFO_HOLD_MASTER_EN=0 Read: - 12 bits when IC_FIRST_DATA_BYTE_STATUS = 1 - 8 bits when IC_FIRST_DATA_BYTE_STATUS = 0 Note: In order for the DW_apb_i2c to continue acknowledging reads, a read command should be written for every byte that is to be received; otherwise the DW_apb_i2c will stop acknowledging.
pub const IC_DATA_CMD = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048010),
    pub const FieldMasks = struct {
        pub const FIRST_DATA_BYTE: u32 = helpers.generateMask(11, 12);
        pub const RESTART: u32 = helpers.generateMask(10, 11);
        pub const STOP: u32 = helpers.generateMask(9, 10);
        pub const CMD: u32 = helpers.generateMask(8, 9);
        pub const DAT: u32 = helpers.generateMask(0, 8);
    };
    const FIRST_DATA_BYTE_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const RESTART_e = enum(u1) {
        DISABLE = 0,
        ENABLE = 1,
    };
    const STOP_e = enum(u1) {
        DISABLE = 0,
        ENABLE = 1,
    };
    const CMD_e = enum(u1) {
        WRITE = 0,
        READ = 1,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// This bit controls whether a RESTART is issued before the byte is sent or received.
        ///
        /// 1 - If IC_RESTART_EN is 1, a RESTART is issued before the data is sent/received (according to the value of CMD), regardless of whether or not the transfer direction is changing from the previous command; if IC_RESTART_EN is 0, a STOP followed by a START is issued instead.
        ///
        /// 0 - If IC_RESTART_EN is 1, a RESTART is issued only if the transfer direction is changing from the previous command; if IC_RESTART_EN is 0, a STOP followed by a START is issued instead.
        ///
        /// Reset value: 0x0
        pub fn RESTART(self: Value, v: RESTART_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// This bit controls whether a STOP is issued after the byte is sent or received.
        ///
        /// - 1 - STOP is issued after this byte, regardless of whether or not the Tx FIFO is empty. If the Tx FIFO is not empty, the master immediately tries to start a new transfer by issuing a START and arbitrating for the bus. - 0 - STOP is not issued after this byte, regardless of whether or not the Tx FIFO is empty. If the Tx FIFO is not empty, the master continues the current transfer by sending/receiving data bytes according to the value of the CMD bit. If the Tx FIFO is empty, the master holds the SCL line low and stalls the bus until a new command is available in the Tx FIFO. Reset value: 0x0
        pub fn STOP(self: Value, v: STOP_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        /// This bit controls whether a read or a write is performed. This bit does not control the direction when the DW_apb_i2con acts as a slave. It controls only the direction when it acts as a master.
        ///
        /// When a command is entered in the TX FIFO, this bit distinguishes the write and read commands. In slave-receiver mode, this bit is a &#39;don&#39;t care&#39; because writes to this register are not required. In slave-transmitter mode, a &#39;0&#39; indicates that the data in IC_DATA_CMD is to be transmitted.
        ///
        /// When programming this bit, you should remember the following: attempting to perform a read operation after a General Call command has been sent results in a TX_ABRT interrupt (bit 6 of the IC_RAW_INTR_STAT register), unless bit 11 (SPECIAL) in the IC_TAR register has been cleared. If a &#39;1&#39; is written to this bit after receiving a RD_REQ interrupt, then a TX_ABRT interrupt occurs.
        ///
        /// Reset value: 0x0
        pub fn CMD(self: Value, v: CMD_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        /// This register contains the data to be transmitted or received on the I2C bus. If you are writing to this register and want to perform a read, bits 7:0 (DAT) are ignored by the DW_apb_i2c. However, when you read this register, these bits return the value of data received on the DW_apb_i2c interface.
        ///
        /// Reset value: 0x0
        pub fn DAT(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 8),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn FIRST_DATA_BYTE(self: Result) FIRST_DATA_BYTE_e {
            const mask = comptime helpers.generateMask(11, 12);
            const val: @typeInfo(FIRST_DATA_BYTE_e).@"enum".tag_type = @intCast((self.val & mask) >> 11);
            return @enumFromInt(val);
        }
        pub fn DAT(self: Result) u8 {
            const mask = comptime helpers.generateMask(0, 8);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// This bit controls whether a RESTART is issued before the byte is sent or received.
    ///
    /// 1 - If IC_RESTART_EN is 1, a RESTART is issued before the data is sent/received (according to the value of CMD), regardless of whether or not the transfer direction is changing from the previous command; if IC_RESTART_EN is 0, a STOP followed by a START is issued instead.
    ///
    /// 0 - If IC_RESTART_EN is 1, a RESTART is issued only if the transfer direction is changing from the previous command; if IC_RESTART_EN is 0, a STOP followed by a START is issued instead.
    ///
    /// Reset value: 0x0
    pub fn RESTART(v: RESTART_e) Value {
        return Value.RESTART(.{}, v);
    }
    /// This bit controls whether a STOP is issued after the byte is sent or received.
    ///
    /// - 1 - STOP is issued after this byte, regardless of whether or not the Tx FIFO is empty. If the Tx FIFO is not empty, the master immediately tries to start a new transfer by issuing a START and arbitrating for the bus. - 0 - STOP is not issued after this byte, regardless of whether or not the Tx FIFO is empty. If the Tx FIFO is not empty, the master continues the current transfer by sending/receiving data bytes according to the value of the CMD bit. If the Tx FIFO is empty, the master holds the SCL line low and stalls the bus until a new command is available in the Tx FIFO. Reset value: 0x0
    pub fn STOP(v: STOP_e) Value {
        return Value.STOP(.{}, v);
    }
    /// This bit controls whether a read or a write is performed. This bit does not control the direction when the DW_apb_i2con acts as a slave. It controls only the direction when it acts as a master.
    ///
    /// When a command is entered in the TX FIFO, this bit distinguishes the write and read commands. In slave-receiver mode, this bit is a &#39;don&#39;t care&#39; because writes to this register are not required. In slave-transmitter mode, a &#39;0&#39; indicates that the data in IC_DATA_CMD is to be transmitted.
    ///
    /// When programming this bit, you should remember the following: attempting to perform a read operation after a General Call command has been sent results in a TX_ABRT interrupt (bit 6 of the IC_RAW_INTR_STAT register), unless bit 11 (SPECIAL) in the IC_TAR register has been cleared. If a &#39;1&#39; is written to this bit after receiving a RD_REQ interrupt, then a TX_ABRT interrupt occurs.
    ///
    /// Reset value: 0x0
    pub fn CMD(v: CMD_e) Value {
        return Value.CMD(.{}, v);
    }
    /// This register contains the data to be transmitted or received on the I2C bus. If you are writing to this register and want to perform a read, bits 7:0 (DAT) are ignored by the DW_apb_i2c. However, when you read this register, these bits return the value of data received on the DW_apb_i2c interface.
    ///
    /// Reset value: 0x0
    pub fn DAT(v: u8) Value {
        return Value.DAT(.{}, v);
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
/// Standard Speed I2C Clock SCL High Count Register
pub const IC_SS_SCL_HCNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048014),
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
/// Standard Speed I2C Clock SCL Low Count Register
pub const IC_SS_SCL_LCNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048018),
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
/// Fast Mode or Fast Mode Plus I2C Clock SCL High Count Register
pub const IC_FS_SCL_HCNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4004801c),
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
/// Fast Mode or Fast Mode Plus I2C Clock SCL Low Count Register
pub const IC_FS_SCL_LCNT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048020),
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
/// I2C Interrupt Status Register
///
/// Each bit in this register has a corresponding mask bit in the IC_INTR_MASK register. These bits are cleared by reading the matching interrupt clear register. The unmasked raw versions of these bits are available in the IC_RAW_INTR_STAT register.
pub const IC_INTR_STAT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4004802c),
    pub const FieldMasks = struct {
        pub const R_RESTART_DET: u32 = helpers.generateMask(12, 13);
        pub const R_GEN_CALL: u32 = helpers.generateMask(11, 12);
        pub const R_START_DET: u32 = helpers.generateMask(10, 11);
        pub const R_STOP_DET: u32 = helpers.generateMask(9, 10);
        pub const R_ACTIVITY: u32 = helpers.generateMask(8, 9);
        pub const R_RX_DONE: u32 = helpers.generateMask(7, 8);
        pub const R_TX_ABRT: u32 = helpers.generateMask(6, 7);
        pub const R_RD_REQ: u32 = helpers.generateMask(5, 6);
        pub const R_TX_EMPTY: u32 = helpers.generateMask(4, 5);
        pub const R_TX_OVER: u32 = helpers.generateMask(3, 4);
        pub const R_RX_FULL: u32 = helpers.generateMask(2, 3);
        pub const R_RX_OVER: u32 = helpers.generateMask(1, 2);
        pub const R_RX_UNDER: u32 = helpers.generateMask(0, 1);
    };
    const R_RESTART_DET_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const R_GEN_CALL_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const R_START_DET_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const R_STOP_DET_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const R_ACTIVITY_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const R_RX_DONE_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const R_TX_ABRT_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const R_RD_REQ_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const R_TX_EMPTY_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const R_TX_OVER_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const R_RX_FULL_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const R_RX_OVER_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const R_RX_UNDER_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn R_RESTART_DET(self: Result) R_RESTART_DET_e {
            const mask = comptime helpers.generateMask(12, 13);
            const val: @typeInfo(R_RESTART_DET_e).@"enum".tag_type = @intCast((self.val & mask) >> 12);
            return @enumFromInt(val);
        }
        pub fn R_GEN_CALL(self: Result) R_GEN_CALL_e {
            const mask = comptime helpers.generateMask(11, 12);
            const val: @typeInfo(R_GEN_CALL_e).@"enum".tag_type = @intCast((self.val & mask) >> 11);
            return @enumFromInt(val);
        }
        pub fn R_START_DET(self: Result) R_START_DET_e {
            const mask = comptime helpers.generateMask(10, 11);
            const val: @typeInfo(R_START_DET_e).@"enum".tag_type = @intCast((self.val & mask) >> 10);
            return @enumFromInt(val);
        }
        pub fn R_STOP_DET(self: Result) R_STOP_DET_e {
            const mask = comptime helpers.generateMask(9, 10);
            const val: @typeInfo(R_STOP_DET_e).@"enum".tag_type = @intCast((self.val & mask) >> 9);
            return @enumFromInt(val);
        }
        pub fn R_ACTIVITY(self: Result) R_ACTIVITY_e {
            const mask = comptime helpers.generateMask(8, 9);
            const val: @typeInfo(R_ACTIVITY_e).@"enum".tag_type = @intCast((self.val & mask) >> 8);
            return @enumFromInt(val);
        }
        pub fn R_RX_DONE(self: Result) R_RX_DONE_e {
            const mask = comptime helpers.generateMask(7, 8);
            const val: @typeInfo(R_RX_DONE_e).@"enum".tag_type = @intCast((self.val & mask) >> 7);
            return @enumFromInt(val);
        }
        pub fn R_TX_ABRT(self: Result) R_TX_ABRT_e {
            const mask = comptime helpers.generateMask(6, 7);
            const val: @typeInfo(R_TX_ABRT_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn R_RD_REQ(self: Result) R_RD_REQ_e {
            const mask = comptime helpers.generateMask(5, 6);
            const val: @typeInfo(R_RD_REQ_e).@"enum".tag_type = @intCast((self.val & mask) >> 5);
            return @enumFromInt(val);
        }
        pub fn R_TX_EMPTY(self: Result) R_TX_EMPTY_e {
            const mask = comptime helpers.generateMask(4, 5);
            const val: @typeInfo(R_TX_EMPTY_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn R_TX_OVER(self: Result) R_TX_OVER_e {
            const mask = comptime helpers.generateMask(3, 4);
            const val: @typeInfo(R_TX_OVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 3);
            return @enumFromInt(val);
        }
        pub fn R_RX_FULL(self: Result) R_RX_FULL_e {
            const mask = comptime helpers.generateMask(2, 3);
            const val: @typeInfo(R_RX_FULL_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn R_RX_OVER(self: Result) R_RX_OVER_e {
            const mask = comptime helpers.generateMask(1, 2);
            const val: @typeInfo(R_RX_OVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 1);
            return @enumFromInt(val);
        }
        pub fn R_RX_UNDER(self: Result) R_RX_UNDER_e {
            const mask = comptime helpers.generateMask(0, 1);
            const val: @typeInfo(R_RX_UNDER_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
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
/// I2C Interrupt Mask Register.
///
/// These bits mask their corresponding interrupt status bits. This register is active low; a value of 0 masks the interrupt, whereas a value of 1 unmasks the interrupt.
pub const IC_INTR_MASK = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048030),
    pub const FieldMasks = struct {
        pub const M_RESTART_DET: u32 = helpers.generateMask(12, 13);
        pub const M_GEN_CALL: u32 = helpers.generateMask(11, 12);
        pub const M_START_DET: u32 = helpers.generateMask(10, 11);
        pub const M_STOP_DET: u32 = helpers.generateMask(9, 10);
        pub const M_ACTIVITY: u32 = helpers.generateMask(8, 9);
        pub const M_RX_DONE: u32 = helpers.generateMask(7, 8);
        pub const M_TX_ABRT: u32 = helpers.generateMask(6, 7);
        pub const M_RD_REQ: u32 = helpers.generateMask(5, 6);
        pub const M_TX_EMPTY: u32 = helpers.generateMask(4, 5);
        pub const M_TX_OVER: u32 = helpers.generateMask(3, 4);
        pub const M_RX_FULL: u32 = helpers.generateMask(2, 3);
        pub const M_RX_OVER: u32 = helpers.generateMask(1, 2);
        pub const M_RX_UNDER: u32 = helpers.generateMask(0, 1);
    };
    const M_RESTART_DET_e = enum(u1) {
        ENABLED = 0,
        DISABLED = 1,
    };
    const M_GEN_CALL_e = enum(u1) {
        ENABLED = 0,
        DISABLED = 1,
    };
    const M_START_DET_e = enum(u1) {
        ENABLED = 0,
        DISABLED = 1,
    };
    const M_STOP_DET_e = enum(u1) {
        ENABLED = 0,
        DISABLED = 1,
    };
    const M_ACTIVITY_e = enum(u1) {
        ENABLED = 0,
        DISABLED = 1,
    };
    const M_RX_DONE_e = enum(u1) {
        ENABLED = 0,
        DISABLED = 1,
    };
    const M_TX_ABRT_e = enum(u1) {
        ENABLED = 0,
        DISABLED = 1,
    };
    const M_RD_REQ_e = enum(u1) {
        ENABLED = 0,
        DISABLED = 1,
    };
    const M_TX_EMPTY_e = enum(u1) {
        ENABLED = 0,
        DISABLED = 1,
    };
    const M_TX_OVER_e = enum(u1) {
        ENABLED = 0,
        DISABLED = 1,
    };
    const M_RX_FULL_e = enum(u1) {
        ENABLED = 0,
        DISABLED = 1,
    };
    const M_RX_OVER_e = enum(u1) {
        ENABLED = 0,
        DISABLED = 1,
    };
    const M_RX_UNDER_e = enum(u1) {
        ENABLED = 0,
        DISABLED = 1,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// This bit masks the R_RESTART_DET interrupt in IC_INTR_STAT register.
        ///
        /// Reset value: 0x0
        pub fn M_RESTART_DET(self: Value, v: M_RESTART_DET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 12),
                .mask = self.mask | comptime helpers.generateMask(12, 13),
            };
        }
        /// This bit masks the R_GEN_CALL interrupt in IC_INTR_STAT register.
        ///
        /// Reset value: 0x1
        pub fn M_GEN_CALL(self: Value, v: M_GEN_CALL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 11),
                .mask = self.mask | comptime helpers.generateMask(11, 12),
            };
        }
        /// This bit masks the R_START_DET interrupt in IC_INTR_STAT register.
        ///
        /// Reset value: 0x0
        pub fn M_START_DET(self: Value, v: M_START_DET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 10),
                .mask = self.mask | comptime helpers.generateMask(10, 11),
            };
        }
        /// This bit masks the R_STOP_DET interrupt in IC_INTR_STAT register.
        ///
        /// Reset value: 0x0
        pub fn M_STOP_DET(self: Value, v: M_STOP_DET_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 9),
                .mask = self.mask | comptime helpers.generateMask(9, 10),
            };
        }
        /// This bit masks the R_ACTIVITY interrupt in IC_INTR_STAT register.
        ///
        /// Reset value: 0x0
        pub fn M_ACTIVITY(self: Value, v: M_ACTIVITY_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 8),
                .mask = self.mask | comptime helpers.generateMask(8, 9),
            };
        }
        /// This bit masks the R_RX_DONE interrupt in IC_INTR_STAT register.
        ///
        /// Reset value: 0x1
        pub fn M_RX_DONE(self: Value, v: M_RX_DONE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 7),
                .mask = self.mask | comptime helpers.generateMask(7, 8),
            };
        }
        /// This bit masks the R_TX_ABRT interrupt in IC_INTR_STAT register.
        ///
        /// Reset value: 0x1
        pub fn M_TX_ABRT(self: Value, v: M_TX_ABRT_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 6),
                .mask = self.mask | comptime helpers.generateMask(6, 7),
            };
        }
        /// This bit masks the R_RD_REQ interrupt in IC_INTR_STAT register.
        ///
        /// Reset value: 0x1
        pub fn M_RD_REQ(self: Value, v: M_RD_REQ_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 5),
                .mask = self.mask | comptime helpers.generateMask(5, 6),
            };
        }
        /// This bit masks the R_TX_EMPTY interrupt in IC_INTR_STAT register.
        ///
        /// Reset value: 0x1
        pub fn M_TX_EMPTY(self: Value, v: M_TX_EMPTY_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 4),
                .mask = self.mask | comptime helpers.generateMask(4, 5),
            };
        }
        /// This bit masks the R_TX_OVER interrupt in IC_INTR_STAT register.
        ///
        /// Reset value: 0x1
        pub fn M_TX_OVER(self: Value, v: M_TX_OVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 3),
                .mask = self.mask | comptime helpers.generateMask(3, 4),
            };
        }
        /// This bit masks the R_RX_FULL interrupt in IC_INTR_STAT register.
        ///
        /// Reset value: 0x1
        pub fn M_RX_FULL(self: Value, v: M_RX_FULL_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// This bit masks the R_RX_OVER interrupt in IC_INTR_STAT register.
        ///
        /// Reset value: 0x1
        pub fn M_RX_OVER(self: Value, v: M_RX_OVER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// This bit masks the R_RX_UNDER interrupt in IC_INTR_STAT register.
        ///
        /// Reset value: 0x1
        pub fn M_RX_UNDER(self: Value, v: M_RX_UNDER_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn M_RESTART_DET(self: Result) M_RESTART_DET_e {
            const mask = comptime helpers.generateMask(12, 13);
            const val: @typeInfo(M_RESTART_DET_e).@"enum".tag_type = @intCast((self.val & mask) >> 12);
            return @enumFromInt(val);
        }
        pub fn M_GEN_CALL(self: Result) M_GEN_CALL_e {
            const mask = comptime helpers.generateMask(11, 12);
            const val: @typeInfo(M_GEN_CALL_e).@"enum".tag_type = @intCast((self.val & mask) >> 11);
            return @enumFromInt(val);
        }
        pub fn M_START_DET(self: Result) M_START_DET_e {
            const mask = comptime helpers.generateMask(10, 11);
            const val: @typeInfo(M_START_DET_e).@"enum".tag_type = @intCast((self.val & mask) >> 10);
            return @enumFromInt(val);
        }
        pub fn M_STOP_DET(self: Result) M_STOP_DET_e {
            const mask = comptime helpers.generateMask(9, 10);
            const val: @typeInfo(M_STOP_DET_e).@"enum".tag_type = @intCast((self.val & mask) >> 9);
            return @enumFromInt(val);
        }
        pub fn M_ACTIVITY(self: Result) M_ACTIVITY_e {
            const mask = comptime helpers.generateMask(8, 9);
            const val: @typeInfo(M_ACTIVITY_e).@"enum".tag_type = @intCast((self.val & mask) >> 8);
            return @enumFromInt(val);
        }
        pub fn M_RX_DONE(self: Result) M_RX_DONE_e {
            const mask = comptime helpers.generateMask(7, 8);
            const val: @typeInfo(M_RX_DONE_e).@"enum".tag_type = @intCast((self.val & mask) >> 7);
            return @enumFromInt(val);
        }
        pub fn M_TX_ABRT(self: Result) M_TX_ABRT_e {
            const mask = comptime helpers.generateMask(6, 7);
            const val: @typeInfo(M_TX_ABRT_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn M_RD_REQ(self: Result) M_RD_REQ_e {
            const mask = comptime helpers.generateMask(5, 6);
            const val: @typeInfo(M_RD_REQ_e).@"enum".tag_type = @intCast((self.val & mask) >> 5);
            return @enumFromInt(val);
        }
        pub fn M_TX_EMPTY(self: Result) M_TX_EMPTY_e {
            const mask = comptime helpers.generateMask(4, 5);
            const val: @typeInfo(M_TX_EMPTY_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn M_TX_OVER(self: Result) M_TX_OVER_e {
            const mask = comptime helpers.generateMask(3, 4);
            const val: @typeInfo(M_TX_OVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 3);
            return @enumFromInt(val);
        }
        pub fn M_RX_FULL(self: Result) M_RX_FULL_e {
            const mask = comptime helpers.generateMask(2, 3);
            const val: @typeInfo(M_RX_FULL_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn M_RX_OVER(self: Result) M_RX_OVER_e {
            const mask = comptime helpers.generateMask(1, 2);
            const val: @typeInfo(M_RX_OVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 1);
            return @enumFromInt(val);
        }
        pub fn M_RX_UNDER(self: Result) M_RX_UNDER_e {
            const mask = comptime helpers.generateMask(0, 1);
            const val: @typeInfo(M_RX_UNDER_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
        }
    };
    /// This bit masks the R_RESTART_DET interrupt in IC_INTR_STAT register.
    ///
    /// Reset value: 0x0
    pub fn M_RESTART_DET(v: M_RESTART_DET_e) Value {
        return Value.M_RESTART_DET(.{}, v);
    }
    /// This bit masks the R_GEN_CALL interrupt in IC_INTR_STAT register.
    ///
    /// Reset value: 0x1
    pub fn M_GEN_CALL(v: M_GEN_CALL_e) Value {
        return Value.M_GEN_CALL(.{}, v);
    }
    /// This bit masks the R_START_DET interrupt in IC_INTR_STAT register.
    ///
    /// Reset value: 0x0
    pub fn M_START_DET(v: M_START_DET_e) Value {
        return Value.M_START_DET(.{}, v);
    }
    /// This bit masks the R_STOP_DET interrupt in IC_INTR_STAT register.
    ///
    /// Reset value: 0x0
    pub fn M_STOP_DET(v: M_STOP_DET_e) Value {
        return Value.M_STOP_DET(.{}, v);
    }
    /// This bit masks the R_ACTIVITY interrupt in IC_INTR_STAT register.
    ///
    /// Reset value: 0x0
    pub fn M_ACTIVITY(v: M_ACTIVITY_e) Value {
        return Value.M_ACTIVITY(.{}, v);
    }
    /// This bit masks the R_RX_DONE interrupt in IC_INTR_STAT register.
    ///
    /// Reset value: 0x1
    pub fn M_RX_DONE(v: M_RX_DONE_e) Value {
        return Value.M_RX_DONE(.{}, v);
    }
    /// This bit masks the R_TX_ABRT interrupt in IC_INTR_STAT register.
    ///
    /// Reset value: 0x1
    pub fn M_TX_ABRT(v: M_TX_ABRT_e) Value {
        return Value.M_TX_ABRT(.{}, v);
    }
    /// This bit masks the R_RD_REQ interrupt in IC_INTR_STAT register.
    ///
    /// Reset value: 0x1
    pub fn M_RD_REQ(v: M_RD_REQ_e) Value {
        return Value.M_RD_REQ(.{}, v);
    }
    /// This bit masks the R_TX_EMPTY interrupt in IC_INTR_STAT register.
    ///
    /// Reset value: 0x1
    pub fn M_TX_EMPTY(v: M_TX_EMPTY_e) Value {
        return Value.M_TX_EMPTY(.{}, v);
    }
    /// This bit masks the R_TX_OVER interrupt in IC_INTR_STAT register.
    ///
    /// Reset value: 0x1
    pub fn M_TX_OVER(v: M_TX_OVER_e) Value {
        return Value.M_TX_OVER(.{}, v);
    }
    /// This bit masks the R_RX_FULL interrupt in IC_INTR_STAT register.
    ///
    /// Reset value: 0x1
    pub fn M_RX_FULL(v: M_RX_FULL_e) Value {
        return Value.M_RX_FULL(.{}, v);
    }
    /// This bit masks the R_RX_OVER interrupt in IC_INTR_STAT register.
    ///
    /// Reset value: 0x1
    pub fn M_RX_OVER(v: M_RX_OVER_e) Value {
        return Value.M_RX_OVER(.{}, v);
    }
    /// This bit masks the R_RX_UNDER interrupt in IC_INTR_STAT register.
    ///
    /// Reset value: 0x1
    pub fn M_RX_UNDER(v: M_RX_UNDER_e) Value {
        return Value.M_RX_UNDER(.{}, v);
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
/// I2C Raw Interrupt Status Register
///
/// Unlike the IC_INTR_STAT register, these bits are not masked so they always show the true status of the DW_apb_i2c.
pub const IC_RAW_INTR_STAT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048034),
    pub const FieldMasks = struct {
        pub const RESTART_DET: u32 = helpers.generateMask(12, 13);
        pub const GEN_CALL: u32 = helpers.generateMask(11, 12);
        pub const START_DET: u32 = helpers.generateMask(10, 11);
        pub const STOP_DET: u32 = helpers.generateMask(9, 10);
        pub const ACTIVITY: u32 = helpers.generateMask(8, 9);
        pub const RX_DONE: u32 = helpers.generateMask(7, 8);
        pub const TX_ABRT: u32 = helpers.generateMask(6, 7);
        pub const RD_REQ: u32 = helpers.generateMask(5, 6);
        pub const TX_EMPTY: u32 = helpers.generateMask(4, 5);
        pub const TX_OVER: u32 = helpers.generateMask(3, 4);
        pub const RX_FULL: u32 = helpers.generateMask(2, 3);
        pub const RX_OVER: u32 = helpers.generateMask(1, 2);
        pub const RX_UNDER: u32 = helpers.generateMask(0, 1);
    };
    const RESTART_DET_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const GEN_CALL_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const START_DET_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const STOP_DET_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const ACTIVITY_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const RX_DONE_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const TX_ABRT_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const RD_REQ_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const TX_EMPTY_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const TX_OVER_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const RX_FULL_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const RX_OVER_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const RX_UNDER_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn RESTART_DET(self: Result) RESTART_DET_e {
            const mask = comptime helpers.generateMask(12, 13);
            const val: @typeInfo(RESTART_DET_e).@"enum".tag_type = @intCast((self.val & mask) >> 12);
            return @enumFromInt(val);
        }
        pub fn GEN_CALL(self: Result) GEN_CALL_e {
            const mask = comptime helpers.generateMask(11, 12);
            const val: @typeInfo(GEN_CALL_e).@"enum".tag_type = @intCast((self.val & mask) >> 11);
            return @enumFromInt(val);
        }
        pub fn START_DET(self: Result) START_DET_e {
            const mask = comptime helpers.generateMask(10, 11);
            const val: @typeInfo(START_DET_e).@"enum".tag_type = @intCast((self.val & mask) >> 10);
            return @enumFromInt(val);
        }
        pub fn STOP_DET(self: Result) STOP_DET_e {
            const mask = comptime helpers.generateMask(9, 10);
            const val: @typeInfo(STOP_DET_e).@"enum".tag_type = @intCast((self.val & mask) >> 9);
            return @enumFromInt(val);
        }
        pub fn ACTIVITY(self: Result) ACTIVITY_e {
            const mask = comptime helpers.generateMask(8, 9);
            const val: @typeInfo(ACTIVITY_e).@"enum".tag_type = @intCast((self.val & mask) >> 8);
            return @enumFromInt(val);
        }
        pub fn RX_DONE(self: Result) RX_DONE_e {
            const mask = comptime helpers.generateMask(7, 8);
            const val: @typeInfo(RX_DONE_e).@"enum".tag_type = @intCast((self.val & mask) >> 7);
            return @enumFromInt(val);
        }
        pub fn TX_ABRT(self: Result) TX_ABRT_e {
            const mask = comptime helpers.generateMask(6, 7);
            const val: @typeInfo(TX_ABRT_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn RD_REQ(self: Result) RD_REQ_e {
            const mask = comptime helpers.generateMask(5, 6);
            const val: @typeInfo(RD_REQ_e).@"enum".tag_type = @intCast((self.val & mask) >> 5);
            return @enumFromInt(val);
        }
        pub fn TX_EMPTY(self: Result) TX_EMPTY_e {
            const mask = comptime helpers.generateMask(4, 5);
            const val: @typeInfo(TX_EMPTY_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn TX_OVER(self: Result) TX_OVER_e {
            const mask = comptime helpers.generateMask(3, 4);
            const val: @typeInfo(TX_OVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 3);
            return @enumFromInt(val);
        }
        pub fn RX_FULL(self: Result) RX_FULL_e {
            const mask = comptime helpers.generateMask(2, 3);
            const val: @typeInfo(RX_FULL_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn RX_OVER(self: Result) RX_OVER_e {
            const mask = comptime helpers.generateMask(1, 2);
            const val: @typeInfo(RX_OVER_e).@"enum".tag_type = @intCast((self.val & mask) >> 1);
            return @enumFromInt(val);
        }
        pub fn RX_UNDER(self: Result) RX_UNDER_e {
            const mask = comptime helpers.generateMask(0, 1);
            const val: @typeInfo(RX_UNDER_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
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
/// I2C Receive FIFO Threshold Register
pub const IC_RX_TL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048038),
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
/// I2C Transmit FIFO Threshold Register
pub const IC_TX_TL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4004803c),
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
/// Clear Combined and Individual Interrupt Register
pub const IC_CLR_INTR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048040),
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
/// Clear RX_UNDER Interrupt Register
pub const IC_CLR_RX_UNDER = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048044),
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
/// Clear RX_OVER Interrupt Register
pub const IC_CLR_RX_OVER = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048048),
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
/// Clear TX_OVER Interrupt Register
pub const IC_CLR_TX_OVER = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4004804c),
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
/// Clear RD_REQ Interrupt Register
pub const IC_CLR_RD_REQ = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048050),
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
/// Clear TX_ABRT Interrupt Register
pub const IC_CLR_TX_ABRT = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048054),
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
/// Clear RX_DONE Interrupt Register
pub const IC_CLR_RX_DONE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048058),
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
/// Clear ACTIVITY Interrupt Register
pub const IC_CLR_ACTIVITY = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4004805c),
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
/// Clear STOP_DET Interrupt Register
pub const IC_CLR_STOP_DET = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048060),
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
/// Clear START_DET Interrupt Register
pub const IC_CLR_START_DET = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048064),
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
/// Clear GEN_CALL Interrupt Register
pub const IC_CLR_GEN_CALL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048068),
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
/// I2C Enable Register
pub const IC_ENABLE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4004806c),
    pub const FieldMasks = struct {
        pub const TX_CMD_BLOCK: u32 = helpers.generateMask(2, 3);
        pub const ABORT: u32 = helpers.generateMask(1, 2);
        pub const ENABLE: u32 = helpers.generateMask(0, 1);
    };
    const TX_CMD_BLOCK_e = enum(u1) {
        NOT_BLOCKED = 0,
        BLOCKED = 1,
    };
    const ABORT_e = enum(u1) {
        DISABLE = 0,
        ENABLED = 1,
    };
    const ENABLE_e = enum(u1) {
        DISABLED = 0,
        ENABLED = 1,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// In Master mode: - 1&#39;b1: Blocks the transmission of data on I2C bus even if Tx FIFO has data to transmit. - 1&#39;b0: The transmission of data starts on I2C bus automatically, as soon as the first data is available in the Tx FIFO. Note: To block the execution of Master commands, set the TX_CMD_BLOCK bit only when Tx FIFO is empty (IC_STATUS[2]==1) and Master is in Idle state (IC_STATUS[5] == 0). Any further commands put in the Tx FIFO are not executed until TX_CMD_BLOCK bit is unset. Reset value:  IC_TX_CMD_BLOCK_DEFAULT
        pub fn TX_CMD_BLOCK(self: Value, v: TX_CMD_BLOCK_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 2),
                .mask = self.mask | comptime helpers.generateMask(2, 3),
            };
        }
        /// When set, the controller initiates the transfer abort. - 0: ABORT not initiated or ABORT done - 1: ABORT operation in progress The software can abort the I2C transfer in master mode by setting this bit. The software can set this bit only when ENABLE is already set; otherwise, the controller ignores any write to ABORT bit. The software cannot clear the ABORT bit once set. In response to an ABORT, the controller issues a STOP and flushes the Tx FIFO after completing the current transfer, then sets the TX_ABORT interrupt after the abort operation. The ABORT bit is cleared automatically after the abort operation.
        ///
        /// For a detailed description on how to abort I2C transfers, refer to &#39;Aborting I2C Transfers&#39;.
        ///
        /// Reset value: 0x0
        pub fn ABORT(self: Value, v: ABORT_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Controls whether the DW_apb_i2c is enabled. - 0: Disables DW_apb_i2c (TX and RX FIFOs are held in an erased state) - 1: Enables DW_apb_i2c Software can disable DW_apb_i2c while it is active. However, it is important that care be taken to ensure that DW_apb_i2c is disabled properly. A recommended procedure is described in &#39;Disabling DW_apb_i2c&#39;.
        ///
        /// When DW_apb_i2c is disabled, the following occurs: - The TX FIFO and RX FIFO get flushed. - Status bits in the IC_INTR_STAT register are still active until DW_apb_i2c goes into IDLE state. If the module is transmitting, it stops as well as deletes the contents of the transmit buffer after the current transfer is complete. If the module is receiving, the DW_apb_i2c stops the current transfer at the end of the current byte and does not acknowledge the transfer.
        ///
        /// In systems with asynchronous pclk and ic_clk when IC_CLK_TYPE parameter set to asynchronous (1), there is a two ic_clk delay when enabling or disabling the DW_apb_i2c. For a detailed description on how to disable DW_apb_i2c, refer to &#39;Disabling DW_apb_i2c&#39;
        ///
        /// Reset value: 0x0
        pub fn ENABLE(self: Value, v: ENABLE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn TX_CMD_BLOCK(self: Result) TX_CMD_BLOCK_e {
            const mask = comptime helpers.generateMask(2, 3);
            const val: @typeInfo(TX_CMD_BLOCK_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn ABORT(self: Result) ABORT_e {
            const mask = comptime helpers.generateMask(1, 2);
            const val: @typeInfo(ABORT_e).@"enum".tag_type = @intCast((self.val & mask) >> 1);
            return @enumFromInt(val);
        }
        pub fn ENABLE(self: Result) ENABLE_e {
            const mask = comptime helpers.generateMask(0, 1);
            const val: @typeInfo(ENABLE_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
        }
    };
    /// In Master mode: - 1&#39;b1: Blocks the transmission of data on I2C bus even if Tx FIFO has data to transmit. - 1&#39;b0: The transmission of data starts on I2C bus automatically, as soon as the first data is available in the Tx FIFO. Note: To block the execution of Master commands, set the TX_CMD_BLOCK bit only when Tx FIFO is empty (IC_STATUS[2]==1) and Master is in Idle state (IC_STATUS[5] == 0). Any further commands put in the Tx FIFO are not executed until TX_CMD_BLOCK bit is unset. Reset value:  IC_TX_CMD_BLOCK_DEFAULT
    pub fn TX_CMD_BLOCK(v: TX_CMD_BLOCK_e) Value {
        return Value.TX_CMD_BLOCK(.{}, v);
    }
    /// When set, the controller initiates the transfer abort. - 0: ABORT not initiated or ABORT done - 1: ABORT operation in progress The software can abort the I2C transfer in master mode by setting this bit. The software can set this bit only when ENABLE is already set; otherwise, the controller ignores any write to ABORT bit. The software cannot clear the ABORT bit once set. In response to an ABORT, the controller issues a STOP and flushes the Tx FIFO after completing the current transfer, then sets the TX_ABORT interrupt after the abort operation. The ABORT bit is cleared automatically after the abort operation.
    ///
    /// For a detailed description on how to abort I2C transfers, refer to &#39;Aborting I2C Transfers&#39;.
    ///
    /// Reset value: 0x0
    pub fn ABORT(v: ABORT_e) Value {
        return Value.ABORT(.{}, v);
    }
    /// Controls whether the DW_apb_i2c is enabled. - 0: Disables DW_apb_i2c (TX and RX FIFOs are held in an erased state) - 1: Enables DW_apb_i2c Software can disable DW_apb_i2c while it is active. However, it is important that care be taken to ensure that DW_apb_i2c is disabled properly. A recommended procedure is described in &#39;Disabling DW_apb_i2c&#39;.
    ///
    /// When DW_apb_i2c is disabled, the following occurs: - The TX FIFO and RX FIFO get flushed. - Status bits in the IC_INTR_STAT register are still active until DW_apb_i2c goes into IDLE state. If the module is transmitting, it stops as well as deletes the contents of the transmit buffer after the current transfer is complete. If the module is receiving, the DW_apb_i2c stops the current transfer at the end of the current byte and does not acknowledge the transfer.
    ///
    /// In systems with asynchronous pclk and ic_clk when IC_CLK_TYPE parameter set to asynchronous (1), there is a two ic_clk delay when enabling or disabling the DW_apb_i2c. For a detailed description on how to disable DW_apb_i2c, refer to &#39;Disabling DW_apb_i2c&#39;
    ///
    /// Reset value: 0x0
    pub fn ENABLE(v: ENABLE_e) Value {
        return Value.ENABLE(.{}, v);
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
/// I2C Status Register
///
/// This is a read-only register used to indicate the current transfer status and FIFO status. The status register may be read at any time. None of the bits in this register request an interrupt.
///
/// When the I2C is disabled by writing 0 in bit 0 of the IC_ENABLE register: - Bits 1 and 2 are set to 1 - Bits 3 and 10 are set to 0 When the master or slave state machines goes to idle and ic_en=0: - Bits 5 and 6 are set to 0
pub const IC_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048070),
    pub const FieldMasks = struct {
        pub const SLV_ACTIVITY: u32 = helpers.generateMask(6, 7);
        pub const MST_ACTIVITY: u32 = helpers.generateMask(5, 6);
        pub const RFF: u32 = helpers.generateMask(4, 5);
        pub const RFNE: u32 = helpers.generateMask(3, 4);
        pub const TFE: u32 = helpers.generateMask(2, 3);
        pub const TFNF: u32 = helpers.generateMask(1, 2);
        pub const ACTIVITY: u32 = helpers.generateMask(0, 1);
    };
    const SLV_ACTIVITY_e = enum(u1) {
        IDLE = 0,
        ACTIVE = 1,
    };
    const MST_ACTIVITY_e = enum(u1) {
        IDLE = 0,
        ACTIVE = 1,
    };
    const RFF_e = enum(u1) {
        NOT_FULL = 0,
        FULL = 1,
    };
    const RFNE_e = enum(u1) {
        EMPTY = 0,
        NOT_EMPTY = 1,
    };
    const TFE_e = enum(u1) {
        NON_EMPTY = 0,
        EMPTY = 1,
    };
    const TFNF_e = enum(u1) {
        FULL = 0,
        NOT_FULL = 1,
    };
    const ACTIVITY_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn SLV_ACTIVITY(self: Result) SLV_ACTIVITY_e {
            const mask = comptime helpers.generateMask(6, 7);
            const val: @typeInfo(SLV_ACTIVITY_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn MST_ACTIVITY(self: Result) MST_ACTIVITY_e {
            const mask = comptime helpers.generateMask(5, 6);
            const val: @typeInfo(MST_ACTIVITY_e).@"enum".tag_type = @intCast((self.val & mask) >> 5);
            return @enumFromInt(val);
        }
        pub fn RFF(self: Result) RFF_e {
            const mask = comptime helpers.generateMask(4, 5);
            const val: @typeInfo(RFF_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn RFNE(self: Result) RFNE_e {
            const mask = comptime helpers.generateMask(3, 4);
            const val: @typeInfo(RFNE_e).@"enum".tag_type = @intCast((self.val & mask) >> 3);
            return @enumFromInt(val);
        }
        pub fn TFE(self: Result) TFE_e {
            const mask = comptime helpers.generateMask(2, 3);
            const val: @typeInfo(TFE_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn TFNF(self: Result) TFNF_e {
            const mask = comptime helpers.generateMask(1, 2);
            const val: @typeInfo(TFNF_e).@"enum".tag_type = @intCast((self.val & mask) >> 1);
            return @enumFromInt(val);
        }
        pub fn ACTIVITY(self: Result) ACTIVITY_e {
            const mask = comptime helpers.generateMask(0, 1);
            const val: @typeInfo(ACTIVITY_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
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
/// I2C Transmit FIFO Level Register This register contains the number of valid data entries in the transmit FIFO buffer. It is cleared whenever: - The I2C is disabled - There is a transmit abort - that is, TX_ABRT bit is set in the IC_RAW_INTR_STAT register - The slave bulk transmit mode is aborted The register increments whenever data is placed into the transmit FIFO and decrements when data is taken from the transmit FIFO.
pub const IC_TXFLR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048074),
    pub fn write(self: @This(), v: u5) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u5) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u5 {
        const mask = comptime helpers.generateMask(0, 5);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// I2C Receive FIFO Level Register This register contains the number of valid data entries in the receive FIFO buffer. It is cleared whenever: - The I2C is disabled - Whenever there is a transmit abort caused by any of the events tracked in IC_TX_ABRT_SOURCE The register increments whenever data is placed into the receive FIFO and decrements when data is taken from the receive FIFO.
pub const IC_RXFLR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048078),
    pub fn write(self: @This(), v: u5) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u5) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 5);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u5 {
        const mask = comptime helpers.generateMask(0, 5);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// I2C SDA Hold Time Length Register
///
/// The bits [15:0] of this register are used to control the hold time of SDA during transmit in both slave and master mode (after SCL goes from HIGH to LOW).
///
/// The bits [23:16] of this register are used to extend the SDA transition (if any) whenever SCL is HIGH in the receiver in either master or slave mode.
///
/// Writes to this register succeed only when IC_ENABLE[0]=0.
///
/// The values in this register are in units of ic_clk period. The value programmed in IC_SDA_TX_HOLD must be greater than the minimum hold time in each mode (one cycle in master mode, seven cycles in slave mode) for the value to be implemented.
///
/// The programmed SDA hold time during transmit (IC_SDA_TX_HOLD) cannot exceed at any time the duration of the low part of scl. Therefore the programmed value cannot be larger than N_SCL_LOW-2, where N_SCL_LOW is the duration of the low part of the scl period measured in ic_clk cycles.
pub const IC_SDA_HOLD = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4004807c),
    pub const FieldMasks = struct {
        pub const IC_SDA_RX_HOLD: u32 = helpers.generateMask(16, 24);
        pub const IC_SDA_TX_HOLD: u32 = helpers.generateMask(0, 16);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Sets the required SDA hold time in units of ic_clk period, when DW_apb_i2c acts as a receiver.
        ///
        /// Reset value: IC_DEFAULT_SDA_HOLD[23:16].
        pub fn IC_SDA_RX_HOLD(self: Value, v: u8) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 16),
                .mask = self.mask | comptime helpers.generateMask(16, 24),
            };
        }
        /// Sets the required SDA hold time in units of ic_clk period, when DW_apb_i2c acts as a transmitter.
        ///
        /// Reset value: IC_DEFAULT_SDA_HOLD[15:0].
        pub fn IC_SDA_TX_HOLD(self: Value, v: u16) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 16),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn IC_SDA_RX_HOLD(self: Result) u8 {
            const mask = comptime helpers.generateMask(16, 24);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn IC_SDA_TX_HOLD(self: Result) u16 {
            const mask = comptime helpers.generateMask(0, 16);
            return @intCast((self.val & mask) >> 0);
        }
    };
    /// Sets the required SDA hold time in units of ic_clk period, when DW_apb_i2c acts as a receiver.
    ///
    /// Reset value: IC_DEFAULT_SDA_HOLD[23:16].
    pub fn IC_SDA_RX_HOLD(v: u8) Value {
        return Value.IC_SDA_RX_HOLD(.{}, v);
    }
    /// Sets the required SDA hold time in units of ic_clk period, when DW_apb_i2c acts as a transmitter.
    ///
    /// Reset value: IC_DEFAULT_SDA_HOLD[15:0].
    pub fn IC_SDA_TX_HOLD(v: u16) Value {
        return Value.IC_SDA_TX_HOLD(.{}, v);
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
/// I2C Transmit Abort Source Register
///
/// This register has 32 bits that indicate the source of the TX_ABRT bit. Except for Bit 9, this register is cleared whenever the IC_CLR_TX_ABRT register or the IC_CLR_INTR register is read. To clear Bit 9, the source of the ABRT_SBYTE_NORSTRT must be fixed first; RESTART must be enabled (IC_CON[5]=1), the SPECIAL bit must be cleared (IC_TAR[11]), or the GC_OR_START bit must be cleared (IC_TAR[10]).
///
/// Once the source of the ABRT_SBYTE_NORSTRT is fixed, then this bit can be cleared in the same manner as other bits in this register. If the source of the ABRT_SBYTE_NORSTRT is not fixed before attempting to clear this bit, Bit 9 clears for one cycle and is then re-asserted.
pub const IC_TX_ABRT_SOURCE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048080),
    pub const FieldMasks = struct {
        pub const TX_FLUSH_CNT: u32 = helpers.generateMask(23, 32);
        pub const ABRT_USER_ABRT: u32 = helpers.generateMask(16, 17);
        pub const ABRT_SLVRD_INTX: u32 = helpers.generateMask(15, 16);
        pub const ABRT_SLV_ARBLOST: u32 = helpers.generateMask(14, 15);
        pub const ABRT_SLVFLUSH_TXFIFO: u32 = helpers.generateMask(13, 14);
        pub const ARB_LOST: u32 = helpers.generateMask(12, 13);
        pub const ABRT_MASTER_DIS: u32 = helpers.generateMask(11, 12);
        pub const ABRT_10B_RD_NORSTRT: u32 = helpers.generateMask(10, 11);
        pub const ABRT_SBYTE_NORSTRT: u32 = helpers.generateMask(9, 10);
        pub const ABRT_HS_NORSTRT: u32 = helpers.generateMask(8, 9);
        pub const ABRT_SBYTE_ACKDET: u32 = helpers.generateMask(7, 8);
        pub const ABRT_HS_ACKDET: u32 = helpers.generateMask(6, 7);
        pub const ABRT_GCALL_READ: u32 = helpers.generateMask(5, 6);
        pub const ABRT_GCALL_NOACK: u32 = helpers.generateMask(4, 5);
        pub const ABRT_TXDATA_NOACK: u32 = helpers.generateMask(3, 4);
        pub const ABRT_10ADDR2_NOACK: u32 = helpers.generateMask(2, 3);
        pub const ABRT_10ADDR1_NOACK: u32 = helpers.generateMask(1, 2);
        pub const ABRT_7B_ADDR_NOACK: u32 = helpers.generateMask(0, 1);
    };
    const ABRT_USER_ABRT_e = enum(u1) {
        ABRT_USER_ABRT_VOID = 0,
        ABRT_USER_ABRT_GENERATED = 1,
    };
    const ABRT_SLVRD_INTX_e = enum(u1) {
        ABRT_SLVRD_INTX_VOID = 0,
        ABRT_SLVRD_INTX_GENERATED = 1,
    };
    const ABRT_SLV_ARBLOST_e = enum(u1) {
        ABRT_SLV_ARBLOST_VOID = 0,
        ABRT_SLV_ARBLOST_GENERATED = 1,
    };
    const ABRT_SLVFLUSH_TXFIFO_e = enum(u1) {
        ABRT_SLVFLUSH_TXFIFO_VOID = 0,
        ABRT_SLVFLUSH_TXFIFO_GENERATED = 1,
    };
    const ARB_LOST_e = enum(u1) {
        ABRT_LOST_VOID = 0,
        ABRT_LOST_GENERATED = 1,
    };
    const ABRT_MASTER_DIS_e = enum(u1) {
        ABRT_MASTER_DIS_VOID = 0,
        ABRT_MASTER_DIS_GENERATED = 1,
    };
    const ABRT_10B_RD_NORSTRT_e = enum(u1) {
        ABRT_10B_RD_VOID = 0,
        ABRT_10B_RD_GENERATED = 1,
    };
    const ABRT_SBYTE_NORSTRT_e = enum(u1) {
        ABRT_SBYTE_NORSTRT_VOID = 0,
        ABRT_SBYTE_NORSTRT_GENERATED = 1,
    };
    const ABRT_HS_NORSTRT_e = enum(u1) {
        ABRT_HS_NORSTRT_VOID = 0,
        ABRT_HS_NORSTRT_GENERATED = 1,
    };
    const ABRT_SBYTE_ACKDET_e = enum(u1) {
        ABRT_SBYTE_ACKDET_VOID = 0,
        ABRT_SBYTE_ACKDET_GENERATED = 1,
    };
    const ABRT_HS_ACKDET_e = enum(u1) {
        ABRT_HS_ACK_VOID = 0,
        ABRT_HS_ACK_GENERATED = 1,
    };
    const ABRT_GCALL_READ_e = enum(u1) {
        ABRT_GCALL_READ_VOID = 0,
        ABRT_GCALL_READ_GENERATED = 1,
    };
    const ABRT_GCALL_NOACK_e = enum(u1) {
        ABRT_GCALL_NOACK_VOID = 0,
        ABRT_GCALL_NOACK_GENERATED = 1,
    };
    const ABRT_TXDATA_NOACK_e = enum(u1) {
        ABRT_TXDATA_NOACK_VOID = 0,
        ABRT_TXDATA_NOACK_GENERATED = 1,
    };
    const ABRT_10ADDR2_NOACK_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const ABRT_10ADDR1_NOACK_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const ABRT_7B_ADDR_NOACK_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn TX_FLUSH_CNT(self: Result) u9 {
            const mask = comptime helpers.generateMask(23, 32);
            return @intCast((self.val & mask) >> 23);
        }
        pub fn ABRT_USER_ABRT(self: Result) ABRT_USER_ABRT_e {
            const mask = comptime helpers.generateMask(16, 17);
            const val: @typeInfo(ABRT_USER_ABRT_e).@"enum".tag_type = @intCast((self.val & mask) >> 16);
            return @enumFromInt(val);
        }
        pub fn ABRT_SLVRD_INTX(self: Result) ABRT_SLVRD_INTX_e {
            const mask = comptime helpers.generateMask(15, 16);
            const val: @typeInfo(ABRT_SLVRD_INTX_e).@"enum".tag_type = @intCast((self.val & mask) >> 15);
            return @enumFromInt(val);
        }
        pub fn ABRT_SLV_ARBLOST(self: Result) ABRT_SLV_ARBLOST_e {
            const mask = comptime helpers.generateMask(14, 15);
            const val: @typeInfo(ABRT_SLV_ARBLOST_e).@"enum".tag_type = @intCast((self.val & mask) >> 14);
            return @enumFromInt(val);
        }
        pub fn ABRT_SLVFLUSH_TXFIFO(self: Result) ABRT_SLVFLUSH_TXFIFO_e {
            const mask = comptime helpers.generateMask(13, 14);
            const val: @typeInfo(ABRT_SLVFLUSH_TXFIFO_e).@"enum".tag_type = @intCast((self.val & mask) >> 13);
            return @enumFromInt(val);
        }
        pub fn ARB_LOST(self: Result) ARB_LOST_e {
            const mask = comptime helpers.generateMask(12, 13);
            const val: @typeInfo(ARB_LOST_e).@"enum".tag_type = @intCast((self.val & mask) >> 12);
            return @enumFromInt(val);
        }
        pub fn ABRT_MASTER_DIS(self: Result) ABRT_MASTER_DIS_e {
            const mask = comptime helpers.generateMask(11, 12);
            const val: @typeInfo(ABRT_MASTER_DIS_e).@"enum".tag_type = @intCast((self.val & mask) >> 11);
            return @enumFromInt(val);
        }
        pub fn ABRT_10B_RD_NORSTRT(self: Result) ABRT_10B_RD_NORSTRT_e {
            const mask = comptime helpers.generateMask(10, 11);
            const val: @typeInfo(ABRT_10B_RD_NORSTRT_e).@"enum".tag_type = @intCast((self.val & mask) >> 10);
            return @enumFromInt(val);
        }
        pub fn ABRT_SBYTE_NORSTRT(self: Result) ABRT_SBYTE_NORSTRT_e {
            const mask = comptime helpers.generateMask(9, 10);
            const val: @typeInfo(ABRT_SBYTE_NORSTRT_e).@"enum".tag_type = @intCast((self.val & mask) >> 9);
            return @enumFromInt(val);
        }
        pub fn ABRT_HS_NORSTRT(self: Result) ABRT_HS_NORSTRT_e {
            const mask = comptime helpers.generateMask(8, 9);
            const val: @typeInfo(ABRT_HS_NORSTRT_e).@"enum".tag_type = @intCast((self.val & mask) >> 8);
            return @enumFromInt(val);
        }
        pub fn ABRT_SBYTE_ACKDET(self: Result) ABRT_SBYTE_ACKDET_e {
            const mask = comptime helpers.generateMask(7, 8);
            const val: @typeInfo(ABRT_SBYTE_ACKDET_e).@"enum".tag_type = @intCast((self.val & mask) >> 7);
            return @enumFromInt(val);
        }
        pub fn ABRT_HS_ACKDET(self: Result) ABRT_HS_ACKDET_e {
            const mask = comptime helpers.generateMask(6, 7);
            const val: @typeInfo(ABRT_HS_ACKDET_e).@"enum".tag_type = @intCast((self.val & mask) >> 6);
            return @enumFromInt(val);
        }
        pub fn ABRT_GCALL_READ(self: Result) ABRT_GCALL_READ_e {
            const mask = comptime helpers.generateMask(5, 6);
            const val: @typeInfo(ABRT_GCALL_READ_e).@"enum".tag_type = @intCast((self.val & mask) >> 5);
            return @enumFromInt(val);
        }
        pub fn ABRT_GCALL_NOACK(self: Result) ABRT_GCALL_NOACK_e {
            const mask = comptime helpers.generateMask(4, 5);
            const val: @typeInfo(ABRT_GCALL_NOACK_e).@"enum".tag_type = @intCast((self.val & mask) >> 4);
            return @enumFromInt(val);
        }
        pub fn ABRT_TXDATA_NOACK(self: Result) ABRT_TXDATA_NOACK_e {
            const mask = comptime helpers.generateMask(3, 4);
            const val: @typeInfo(ABRT_TXDATA_NOACK_e).@"enum".tag_type = @intCast((self.val & mask) >> 3);
            return @enumFromInt(val);
        }
        pub fn ABRT_10ADDR2_NOACK(self: Result) ABRT_10ADDR2_NOACK_e {
            const mask = comptime helpers.generateMask(2, 3);
            const val: @typeInfo(ABRT_10ADDR2_NOACK_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn ABRT_10ADDR1_NOACK(self: Result) ABRT_10ADDR1_NOACK_e {
            const mask = comptime helpers.generateMask(1, 2);
            const val: @typeInfo(ABRT_10ADDR1_NOACK_e).@"enum".tag_type = @intCast((self.val & mask) >> 1);
            return @enumFromInt(val);
        }
        pub fn ABRT_7B_ADDR_NOACK(self: Result) ABRT_7B_ADDR_NOACK_e {
            const mask = comptime helpers.generateMask(0, 1);
            const val: @typeInfo(ABRT_7B_ADDR_NOACK_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
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
/// Generate Slave Data NACK Register
///
/// The register is used to generate a NACK for the data part of a transfer when DW_apb_i2c is acting as a slave-receiver. This register only exists when the IC_SLV_DATA_NACK_ONLY parameter is set to 1. When this parameter disabled, this register does not exist and writing to the register&#39;s address has no effect.
///
/// A write can occur on this register if both of the following conditions are met: - DW_apb_i2c is disabled (IC_ENABLE[0] = 0) - Slave part is inactive (IC_STATUS[6] = 0) Note: The IC_STATUS[6] is a register read-back location for the internal slv_activity signal; the user should poll this before writing the ic_slv_data_nack_only bit.
pub const IC_SLV_DATA_NACK_ONLY = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048084),
    const NACK_e = enum(u1) {
        DISABLED = 0,
        ENABLED = 1,
    };
    pub fn write(self: @This(), v: NACK_e) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(@intFromEnum(v)) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: NACK_e) void {
        self.reg.* = (helpers.toU32(@intFromEnum(v)) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) NACK_e {
        const mask = comptime helpers.generateMask(0, 1);
        return @enumFromInt((self.reg.* & mask) >> 0);
    }
};
/// DMA Control Register
///
/// The register is used to enable the DMA Controller interface operation. There is a separate bit for transmit and receive. This can be programmed regardless of the state of IC_ENABLE.
pub const IC_DMA_CR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048088),
    pub const FieldMasks = struct {
        pub const TDMAE: u32 = helpers.generateMask(1, 2);
        pub const RDMAE: u32 = helpers.generateMask(0, 1);
    };
    const TDMAE_e = enum(u1) {
        DISABLED = 0,
        ENABLED = 1,
    };
    const RDMAE_e = enum(u1) {
        DISABLED = 0,
        ENABLED = 1,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,

        /// Transmit DMA Enable. This bit enables/disables the transmit FIFO DMA channel. Reset value: 0x0
        pub fn TDMAE(self: Value, v: TDMAE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 1),
                .mask = self.mask | comptime helpers.generateMask(1, 2),
            };
        }
        /// Receive DMA Enable. This bit enables/disables the receive FIFO DMA channel. Reset value: 0x0
        pub fn RDMAE(self: Value, v: RDMAE_e) Value {
            return .{
                .val = self.val | (helpers.toU32(v) << 0),
                .mask = self.mask | comptime helpers.generateMask(0, 1),
            };
        }
    };
    const Result = struct {
        val: u32,
        pub fn TDMAE(self: Result) TDMAE_e {
            const mask = comptime helpers.generateMask(1, 2);
            const val: @typeInfo(TDMAE_e).@"enum".tag_type = @intCast((self.val & mask) >> 1);
            return @enumFromInt(val);
        }
        pub fn RDMAE(self: Result) RDMAE_e {
            const mask = comptime helpers.generateMask(0, 1);
            const val: @typeInfo(RDMAE_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
        }
    };
    /// Transmit DMA Enable. This bit enables/disables the transmit FIFO DMA channel. Reset value: 0x0
    pub fn TDMAE(v: TDMAE_e) Value {
        return Value.TDMAE(.{}, v);
    }
    /// Receive DMA Enable. This bit enables/disables the receive FIFO DMA channel. Reset value: 0x0
    pub fn RDMAE(v: RDMAE_e) Value {
        return Value.RDMAE(.{}, v);
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
/// DMA Transmit Data Level Register
pub const IC_DMA_TDLR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4004808c),
    pub fn write(self: @This(), v: u4) void {
        const mask = comptime helpers.generateMask(0, 4);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u4) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 4);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 4);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u4 {
        const mask = comptime helpers.generateMask(0, 4);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// I2C Receive Data Level Register
pub const IC_DMA_RDLR = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048090),
    pub fn write(self: @This(), v: u4) void {
        const mask = comptime helpers.generateMask(0, 4);
        helpers.hwWriteMasked(self.reg, helpers.toU32(v) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: u4) void {
        self.reg.* = (helpers.toU32(v) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 4);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 4);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) u4 {
        const mask = comptime helpers.generateMask(0, 4);
        return @intCast((self.reg.* & mask) >> 0);
    }
};
/// I2C SDA Setup Register
///
/// This register controls the amount of time delay (in terms of number of ic_clk clock periods) introduced in the rising edge of SCL - relative to SDA changing - when DW_apb_i2c services a read request in a slave-transmitter operation. The relevant I2C requirement is tSU:DAT (note 4) as detailed in the I2C Bus Specification. This register must be programmed with a value equal to or greater than 2.
///
/// Writes to this register succeed only when IC_ENABLE[0] = 0.
///
/// Note: The length of setup time is calculated using [(IC_SDA_SETUP - 1) * (ic_clk_period)], so if the user requires 10 ic_clk periods of setup time, they should program a value of 11. The IC_SDA_SETUP register is only used by the DW_apb_i2c when operating as a slave transmitter.
pub const IC_SDA_SETUP = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048094),
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
/// I2C ACK General Call Register
///
/// The register controls whether DW_apb_i2c responds with a ACK or NACK when it receives an I2C General Call address.
///
/// This register is applicable only when the DW_apb_i2c is in slave mode.
pub const IC_ACK_GENERAL_CALL = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x40048098),
    const ACK_GEN_CALL_e = enum(u1) {
        DISABLED = 0,
        ENABLED = 1,
    };
    pub fn write(self: @This(), v: ACK_GEN_CALL_e) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwWriteMasked(self.reg, helpers.toU32(@intFromEnum(v)) << 0, mask);
    }
    pub fn writeOver(self: @This(), v: ACK_GEN_CALL_e) void {
        self.reg.* = (helpers.toU32(@intFromEnum(v)) << 0);
    }
    pub fn clear(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicClear(self.reg, mask);
    }
    pub fn set(self: @This()) void {
        const mask = comptime helpers.generateMask(0, 1);
        helpers.hwAtomicSet(self.reg, mask);
    }
    pub fn read(self: @This()) ACK_GEN_CALL_e {
        const mask = comptime helpers.generateMask(0, 1);
        return @enumFromInt((self.reg.* & mask) >> 0);
    }
};
/// I2C Enable Status Register
///
/// The register is used to report the DW_apb_i2c hardware status when the IC_ENABLE[0] register is set from 1 to 0; that is, when DW_apb_i2c is disabled.
///
/// If IC_ENABLE[0] has been set to 1, bits 2:1 are forced to 0, and bit 0 is forced to 1.
///
/// If IC_ENABLE[0] has been set to 0, bits 2:1 is only be valid as soon as bit 0 is read as &#39;0&#39;.
///
/// Note: When IC_ENABLE[0] has been set to 0, a delay occurs for bit 0 to be read as 0 because disabling the DW_apb_i2c depends on I2C bus activities.
pub const IC_ENABLE_STATUS = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x4004809c),
    pub const FieldMasks = struct {
        pub const SLV_RX_DATA_LOST: u32 = helpers.generateMask(2, 3);
        pub const SLV_DISABLED_WHILE_BUSY: u32 = helpers.generateMask(1, 2);
        pub const IC_EN: u32 = helpers.generateMask(0, 1);
    };
    const SLV_RX_DATA_LOST_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const SLV_DISABLED_WHILE_BUSY_e = enum(u1) {
        INACTIVE = 0,
        ACTIVE = 1,
    };
    const IC_EN_e = enum(u1) {
        DISABLED = 0,
        ENABLED = 1,
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn SLV_RX_DATA_LOST(self: Result) SLV_RX_DATA_LOST_e {
            const mask = comptime helpers.generateMask(2, 3);
            const val: @typeInfo(SLV_RX_DATA_LOST_e).@"enum".tag_type = @intCast((self.val & mask) >> 2);
            return @enumFromInt(val);
        }
        pub fn SLV_DISABLED_WHILE_BUSY(self: Result) SLV_DISABLED_WHILE_BUSY_e {
            const mask = comptime helpers.generateMask(1, 2);
            const val: @typeInfo(SLV_DISABLED_WHILE_BUSY_e).@"enum".tag_type = @intCast((self.val & mask) >> 1);
            return @enumFromInt(val);
        }
        pub fn IC_EN(self: Result) IC_EN_e {
            const mask = comptime helpers.generateMask(0, 1);
            const val: @typeInfo(IC_EN_e).@"enum".tag_type = @intCast((self.val & mask) >> 0);
            return @enumFromInt(val);
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
/// I2C SS, FS or FM+ spike suppression limit
///
/// This register is used to store the duration, measured in ic_clk cycles, of the longest spike that is filtered out by the spike suppression logic when the component is operating in SS, FS or FM+ modes. The relevant I2C requirement is tSP (table 4) as detailed in the I2C Bus Specification. This register must be programmed with a minimum value of 1.
pub const IC_FS_SPKLEN = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400480a0),
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
/// Clear RESTART_DET Interrupt Register
pub const IC_CLR_RESTART_DET = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400480a8),
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
/// Component Parameter Register 1
///
/// Note This register is not implemented and therefore reads as 0. If it was implemented it would be a constant read-only register that contains encoded information about the component&#39;s parameter settings. Fields shown below are the settings for those parameters
pub const IC_COMP_PARAM_1 = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400480f4),
    pub const FieldMasks = struct {
        pub const TX_BUFFER_DEPTH: u32 = helpers.generateMask(16, 24);
        pub const RX_BUFFER_DEPTH: u32 = helpers.generateMask(8, 16);
        pub const ADD_ENCODED_PARAMS: u32 = helpers.generateMask(7, 8);
        pub const HAS_DMA: u32 = helpers.generateMask(6, 7);
        pub const INTR_IO: u32 = helpers.generateMask(5, 6);
        pub const HC_COUNT_VALUES: u32 = helpers.generateMask(4, 5);
        pub const MAX_SPEED_MODE: u32 = helpers.generateMask(2, 4);
        pub const APB_DATA_WIDTH: u32 = helpers.generateMask(0, 2);
    };
    const Value = struct {
        val: u32 = 0,
        mask: u32 = 0,
    };
    const Result = struct {
        val: u32,
        pub fn TX_BUFFER_DEPTH(self: Result) u8 {
            const mask = comptime helpers.generateMask(16, 24);
            return @intCast((self.val & mask) >> 16);
        }
        pub fn RX_BUFFER_DEPTH(self: Result) u8 {
            const mask = comptime helpers.generateMask(8, 16);
            return @intCast((self.val & mask) >> 8);
        }
        pub fn ADD_ENCODED_PARAMS(self: Result) u1 {
            const mask = comptime helpers.generateMask(7, 8);
            return @intCast((self.val & mask) >> 7);
        }
        pub fn HAS_DMA(self: Result) u1 {
            const mask = comptime helpers.generateMask(6, 7);
            return @intCast((self.val & mask) >> 6);
        }
        pub fn INTR_IO(self: Result) u1 {
            const mask = comptime helpers.generateMask(5, 6);
            return @intCast((self.val & mask) >> 5);
        }
        pub fn HC_COUNT_VALUES(self: Result) u1 {
            const mask = comptime helpers.generateMask(4, 5);
            return @intCast((self.val & mask) >> 4);
        }
        pub fn MAX_SPEED_MODE(self: Result) u2 {
            const mask = comptime helpers.generateMask(2, 4);
            return @intCast((self.val & mask) >> 2);
        }
        pub fn APB_DATA_WIDTH(self: Result) u2 {
            const mask = comptime helpers.generateMask(0, 2);
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
/// I2C Component Version Register
pub const IC_COMP_VERSION = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400480f8),
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
/// I2C Component Type Register
pub const IC_COMP_TYPE = struct {
    comptime reg: *volatile u32 = @ptrFromInt(0x400480fc),
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
pub const I2C1_p = struct {
    comptime base_address: *volatile u32 = @ptrFromInt(0x40048000),

    /// I2C Control Register. This register can be written only when the DW_apb_i2c is disabled, which corresponds to the IC_ENABLE[0] register being set to 0. Writes at other times have no effect.
    ///
    /// Read/Write Access: - bit 10 is read only. - bit 11 is read only - bit 16 is read only - bit 17 is read only - bits 18 and 19 are read only.
    IC_CON: IC_CON = .{},
    /// I2C Target Address Register
    ///
    /// This register is 12 bits wide, and bits 31:12 are reserved. This register can be written to only when IC_ENABLE[0] is set to 0.
    ///
    /// Note: If the software or application is aware that the DW_apb_i2c is not using the TAR address for the pending commands in the Tx FIFO, then it is possible to update the TAR address even while the Tx FIFO has entries (IC_STATUS[2]= 0). - It is not necessary to perform any write to this register if DW_apb_i2c is enabled as an I2C slave only.
    IC_TAR: IC_TAR = .{},
    /// I2C Slave Address Register
    IC_SAR: IC_SAR = .{},
    /// I2C Rx/Tx Data Buffer and Command Register; this is the register the CPU writes to when filling the TX FIFO and the CPU reads from when retrieving bytes from RX FIFO.
    ///
    /// The size of the register changes as follows:
    ///
    /// Write: - 11 bits when IC_EMPTYFIFO_HOLD_MASTER_EN=1 - 9 bits when IC_EMPTYFIFO_HOLD_MASTER_EN=0 Read: - 12 bits when IC_FIRST_DATA_BYTE_STATUS = 1 - 8 bits when IC_FIRST_DATA_BYTE_STATUS = 0 Note: In order for the DW_apb_i2c to continue acknowledging reads, a read command should be written for every byte that is to be received; otherwise the DW_apb_i2c will stop acknowledging.
    IC_DATA_CMD: IC_DATA_CMD = .{},
    /// Standard Speed I2C Clock SCL High Count Register
    IC_SS_SCL_HCNT: IC_SS_SCL_HCNT = .{},
    /// Standard Speed I2C Clock SCL Low Count Register
    IC_SS_SCL_LCNT: IC_SS_SCL_LCNT = .{},
    /// Fast Mode or Fast Mode Plus I2C Clock SCL High Count Register
    IC_FS_SCL_HCNT: IC_FS_SCL_HCNT = .{},
    /// Fast Mode or Fast Mode Plus I2C Clock SCL Low Count Register
    IC_FS_SCL_LCNT: IC_FS_SCL_LCNT = .{},
    /// I2C Interrupt Status Register
    ///
    /// Each bit in this register has a corresponding mask bit in the IC_INTR_MASK register. These bits are cleared by reading the matching interrupt clear register. The unmasked raw versions of these bits are available in the IC_RAW_INTR_STAT register.
    IC_INTR_STAT: IC_INTR_STAT = .{},
    /// I2C Interrupt Mask Register.
    ///
    /// These bits mask their corresponding interrupt status bits. This register is active low; a value of 0 masks the interrupt, whereas a value of 1 unmasks the interrupt.
    IC_INTR_MASK: IC_INTR_MASK = .{},
    /// I2C Raw Interrupt Status Register
    ///
    /// Unlike the IC_INTR_STAT register, these bits are not masked so they always show the true status of the DW_apb_i2c.
    IC_RAW_INTR_STAT: IC_RAW_INTR_STAT = .{},
    /// I2C Receive FIFO Threshold Register
    IC_RX_TL: IC_RX_TL = .{},
    /// I2C Transmit FIFO Threshold Register
    IC_TX_TL: IC_TX_TL = .{},
    /// Clear Combined and Individual Interrupt Register
    IC_CLR_INTR: IC_CLR_INTR = .{},
    /// Clear RX_UNDER Interrupt Register
    IC_CLR_RX_UNDER: IC_CLR_RX_UNDER = .{},
    /// Clear RX_OVER Interrupt Register
    IC_CLR_RX_OVER: IC_CLR_RX_OVER = .{},
    /// Clear TX_OVER Interrupt Register
    IC_CLR_TX_OVER: IC_CLR_TX_OVER = .{},
    /// Clear RD_REQ Interrupt Register
    IC_CLR_RD_REQ: IC_CLR_RD_REQ = .{},
    /// Clear TX_ABRT Interrupt Register
    IC_CLR_TX_ABRT: IC_CLR_TX_ABRT = .{},
    /// Clear RX_DONE Interrupt Register
    IC_CLR_RX_DONE: IC_CLR_RX_DONE = .{},
    /// Clear ACTIVITY Interrupt Register
    IC_CLR_ACTIVITY: IC_CLR_ACTIVITY = .{},
    /// Clear STOP_DET Interrupt Register
    IC_CLR_STOP_DET: IC_CLR_STOP_DET = .{},
    /// Clear START_DET Interrupt Register
    IC_CLR_START_DET: IC_CLR_START_DET = .{},
    /// Clear GEN_CALL Interrupt Register
    IC_CLR_GEN_CALL: IC_CLR_GEN_CALL = .{},
    /// I2C Enable Register
    IC_ENABLE: IC_ENABLE = .{},
    /// I2C Status Register
    ///
    /// This is a read-only register used to indicate the current transfer status and FIFO status. The status register may be read at any time. None of the bits in this register request an interrupt.
    ///
    /// When the I2C is disabled by writing 0 in bit 0 of the IC_ENABLE register: - Bits 1 and 2 are set to 1 - Bits 3 and 10 are set to 0 When the master or slave state machines goes to idle and ic_en=0: - Bits 5 and 6 are set to 0
    IC_STATUS: IC_STATUS = .{},
    /// I2C Transmit FIFO Level Register This register contains the number of valid data entries in the transmit FIFO buffer. It is cleared whenever: - The I2C is disabled - There is a transmit abort - that is, TX_ABRT bit is set in the IC_RAW_INTR_STAT register - The slave bulk transmit mode is aborted The register increments whenever data is placed into the transmit FIFO and decrements when data is taken from the transmit FIFO.
    IC_TXFLR: IC_TXFLR = .{},
    /// I2C Receive FIFO Level Register This register contains the number of valid data entries in the receive FIFO buffer. It is cleared whenever: - The I2C is disabled - Whenever there is a transmit abort caused by any of the events tracked in IC_TX_ABRT_SOURCE The register increments whenever data is placed into the receive FIFO and decrements when data is taken from the receive FIFO.
    IC_RXFLR: IC_RXFLR = .{},
    /// I2C SDA Hold Time Length Register
    ///
    /// The bits [15:0] of this register are used to control the hold time of SDA during transmit in both slave and master mode (after SCL goes from HIGH to LOW).
    ///
    /// The bits [23:16] of this register are used to extend the SDA transition (if any) whenever SCL is HIGH in the receiver in either master or slave mode.
    ///
    /// Writes to this register succeed only when IC_ENABLE[0]=0.
    ///
    /// The values in this register are in units of ic_clk period. The value programmed in IC_SDA_TX_HOLD must be greater than the minimum hold time in each mode (one cycle in master mode, seven cycles in slave mode) for the value to be implemented.
    ///
    /// The programmed SDA hold time during transmit (IC_SDA_TX_HOLD) cannot exceed at any time the duration of the low part of scl. Therefore the programmed value cannot be larger than N_SCL_LOW-2, where N_SCL_LOW is the duration of the low part of the scl period measured in ic_clk cycles.
    IC_SDA_HOLD: IC_SDA_HOLD = .{},
    /// I2C Transmit Abort Source Register
    ///
    /// This register has 32 bits that indicate the source of the TX_ABRT bit. Except for Bit 9, this register is cleared whenever the IC_CLR_TX_ABRT register or the IC_CLR_INTR register is read. To clear Bit 9, the source of the ABRT_SBYTE_NORSTRT must be fixed first; RESTART must be enabled (IC_CON[5]=1), the SPECIAL bit must be cleared (IC_TAR[11]), or the GC_OR_START bit must be cleared (IC_TAR[10]).
    ///
    /// Once the source of the ABRT_SBYTE_NORSTRT is fixed, then this bit can be cleared in the same manner as other bits in this register. If the source of the ABRT_SBYTE_NORSTRT is not fixed before attempting to clear this bit, Bit 9 clears for one cycle and is then re-asserted.
    IC_TX_ABRT_SOURCE: IC_TX_ABRT_SOURCE = .{},
    /// Generate Slave Data NACK Register
    ///
    /// The register is used to generate a NACK for the data part of a transfer when DW_apb_i2c is acting as a slave-receiver. This register only exists when the IC_SLV_DATA_NACK_ONLY parameter is set to 1. When this parameter disabled, this register does not exist and writing to the register&#39;s address has no effect.
    ///
    /// A write can occur on this register if both of the following conditions are met: - DW_apb_i2c is disabled (IC_ENABLE[0] = 0) - Slave part is inactive (IC_STATUS[6] = 0) Note: The IC_STATUS[6] is a register read-back location for the internal slv_activity signal; the user should poll this before writing the ic_slv_data_nack_only bit.
    IC_SLV_DATA_NACK_ONLY: IC_SLV_DATA_NACK_ONLY = .{},
    /// DMA Control Register
    ///
    /// The register is used to enable the DMA Controller interface operation. There is a separate bit for transmit and receive. This can be programmed regardless of the state of IC_ENABLE.
    IC_DMA_CR: IC_DMA_CR = .{},
    /// DMA Transmit Data Level Register
    IC_DMA_TDLR: IC_DMA_TDLR = .{},
    /// I2C Receive Data Level Register
    IC_DMA_RDLR: IC_DMA_RDLR = .{},
    /// I2C SDA Setup Register
    ///
    /// This register controls the amount of time delay (in terms of number of ic_clk clock periods) introduced in the rising edge of SCL - relative to SDA changing - when DW_apb_i2c services a read request in a slave-transmitter operation. The relevant I2C requirement is tSU:DAT (note 4) as detailed in the I2C Bus Specification. This register must be programmed with a value equal to or greater than 2.
    ///
    /// Writes to this register succeed only when IC_ENABLE[0] = 0.
    ///
    /// Note: The length of setup time is calculated using [(IC_SDA_SETUP - 1) * (ic_clk_period)], so if the user requires 10 ic_clk periods of setup time, they should program a value of 11. The IC_SDA_SETUP register is only used by the DW_apb_i2c when operating as a slave transmitter.
    IC_SDA_SETUP: IC_SDA_SETUP = .{},
    /// I2C ACK General Call Register
    ///
    /// The register controls whether DW_apb_i2c responds with a ACK or NACK when it receives an I2C General Call address.
    ///
    /// This register is applicable only when the DW_apb_i2c is in slave mode.
    IC_ACK_GENERAL_CALL: IC_ACK_GENERAL_CALL = .{},
    /// I2C Enable Status Register
    ///
    /// The register is used to report the DW_apb_i2c hardware status when the IC_ENABLE[0] register is set from 1 to 0; that is, when DW_apb_i2c is disabled.
    ///
    /// If IC_ENABLE[0] has been set to 1, bits 2:1 are forced to 0, and bit 0 is forced to 1.
    ///
    /// If IC_ENABLE[0] has been set to 0, bits 2:1 is only be valid as soon as bit 0 is read as &#39;0&#39;.
    ///
    /// Note: When IC_ENABLE[0] has been set to 0, a delay occurs for bit 0 to be read as 0 because disabling the DW_apb_i2c depends on I2C bus activities.
    IC_ENABLE_STATUS: IC_ENABLE_STATUS = .{},
    /// I2C SS, FS or FM+ spike suppression limit
    ///
    /// This register is used to store the duration, measured in ic_clk cycles, of the longest spike that is filtered out by the spike suppression logic when the component is operating in SS, FS or FM+ modes. The relevant I2C requirement is tSP (table 4) as detailed in the I2C Bus Specification. This register must be programmed with a minimum value of 1.
    IC_FS_SPKLEN: IC_FS_SPKLEN = .{},
    /// Clear RESTART_DET Interrupt Register
    IC_CLR_RESTART_DET: IC_CLR_RESTART_DET = .{},
    /// Component Parameter Register 1
    ///
    /// Note This register is not implemented and therefore reads as 0. If it was implemented it would be a constant read-only register that contains encoded information about the component&#39;s parameter settings. Fields shown below are the settings for those parameters
    IC_COMP_PARAM_1: IC_COMP_PARAM_1 = .{},
    /// I2C Component Version Register
    IC_COMP_VERSION: IC_COMP_VERSION = .{},
    /// I2C Component Type Register
    IC_COMP_TYPE: IC_COMP_TYPE = .{},
};
pub const I2C1 = I2C1_p{};
