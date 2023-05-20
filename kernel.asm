main:
	mov  ax, cs
	mov  ds, ax
	mov  bx, hello_string
	mov  ah, 0x0e
	call kernel_print
	hlt

kernel_print:
	mov al, [bx]
	cmp al, 0
	je  end_kernel_print
	int 0x10
	inc bx
	jmp kernel_print

end_kernel_print:
	hlt
	ret

hello_string: db "Kernel launched",0x0d,0x0a,0
