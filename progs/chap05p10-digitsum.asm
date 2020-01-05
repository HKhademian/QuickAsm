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
	buffer resb 100


section .data


section .code
_start:
	fgets text1, MAX_TEXT

	summer:
	mov ESI, text1
	mov EAX, 0
	dec ESI
	loop1:
		inc ESI
		movzx EBX, BYTE [ESI]
		cmp EBX, NULL
		je loop1_done
		sub EBX, '0'
		add EAX, EBX
		jmp loop1
		loop1_done:

	i2a EAX, text1
	puts text1
	puts CRLF

	;; extra
	;cmp EAX, 10
	;jge summer

	jmp _end

_end:
	push 0
	call ExitProcess
