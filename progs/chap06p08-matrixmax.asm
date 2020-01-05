%include "lib.asm"
extern ExitProcess
global _start

%macro geti 0
	fgets buffer, 12
	a2i 12, buffer
%endmacro

%macro geti 1
	puts %1
	geti
%endmacro

%macro puti 1
	i2a DWORD %1, buffer
	puts buffer
%endmacro

section .text
	MAX_COL EQU 10
	MAX_ROW EQU 10
	NULL EQU 0
	
	CRLF db 0DH, 0AH, NULL
	CEQ db "= ", NULL
	CTAB db '	', NULL
	
	MSG_MAT_ROW db "#(R", NULL
	MSG_MAT_COL db ",C", NULL
	MSG_MAT_EQ db ")= ", NULL
	MSG_INPUT_MAT_COL db "Enter matrix number of columns: ", NULL
	MSG_INPUT_MAT_ROW db "Enter matrix number of rows: ", NULL
	MSG_MAX1 db "The maximum element is at (", NULL
	MSG_MAX2 db ",", NULL
	MSG_MAX3 db ")", NULL
	
section .bss
	mat resd (MAX_COL*MAX_ROW)+1
	buffer resb 100
	
section .data

section .code
matrixGet:
	%define matrix DWORD [EBP+8]
	%define numCol DWORD [EBP+12]
	%define numRow DWORD [EBP+16]
	enter 0, 0
	push ESI
	push EAX
	push ECX
	push EDX

	.getNumRow:
		geti MSG_INPUT_MAT_ROW
		cmp EAX, 10
		ja .getNumRow
		cmp EAX, 1
		jb .getNumRow
		mov numRow, EAX
	
	.getNumCol:
		geti MSG_INPUT_MAT_COL
		cmp EAX, 10
		ja .getNumCol
		cmp EAX, 1
		jb .getNumCol
		mov numCol, EAX
	
	mov ESI, matrix
	sub ESI, 4
	mov ECX, 0-1
	.rows:
		inc ECX
		cmp ECX, numRow
		jae .rows_done
		mov EDX, 0-1
		.cols:
			inc EDX
			cmp EDX, numCol
			jae .cols_done
			add ESI, 4
			
			; print #i,j=
			puts MSG_MAT_ROW
			puti ECX
			puts MSG_MAT_COL
			puti EDX
			puts MSG_MAT_EQ
			; get mat[i],[j]
			geti
			mov [ESI], EAX
			
			jmp .cols
			.cols_done:
		jmp .rows
		.rows_done:

	pop EDX
	pop ECX
	pop EAX
	pop ESI
	leave
	ret 12-8
	%undef numRow
	%undef numCol
	%undef matrix

mat_max:
	%define matrix DWORD [EBP+8]
	%define numCol DWORD [EBP+12]
	%define numRow DWORD [EBP+16]
	%define returnRow numRow	; rewrite on argument
	%define returnCol numCol	; rewrite on argument
	enter 8,0 ; we have two local
	push ESI
	push EDX
	push ECX
	push EBX
	
	mov ESI, matrix
	
	%define lastMax EBX
	%define lastMaxRow DWORD [EBP-4]
	%define lastMaxCol DWORD [EBP-8]
	%define curRow ECX
	%define curCol EDX
	mov lastMaxRow, 0
	mov lastMaxCol, 0
	mov lastMax, [ESI]	; max at (0,0)
	sub ESI, 4	; first ittr backward
	mov curRow, 0
	.rows:
		mov curCol, 0
		.cols:
			add ESI, 4
			cmp [ESI], lastMax
			jle .skip_rep
			mov lastMax, [ESI]
			mov lastMaxRow, curRow
			mov lastMaxCol, curCol
			.skip_rep:
			inc curCol
			cmp curCol, numCol
			jb .cols

		inc curRow
		cmp curRow, numRow
		jb .rows

	mov EBX, lastMaxRow
	mov returnRow, EBX
	mov EBX, lastMaxCol
	mov returnCol, EBX
	%undef curRow
	%undef curCol
	%undef lastMaxCol
	%undef lastMaxRow
	%undef lastMax
	
	pop EBX
	pop ECX
	pop EDX
	pop ESI
	leave
	ret 12-8
	%undef returnCol
	%undef returnRow
	%undef numRow
	%undef numCol
	%undef matrix


_start:
	push DWORD 0	; arg2: num_row
	push DWORD 0	; arg1: num_col
	push mat			; arg0: matrix
	call matrixGet
	pop ECX				; ECX=num_col
	pop EBX				; EBX=num_row

	push EBX			; arg2: num_row
	push ECX			; arg1: num_col
	push mat			; arg0: matrix
	call mat_max
	pop ECX				; ECX=returnCol
	pop EBX				; EBX=returnRow

	puts MSG_MAX1
	puti EBX
	puts MSG_MAX2
	puti ECX
	puts MSG_MAX3

_end:
	push DWORD 0
	call ExitProcess
