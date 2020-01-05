%include "lib.asm"
extern ExitProcess
global _start

%macro geti 0
	fgets buffer, 12
	a2i 12, buffer
%endmacro

%macro puti 1
	i2a %1, buffer
	puts buffer
%endmacro

section .bss
	myarr resd 100
	buffer resb 100

section .code
arrget:
	;;; fills arr(EAX) with DWORD numbers and returns(EAX) item count
	enter 0,0
	push ESI
	push ECX
	
	mov ESI, EAX
	geti
	push EAX
	
	mov ECX, EAX
	jmp .get_loop_cond
	.get_loop_msg1 db "Enter #", 0
	.get_loop_msg2 db ": ", 0
	.get_loop:
		puts .get_loop_msg1
		sub ECX, [ESP]
		neg ECX
		puti ECX
		neg ECX
		add ECX, [ESP]
		puts .get_loop_msg2
		geti
		mov [ESI], EAX
		.get_loop_cond:
		add ESI, 4
		sub ECX, 1
		jae .get_loop
		.get_loop_done:
	
	pop EAX
	pop ECX
	pop ESI
	leave
	ret 0

arrgetpos:
	;;; fills arr(EAX) with DWORD numbers and returns(EAX) item count
	enter 0,0
	push ESI
	push ECX
	mov ESI, EAX
	mov ECX, 0
	.get_loop:
		puts .MSG_GET_1
		puti ECX
		puts .MSG_GET_2
		geti
		cmp EAX, 0
		jl .get_loop_done
		mov [ESI+ECX*4], EAX
		inc ECX
		jmp .get_loop
		.get_loop_done:
	
	mov EAX, ECX
	pop ECX
	pop ESI
	leave
	ret 0
	.MSG_GET_1 db "Enter $", 0
	.MSG_GET_2 db ": ", 0

arrsort:
	;;; receive arr(arg0:DWORD) and size(arg1:DWORD) and (select) sort asc
	%define arr DWORD [EBP+8]
	%define size DWORD [EBP+12]
	%define el_size 4
	enter 4,0
	push EDI
	push ESI
	push EDX
	push ECX
	push EBX
	push EAX
	mov ESI, arr
	mov ECX, -1
	jmp .outer_loop_cond
	.outer_loop:
		%define best EBX
		mov best, ECX
		mov EDX, ECX
		jmp .inner_loop_cond
		.inner_loop:
			mov EAX, [ESI+best*el_size]
			cmp EAX, [ESI+EDX*el_size]
			jle .inner_loop_cond ; signed comp
			mov best, EDX
			.inner_loop_cond:
				inc EDX
				cmp EDX, size
				jb .inner_loop
			.inner_loop_done:
		cmp ECX, best
		je .outer_loop_cond ; if best=ecx then skip else swap
		mov EAX, [ESI+best*el_size]
		xchg EAX, [ESI+ECX*el_size]
		xchg EAX, [ESI+best*el_size]
		.outer_loop_cond:
			inc ECX
			cmp ECX, size
			jb .outer_loop
		.outer_loop_done:
		%undef best
	pop EAX
	pop EBX
	pop ECX
	pop EDX
	pop ESI
	pop EDI
	leave
	ret 8
	%undef arr
	%undef size
	%undef el_size

arrprint:
	;;; receive arr(arg0:DWORD) and size(arg1:DWORD) and print array
	%define arr DWORD [EBP+8]
	%define size DWORD [EBP+12]
	%define el_size 4
	enter 0,0
	push ESI
	push ECX
	mov ESI, arr
	mov ECX, -1
	jmp .looper_cond
	.looper:
		puti DWORD [ESI+ECX*el_size]
		puts .MSG_SPACER
		.looper_cond:
			inc ECX
			cmp ECX, size
			jb .looper
		.looper_done:
		puts .MSG_LINER
	pop ECX
	pop ESI
	leave
	ret 8
	.MSG_SPACER: db '	', 0
	.MSG_LINER: db 0DH, 0AH, 0
	%undef arr
	%undef size
	%undef el_size

_start:
	mov EAX, myarr
	call arrgetpos

	push EAX
	push DWORD myarr
	call arrprint

	push EAX
	push DWORD myarr
	call arrsort

	push EAX
	push myarr
	call arrprint

	jmp _end

_end:
	push DWORD 0
	call ExitProcess
