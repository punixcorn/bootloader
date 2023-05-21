	;; the bootloader for potatOs
	;; function:
	;; - load init_kernel.asm and jump to it

	bits 16; 16 bits mode
	org  0x7c00; start from 0x07c00

	jmp start; program start

%include "./libs/print.asm"; for printing [ function = print_message( bx = string) ]

load_kernel:
	;setting up Disk
	mov      ah, 0x02; first thing to set
	mov      al, 25; number of sectors to read
	mov      dl, [disknum]; the disk type to read 80h for harddisk (using disknum)
	;seting  up CHS
	mov      ch, 0h; Cylinder to read ( C )
	mov      dh, 0h; which Head ( H )
	mov      cl, 2h; which sector to start reading ( S )
	hlt
	int      13h; load disk !
	jc       load_kernel_err

load_kernel_err:
	push bx
	mov  bx, kernel_err_msg
	call print_message
	pop  bx
	hlt

start:
	;kernel location
	KERNEL_LOCATION equ 0x1000
	;save   disk type number
	mov     [disknum], dl

	;set registers
	xor  ax, ax
	mov  es, ax
	mov  ds, ax
	mov  ax, 0x7c00
	mov  ss, ax
	mov  sp, 0x7c00

	;switching to text mode
	mov        ah, 0x0
	mov        al, 0x3
	int        0x10

	;printing boot message
	mov       bx, booting
	call      print_message
	mov       bx, booting_2
	call      print_message

	;load kernel
	mov   ax, KERNEL_LOCATION
	mov   es, ax; where to load disk memory es:bx = pointer load disk
	xor   bx, bx
	call  load_kernel

	;switch to text mode
	mov     ah, 0x0
	mov     al, 0x3
	int     0x10

	;        switch to protected mode
	%include "./libs/protected_mode.asm"

booting:
	db 'welcome to potatOs...', 0x0d, 0x0a, 0

booting_2:
	db 'initializing kernel to boot...', 0x0d, 0x0a, 0

kernel_err_msg:
	db 'Error: could not init kernel,[loading Disk]  carry flag was set', 0x0d, 0x0a, 0

kernel_err_msg_2:
	db 'Error: could not init kernel,[loading Disk] al was not same', 0x0d, 0x0a, 0

disknum:
	db 0

	times 510-($-$$) db 0
	dw    0xaa55; magic boot number
