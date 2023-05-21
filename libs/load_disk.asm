	;; Load Disk
	;; dh = number of disks to load

load_disk:
	;   setting up Disk
	mov al, dh; number of sectors to read
	mov dl, 80h; [disknum]; the disk type to read 80h for harddisk or 0 for 0 based indexing ?? (using disknum)
	;   setting  up CHS
	mov ch, 0h; Cylinder ( C )
	mov dh, 0h; Head ( H )
	mov cl, 2h; sector ( S )
	;   setting interrupt
	mov ah, 0x2; first thing to set
	int 13h; load disk !
	jc  load_kernel_err_carry_flag
	ret

load_kernel_err_carry_flag:
	push bx
	mov  bx, load_disk_err_msg_cf
	call print_message
	mov  bx, load_disk_err_AH
	call print_message
	mov  al, ah
	mov  ah, 0x0e
	int  10h
	pop  bx
	hlt
