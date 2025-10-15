const rp = @import("chip/rp2040.zig");

pub const Handler = *const fn () callconv(.c) void;

const BaseVectorTable = extern struct {
    initial_stack_ptr: *const anyopaque,
    reset: Handler = &unhandledInterruptReset,
};
// this is only for the startup, later we swap to using vector_table which will
// be located in ram to be able to add interrupt handlers at runtime
export const base_vector_table: BaseVectorTable align(256) linksection(".vector_table") = .{
    .initial_stack_ptr = @ptrFromInt(0x20040000),
    .reset = &resetHandler,
};

// The rp2040 datasheet doesnt talk about the base interrupts only the vendor
// See armV6 reference manual section B.1.5.2
pub const VectorTable = extern struct {
    // arm spec common interrupts
    initial_stack_ptr: *const anyopaque,
    reset: Handler = &unhandledInterruptReset,
    nmi: Handler = &unhandledInterruptNmi,
    hard_fault: Handler = &unhandledInterruptHardFault,
    reserved: [7]u32 = undefined,
    svc: Handler = &unhandledInterruptSvc,
    reserved2: [2]u32 = undefined,
    pend_sv: Handler = &unhandledInterruptPendSV,
    sys_tick: Handler = &unhandledInterruptSysTick,

    // rp2040 specific ones
    TIMER_IRQ_0: Handler = &unhandledInterruptTimer0,
    TIMER_IRQ_1: Handler = &unhandledInterruptTimer1,
    TIMER_IRQ_2: Handler = &unhandledInterruptTimer2,
    TIMER_IRQ_3: Handler = &unhandledInterruptTimer3,
    PWM_IRQ_WRAP: Handler = &unhandledInterruptPWM,
    USBCTRL_IRQ: Handler = &unhandledInterruptUSB,
    XIP_IRQ: Handler = &unhandledInterruptXIP,
    PIO0_IRQ_0: Handler = &unhandledInterruptPIO_00,
    PIO0_IRQ_1: Handler = &unhandledInterruptPIO_01,
    PIO1_IRQ_0: Handler = &unhandledInterruptPIO_10,
    PIO1_IRQ_1: Handler = &unhandledInterruptPIO_11,
    DMA_IRQ_0: Handler = &unhandledInterrupt1DMA0,
    DMA_IRQ_1: Handler = &unhandledInterruptDMA1,
    IO_IRQ_BANK0: Handler = &unhandledInterruptIOBank,
    IO_IRQ_QSPI: Handler = &unhandledInterruptIOQSPI,
    SIO_IRQ_PROC0: Handler = &unhandledInterruptSIO0,
    SIO_IRQ_PROC1: Handler = &unhandledInterruptSIO1,
    CLOCKS_IRQ: Handler = &unhandledInterruptClocks,
    SPI0_IRQ: Handler = &unhandledInterruptSPI0,
    SPI1_IRQ: Handler = &unhandledInterruptSPIgp,
    UART0_IRQ: Handler = &unhandledInterruptUART0,
    UART1_IRQ: Handler = &unhandledInterruptUART1,
    ADC_IRQ_FIFO: Handler = &unhandledInterruptADC,
    I2C0_IRQ: Handler = &unhandledInterruptI2C0,
    I2C1_IRQ: Handler = &unhandledInterruptI2C1,
    RTC_IRQ: Handler = &unhandledInterruptRTC,
};

pub var vector_table: VectorTable align(256) = .{
    .initial_stack_ptr = @ptrFromInt(0x20040000),
    .reset = &resetHandler,
};

const helpers = @import("chip/helpers.zig");
pub fn enableInterrupt(interrupt: NVICInterrupt) void {
    rp.peripherals.PPB.NVIC_ICPR.write(@as(u32, 1) << @intFromEnum(interrupt));
    rp.peripherals.PPB.NVIC_ISER.write(@as(u32, 1) << @intFromEnum(interrupt));
}

extern fn startup() callconv(.c) void;
fn resetHandler() callconv(.c) void {
    startup();
}

fn unhandledInterruptReset() callconv(.c) void {
    @breakpoint();
}
fn unhandledInterruptNmi() callconv(.c) void {
    @breakpoint();
}
fn unhandledInterruptHardFault() callconv(.c) void {
    @breakpoint();
}
fn unhandledInterruptSvc() callconv(.c) void {
    @breakpoint();
}
fn unhandledInterruptPendSV() callconv(.c) void {
    @breakpoint();
}
fn unhandledInterruptSysTick() callconv(.c) void {
    @breakpoint();
}

pub const NVICInterrupt = enum(u5) {
    TIMER_IRQ_0 = 0,
    TIMER_IRQ_1 = 1,
    TIMER_IRQ_2 = 2,
    TIMER_IRQ_3 = 3,
    PWM_IRQ_WRAP = 4,
    USBCTRL_IRQ = 5,
    XIP_IRQ = 6,
    PIO0_IRQ_0 = 7,
    PIO0_IRQ_1 = 8,
    PIO1_IRQ_0 = 9,
    PIO1_IRQ_1 = 10,
    DMA_IRQ_0 = 11,
    DMA_IRQ_1 = 12,
    IO_IRQ_BANK0 = 13,
    IO_IRQ_QSPI = 14,
    SIO_IRQ_PROC0 = 15,
    SIO_IRQ_PROC1 = 16,
    CLOCKS_IRQ = 17,
    SPI0_IRQ = 18,
    SPI1_IRQ = 19,
    UART0_IRQ = 20,
    UART1_IRQ = 21,
    ADC_IRQ_FIFO = 22,
    I2C0_IRQ = 23,
    I2C1_IRQ = 24,
    RTC_IRQ = 25,
};

pub fn unhandledInterruptTimer0() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptTimer1() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptTimer2() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptTimer3() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptPWM() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptUSB() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptXIP() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptPIO_00() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptPIO_01() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptPIO_10() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptPIO_11() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterrupt1DMA0() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptDMA1() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptIOBank() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptIOQSPI() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptSIO0() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptSIO1() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptClocks() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptSPI0() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptSPIgp() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptUART0() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptUART1() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptADC() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptI2C0() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptI2C1() callconv(.c) void {
    @breakpoint();
}

pub fn unhandledInterruptRTC() callconv(.c) void {
    @breakpoint();
}
