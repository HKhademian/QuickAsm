%include "lib.asm"
extern ExitProcess	; windows syscall to exit

section .text
	MSG_NEWLINE db 10, 0
	MSG_RES db "#", 0
	MSG_C_EQ db ":	C=", 0
	MSG_X_EQ db "	X=", 0
	MSG_Y_EQ db "	Y=", 0


section .bss
	buffer resb 100


section .data


section .code
	global _start

	;;; n2 is n^2 in comments
_start:

	fgets buffer, 25
	a2i 25, buffer					; input c and store in eax

	mov ebp, esp
  push DWORD 0						; [EBP-4] = resCount

	push eax								; [EBP-8] = C
	imul eax, eax
	push eax								; [EBP-12] = C2

	push DWORD [EBP-8]			; [EBP-16] = X from C to 0
	inc DWORD [EBP-16]				; dummy X+=1 for first itteration

	findX:
		sub DWORD [EBP-16], 1	; X-=1
		jl end								; end if X<0

		mov edx, [EBP-16]
		imul edx, edx					; EDX = X2

		mov ecx, [EBP-12]
		sub ecx, edx					; ECX = reqY2 = C2-X2

		mov ebx, 0						; EBX = y from 0 to c
		dec ebx								; dummy y-=1
		findY:
			add ebx, 1
			cmp ebx, [EBP-8]
			jg findX						; if y>c then goto next X

			mov eax, ebx
			imul eax, eax				; EAX = newY2
			cmp eax, ecx
			je printMe					; if newY2=reqY2 then print result
			jg findX						; if newY2>reqY2 then goto next X
			jmp findY						; go find next y

			printMe:
				inc DWORD [EBP-4]	; resCount++
				puts MSG_RES
				i2a DWORD [EBP-4], buffer
				puts buffer
				puts MSG_C_EQ
				i2a DWORD [EBP-8], buffer
				puts buffer
				puts MSG_X_EQ
				i2a DWORD [EBP-16], buffer
				puts buffer
				puts MSG_Y_EQ
				i2a ebx, buffer
				puts buffer
				puts MSG_NEWLINE
			jmp findX

end:
	mov eax, 0
	call ExitProcess
