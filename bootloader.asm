	;    the bootloader for potatOs
	org  0x7c00; start from 0x07c00
	bits 16; 16 bits mode

	;   bootloader entry
	jmp start

	; put offset of string in bx

print_message:
	mov al, [bx]
	cmp al, 0
	je  end_print
	int 10h
	inc bx
	jmp print_message

end_print:
	ret

load_kernel:
	;setting up Disk
	mov      ah, 02h; first thing to set
	mov      al, 01h; number of sectors to read
	mov      dl, [disknum]; the disk type to read 80h for harddisk (using disknum)
	;seting  up CHS
	mov      ch, 0; Cylinder to read ( C )
	mov      dh, 0; which Head ( H )
	mov      cl, 2; how many sectors to read ( S )
	mov      bx, 0; where to load disk in memory
	int      13h; intuerupt
	jc       load_kernel_err
	cmp      al, 01h
	jne      load_kernel_err
	ret

load_kernel_err:
	push bx
	mov  bx, kernel_err_msg
	call print_message
	pop  bx
	hlt

start:
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
	mov       ah, 0x0e
	mov       bx, booting; for some reason ds:si is not working ( using bx )
	call      print_message

	;save  disk type number
	mov    [disknum], dl
	;where to load disk memory es:bx = pointer to where to load disk in memory
	mov    ax, 0x7e00; 7e00 = 7c00 + 512B(the A)
	mov    es, ax; hence 7e00:0000 is where we want to load our disk
	;load  disk into memory
	call   load_kernel

	;test if disk has been loaded print whats at 7e00:000 which should be A
	;mov  ah, 0x0e
	;mov  bx, 0x0
	;mov  al, [es:bx]
	;int  10h

	jmp 7e00h:0000h; jump to loaded disk

booting:
	db 'looking for potat0s Kernel to boot...', 0x0d, 0x0a, 0
	kernel_err_msg: db 'error loading kernel',0x0d,0x0a,0

disknum:
	db    0
	times 510-($-$$) db 0
	dw    0xaa55; magic boot number
	;seg  descrpitor = 8bytes ( )
	;GDTR = [16bits GDT limit] [32bits GDT base address]
	;seg  selector = [16bits]( 00 = privelege, 0 = table indicator, 00...=index of sege descriptor)
