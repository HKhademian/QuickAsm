%include "lib.asm"
extern ExitProcess
global _start


section .text


section .bss
	buffer resb 25


section .data


section .code
_start:
	fgets buffer, 12
	a2i 12, buffer

	;push EAX
	;call facStack
	;pop EAX

	call facReg

	i2a EAX, buffer
	putstr buffer

	jmp _end


facReg:
	%define n EAX
	cmp n, 1
	jg facReg_rec
	mov n, 1
	jmp facReg_done
	facReg_rec:
	push n
	dec n
	call facReg
	imul n, DWORD [ESP]
	add ESP, 4
	facReg_done:
	ret

facStack:
	%define n DWORD [EBP+8]
	enter 0, 0
	push EAX

	mov EAX, n
	cmp EAX, 1
	jg facStack_rec
	mov n, 1
	jmp facStack_done

	facStack_rec:
	dec EAX
	push EAX
	call facStack
	pop EAX
	imul EAX, n
	mov n, EAX

	facStack_done:
	pop EAX
	leave
	ret

_end:
	push 0
	call ExitProcess
