;%include "lib.asm"
;extern ExitProcess
;extern printf
global _start

section .text
	str1 db "Hello World!", 10, 0

section .bss

section .data

section .code
_start:
	push 0
  ;push str1
	;call printf
	
_end:
  ;push DWORD 0
  ;call ExitProcess
