%include "lib.asm"
%include "lib-string.asm"
extern ExitProcess	; windows syscall to exit
global _start


section .text


section .bss
	buffer resb 25


section .data


section .code
_start:
	mov EBX, 1374
	mov EAX, EBX-1
	i2a EAX, buffer
	puts buffer

	jmp _end

_end:
	push 0
	call ExitProcess
