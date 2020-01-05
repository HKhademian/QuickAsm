%include "lib.asm"
extern ExitProcess

section .text
	MAX_N EQU 100
	NWLN db 10, 0
	MSG_TAB db '	', 0
	MSG_ENTER_COUNT db "Enter N: ", 0
	MSG_ENTER_NUM_1 db "Enter #", 0
	MSG_ENTER_NUM_2 db " Num: ", 0

section .bss
	array resd MAX_N
	buffer2 resb 25
	buffer resb 25


section .data


section .code
	global _start

getArray:
	enter 0, 0
	push EAX
	push ECX
	push ESI

	getArray_getCount:
	puts MSG_ENTER_COUNT
	fgets buffer, 12
	a2i 12, buffer
	cmp EAX, MAX_N
	jg getArray_getCount
	mov [EBP+12], EAX						; return len
	mov ECX, EAX								; N

	mov ESI, [EBP+8]
	inc ECX
	getArray_loop:
		sub ECX, 1
		jle getArray_loop_done
		
		puts MSG_ENTER_NUM_1
		i2a ECX, buffer2
		puts buffer2
		puts MSG_ENTER_NUM_2
		fgets buffer, 12
		a2i 12, buffer
		mov DWORD [ESI], EAX
		add ESI, 4
		jmp getArray_loop
		getArray_loop_done:

	pop ESI
	pop ECX
	pop EAX
	leave
	ret 4

printArray:
	enter 0, 0
	push ECX
	push ESI
	push EDI

	mov ESI, [EBP+8]		; array
	mov ECX, [EBP+12]		; count

	printArray_loop:
		sub ECX, 1
		jl printArray_loop_done
		i2a DWORD [ESI], buffer
		puts buffer
		puts MSG_TAB
		add ESI, 4
		jmp printArray_loop
		printArray_loop_done:

	pop EDI
	pop ESI
	pop ECX
	leave
	ret 4 + 4

sortArray:
	enter 0, 0
	push EDX
	push ESI
	push EDI
	sub ESP, 4*4													; we need 4 DWORD

	mov EDI, [EBP+12]											; n
	mov ESI, [EBP+8]											; array
	lea ESI, [ESI]

	add ESI, EDI
	add ESI, EDI
	add ESI, EDI
	add ESI, EDI
	mov [EBP-12-4], ESI 									; [EBP-24-4] = array[i] start at array[n-1]
	mov [EBP-12-8], EDI										; [EBP-24-8] = i starts at n-1
	sortArray_loop1:
		sub DWORD [EBP-12-4], 4							; array[--i]
		sub DWORD [EBP-12-8], 1							; i--
		jl sortArray_loop1_done

		mov [EBP-12-12], DWORD 0-1					; [EBP-24-12] = j starts at 0
		mov ESI, DWORD [EBP+8]
		mov [EBP-12-16], ESI								; [EBP-24-16] = array[j] start at array[0]
		sub DWORD [EBP-12-16], 4						; dummy -4 for first itteration
		sortArray_loop2:
			add DWORD [EBP-12-16], 4					; array[++j]
			add DWORD [EBP-12-12], 1					; j++
			mov EDI, [EBP-12-12]
			cmp EDI, [EBP-12-8]
			jge sortArray_loop2_done

			mov EDI, [EBP-12-16]
			mov ESI, [EBP-12-4]
			mov EDX, [ESI]
			cmp [EDI], EDX
			jge sortArray_loop2 								; DECrement order
			;jle sortArray_loop2 								; INCrement order
			push DWORD [EDI]
			push DWORD [ESI]
			pop DWORD [EDI]
			pop DWORD [ESI]

			jmp sortArray_loop2
			sortArray_loop2_done:

		jmp sortArray_loop1
		sortArray_loop1_done:

	add ESP, 4*4													; free allocated stack
	pop EDI
	pop ESI
	pop EDX

	leave
	ret 4 + 4


_start:
	push 0							; count
	push array
	call getArray
	pop EAX

	push EAX
	push array
	call sortArray

	push EAX
	push array
	call printArray

_end:
	push 0
	call ExitProcess
