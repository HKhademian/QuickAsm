%include "lib.asm"
%include "lib-string.asm"
extern ExitProcess
global _start

section .text
	MAX_TEXT EQU 1000
	CRLF db CR, LF, NULL
	CTAB db TAB, NULL


section .bss
	text1 resb MAX_TEXT
	text2 resb MAX_TEXT
	buffer resb 25


section .data


section .code
_start:
	fgets text1, MAX_TEXT
	fgets text2, MAX_TEXT

	push text1
	push text2
	call strstr

	pop EAX	
	putstr EAX
	putstr CRLF
	sub EAX, text1
	i2a EAX, buffer
	putstr buffer

	jmp _end

_end:
	push 0
	call ExitProcess
