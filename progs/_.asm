%include "lib.asm"
global _start

section .text	; constant data here

section .bss	; uninitialized data here

section .data	; variables and initialized data

section .code	; program logig

_start: 			; main()
	enter 0,0
  
	; program starts here

  mov eax, 0 ; return 0
	leave
	ret
