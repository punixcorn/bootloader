; the bootloader for potatOs
; function:
; - load init_kernel.asm and jump to it

[bits 16]
org   0x7c00; start from 0x07c00


	;switching to text mode
	mov        ah, 0x0
	mov        al, 0x3
	int        0x10

	;printing boot message
	mov       bx, booting_message
	call      print_message
	mov       bx, booting_disk
	call      print_message

	;set location es:bx
	xor  bx, bx
	mov  es, bx
	mov  bx, KERNEL_LOCATION
    call load_disk


    call enter_protected_mode
    jmp $

%include "include/print.asm"                ; for printing [ print_message( bx = string) ]
%include "include/load_disk.asm"            ; load disk 
%include "include/gdt.asm"                  ; load gdt
%include "include/protected_mode.asm"       ; set up protected mode
KERNEL_LOCATION equ 0x1000

; start protected mode
[bits 32]

protected_mode:
    ;mov dword [0xb8000], 0x2f4b2f4f
    ;jmp $
	;jump to kernel
	call  KERNEL_LOCATION
    jmp $

booting_message:
	db 0x0d,0x0a,'welcome to potatOs...', 0x0d, 0x0a, 0

booting_disk:
	db 'initializing disk to boot...', 0x0d, 0x0a, 0

	times 510-($-$$) db 0
	dw    0xaa55; magic boot number
