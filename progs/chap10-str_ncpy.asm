%include "lib.asm"
global str_ncpy
global _start

section .code
;;; str_ncpy(esi<=string1, edi<=string2, ecx<=count)
str_ncpy:
  push eax
  push ecx
  push esi
  push edi
  .cpy:
    mov al, [edi]
    mov [esi], al
    cmp al, 0
    ; end of str by str2
    je .cpy_done
    inc esi
    inc edi
    sub ecx, 1
    ja .cpy
    ; end of str by count
    mov byte [esi], 0
    .cpy_done:
  pop edi
  pop esi
  pop ecx
  pop eax
  ret

_start:
  mov esi, str2
  mov edi, str1
  mov ecx, 3
  call str_ncpy
  puts str2
  puts CRLF
  mov esi, str2
  mov edi, str1
  mov ecx, 25
  call str_ncpy
  puts str2
  puts CRLF
  ret

CRLF db `\n\0`

section .data
  str1 db "Hossain", 0
  str2 db "Khademian", 0
      times 50 db 0