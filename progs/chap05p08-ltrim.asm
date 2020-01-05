%include "lib.asm"
extern ExitProcess
global _start

section .bss
  MAX EQU 1000
  NULL EQU 0
  text1 resb MAX
  buffer resb 25

section .code
ltrim:
  %define str1 DWORD [EBP+8]
  enter 0,0
  push ESI
  push EDI
  push EAX
  
  mov ESI, str1
  mov EDI, str1
  
  dec EDI
  ltrim_edi:
    inc EDI
    mov AL, [EDI]
    cmp AL, NULL
    je ltrim_edi_done
    cmp AL, ' '
    jne ltrim_edi_done
    jmp ltrim_edi
    ltrim_edi_done:

  dec ESI
  dec EDI
  ltrim_loop:
    inc ESI
    inc EDI
    mov AL, [EDI]
    mov [ESI], AL
    cmp AL, NULL
    jne ltrim_loop
    ltrim_loop_done:
  
  pop EAX
  pop EDI
  pop ESI
  leave
  ret

_start:
  fgets text1, MAX
  push text1  
  call ltrim
  puts text1

_end:
  push DWORD 0
  call ExitProcess
