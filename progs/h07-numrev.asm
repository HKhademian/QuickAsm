%include "lib.asm"
extern ExitProcess	; windows syscall to exit


section .text


section .bss
	buffer resb 25


section .data


section .code
	global _start

_start:
	fgets buffer, 12				; read number
	a2i 12, buffer

	mov EDI, 0							; result
	mov EBX, 10
	loop1:
		cmp EAX, 0
		jle loop1_done				; if number == 0 done
		imul DWORD EDI, 10		; result *= 10
		mov EDX, 0
		div EBX								; EAX = EAX//10    EDX = EAX%10
		add EDI, EDX					; result += EAX%10
		jmp loop1
		loop1_done:
	
	i2a EDI, buffer
	puts buffer

;jmp _start							; restart

_end:
	push 0
	call ExitProcess
