%include "lib.asm"
extern ExitProcess
global _start

%macro puti 1
	i2a DWORD %1, buffer
	puts buffer
%endmacro
%macro geti 0
	fgets buffer, 12
	a2i 12, buffer
%endmacro

section .bss
	buffer resb 1000
	buffer2 resb 50
	data resd 10

section .code
	NULL EQU 0
	CRLF db 0DH, 0AH, NULL
p01_start_p01:
	enter 12, 0
	%define sum DWORD [EBP-4]
	%define min DWORD [EBP-8]
	%define max DWORD [EBP-12]
	mov sum, 0
	mov ECX, 0
	.get_loop:
		fgets buffer, 12
		cmp BYTE [buffer], 'y'
		je .get_loop_done
		inc ECX
		a2i 12, buffer
		add sum, EAX
		cmp ECX, 1
		je .get_loop_first
		cmp EAX, min
		jge .get_loop_min_skip
		mov min, EAX
		.get_loop_min_skip:
		cmp EAX, max
		jle .get_loop_max_skip
		mov max, EAX
		.get_loop_max_skip:
		jmp .get_loop
		.get_loop_first:
		mov min, EAX
		mov max, EAX
		jmp .get_loop
		.get_loop_done:
	puts .MSG_SUM
	puti sum
	puts CRLF
	puts .MSG_MAX
	puti max
	puts CRLF
	puts .MSG_MIN
	puti min
	puts CRLF
	mov EAX, sum
	cdq
	idiv ECX
	puts .MSG_AVR
	puti EAX
	leave
	ret
	.MSG_SUM db "sum=", NULL
	.MSG_AVR db "avr=", NULL
	.MSG_MAX db "max=", NULL
	.MSG_MIN db "min=", NULL

p02_start_p02:
	enter 0,0

	mov CL, 0
	.get_loop:
		fgets buffer2, 12
		mov BL, [buffer2]
		cmp BL, '9'
		ja .get_loop_done
		cmp BL, '0'
		jb .get_loop_done
		inc CL
		a2i 12, buffer2
		push AX
		jmp .get_loop
		.get_loop_done:

	dec CL
	mov CH, 0
	.calc_loop:
		movsx EBX, CH
		add EBX, buffer2
		mov BL, [EBX] ; read op
		cmp BL, '+'
		je .calc_add
		cmp BL, '-'
		je .calc_sub
		cmp BL, '*'
		je .calc_mul
		jmp .calc_div
		.calc_add:
			pop AX
			pop DX
			add AX, DX
			push AX
			jmp .calc_cond
		.calc_sub:
			pop AX
			pop DX
			sub AX, DX
			push AX
			jmp .calc_cond
		.calc_mul:
			pop AX
			pop DI
			cwd ; signex. AX to DX
			mul DI
			push AX
			jmp .calc_cond
		.calc_div:
			pop AX
			pop DI
			cwd ; signex. AX to DX
			div DI
			push AX
			jmp .calc_cond
		.calc_cond:
			movsx EAX, WORD [ESP]
			puti EAX
			puts CRLF
			inc CH
			cmp CH, CL
			jb .calc_loop

	leave
	ret

p03v01_start:
	enter 0, 0
	fgets buffer, 1000
	mov ESI, buffer
	call p03v01_ltrim
	mov ESI, buffer
	.navigate:
		mov BL, [ESI]
		inc ESI
		cmp BL, NULL
		je .navigate_done
		cmp BL, ' '
		jne .navigate
		call p03v01_ltrim
		jmp .navigate
		.navigate_done:
	
	puts buffer

	leave
	ret
	
p03v01_ltrim:
	enter 0,0
	push ESI
	push EDI
	push EBX
	mov EDI, ESI
	dec EDI
	.skiper:
		inc EDI
		mov BL, [EDI]
		cmp BL, NULL
		je .skiper_done
		cmp BL, ' '
		je .skiper
		.skiper_done:
	.shift:
		mov BL, [EDI]
		mov [ESI], BL
		inc ESI
		inc EDI
		cmp BL, NULL
		jne .shift
		.shift_done:
	pop EBX
	pop EDI
	pop ESI
	leave
	ret

p03v02_start:
	enter 0, 0
	fgets buffer, 1000
	mov ESI, buffer
	mov EDI, buffer
	mov ECX, 1 ; we have fake starting space
	.navigate:
		mov BL, [EDI]
		cmp BL, NULL
		cmp BL, ' '
		je .navigate_detect
		xor ECX, ECX ; no space detected
		.navigate_write:
		mov [ESI], BL
		inc EDI
		inc ESI
		cmp BL, NULL
		je .navigate_done
		jmp .navigate
		.navigate_detect: ; a space detected
		jecxz .navigate_detect_first ; if we dont have previous space
		inc EDI
		jmp .navigate
		.navigate_detect_first:
		mov ECX, 1
		jmp .navigate_write
		.navigate_done:
	
	puts buffer

	leave
	ret

_end:
	push 0
	call ExitProcess
