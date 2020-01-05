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
	
section .bss
	buffer resb 100
	mat resd (MAX_COL*MAX_ROW)+1
	
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

matrixPrint:
	%define matrix DWORD [EBP+8]
	%define numCol DWORD [EBP+12]
	%define numRow DWORD [EBP+16]
	enter 0,0
	push ESI
	push EDX
	push ECX
	
	mov ESI, matrix
	sub ESI, 4
	mov ECX, numRow
	.rows:
		mov EDX, numCol
		.cols:
			add ESI, 4
			puti [ESI]
			puts CTAB
			sub EDX, 1
			ja .cols
			.cols_done:
			puts CRLF
		sub ECX, 1
		ja .rows
		.rows_done:
	
	pop ECX
	pop EDX
	pop ESI
	leave
	ret 12
	%undef numRow
	%undef numCol
	%undef matrix

matrixRotPrint:
	%define matrix DWORD [EBP+8]
	%define numCol DWORD [EBP+12]
	%define numRow DWORD [EBP+16]
	enter 0,0
	push ESI
	push EDI
	push EDX
	push ECX
	push EBX
	
	mov EDI, matrix
	mov EBX, numCol
	
	mov ECX, 0
	.cols:
		mov ESI, EDI
		times 4 add ESI, ECX		; column offset
		mov EDX, numRow
		times 4 sub ESI, EBX		; first time backward
		.rows:
			times 4 add ESI, EBX	; row itterate
			puti [ESI]
			puts CTAB
			sub EDX, 1
			ja .rows
			.rows_done:
			puts CRLF
		inc ECX
		cmp ECX, numCol
		jb .cols
		.cols_done:
	
	pop EBX
	pop ECX
	pop EDX
	pop EDI
	pop ESI
	leave
	ret 12
	%undef numRow
	%undef numCol
	%undef matrix

_start:
	push DWORD 0	; arg2: num_row
	push DWORD 0	; arg1: num_col
	push mat			; arg0: matrix
	call matrixGet
	pop ECX				; EAX=num_col
	pop EBX				; EBX=num_row

	push EBX			; arg1: num_row
	push ECX			; arg2: num_col
	push mat			; arg0: matrix
	call matrixPrint
	puts CRLF

	push EBX			; arg1: num_row
	push ECX			; arg2: num_col
	push mat			; arg0: matrix
	call matrixRotPrint

_end:
	push DWORD 0
	call ExitProcess
