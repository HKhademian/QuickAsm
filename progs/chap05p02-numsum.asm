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

digitSumArray:
	enter 0, 0
	push ESI

	mov ESI, [EBP+8]

	sub ESI, 4
	inc DWORD [EBP+12]
	digitSumArray_loop:
		add ESI, 4
		sub DWORD [EBP+12], 1
		jle digitSumArray_loop_done
		push DWORD [ESI]
		call digitSum
		pop DWORD [ESI]
		jmp digitSumArray_loop
		digitSumArray_loop_done:

	pop ESI
	leave
	ret 8

digitSum:
	enter 0, 0
	push EAX
	push EBX
	push ECX
	push EDX

	mov EAX, [EBP+8]					; num is arg0
	mov EBX, 0								; digits sum
	mov ECX, 10
	digitSum_loop:
		cmp EAX, 0
		je digitSum_end
		mov EDX, 0
		div ECX									; EDX:EAX/10 => EAX=EAX/10	EDX=EAX%10
		add EBX, EDX
		jmp digitSum_loop
		digitSum_end:
	mov [EBP+8], EBX					; replace number with digit sum in stack

	pop EDX
	pop ECX
	pop EBX
	pop EAX
	leave
	ret

_start:
	push DWORD 0							; return result keeper
	push array
	call getArray

	push DWORD [ESP]
	push array
	call printArray

	puts NWLN
	
	push DWORD [ESP]
	push array
	call digitSumArray

	push DWORD [ESP]
	push array
	call printArray

_end:
	push 0
	call ExitProcess
