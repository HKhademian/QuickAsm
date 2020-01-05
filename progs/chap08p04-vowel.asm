%include "lib.asm"
extern ExitProcess
global _start

section .text
  NULL EQU 0
  MAX EQU 1000
  CRLF db 0DH, 0AH, NULL
  
  MSG_HEADER	db " Vowel	Count", NULL
  MSG_A 		db "a or A	  ", NULL
  MSG_E 		db "e or E	  ", NULL
  MSG_I 		db "i or I	  ", NULL
  MSG_O 		db "o or O	  ", NULL
  MSG_U 		db "u or U	  ", NULL

section .bss
  buffer resb MAX

section .data
  counts times 5 db 0 ; a e i o u

section .code
_start:
  fgets buffer, MAX
  
  mov ESI, buffer
  dec ESI
  check:
	inc ESI
	mov AL, [ESI]
    cmp AL, NULL
	je check_done
    
	cmp AL, 'a'
	je check_a
	cmp AL, 'A'
	je check_a
	
	cmp AL, 'e'
	je check_e
	cmp AL, 'E'
	je check_e
	
	cmp AL, 'i'
	je check_i
	cmp AL, 'I'
	je check_i
	
	cmp AL, 'o'
	je check_o
	cmp AL, 'O'
	je check_o
	
	cmp AL, 'u'
	je check_u
	cmp AL, 'U'
	je check_u
	
    jmp check
	check_a:
		inc byte [counts+0]
		jmp check
	
	check_e:
		inc byte [counts+1]
		jmp check
	
	check_i:
		inc byte [counts+2]
		jmp check
	check_o:
		inc byte [counts+3]
		jmp check
		
	check_u:
		inc byte [counts+4]
		jmp check
    check_done:
  
  puts MSG_HEADER
  puts CRLF

  puts MSG_A
  movzx EAX, byte [counts+0]
  i2a EAX, buffer
  puts buffer
  puts CRLF

  puts MSG_E
  movzx EAX, byte [counts+1]
  i2a EAX, buffer
  puts buffer
  puts CRLF

  puts MSG_I
  movzx EAX, byte [counts+2]
  i2a EAX, buffer
  puts buffer
  puts CRLF

  puts MSG_O
  movzx EAX, byte [counts+3]
  i2a EAX, buffer
  puts buffer
  puts CRLF

  puts MSG_U
  movzx EAX, byte [counts+4]
  i2a EAX, buffer
  puts buffer
  puts CRLF

  jmp _end

_end:
  push 0
  call ExitProcess
