%include "lib.asm"
extern ExitProcess	; windows syscall to exit


section .text
	N equ 32					; up to 32 bits
	HEX db "0123456789ABCDEF"


section .bss
	buffer resb 25


section .data


section .code
	global _start

_start:
	fgets buffer, 12	; fill buffer with 12 character
	a2i 12, buffer		; eax = buffer as number
	mov edx, eax			; copy number to EDX

	mov cl, N-4				; position keeper at end of the bits
tester:
	mov ebx, HEX
	mov eax, edx
	shr eax, cl
	and eax, 0FH			; now AL is digit
	xlatb							; AL = HEX[AL]
	mov [buffer], BYTE al
	mov [buffer+1], BYTE 0
	puts buffer
	sub cl, 4
	jae tester
;jmp _start					; restart

end:
	push 0
	call ExitProcess
