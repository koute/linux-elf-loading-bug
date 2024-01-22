        SECTIONS {
            . = 0x10000;
            .rodata : { *(.rodata) *(.rodata.*) *(.gcc_except_table.*) }
            . = ALIGN(0x1000);
            .data : { *(.got) *(.got.*) *(.data.rel.ro) *(.data.rel.ro.*) *(.sdata) *(.sdata.*) *(.data) *(.data.*) }
            .bss : { *(.sbss) *(.sbss.*) *(.bss) *(.bss.*) }
            . = ALIGN(0x1000);
            .text : { *(.text .text.*) }
            . = 0x20000;
            .extra : { KEEP(*(.extra)) }
            /DISCARD/ : { *(.comment) *(.eh_frame) *(.eh_frame_hdr) }
        }

        ENTRY(_start)
