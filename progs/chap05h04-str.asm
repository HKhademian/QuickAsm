%include "lib.asm"
%include "lib-string.asm"
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

	MSG_STRLEN db "strlen(str)", CR, LF, NULL
	MSG_STRCMP db "strcmp(str1, str2)", CR, LF, NULL
	MSG_STRSTR db "strstr(str1, str2)", CR, LF, NULL
	MSG_STRCAT db "strcat(str1, str2)", CR, LF, NULL
	MSG_STRNCAT db "strncat(str1, str2, n)", CR, LF, NULL
	MSG_STRCPY db "strcpy(str1, str2)", CR, LF, NULL
	MSG_STRNCPY db "strncpy(str1, str2, n)", CR, LF, NULL


section .bss
	text1 resb MAX_TEXT
	text2 resb MAX_TEXT
	buffer resb 25


section .data
section .data


section .code
	global _start

	logTexts:
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
		ret

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

	; putstr MSG_STRLEN
	; push text1
	; call strlen
	; putstr MSG_LEN
	; putstr MSG_TEXT
	; i2a 1, buffer
	; putstr buffer
	; putstr MSG_EQ
	; i2a DWORD [ESP], buffer
	; putstr buffer
	; putstr CRLF
	;
	; push text2
	; call strlen
	; putstr MSG_LEN
	; putstr MSG_TEXT
	; i2a 2, buffer
	; putstr buffer
	; putstr MSG_EQ
	; i2a DWORD [ESP], buffer
	; putstr buffer
	; putstr CRLF
	; putstr CRLF

	; putstr MSG_STRCMP
	; push text1
	; push text2
	; call strcmp
	; i2a DWORD [ESP], buffer
	; putstr MSG_DIF
	; putstr MSG_EQ
	; putstr buffer
	; putstr CRLF
	; putstr CRLF

	; putstr MSG_STRSTR
	; push text1
	; push text2
	; call strstr
	; mov EAX, DWORD [ESP]
	; putstr MSG_SRC
	; putstr MSG_EQ
	; putstr EAX
	; putstr CRLF
	; putstr CRLF

	; putstr MSG_STRCAT
	; push text1
	; push text2
	; call strcat
	; call logTexts

	mov byte [text1+3], 0
	call logTexts
	putstr MSG_STRNCAT
	push text1
	push text2
	push DWORD 4
	call strncat
	call logTexts

	; ;mov byte [text1+3], 0
	; ;call logTexts
	; putstr MSG_STRNCPY
	; push text1
	; push text2
	; push DWORD 4
	; call strncpy
	; call logTexts

	; putstr MSG_STRCPY
	; push text1
	; push text2
	; call strcpy
	; call logTexts

_end:
	push 0
	call ExitProcess
