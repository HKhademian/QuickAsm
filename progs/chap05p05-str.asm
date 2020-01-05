%include "lib.asm"
extern ExitProcess

section .text
	MAX_TEXT EQU 1000
	CRLF db CR, LF, NULL
	CTAB db TAB, NULL
	
	MSG_EQ db "= ", NULL
	MSG_TEXT db "Text", NULL
	MSG_INP db "Input ", NULL
	MSG_LEN db "Len ", NULL
	MSG_DIF db "Difference", NULL
	MSG_SRC db "Search", NULL


section .bss
	text1 resb MAX_TEXT
	text2 resb MAX_TEXT
	buffer resb 25


section .data
section .data


section .code
	global _start

;;; return(arg0:DWORD) length of str1(arg0:DWORD)
strlen:
	%define str1 [EBP+8]
	%define return [EBP+8]
	enter 0, 0
	push ESI
	push ECX
	
	mov ESI, str1
	mov ECX, 0
	dec ECX
	dec ESI
	strlen_loop:
		inc ESI
		inc ECX
		cmp BYTE [ESI], NULL
		jne strlen_loop
		strlen_loop_done:

	mov return, ECX
	pop ESI
	pop ECX
	leave
	ret 4-4

;;; compare str1(arg0:DWORD) with str2(arg1:DWORD)
;;; return(arg0:DWORD) is 0:EQ  anyPOS:str1>str2  anyNeg:str1<str2
strcmp:
	%define str1 [EBP+12]
	%define str2 [EBP+8]
	%define return [EBP+12]
	enter 0, 0
	push ESI
	push EDI
	push EDX
	
	mov ESI, str2
	mov EDI, str1
	dec ESI
	dec EDI
	strcmp_loop:
		inc ESI
		inc EDI
		mov DL, [ESI]
		mov DH, [EDI]

		sub DL, DH
		jnz strcmp_loop_done
		cmp DH, NULL
		jne strcmp_loop
		strcmp_loop_done:

	movsx EDX, DL
	mov return, EDX
	pop EDX
	pop EDI
	pop ESI
	leave
	ret 8-4

;;; search str2(arg1:DWORD) in str1(arg0:DWORD) and return(arg0:DWORD) start pointer or NULL
strstr:
	%define str1 [EBP+12]
	%define str2 [EBP+8]
	%define return [EBP+12]
	enter 0, 0
	push ESI
	push EDI
	push EDX

	dec BYTE str1
	strstr_loop_str1:
		inc BYTE str1
		mov ESI, str1
		cmp BYTE [ESI], NULL
		je strstr_loop_notfount
		mov EDI, str2
		dec ESI
		dec EDI
		strstr_loop_str2:
			inc EDI
			mov DL, [EDI]
			cmp DL, NULL
			je strstr_loop_found
			inc ESI
			cmp DL, [ESI]
			jne strstr_loop_str1
			jmp strstr_loop_str2
		strstr_loop_notfount:
			mov DWORD return, NULL
		strstr_loop_found:

	pop EDX
	pop EDI
	pop ESI
	leave
	ret 8-4

;;; copy str2(arg1:DWORD) in to str1(arg0:DWORD) and return(arg0:DWORD) str1 start pointer
strcpy:
	%define str1 [EBP+12]
	%define str2 [EBP+8]
	%define return [EBP+12]
	enter 0, 0
	push ESI
	push EDI
	push EDX

	mov ESI, str1
	mov EDI, str2
	dec ESI
	dec EDI
	strcpy_loop:
		inc ESI
		inc EDI
		mov DL, [EDI]
		mov [ESI], DL
		cmp DL, NULL
		jne strcpy_loop

	pop EDX
	pop EDI
	pop ESI
	leave
	ret 8-4

;;; copy str2(arg1:DWORD) and paste at the enf of str1(arg0:DWORD) and return(arg0:DWORD) str1 start pointer
strcat:
	%define str1 [EBP+12]
	%define str2 [EBP+8]
	%define return [EBP+12]
	enter 0, 0
	push ESI
	push EDI
	push EDX

	mov ESI, str1
	mov EDI, str2
	
	dec ESI
	strcat_endStr1:
		inc ESI
		cmp BYTE [ESI], NULL
		jne strcat_endStr1
		strcat_endStr1_done:

	;;use strcpy
	;push ESI
	;push EDI
	;call strcpy
	;add ESP, 4
	;jmp strcat_copyStr2_done

	dec ESI
	dec EDI
	strcat_copyStr2:
		inc ESI
		inc EDI
		mov DL, [EDI]
		mov [ESI], DL
		cmp DL, NULL
		jne strcat_copyStr2
		strcat_copyStr2_done:
	
	pop EDX
	pop EDI
	pop ESI
	leave
	ret 8-4

_start:
	putstr MSG_INP
	putstr MSG_TEXT
	i2a 1, buffer
	putstr buffer
	putstr MSG_EQ
	fgets text1, MAX_TEXT

	putstr MSG_INP
	putstr MSG_TEXT
	i2a 2, buffer
	putstr buffer
	putstr MSG_EQ
	fgets text2, MAX_TEXT
	putstr CRLF

	push text1
	call strlen
	putstr MSG_LEN
	putstr MSG_TEXT
	i2a 1, buffer
	putstr buffer
	putstr MSG_EQ
	i2a DWORD [ESP], buffer
	putstr buffer
	putstr CRLF

	push text2
	call strlen
	putstr MSG_LEN
	putstr MSG_TEXT
	i2a 2, buffer
	putstr buffer
	putstr MSG_EQ
	i2a DWORD [ESP], buffer
	putstr buffer
	putstr CRLF
	putstr CRLF

	push text1
	push text2
	call strcmp
	i2a DWORD [ESP], buffer
	putstr MSG_DIF
	putstr MSG_EQ
	putstr buffer
	putstr CRLF
	putstr CRLF

	push text1
	push text2
	call strstr
	mov EAX, DWORD [ESP]
	putstr MSG_SRC
	putstr MSG_EQ
	putstr EAX
	putstr CRLF
	putstr CRLF

	push text1
	push text2
	call strcat
	putstr MSG_TEXT
	i2a 1, buffer
	putstr buffer
	putstr MSG_EQ
	putstr text1
	putstr CRLF
	putstr MSG_TEXT
	i2a 2, buffer
	putstr buffer
	putstr MSG_EQ
	putstr text2
	putstr CRLF
	putstr CRLF

	push text1
	push text2
	call strcpy
	putstr MSG_TEXT
	i2a 1, buffer
	putstr buffer
	putstr MSG_EQ
	putstr text1
	putstr CRLF
	putstr MSG_TEXT
	i2a 2, buffer
	putstr buffer
	putstr MSG_EQ
	putstr text2
	putstr CRLF
	putstr CRLF


_end:
	push 0
	call ExitProcess
