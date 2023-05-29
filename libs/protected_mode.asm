GDT_START:
	; a null descriptor is first

null_descriptor:
	dd 0
	dd 0

code_descriptor:
	dw 0xffff;; first 16bits of limit
	dw 0x0000;; first 24 bits of base [ 16 +
	db 0x00;; 8 ]
	db 0x9a;; 0b10011010;; ppt + typeflags
	db 0xcf;; 0b11001111;; Flags + final 4 bits of limit
	db 0x00; last 8 bits of base

data_descriptor:
	dw 0xffff;; first 16bits of limit
	dw 0x0000;; first 24 bitsof base
	db 0x00;; last 8 bots
	db 0x92; 0b10010010;; ppt + typeflags
	db 0xcf; 0b11001111;; Flags + final 4 bits of limit
	db 0x00; last 8 bits of base

GDT_END:

GDT_PTR:
	dw (GDT_END - GDT_START ) -1; size of GDT
	dd GDT_START; memory address of GDT_START

	CODE_SEG equ code_descriptor - GDT_START
	DATA_SEG equ data_descriptor - GDT_START

	; Set up the IDT

;IDT:
	; times 256 dw 0

;IDT_PTR:
	; dw 256 * 8 - 1
	; dd IDT

load_gdt:
	cli
	lgdt [GDT_PTR]
	mov  eax, cr0
	or   eax, 0x01
	mov  cr0, eax

;load_idt:
	; lidt [IDT_PTR]

	;   far jump
	jmp CODE_SEG:start_protected_mode
hlt
;[bits 32]

start_protected_mode:
	; set up resgisters
	; mov ax, DATA_SEG
	; mov ds, ax
	; mov ss, ax
	; mov es, ax
	; mov fs, ax
	; mov gs, ax
	; mov ebp, 0x9000
	; mov esp, ebp

;kernel_jmp:
	; ; jump to kernel
	; jmp   KERNEL_LOCATION
