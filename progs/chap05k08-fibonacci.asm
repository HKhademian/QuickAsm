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

	push EAX
	call fibonacci
	pop EAX

	i2a EAX, buffer
	putstr buffer

	jmp _end

fibonacci:
	%define n DWORD [EBP+8]
	%define return DWORD [EBP+8]
	enter 0,0
	push EAX
	push EBX
	push ECX

	mov EBX, 1
	mov EAX, 1
	fibonacci_loop:
		mov ECX, EAX
		mov EAX, EBX
		add EBX, ECX
		cmp EBX, n
		jle fibonacci_loop
	
	mov return, EAX
	pop ECX
	pop EBX
	pop EAX
	leave
	ret

_end:
	push 0
	call ExitProcess
