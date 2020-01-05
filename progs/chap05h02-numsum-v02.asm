%include "lib.asm"
extern ExitProcess

section .text
  NWLN db 10, 0


section .bss
  buffer resb 25


section .data


section .code
  global _start

digitSum:
  push EBP
  mov EBP, ESP
  push EAX
  push ECX
  push EDX

  mov EAX, [EBP+8]          ; num is arg1
  mov [EBP+12], DWORD 0     ; arg0 is sum
  mov ECX, 10
  digitSum_loop:
    cmp EAX, 0
    je digitSum_end
    mov EDX, 0
    div ECX                 ; EDX:EAX/10 => EAX=EAX/10  EDX=EAX%10
    add [EBP+12], EDX
    jmp digitSum_loop
    digitSum_end:

  pop EDX
  pop ECX
  pop EAX
  pop EBP
  ret 4                     ; we dont pop arg0

_start:
  fgets buffer, 12
  a2i 12, buffer
  
  push 0              ; return result keeper
  push EAX
  call digitSum
  pop EAX
  
  i2a EAX, buffer
  puts buffer

_end:
  push 0
  call ExitProcess
