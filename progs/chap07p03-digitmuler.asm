%include "lib.asm"
extern ExitProcess
global _start

section .text
  NULL EQU 0
  MAX EQU 100
  CRLF db 0DH, 0AH, NULL

section .bss
  buffer resb MAX

section .data

section .code
_start:
  fgets buffer, MAX

  muling:
    push buffer
    call digitMul
    ;pop EAX
    i2a EAX, buffer
    ;puts buffer
    ;puts CRLF
    cmp EAX, 10
    jge muling
  
  puts buffer

  jmp _end

digitMul:
  %define str1 DWORD [EBP+8]
  %define return DWORD [EBP+8]
  enter 0, 0
  push EAX
  push EBX
  push ESI

  mov EAX, 1
  mov ESI, str1
  dec ESI
  digitMul_loop:
    inc ESI
    movzx EBX, BYTE [ESI]
    cmp EBX, NULL
    jz digitMul_loop_done
    sub EBX, '0'
    imul EAX, EBX
    jmp digitMul_loop
    digitMul_loop_done:

  ;mov return, EAX
  pop ESI
  pop EBX
  ;pop EAX
  leave
  ret  4;-4

_end:
  push 0
  call ExitProcess
