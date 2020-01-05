%include "lib.asm"
%include "lib-string.asm"
extern ExitProcess
global _start

section .text
	MAX_LEN EQU 1000
	CRLF db CR, LF, NULL
	CTAB db TAB, NULL

	MSG_Input_ARRAY db "Please Enter Array numbers (empty is terminator) ", CR, LF, NULL
	MSG_EQ db "= ", NULL

	MSG_L1 db ".L1.", NULL
	MSG_L2 db ".L2.", NULL

section .bss
	array resd MAX_LEN
	buffer resb 100


section .data


section .code
_start:
	push array
	call getDArray
	pop ECX

	push ECX
	push array
	call sortInsertionDArray

	push ECX
	push array
	call printDArray


	jmp _end

sortInsertionDArray:
	;;;insertion_sort (array, size)
	;;;	for (i = 1 to size−1)
	;;;		temp := array[i]
	;;;		j := i − 1
	;;;		while ((temp < array[j]) AND (j ≥ 0))
	;;;			array[j+1] := array[j]
	;;;			j := j − 1
	;;;		end while
	;;;		array[j+1] := temp
	;;;	end for
	;;;end insertion_sort

	%define size DWORD [EBP+12]
	%define array DWORD [EBP+8]
	enter 0, 0
	%define temp EBX
	%define t EDI
	%define i ECX
	%define j EDX
	pushad
	;push EAX
	;push EBX
	;push ECX
	;push EDX
	;push ESI
	;push EDI

	mov ESI, array
	mov i, 0
	sortInsertionDArray_loop1:
		inc i
		cmp i, size
		jge sortInsertionDArray_loop1_done
		;puts MSG_L1
		;i2a  i, buffer
		;puts buffer
		;puts CTAB
		mov temp, [ESI+i*4]
		mov j, i
		dec j
		sortInsertionDArray_loop2:
			cmp j, 0
			jl sortInsertionDArray_loop2_done
			mov t, [ESI+j*4]
			cmp temp, t
			jge sortInsertionDArray_loop2_done
			;puts MSG_L2
			;i2a  j, buffer
			;puts buffer
			;puts CTAB
			mov [ESI+j*4+4], t
			dec j
			jmp sortInsertionDArray_loop2
			sortInsertionDArray_loop2_done:
		mov [ESI+j*4+4], temp
		jmp sortInsertionDArray_loop1
		sortInsertionDArray_loop1_done:


	popad
	;pop EDI
	;pop ESI
	;pop EDX
	;pop ECX
	;pop EBX
	;pop EAX
	leave
	ret 8-0

printDArray:
	%define len DWORD [EBP+12]
	%define array DWORD [EBP+8]
	enter 0, 0
	push ECX
	push ESI

	mov ESI, array
	sub ESI, 4
	mov ECX, 0-1
	printDArray_loop:
		sub len, 1
		jl printDArray_done
		add ESI, 4
		inc ECX
		cmp ECX, 10
		jne printDArray_print
		mov ECX, 0
		puts CRLF
		printDArray_print:
		i2a DWORD [ESI], buffer
		puts buffer
		puts CTAB
		jmp printDArray_loop
		printDArray_done:

	pop ESI
	pop ECX
	leave
	ret 8-0

getDArray:
	%define return DWORD [EBP+8]
	%define array DWORD [EBP+8]
	enter 0,0
	push EAX
	push ECX
	push ESI

	puts MSG_Input_ARRAY

	mov ESI, array
	mov ECX, 0-1
	getDArray_fill:
		inc ECX

		i2a ECX, buffer
		puts buffer
		puts MSG_EQ

		fgets buffer, 12
		a2i 12, buffer

		cmp BYTE [buffer], NULL
		je getDArray_fill_done

		mov [ESI+ECX*4], EAX
		jmp getDArray_fill
		getDArray_fill_done:

	mov return, ECX

	pop ESI
	pop ECX
	pop EAX
	leave
	ret 4-4

_end:
	push 0
	call ExitProcess
