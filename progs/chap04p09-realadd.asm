%include "lib.asm"
extern ExitProcess	; windows syscall to exit

section .text
	MSG_INP_SEG db "Please Enter segment Address: ", 0
	MSG_INP_OFF db "Please Enter offset Address: ", 0
	MSG_REAL db "Real Address is: ", 0

section .data


section .bss
	buffer resb 25


section .code
	global _start

_start:
	puts MSG_INP_SEG
	fgets buffer, 12
	a2i 12, buffer
	mov EBX, EAX

	puts MSG_INP_OFF
	fgets buffer, 12
	a2i 12, buffer
	
	and EBX, 0FFFFH
	shl EBX, 4

	and EAX, 0FFFFH
	add EAX, EBX

	puts MSG_REAL
	i2a EAX, buffer
	puts buffer

;jmp _start

_end:
	push 0
	call ExitProcess
