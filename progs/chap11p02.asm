%include "lib.asm"
global _start

section .code
_start:
	enter 0,0
	
	and al, 0x0F ; reset upper nibble
	or al, 0x30 ; set upper nibble to 3H

	leave
	ret
