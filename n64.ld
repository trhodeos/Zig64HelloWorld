MEMORY {
    rom	: ORIGIN = 0x80000000, LENGTH = 64M
}

ENTRY(N64Main)

OUTPUT_FORMAT("elf32-bigmips")
OUTPUT_ARCH(mips)

__text_start = ORIGIN(rom);

SECTIONS
{
  . = __text_start;

  .text :
  {
    KEEP(*(.n64header))
    KEEP(*(.n64main))
    . ALIGN(32);
  } >rom = 0xff
  __text_end = .;

  .fini : {
    KEEP (*(.fini))
  } >rom =0

  .rodata : {
    *(.rodata)
    . = ALIGN(32);
  } >rom = 0xff

  .data : {
    *(.data)
    . = ALIGN(32);
  } >rom = 0xff

  .bss : {
    *(COMMON)
    *(.bss)
    . = ALIGN(32);
  } >rom

  .got : {
    *(.got)
  } >rom

  .reginfo : {
    *(.reginfo)
  } >rom

  /* Everything is statically linked, so discard PLTs. */
  /DISCARD/ : { *(.rel.iplt) *(.rela.iplt) *(.rel.plt) *(.rela.plt) *(.plt) *(.iplt) }

  /* We don't make use of debugging information, so drop that, too. */
  /DISCARD/ : { *(.debug) *(.debug_srcinfo) *(.debug_sfnames) *(.debug_aranges) *(.debug_pubnames) *(.debug_info .gnu.linkonce.wi.*) *(.debug_abbrev) *(.debug_line .debug_line.* .debug_line_end ) *(.debug_frame) *(.debug_str) *(.debug_loc) *(.debug_macinfo) *(.debug_weaknames) *(.debug_funcnames) *(.debug_typenames) *(.debug_varnames) *(.debug_pubtypes) *(.debug_ranges) *(.debug_macro) *(.mdebug.abi32) *(.mdebug.abiN32) *(.mdebug.abi64) *(.mdebug.abiO64) *(.mdebug.eabi32) *(.mdebug.eabi64) }

  /* Discard things that the standard link script drops, too. */
  /DISCARD/ : { *(.note.GNU-stack) *(.gnu_debuglink) *(.gnu.lto_*) }

  /* Don't include MIPS ABI information with the ROM. */
  /DISCARD/ : { *(.MIPS.abiflags) }
}
