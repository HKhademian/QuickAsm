%include "lib.asm"
extern ExitProcess  ; windows syscall to exit

section .text
  MSG_X_EQ db "X= ", 0
  MSG_Y_EQ db " and Y= ", 0
  MSG_NEWLINE db 10, 0

section .bss
  buffer resb 100


section .data
  myC dq 0
  myC2 dq 0
  myX dq 0
  myX2 dq 0
  myY2 dq 0


section .code
  global _start

_start:
  fgets buffer, 25
  a2i 25, buffer
  mov [myC], eax
  imul eax, eax
  mov [myC2], eax

  mov ecx, [myC]          ; first start at x=c
  inc ecx
  mov [myX], ecx
  findX:
    sub [myX], DWORD 1
    jl end
   
    mov ecx, [myX]
    imul ecx, ecx
    mov [myX2], ecx
    
    mov ebx, [myC2]
    sub ebx, [myX2]
    mov [myY2], ebx

    mov eax, 0         ; y start at 0 to c
    dec eax
    findY:
      add eax, 1
      cmp eax, [myC]
      jg findX

      mov edx, eax
      imul edx, edx
      cmp edx, ebx
      je printMe
      jg findX
      jmp findY

      printMe:
        puts MSG_X_EQ
        i2a DWORD [myX], buffer
        puts buffer
        puts MSG_Y_EQ
        i2a eax, buffer
        puts buffer
        puts MSG_NEWLINE
      jmp findX

end:
  mov eax, 0
  call ExitProcess
