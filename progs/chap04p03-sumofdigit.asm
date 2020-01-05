%include "lib.asm"
extern ExitProcess  ; windows syscall to exit

section .text
  MSG db "sum of individual digits is: ", 0


section .bss
  buffer resb 100


section .data


section .code
  global _start

_start:
  fgets buffer, 100  
  mov eax, 0                 ; sum of all digits
  lea esi, [buffer]          ; char looper
  count:
    mov dl, [esi]
    inc esi

    cmp dl, 0
    je printer     ; exit on \0 character
    
    sub dl, '0'
    jl count
    cmp dl, 9
    jg count

    movzx edx, dl
    add eax, edx
    jmp count

  printer:
    puts MSG
    i2a eax, buffer
    puts buffer

end:
  mov eax, 0
  call ExitProcess
