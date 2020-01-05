%include "lib.asm"
extern ExitProcess

section .text
	MAX_N EQU 100
	NWLN db 10, 0
	TAB db '	', 0
	MSG_ENTER_N db "Enter N (0-100): ", 0
	MSG_INPUT_1 db "Enter #", 0
	MSG_INPUT_2 db " Number: ", 0


section .bss
	array resd MAX_N
	buffer resb 25


section .data


section .code
	global _start

getArray:
	enter 0, 0
	push EAX
	push ECX
	push ESI

	getArray_getN:
		puts MSG_ENTER_N
		fgets buffer, 12
		a2i 12, buffer
		cmp EAX, MAX_N
		jg getArray_getN
	
	mov ESI, [EBP+8]
	mov [EBP+12], EAX					; return N
	mov ECX, EAX
	inc ECX
	sub ESI, 4
	getArray_loop:
		add ESI, 4
		sub ECX, 1
		jle getArray_loop_done
		puts MSG_INPUT_1
		i2a ECX, buffer
		puts buffer
		puts MSG_INPUT_2
		fgets buffer, 12
		a2i 12, buffer
		mov [ESI], EAX
		jmp getArray_loop
		getArray_loop_done:

	pop ESI
	pop ECX
	pop EAX
	leave
	ret 4											; array parram is pop out of stack

printArray:
	enter 0, 0
	push ESI

	mov ESI, [EBP+8]
	inc DWORD [EBP+12]
	sub ESI, 4
	printArray_loop:
		add ESI, 4
		sub DWORD [EBP+12], 1
		jle printArray_loop_done
		i2a DWORD [ESI], buffer
		puts buffer
		puts TAB
		jmp printArray_loop
		printArray_loop_done:

	pop ESI
	leave
	ret 8											; array_parram & n_param is pop out of stack

maxArray:
	enter 0, 0
	push EDI
	push ESI

	mov ESI, [EBP+8]
	mov EDI, [ESI]

	sub ESI, 4
	inc DWORD [EBP+12]
	maxArray_loop:
		add ESI, 4
		sub DWORD [EBP+12], 1
		jle maxArray_loop_done
		cmp EDI, [ESI]
		jge maxArray_loop				; MAX
		;jle maxArray_loop			; MIN
		mov EDI, [ESI]
		jmp maxArray_loop
		maxArray_loop_done:

	mov [EBP+12], EDI
	pop ESI
	pop EDI
	leave
	ret 4

_start:
	push DWORD 0							; return result keeper
	push array
	call getArray

	; push DWORD [ESP]
	; push array
	; call printArray
	
	push DWORD [ESP]
	push array
	call maxArray

	puts NWLN
	i2a DWORD [ESP], buffer
	puts buffer

_end:
	push 0
	call ExitProcess
