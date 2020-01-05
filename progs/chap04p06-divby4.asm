%include "lib.asm"
extern ExitProcess  ; windows syscall to exit

section .text


section .bss
  buffer resb 100


section .data


section .code
  global _start

_start:
  fgets buffer, 100
  a2i 100, buffer
  shr eax, 2
  ;mov edx, 0
  ;mov ecx, 4
  ;idiv ecx
  printer:
   i2a eax, buffer
    puts buffer

end:
  mov eax, 0
  call ExitProcess
