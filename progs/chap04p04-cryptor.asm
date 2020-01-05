%include "lib.asm"
extern ExitProcess  ; windows syscall to exit

section .text
  TABLE db 4, 6, 9, 5, 0, 3, 1, 8, 7, 2
  MSG_CONTINUE db 10, "Do you want to continue? ", 0

section .bss
  buffer resb 100


section .data


section .code
  global _start

_start:
  fgets buffer, 100  
  lea esi, [buffer]          ; char looper
  mov ebx, TABLE
  count:
    mov al, [esi]
    cmp al, 0
    je printer     ; exit on \0 character
    
    sub al, '0'
    jl looper
    cmp al, 9
    jg looper

    xlat
    add al, '0'
    mov [esi], al

    looper:
    inc esi
    jmp count

  printer:
    puts buffer

  confirm:
    puts MSG_CONTINUE
    fgets buffer, 100
    mov al, [buffer]
    cmp al, 'y'
    je _start
    cmp al, 'Y'
    je _start

end:
  mov eax, 0
  call ExitProcess
