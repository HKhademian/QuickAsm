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
  push EBX
  push ECX
  push EDX

  mov EAX, [EBP+8]    ; num is arg1
  mov EBX, 0          ; digits sum
  mov ECX, 10
  digitSum_loop:
    cmp EAX, 0
    je digitSum_end
    mov EDX, 0
    div ECX           ; EDX:EAX/10 => EAX=EAX/10  EDX=EAX%10
    add EBX, EDX
    jmp digitSum_loop
    digitSum_end:
  mov [EBP+12], EBX   ; arg0 is sum

  pop EDX
  pop ECX
  pop EBX
  pop EAX
  pop EBP
  ret 4               ; we dont pop arg0

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
