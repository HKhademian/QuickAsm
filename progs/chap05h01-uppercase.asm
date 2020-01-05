%include "lib.asm"
extern ExitProcess

section .text
  NWLN db 10, 0


section .bss
  buffer resb 100
  buffer2 resb 100


section .data


section .code
  global _start

toUpperCase:
  push EBP
  mov EBP, ESP
  push ESI

  mov ESI, [EBP+8]
  dec ESI
  toUpperCase_loop:
    inc ESI
    cmp [ESI], BYTE 0
    je toUpperCase_end
    cmp [ESI], BYTE 'a'
    jl toUpperCase_loop
    cmp [ESI], BYTE 'z'
    jg toUpperCase_loop
    add [ESI], BYTE 'A'-'a'
    jmp toUpperCase_loop
    toUpperCase_end:

  pop ESI
  pop EBP
  ret 4

_start:
  fgets buffer, 100
  push buffer
  call toUpperCase
  puts buffer

_end:
  push 0
  call ExitProcess
