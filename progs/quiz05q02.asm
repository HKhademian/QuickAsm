%include "lib.asm"

section .data

section .bss
	input: resb 15

section .code
	global _start
	
_start:
	fgets input,12
	a2i 12, input
	mov EDX, EAX		;x
	
	fgets input,12
	a2i 12, input
	mov ECX, EAX		;y
	
	fgets input,12
	a2i 12, input
	mov EBX, EAX		;z
	

	add EDX, 2
	neg EDX
	imul EDX, ECX
	add EDX, EBX

	i2a EDX, input
	puts input

end:
	mov eax,1
	mov ebx,0
