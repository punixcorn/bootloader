	;  init gdt, protected mode then call Kernel
	;; To know
	;; limit : 20bits
	;; base : 32bits
	;; next bits : PPT : 4bits [ final : 1001 ]
	;; Present (if segment is used) ? 1
	;; Privilege the power(ring) : 00 | 01 | 10 | 11
	;; Type (1 code, 0 data) : 1

	;; code segment
	;; next bits : Flags : 8bits [ final : 10101100 ]
	;; 4 bits : type flags
	;; 1st : contain code ? 1
	;; 2nd : conforming ? exec by lower power ? 0
	;; 3rd : readable ? 1
	;; 4th : accesed : 0 ( always )
	;; 4 bits : type flags
	;; 1st : 4gib(1) or 64kib(0)  ? 1
	;; 2nd : 32bits ? 1
	;; 3rd : 0
	;; 4th : 0

	;; data segment
	;; 4 bits : type flags
	;; 2nd : direction(grow downwards?) ?  0
	;; 3rd : writeable ? 1

GDT_START:
	; a null descriptor is first

null_descriptor:
	dd 0x0; 2 byte (NULL)
	dd 0x0; 2 byte (NULL)

code_descriptor:
	dw 0xffff;; first 16bits of limit
	dw 0x0;; first 24 bitsof base [ 16 +
	db 0x0;; 8 ]
	db 0x9a;; 0b10011010;; ppt + typeflags
	db 0xcf;; 0b11001111;; Flags + final 4 bits of limit
	db 0x0; last 8 bits of base

data_descriptor:
	dw 0xffff;; first 16bits of limit
	dw 0x0;; first 24 bitsof base
	db 0x0
	db 0x92; 0b10010010;; ppt + typeflags
	db 0xcf; 0b11001111;; Flags + final 4 bits of limit
	db 0x0; last 8 bits of base

GDT_END:

GDT_descriptor:
	dw (GDT_END - GDT_START ) - 1; size of GDT
	dd GDT_START; memory address of GDT_START

	CODE_SEG equ code_descriptor - GDT_START
	DATA_SEG equ data_descriptor - GDT_START
