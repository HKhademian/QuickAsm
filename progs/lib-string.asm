global strlen, strcmp, strstr, strcpy, strncpy, strcat

;;; strlen: return(arg0:DWORD) length of str1(arg0:DWORD)
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

;;; strcmp: compare str1(arg0:DWORD) with str2(arg1:DWORD)
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

;;; strstr: search str2(arg1:DWORD) in str1(arg0:DWORD) and return(arg0:DWORD) start pointer or NULL
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

;;; strcpy: copy str2(arg1:DWORD) into str1(arg0:DWORD) and return(arg0:DWORD) str1 start pointer
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

;;; strncpy: copy max n bytes of str2(arg1:DWORD) into str1(arg0:DWORD) and return(arg0:DWORD) str1 start pointer
strncpy:
	%define str1 [EBP+16]
	%define str2 [EBP+12]
	%define n [EBP+8]
	%define return [EBP+16]
	enter 0, 0
	push ESI
	push EDI
	push EDX
	push ECX

	mov ESI, str1
	mov EDI, str2
	mov ECX, n

	dec ESI
	dec EDI
	strncpy_copyStr2:
		inc ESI
		inc EDI
		mov DL, [EDI]
		mov [ESI], DL
		cmp DL, NULL
		je strncpy_copyStr2_done
    sub ECX, 1
    jg strncpy_copyStr2
		;; not in c standard library
		;inc ESI
		;mov BYTE [ESI], NULL
    strncpy_copyStr2_done:

	pop ECX
	pop EDX
	pop EDI
	pop ESI
	leave
	ret 12-4

;;; strcat: copy str2(arg1:DWORD) and paste at the enf of str1(arg0:DWORD) and return(arg0:DWORD) str1 start pointer
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

;;; strncat: copy max n str2(arg1:DWORD) and paste at the enf of str1(arg0:DWORD) and return(arg0:DWORD) str1 start pointer
strncat:
	%define str1 [EBP+16]
	%define str2 [EBP+12]
	%define n [EBP+8]
	%define return [EBP+16]
	enter 0, 0
	push ESI
	push EDI
	push EDX
	push ECX

	mov ESI, str1
	mov EDI, str2
	
	dec ESI
	strncat_endStr1:
		inc ESI
		cmp BYTE [ESI], NULL
		jne strncat_endStr1
		strncat_endStr1_done:

	mov ECX, n
	dec ESI
	dec EDI
	strncat_copyStr2:
		inc ESI
		inc EDI
		mov DL, [EDI]
		mov [ESI], DL
		cmp DL, NULL
		je strncat_copyStr2_done
		sub ECX, 1
		jg strncat_copyStr2
		; as in c standard lib
		inc ESI
		mov BYTE [ESI], NULL
		strncat_copyStr2_done:
	
	pop EDX
	pop EDI
	pop ESI
	leave
	ret 8-4

;;; strrev: reverse str1(arg0:DWORD) and return(arg0:DWORD) the str1 pointer
strrev:
	%define str1 DWORD [EBP+8]
	enter 0, 0
	push ESI
	push EDI
	push EDX

	mov ESI, str1
	mov EDI, ESI

	dec EDI
	strrev_eos:
		inc EDI
		cmp BYTE [EDI], NULL
		jne strrev_eos
	
	dec ESI
	strrev_swap:
		inc ESI
		dec EDI
		mov DL, [ESI]
		mov DH, [EDI]
		mov [ESI], DH
		mov [EDI], DL
		cmp ESI, EDI
		jl strrev_swap

	pop EDX
	pop EDI
	pop ESI
	leave
	ret 4-4

;;; strltrim: left trim whitespaces(space and tab) from str1(arg0:DWORD) and return(arg0:DWORD) start pointer of result
strltrim:
	%define str1 DWORD [EBP+8]
	enter 0, 0
	push ESI

	mov ESI, str1
	dec ESI
	strltrim_ltrim:
		inc ESI
		cmp BYTE [ESI], ' '
		je strltrim_ltrim
		cmp BYTE [ESI], '	'
		je strltrim_ltrim
	
	mov str1, ESI
	pop ESI
	leave
	ret 4-4

;;; strrtrim: right trim whitespaces(space and tab) from str1(arg0:DWORD) and return(arg0:DWORD) start pointer of result
strrtrim:
	%define str1 DWORD [EBP+8]
	enter 0, 0
	push ESI

	mov ESI, str1
	dec ESI
	strrtrim_eos:
		inc ESI
		cmp BYTE [ESI], NULL
		jne strrtrim_eos
	
	strrtrim_rtrim:
		dec ESI
		cmp ESI, str1
		jl strrtrim_rtrim_done
		cmp BYTE [ESI], ' '
		je strrtrim_rtrim
		cmp BYTE [ESI], '	'
		je strrtrim_rtrim
		strrtrim_rtrim_done:
		mov BYTE [ESI+1], NULL

	pop ESI
	leave
	ret 4-4

;;; strtrim: trim whitespaces(space and tab) from str1(arg0:DWORD) and return(arg0:DWORD) start pointer of result
strtrim:
	%define str1 DWORD [EBP+8]
	enter 0, 0
	push ESI

	mov ESI, str1
	dec ESI
	strtrim_ltrim:
		inc ESI
		cmp BYTE [ESI], ' '
		je strtrim_ltrim
		cmp BYTE [ESI], '	'
		je strtrim_ltrim
	mov str1, ESI

	dec ESI
	strtrim_eos:
		inc ESI
		cmp BYTE [ESI], NULL
		jne strtrim_eos
	
	strtrim_rtrim:
		dec ESI
		cmp ESI, str1
		jl strtrim_rtrim_done
		cmp BYTE [ESI], ' '
		je strtrim_rtrim
		cmp BYTE [ESI], '	'
		je strtrim_rtrim
		strtrim_rtrim_done:
		mov BYTE [ESI+1], NULL

	pop ESI
	leave
	ret 4-4

;;;