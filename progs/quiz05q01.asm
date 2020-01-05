%include "lib.asm"

section .data

section .bss
	input: resb 15

section .code
	global _start
	
_start:
	fgets input,12
	a2i 12, input

	summer:
	cmp EAX, 10
	jl printer
	SumInt: ; calc sum of AX digits and put in AX
		mov BX, 0
		SumInt_Take:
			mov DX, 0
			mov CX, 10
			div CX ; AX=DX:AX/10  DX=DX:AX%10
			add BX, DX ; BL += AX%10
			cmp AX, 0
			jnz SumInt_Take
		movzx EAX, BX
	jmp summer

	printer:
	i2a EAX, input
	puts input

end:
	mov eax,1
	mov ebx,0
