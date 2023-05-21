[bits 16]
[org  0x7c00]

;some info
mov   [disk_type], dl

	;   clear screen
	mov ah, 0x0
	mov al, 0x3
	int 10h

	;print message
	mov    bx, start_msg
	call   print

	;load disk
	xor   bx, bx
	mov   ax, 0x7e00
	mov   es, ax
	mov   ah, 0x02
	mov   al, 2
	mov   dl, [disk_type]
	mov   ch, 0
	mov   dh, 0
	mov   cl, 2
	int   13h
	jc    carry_f

	mov    ah, 0x0e
	mov    al, [es:bx]
	int    10h
	hlt
	hlt
	;print from that space

print:
	pusha
	mov ah, 0x0e
	jmp .loop

.loop:
	mov al, [bx]
	cmp al, 0
	je  end
	int 10h
	inc bx
	jmp .loop

end:
	popa
	ret

carry_f:
	mov  bx, disk_load_err
	call print
	hlt

loaded_disk:
	db "disk has been loaded no err...", 0x0d, 0x0a, 0

disk_load_err:
	db "could not read disk, carry flag", 0x0d, 0x0a, 0

err_al:
	db "could not read disk, al not eq", 0x0d, 0x0a, 0

start_msg:
	db    "booting...", 0x0d, 0x0a, 0
	disk_type: db 0
	times 510-($-$$) db 0
	dw    0xaa55
	times 5000-($-$$) db 'A'
