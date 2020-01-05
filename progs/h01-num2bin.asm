%include "lib.asm"
extern ExitProcess	; windows syscall to exit

section .text
	N equ 8						; up to 32 bits
	ONE db '1', 0
	ZERO db '0', 0


section .data
	buffer times 25 db 0


section .code
	global _start

_start:
	fgets buffer, 12	; fill buffer with 12 character
	a2i 12, buffer		; eax = buffer as number

	mov ebx, 1				; use ebx as mask
	shl ebx, N-1			; our numbers are N bits
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
