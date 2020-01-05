%include "lib.asm"
extern ExitProcess	; windows syscall to exit


section .text


section .bss
	buffer resb 255


section .data


section .code
	global _start

_start:
	fgets buffer, 255			; read text
	mov esi, buffer
	dec esi

processor:
	inc esi
	mov AL, [ESI]
	cmp AL, 0
	je printer						; if '\0' finish process and print the result
	cmp AL, 'a'
	jl processor					; not in the range
	cmp AL, 'z'
	jg processor					; not in the range
	sub BYTE [esi], 'a'-'A'
	jmp processor					; next char

printer:
	puts buffer

;jmp _start							; restart

_end:
	push 0
	call ExitProcess
