%include "lib.asm"
%include "lib-string.asm"
extern ExitProcess
global _start

section .text
	MAX_TEXT EQU 1000
	CRLF db CR, LF, NULL
	CTAB db TAB, NULL
	DOT db '***', NULL


section .bss
	text1 resb MAX_TEXT
	text2 resb MAX_TEXT
	buffer resb 25


section .data


section .code
_start:
	fgets text1, MAX_TEXT

	push text1
	;call strltrim
	;call strrtrim
	call strtrim
	pop EAX
	putstr DOT
	putstr EAX
	putstr DOT
	putstr CRLF

	jmp _end

_end:
	push 0
	call ExitProcess
