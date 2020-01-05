%include "lib.asm"
extern ExitProcess
global _start

section .bss
  buffer resb 25

section .code
max:
  %define num1 WORD [EBP+8]
  %define num2 WORD [EBP+10]
  %define num3 WORD [EBP+12]
  enter 0,0
  mov AX, num1
  cmp AX, num2
  jge max_skip2
  mov AX, num2
  max_skip2:
  cmp AX, num3
  jge max_skip3
  mov AX, num3
  max_skip3:
  leave
  ret

_start:
  mov ECX, 3
  getNums:
    fgets buffer, 12
    a2i 12, buffer
    push AX
	loop getNums
  
  call max
  movsx EAX, AX
  i2a EAX, buffer
  puts buffer

_end:
	push DWORD 0
	call ExitProcess
