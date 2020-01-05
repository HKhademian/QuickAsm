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

	fgets buffer, 12
	a2i 12, buffer

	push EAX
	push ECX
	push array
	call searchBinaryDArray
	pop EAX

	i2a EAX, buffer
	puts buffer

	jmp _end

searchBinaryDArray:
	;;; binary_search (array, size, number)
	;;; 	lower := 0
	;;; 	upper := size − 1
	;;; 	while (lower ≤ upper)
	;;; 		middle := (lower + upper)/2
	;;; 		if (number = array[middle]) then
	;;; 			return (middle)
	;;; 		else if (number < array[middle]) then
	;;; 			upper := middle − 1
	;;; 		else
	;;; 			lower := middle + 1
	;;; 		end if
	;;; 	end while
	;;; 	return (-1) {number not found}
	;;; end binary_search
	%define return DWORD [EBP+16]
	%define number DWORD [EBP+16]
	%define size DWORD [EBP+12]
	%define array DWORD [EBP+8]
	enter 0, 0
	%define temp EDX
	%define lower ECX
	%define upper EBX
	%define middle EAX
	pushad
	mov ESI, array
	
	mov lower, 0
	mov upper, size
	dec size
	searchBinaryDArray_loop1:
		mov temp, -1
		cmp lower, upper
		jg searchBinaryDArray_loop1_done
		mov middle, lower
		add middle, upper
		shr middle, 1	; middle/=2
		mov temp, [ESI+middle*4]
		cmp number, temp
		je searchBinaryDArray_loop1_found
		jl searchBinaryDArray_loop1_lower
		searchBinaryDArray_loop1_upper:
			mov lower, middle
			inc lower
			jmp searchBinaryDArray_loop1
		searchBinaryDArray_loop1_lower:
			mov upper, middle
			dec upper
			jmp searchBinaryDArray_loop1
		searchBinaryDArray_loop1_found:
			mov temp, middle
		searchBinaryDArray_loop1_done:
	
	mov return, temp
	popad
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
