enter_protected_mode:
    ;clear scrren
    mov al, 0x0
    mov ah, 0x3
    int 10h
 
    ; disable inturrupts
	cli

    ; load gdt
	lgdt [GDT_descriptor]

	mov  eax, cr0
	or   eax, 1
	mov  cr0, eax

	;    far jump
	jmp  CODE_SEG:protected_mode



