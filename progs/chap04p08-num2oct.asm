%include "lib.asm"
extern ExitProcess	; windows syscall to exit

section .text
	N equ 33					; up to 32 bits (11 octal digit)


section .data


section .bss
	buffer resb 25


section .code
	global _start

_start:
	fgets buffer, 12	; fill buffer with 12 decimal
	a2i 12, buffer		; eax = buffer as number

	mov cl, N-3
tester:
	mov edx, eax
	shr edx, cl
	and edx, 07H
	add edx, '0'
	mov [buffer], BYTE dl
	mov [buffer+1], BYTE 0
	puts buffer
	sub cl, 3
	jae tester

;jmp _start

_end:
	push 0
	call ExitProcess
