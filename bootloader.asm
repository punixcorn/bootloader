	;; the bootloader for potatOs
	;; function: load disk into memory, switch to protected mode

	cli
	bits 16; 16 bits mode
	org  0x7c00; start from 0x07c00
	jmp  start; program start

%include "./libs/print.asm"; for printing [ print_message( bx = string) ]
%include "./libs/load_disk.asm"; for loading disk [ load_disk( dh=number of sectors to load )]

start:
	KERNEL_LOCATION equ 0x1000;kernel location
	SECTORS_TO_LOAD equ 9; sectors to read into memory

	;set registers
	xor  ax, ax
	mov  ds, ax
	mov  ax, 0x7c00
	mov  ss, ax
	mov  sp, 0x7c00

	;switching to text mode
	mov        ah, 0x0
	mov        al, 0x3
	int        0x10

	;printing boot message
	mov       bx, booting_msg
	call      print_message
	mov       bx, booting_msg_2
	call      print_message

	;load kernel
	xor   ax, ax
	mov   es, ax; where to load disk memory es:bx = pointer load disk
	mov   bx, KERNEL_LOCATION
	mov   dh, SECTORS_TO_LOAD
	call  load_disk

	mov  bx, test_message
	call print_message

	;switch  to protected mode
	%include "./libs/protected_mode.asm"

booting_msg:
	db 'welcome to potatOs...', 0x0d, 0x0a, 0

booting_msg_2:
	db 'initializing kernel to boot...', 0x0d, 0x0a, 0

test_message:
	db 'kernel loaded', 0x0d, 0x0a, 0

load_disk_err_msg_cf:
	db 'Error: could not init kernel : [loading Disk]  carry flag was set', 0x0d, 0x0a, 0

load_disk_err_AH:
	db 'Value of ah : ', 0

	times 510-($-$$) db 0
	dw    0xaa55; magic boot number
