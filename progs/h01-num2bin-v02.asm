%include "lib.asm"
extern ExitProcess	; windows syscall to exit

section .text
	ONE db '1', 0
	ZERO db '0', 0


section .data
	buffer times 25 db 0


section .code
	global _start

_start:
	fgets buffer, 12	; get n as binary len
	a2i 12, buffer
	mov cl, al
	dec cl
	mov ebx, 1				; use ebx as mask
	shl ebx, cl				; our numbers are N bits

	fgets buffer, 12	; get number to convert
	a2i 12, buffer		; eax = num to convert

tester:
	test eax, ebx
	jz tester_zero
	tester_one: puts ONE
	jmp tester_looper
	tester_zero: puts ZERO
	tester_looper:
		shr ebx, 1			; shift mask 1 bit to right to test next digit
		jnz tester

_end:
	push 0
	call ExitProcess
