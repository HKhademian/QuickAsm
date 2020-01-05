%include "lib.asm"
global _start

section .bss
	resb 10
	bufferA resb 100
	bufferB resb 100

section .data
	bufferR times 100 db 0

section .code
_start:
	enter 0,0
	fgets bufferA, 100
	fgets bufferB, 100

	mov esi, -1
	alen:
		inc esi
		cmp [bufferA+esi], byte 0
		jne alen

	mov edi, -1
	blen:
		inc edi
		cmp [bufferB+edi], byte 0
		jne blen

	mov ebx, 0 ; sum
	bdigit:
		dec edi
		jle bdigit_done
		mov ecx, esi
		adigit:
			dec ecx
			jle adigit_done
			mov al, [bufferA+esi]
			mov bl, [bufferB+edi]
			and al, 0fh
			and bl, 0fh
			mul bl
			add ebx, al


	leave
	ret
