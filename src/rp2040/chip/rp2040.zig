pub const RESETS = @import("RESETS.zig");
pub const PSM = @import("PSM.zig");
pub const CLOCKS = @import("CLOCKS.zig");
pub const PADS_BANK0 = @import("PADS_BANK0.zig");
pub const PADS_QSPI = @import("PADS_QSPI.zig");
pub const IO_QSPI = @import("IO_QSPI.zig");
pub const IO_BANK0 = @import("IO_BANK0.zig");
pub const SYSINFO = @import("SYSINFO.zig");
pub const PPB = @import("PPB.zig");
pub const SSI = @import("SSI.zig");
pub const XIP_CTRL = @import("XIP_CTRL.zig");
pub const SYSCFG = @import("SYSCFG.zig");
pub const XOSC = @import("XOSC.zig");
pub const PLL_SYS = @import("PLL_SYS.zig");
pub const PLL_USB = @import("PLL_USB.zig");
pub const UART0 = @import("UART0.zig");
pub const UART1 = @import("UART1.zig");
pub const ROSC = @import("ROSC.zig");
pub const WATCHDOG = @import("WATCHDOG.zig");
pub const DMA = @import("DMA.zig");
pub const TIMER = @import("TIMER.zig");
pub const PWM = @import("PWM.zig");
pub const ADC = @import("ADC.zig");
pub const I2C0 = @import("I2C0.zig");
pub const I2C1 = @import("I2C1.zig");
pub const SPI0 = @import("SPI0.zig");
pub const SPI1 = @import("SPI1.zig");
pub const PIO0 = @import("PIO0.zig");
pub const PIO1 = @import("PIO1.zig");
pub const BUSCTRL = @import("BUSCTRL.zig");
pub const SIO = @import("SIO.zig");
pub const USB = @import("USB.zig");
pub const USB_DPRAM = @import("USB_DPRAM.zig");
pub const TBMAN = @import("TBMAN.zig");
pub const VREG_AND_CHIP_RESET = @import("VREG_AND_CHIP_RESET.zig");
pub const RTC = @import("RTC.zig");

const Peripherals = struct {
    RESETS: *const RESETS.RESETS_p = &RESETS.RESETS,
    PSM: *const PSM.PSM_p = &PSM.PSM,
    CLOCKS: *const CLOCKS.CLOCKS_p = &CLOCKS.CLOCKS,
    PADS_BANK0: *const PADS_BANK0.PADS_BANK0_p = &PADS_BANK0.PADS_BANK0,
    PADS_QSPI: *const PADS_QSPI.PADS_QSPI_p = &PADS_QSPI.PADS_QSPI,
    IO_QSPI: *const IO_QSPI.IO_QSPI_p = &IO_QSPI.IO_QSPI,
    IO_BANK0: *const IO_BANK0.IO_BANK0_p = &IO_BANK0.IO_BANK0,
    SYSINFO: *const SYSINFO.SYSINFO_p = &SYSINFO.SYSINFO,
    PPB: *const PPB.PPB_p = &PPB.PPB,
    /// DW_apb_ssi has the following features:
    /// * APB interface – Allows for easy integration into a DesignWare Synthesizable Components for AMBA 2 implementation.
    /// * APB3 and APB4 protocol support.
    /// * Scalable APB data bus width – Supports APB data bus widths of 8, 16, and 32 bits.
    /// * Serial-master or serial-slave operation – Enables serial communication with serial-master or serial-slave peripheral devices.
    /// * Programmable Dual/Quad/Octal SPI support in Master Mode.
    /// * Dual Data Rate (DDR) and Read Data Strobe (RDS) Support - Enables the DW_apb_ssi master to perform operations with the device in DDR and RDS modes when working in Dual/Quad/Octal mode of operation.
    /// * Data Mask Support - Enables the DW_apb_ssi to selectively update the bytes in the device. This feature is applicable only in enhanced SPI modes.
    /// * eXecute-In-Place (XIP) support - Enables the DW_apb_ssi master to behave as a memory mapped I/O and fetches the data from the device based on the APB read request. This feature is applicable only in enhanced SPI modes.
    /// * DMA Controller Interface – Enables the DW_apb_ssi to interface to a DMA controller over the bus using a handshaking interface for transfer requests.
    /// * Independent masking of interrupts – Master collision, transmit FIFO overflow, transmit FIFO empty, receive FIFO full, receive FIFO underflow, and receive FIFO overflow interrupts can all be masked independently.
    /// * Multi-master contention detection – Informs the processor of multiple serial-master accesses on the serial bus.
    /// * Bypass of meta-stability flip-flops for synchronous clocks – When the APB clock (pclk) and the DW_apb_ssi serial clock (ssi_clk) are synchronous, meta-stable flip-flops are not used when transferring control signals across these clock domains.
    /// * Programmable delay on the sample time of the received serial data bit (rxd); enables programmable control of routing delays resulting in higher serial data-bit rates.
    /// * Programmable features:
    /// - Serial interface operation – Choice of Motorola SPI, Texas Instruments Synchronous Serial Protocol or National Semiconductor Microwire.
    /// - Clock bit-rate – Dynamic control of the serial bit rate of the data transfer; used in only serial-master mode of operation.
    /// - Data Item size (4 to 32 bits) – Item size of each data transfer under the control of the programmer.
    /// * Configured features:
    /// - FIFO depth – 16 words deep. The FIFO width is fixed at 32 bits.
    /// - 1 slave select output.
    /// - Hardware slave-select – Dedicated hardware slave-select line.
    /// - Combined interrupt line - one combined interrupt line from the DW_apb_ssi to the interrupt controller.
    /// - Interrupt polarity – active high interrupt lines.
    /// - Serial clock polarity – low serial-clock polarity directly after reset.
    /// - Serial clock phase – capture on first edge of serial-clock directly after reset.
    SSI: *const SSI.SSI_p = &SSI.SSI,
    /// QSPI flash execute-in-place block
    XIP_CTRL: *const XIP_CTRL.XIP_CTRL_p = &XIP_CTRL.XIP_CTRL,
    /// Register block for various chip control signals
    SYSCFG: *const SYSCFG.SYSCFG_p = &SYSCFG.SYSCFG,
    /// Controls the crystal oscillator
    XOSC: *const XOSC.XOSC_p = &XOSC.XOSC,
    PLL_SYS: *const PLL_SYS.PLL_SYS_p = &PLL_SYS.PLL_SYS,
    PLL_USB: *const PLL_USB.PLL_USB_p = &PLL_USB.PLL_USB,
    UART0: *const UART0.UART0_p = &UART0.UART0,
    UART1: *const UART1.UART1_p = &UART1.UART1,
    ROSC: *const ROSC.ROSC_p = &ROSC.ROSC,
    WATCHDOG: *const WATCHDOG.WATCHDOG_p = &WATCHDOG.WATCHDOG,
    /// DMA with separate read and write masters
    DMA: *const DMA.DMA_p = &DMA.DMA,
    /// Controls time and alarms
    /// time is a 64 bit value indicating the time in usec since power-on
    /// timeh is the top 32 bits of time &amp; timel is the bottom 32 bits
    /// to change time write to timelw before timehw
    /// to read time read from timelr before timehr
    /// An alarm is set by setting alarm_enable and writing to the corresponding alarm register
    /// When an alarm is pending, the corresponding alarm_running signal will be high
    /// An alarm can be cancelled before it has finished by clearing the alarm_enable
    /// When an alarm fires, the corresponding alarm_irq is set and alarm_running is cleared
    /// To clear the interrupt write a 1 to the corresponding alarm_irq
    TIMER: *const TIMER.TIMER_p = &TIMER.TIMER,
    /// Simple PWM
    PWM: *const PWM.PWM_p = &PWM.PWM,
    /// Control and data interface to SAR ADC
    ADC: *const ADC.ADC_p = &ADC.ADC,
    /// DW_apb_i2c address block
    ///
    /// List of configuration constants for the Synopsys I2C hardware (you may see references to these in I2C register header; these are *fixed* values, set at hardware design time):
    ///
    /// IC_ULTRA_FAST_MODE ................ 0x0
    /// IC_UFM_TBUF_CNT_DEFAULT ........... 0x8
    /// IC_UFM_SCL_LOW_COUNT .............. 0x0008
    /// IC_UFM_SCL_HIGH_COUNT ............. 0x0006
    /// IC_TX_TL .......................... 0x0
    /// IC_TX_CMD_BLOCK ................... 0x1
    /// IC_HAS_DMA ........................ 0x1
    /// IC_HAS_ASYNC_FIFO ................. 0x0
    /// IC_SMBUS_ARP ...................... 0x0
    /// IC_FIRST_DATA_BYTE_STATUS ......... 0x1
    /// IC_INTR_IO ........................ 0x1
    /// IC_MASTER_MODE .................... 0x1
    /// IC_DEFAULT_ACK_GENERAL_CALL ....... 0x1
    /// IC_INTR_POL ....................... 0x1
    /// IC_OPTIONAL_SAR ................... 0x0
    /// IC_DEFAULT_TAR_SLAVE_ADDR ......... 0x055
    /// IC_DEFAULT_SLAVE_ADDR ............. 0x055
    /// IC_DEFAULT_HS_SPKLEN .............. 0x1
    /// IC_FS_SCL_HIGH_COUNT .............. 0x0006
    /// IC_HS_SCL_LOW_COUNT ............... 0x0008
    /// IC_DEVICE_ID_VALUE ................ 0x0
    /// IC_10BITADDR_MASTER ............... 0x0
    /// IC_CLK_FREQ_OPTIMIZATION .......... 0x0
    /// IC_DEFAULT_FS_SPKLEN .............. 0x7
    /// IC_ADD_ENCODED_PARAMS ............. 0x0
    /// IC_DEFAULT_SDA_HOLD ............... 0x000001
    /// IC_DEFAULT_SDA_SETUP .............. 0x64
    /// IC_AVOID_RX_FIFO_FLUSH_ON_TX_ABRT . 0x0
    /// IC_CLOCK_PERIOD ................... 100
    /// IC_EMPTYFIFO_HOLD_MASTER_EN ....... 1
    /// IC_RESTART_EN ..................... 0x1
    /// IC_TX_CMD_BLOCK_DEFAULT ........... 0x0
    /// IC_BUS_CLEAR_FEATURE .............. 0x0
    /// IC_CAP_LOADING .................... 100
    /// IC_FS_SCL_LOW_COUNT ............... 0x000d
    /// APB_DATA_WIDTH .................... 32
    /// IC_SDA_STUCK_TIMEOUT_DEFAULT ...... 0xffffffff
    /// IC_SLV_DATA_NACK_ONLY ............. 0x1
    /// IC_10BITADDR_SLAVE ................ 0x0
    /// IC_CLK_TYPE ....................... 0x0
    /// IC_SMBUS_UDID_MSB ................. 0x0
    /// IC_SMBUS_SUSPEND_ALERT ............ 0x0
    /// IC_HS_SCL_HIGH_COUNT .............. 0x0006
    /// IC_SLV_RESTART_DET_EN ............. 0x1
    /// IC_SMBUS .......................... 0x0
    /// IC_OPTIONAL_SAR_DEFAULT ........... 0x0
    /// IC_PERSISTANT_SLV_ADDR_DEFAULT .... 0x0
    /// IC_USE_COUNTS ..................... 0x0
    /// IC_RX_BUFFER_DEPTH ................ 16
    /// IC_SCL_STUCK_TIMEOUT_DEFAULT ...... 0xffffffff
    /// IC_RX_FULL_HLD_BUS_EN ............. 0x1
    /// IC_SLAVE_DISABLE .................. 0x1
    /// IC_RX_TL .......................... 0x0
    /// IC_DEVICE_ID ...................... 0x0
    /// IC_HC_COUNT_VALUES ................ 0x0
    /// I2C_DYNAMIC_TAR_UPDATE ............ 0
    /// IC_SMBUS_CLK_LOW_MEXT_DEFAULT ..... 0xffffffff
    /// IC_SMBUS_CLK_LOW_SEXT_DEFAULT ..... 0xffffffff
    /// IC_HS_MASTER_CODE ................. 0x1
    /// IC_SMBUS_RST_IDLE_CNT_DEFAULT ..... 0xffff
    /// IC_SMBUS_UDID_LSB_DEFAULT ......... 0xffffffff
    /// IC_SS_SCL_HIGH_COUNT .............. 0x0028
    /// IC_SS_SCL_LOW_COUNT ............... 0x002f
    /// IC_MAX_SPEED_MODE ................. 0x2
    /// IC_STAT_FOR_CLK_STRETCH ........... 0x0
    /// IC_STOP_DET_IF_MASTER_ACTIVE ...... 0x0
    /// IC_DEFAULT_UFM_SPKLEN ............. 0x1
    /// IC_TX_BUFFER_DEPTH ................ 16
    I2C0: *const I2C0.I2C0_p = &I2C0.I2C0,
    I2C1: *const I2C1.I2C1_p = &I2C1.I2C1,
    SPI0: *const SPI0.SPI0_p = &SPI0.SPI0,
    SPI1: *const SPI1.SPI1_p = &SPI1.SPI1,
    /// Programmable IO block
    PIO0: *const PIO0.PIO0_p = &PIO0.PIO0,
    PIO1: *const PIO1.PIO1_p = &PIO1.PIO1,
    /// Register block for busfabric control signals and performance counters
    BUSCTRL: *const BUSCTRL.BUSCTRL_p = &BUSCTRL.BUSCTRL,
    /// Single-cycle IO block
    /// Provides core-local and inter-core hardware for the two processors, with single-cycle access.
    SIO: *const SIO.SIO_p = &SIO.SIO,
    /// USB FS/LS controller device registers
    USB: *const USB.USB_p = &USB.USB,
    /// DPRAM layout for USB device.
    USB_DPRAM: *const USB_DPRAM.USB_DPRAM_p = &USB_DPRAM.USB_DPRAM,
    /// Testbench manager. Allows the programmer to know what platform their software is running on.
    TBMAN: *const TBMAN.TBMAN_p = &TBMAN.TBMAN,
    /// control and status for on-chip voltage regulator and chip level reset subsystem
    VREG_AND_CHIP_RESET: *const VREG_AND_CHIP_RESET.VREG_AND_CHIP_RESET_p = &VREG_AND_CHIP_RESET.VREG_AND_CHIP_RESET,
    /// Register block to control RTC
    RTC: *const RTC.RTC_p = &RTC.RTC,
};

pub const peripherals = Peripherals{};

pub fn busy_wait_at_least_cycles(delay_cycles: u32) void {
    var cycles = delay_cycles;
    asm volatile (
        \\1: subs %[cycles], #3
        \\bcs 1b
        : [cycles] "+r" (cycles),
        :
        : .{ .cpsr = true, .memory = true });
}
