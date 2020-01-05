%include "lib.asm"
extern ExitProcess	; windows syscall to exit

section .text
	N equ 8						; up to 32 bits


section .data


section .bss
	buffer resb 25


section .code
	global _start

_start:
	fgets buffer, 12	; fill buffer with 12 character
	a2i 12, buffer		; eax = buffer as number

	mov cl, N-4
tester:
	mov edx, eax
	shr edx, cl
	and edx, 0FH
	cmp edx, 10
	jae tester_hexer
	tester_decimal: add edx, BYTE '0'
	jmp tester_printer
	tester_hexer: add edx, BYTE 'A'-10
	tester_printer:
	mov [buffer], BYTE dl
	mov [buffer+1], BYTE 0
	puts buffer
	sub cl, 4
	jae tester

;jmp _start

_end:
	push 0
	call ExitProcess
