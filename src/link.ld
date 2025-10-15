MEMORY
{
    FLASH(rwx) : ORIGIN = 0x10000000, LENGTH = 16m
    RAM(rwx) : ORIGIN =  0x20000000, LENGTH = 256k
}

SECTIONS
{
    .boot2 : {
        __boot2_start__ = .;
        KEEP(*(.boot2))
        /* 0 pad to 256 bytes, we'll put the checksum in later from zig */
        . = ALIGN(256);
        FILL(0x00);
        __boot2_end__ = .;
    } > FLASH
    ASSERT(__boot2_end__ - __boot2_start__ == 256,
        "ERROR: Pico second stage bootloader must be 256 bytes in size")

    .text : {
        __text_start__ = .;
        KEEP(*(.vector_table))
        *(.text*)
        *(.rodata*)
        __text_end__ = .;
    } > FLASH

    .data : {
        __data_start__ = .;
        *(.data*)
        __data_end__ = .;
    } > RAM AT> FLASH

    .bss : {
        __bss_start__ = .;
        *(.bss*)
        *(COMMON)
        __bss_end__ = .;
    } > RAM


    /DISCARD/ : {
        *(.ARM .ARM.*)
    }

    __data_load__ = LOADADDR(.data);

}
