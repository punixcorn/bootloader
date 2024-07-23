load_disk:
    pusha
	;   setting up Disk
	mov al, 1       ; number of sectors to read
	;mov dl, 0x80; [disknum]; the disk type to read 80h for harddisk (using disknum)

	;   setting  up CHS
	mov ch, 0h      ; Cylinder ( C )
	mov dh, 0h      ; Head ( H )
	mov cl, 2h      ; Sector ( S )

	;   setting interrupt
	mov ah, 0x02    ; first thing to set
	int 13h         ; load disk !
	jc  .load_disk_err
    cmp al, 0x1
    jne .load_disk_sector_err
    popa
    ret 

.load_disk_err:
	push bx
	mov  bx, disk_err_msg
	call print_message
	pop  bx
    jmp $

.load_disk_sector_err:
	push bx
	mov  bx, disk_err_msg_2
	call print_message
	pop  bx
    jmp $

disk_err_msg:
	db 'Error: could not  load disk , carry flag was set...', 0x0d, 0x0a, 0

disk_err_msg_2:
	db 'Error: could not load disk , al was not same...', 0x0d, 0x0a, 0


