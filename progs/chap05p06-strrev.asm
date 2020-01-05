%include "lib.asm"
extern ExitProcess
global _start

section .text
	MAX_TEXT EQU 1000
	CRLF db CR, LF, NULL
	CTAB db TAB, NULL
	MSG_EQ db "= ", NULL
	MSG_TEXT db "Text", NULL
	MSG_INP db "Input ", NULL


section .bss
	text1 resb MAX_TEXT
	buffer resb 25


section .data


section .code
_start:
	putstr MSG_INP
	putstr MSG_TEXT
	putstr MSG_EQ
	fgets text1, MAX_TEXT

	push text1
	call strrev
	putstr text1
	putstr CRLF

	call strrev
	putstr text1

	jmp _end

_end:
	push 0
	call ExitProcess
