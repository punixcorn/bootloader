; print a string
; address loaded into bx

print_message:
	pusha
	mov ah, 0x0e
	jmp .loop

.loop:
	mov al, [bx]
	cmp al, 0
	je  end_print
	int 10h
	inc bx
	jmp .loop

end_print:
	popa
	ret
