%include "lib.asm"
extern ExitProcess
global _start

section .text
	NULL EQU 0
	CRLF db 0DH, 0AH, NULL
	MSG_INP db "Input 8bit signed number: ", NULL
	MSG_OUT db "Abs is: ", NULL


section .bss
	buffer resb 50

section .data

section .code
_start:
	enter 0,0
	
	puts MSG_INP
	fgets buffer, 3+2
	a2i 3+2, buffer
	movsx eax, al
	call fun_abs
	movsx eax, al
	i2a eax, buffer
	puts MSG_OUT
	puts buffer

	jmp _end
	
; abs(value=al): ret=al
fun_abs:
	test al, 80H
	jz SHORT .done
	not al
	inc al
	.done: ret

_end:
	push 0
	call ExitProcess
	leave
	ret
