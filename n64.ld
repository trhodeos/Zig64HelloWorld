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
    . = 0x80001000;
    KEEP(*(.n64main))
    . = ALIGN(4);
  } >rom = 0
  __text_end = .;

  .fini : {
    KEEP (*(.fini))
  } >rom

  .rodata : {
    *(.rodata)
    . = ALIGN(32);
  } >rom

  .data : {
    *(.data)
    . = ALIGN(32);
  } >rom

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

  .text2 : {
    . = 0x80101000;
    . = ALIGN(4);
  } >rom =0
  __text2_end = .;

  /* Everything is statically linked, so discard PLTs. */
  /DISCARD/ : { *(.rel.iplt) *(.rela.iplt) *(.rel.plt) *(.rela.plt) *(.plt) *(.iplt) }

  /* We don't make use of debugging information, so drop that, too. */
  /DISCARD/ : { *(.debug) *(.debug_srcinfo) *(.debug_sfnames) *(.debug_aranges) *(.debug_pubnames) *(.debug_info .gnu.linkonce.wi.*) *(.debug_abbrev) *(.debug_line .debug_line.* .debug_line_end ) *(.debug_frame) *(.debug_str) *(.debug_loc) *(.debug_macinfo) *(.debug_weaknames) *(.debug_funcnames) *(.debug_typenames) *(.debug_varnames) *(.debug_pubtypes) *(.debug_ranges) *(.debug_macro) *(.mdebug.abi32) *(.mdebug.abiN32) *(.mdebug.abi64) *(.mdebug.abiO64) *(.mdebug.eabi32) *(.mdebug.eabi64) }

  /* Discard things that the standard link script drops, too. */
  /DISCARD/ : { *(.note.GNU-stack) *(.gnu_debuglink) *(.gnu.lto_*) }

  /* Don't include MIPS ABI information with the ROM. */
  /DISCARD/ : { *(.MIPS.abiflags) }
}
