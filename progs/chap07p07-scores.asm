%include "lib.asm"
extern ExitProcess
global _start

section .text
  NULL EQU 0
  MAX EQU 25
  CRLF db 0DH, 0AH, NULL
  CPER db '%', NULL

section .bss
  buffer resb MAX

section .data

section .code
_start:
  %define sum EDX
  %define count ECX
  %define max EBX
  %define maxCount EDI
  
  fgets buffer, 12
  a2i 12, buffer
  mov maxCount, EAX
  
  mov sum, 0
  mov max, -1
  mov count, 0
  fill:
    cmp count, maxCount
    jae fill_done
    fgets buffer, 12
    a2i 12, buffer
    cmp EAX, 0
    jl fill_done
    inc count
    add sum, EAX
    cmp EAX, max
    jle fill
    mov max, EAX
    jmp fill
    fill_done:
  
  ;puts CRLF

  ;i2a count, buffer
  ;puts buffer
  ;puts CRLF

  ;i2a sum, buffer
  ;puts buffer
  ;puts CRLF

  ;i2a max, buffer
  ;puts buffer
  ;puts CRLF

  mov EAX, 0
  xchg EAX, sum
  div count
  
  mov ECX, 100
  mul ECX
  
  ;i2a EAX, buffer
  ;puts buffer
  ;puts CRLF
  
  mov EDX, 0
  div max
  
  i2a EAX, buffer
  puts buffer
  puts CPER

  jmp _end


_end:
  push 0
  call ExitProcess
