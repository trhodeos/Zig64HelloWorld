MEMORY {
    rom	: ORIGIN = 0x80000000, LENGTH = 0x7FFFFFFF
    iwram	: ORIGIN = 0x03000000, LENGTH = 32K
    ewram	: ORIGIN = 0x02000000, LENGTH = 256K
}

ENTRY(N64Main)

OUTPUT_FORMAT("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
OUTPUT_ARCH(mips64el)

__text_start = ORIGIN(rom);
__eheap_end = ORIGIN(ewram) + LENGTH(ewram);
__iwram_start = ORIGIN(iwram);
__iwram_top = ORIGIN(iwram) + LENGTH(iwram);
__sp_irq = __iwram_top - 0x060;
__sp_usr = __sp_irq - 0x0a0;
__irq_flags = 0x03007ff8;

SECTIONS
{
    . = __text_start;

    .text :
    {
        KEEP(*(.gbaheader))
        *(EXCLUDE_FILE (*.iwram*) .text*)
        . ALIGN(4);
    } >rom = 0xff

    __text_end = .;
    .fini :
    {
        KEEP (*(.fini))
        . = ALIGN(4);
    } >rom =0

    .rodata : {
        *(.rodata)
        . = ALIGN(4);
    } >rom = 0xff

    .ARM.extab   : { *(.ARM.extab* .gnu.linkonce.armextab.*) } >rom
    __exidx_start = .;
    .ARM.exidx   : { *(.ARM.exidx* .gnu.linkonce.armexidx.*) } >rom
    __exidx_end = .;

    .data : {
        *(.data)
        . = ALIGN(4);
    } >ewram = 0xff

    .bss : {
        *(COMMON)
        *(.bss)
        . = ALIGN(4);
    } >ewram
}
