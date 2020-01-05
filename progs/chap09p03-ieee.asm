%include "lib.asm"
extern ExitProcess
global _start

section .text
	NULL EQU 0
	CRLF db 0DH, 0AH, NULL
	CONE db '1', NULL
	CZERO db '0', NULL
	MSG_INP db "Input 8 Hex digit for 32bit float: ", NULL
	MSG_SIGN db "Sign: ", NULL
	MSG_EXPO db "exponent: ", NULL
	MSG_MANT db "mantissa: 1.", NULL

section .bss
	buffer resb 50

section .data

section .code
_start:
	enter 0,0
	
	puts MSG_INP
	fgets buffer, 8+2
	
	mov esi, buffer
	xor eax, eax ; num = 0
	mov cl, 4*7 ; 16^7=2^(4*7)

	jmp SHORT .hex2num_cond
	.hex2num:
		cmp dl, 'A'
		jnae .hex2num_numdigit
		sub dl, 'A'-'0'-10
		.hex2num_numdigit:
		sub dl, '0'
		shl eax, 4
		or eax, edx
		.hex2num_cond:
		xor edx, edx
		mov dl, [esi]
		inc esi
		cmp dl, NULL
		jne .hex2num
		.hex2num_done:

	mov ebx, eax
	mov ch, 32
	call bitprint
	mov eax, ebx

	puts CRLF
	puts MSG_SIGN
	mov ch, 1
	call bitprint

	puts CRLF
	puts MSG_EXPO
	mov ch, 8
	call bitprint

	puts CRLF
	puts MSG_MANT
	mov ch, 23
	call bitprint

	jmp _end
	
; bitprint(value=eax, count=ch)
bitprint:
	cmp ch, 0
	ja SHORT .bit_test
	ret
	.bit_test:
		bt eax, 31
		jnc .bit0
		.bit1:
			puts CONE
			jmp .done
		.bit0:
			puts CZERO
			jmp .done
		.done:
			shl eax, 1
			dec ch
			jmp bitprint


_end:
	push 0
	call ExitProcess
	leave
	ret
