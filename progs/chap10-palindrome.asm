%include "lib.asm"
global str_ncpy
global _start

section .code
;;; palindrome(str1)
palindrome:
  enter 0,0
  push edi
  push esi

  mov esi, DWORD [EBP+8] ; load str1 pointer
  mov edi, esi

  dec edi
  .edi2end:
    inc edi
    cmp [edi], byte 0
    jne .edi2end
  ;dec edi ; edi is on last char

  dec esi ; fake for first ittr
  .detector:
    .detector_left:
      inc esi
      cmp esi, edi
      ja .detector_eq
      mov al, [esi]
      cmp al, ' '
      je .detector_left
      cmp al, '!'
      je .detector_left
      cmp al, '.'
      je .detector_left
      cmp al, ','
      je .detector_left
      cmp al, '9'
      jnbe .detector_left_wrd
      cmp al, '0'
      jnae .detector_err
      jmp .detector_left_done
      .detector_left_wrd:
      cmp al, 'Z'
      jnbe .detector_left_sml
      sub al, 'Z'-'z'
      .detector_left_sml:
      cmp al, 'a'
      jnae .detector_err
      cmp al, 'z'
      jnbe .detector_err
      .detector_left_done:
    .detector_right:
      dec edi
      cmp edi, esi
      jb .detector_eq
      mov ah, [edi]
      cmp ah, ' '
      je .detector_right
      cmp ah, '!'
      je .detector_right
      cmp ah, '.'
      je .detector_right
      cmp ah, ','
      je .detector_right
      cmp ah, '9'
      jnbe .detector_right_wrd
      cmp ah, '0'
      jnae .detector_err
      jmp .detector_right_done
      .detector_right_wrd:
      cmp ah, 'Z'
      jnbe .detector_right_sml
      sub ah, 'Z'-'z'
      .detector_right_sml:
      cmp ah, 'a'
      jnae .detector_err
      cmp ah, 'z'
      jnbe .detector_err
      .detector_right_done:
    cmp al,ah
    je .detector
    .detector_neq:
      mov eax, 0
      clc ; no error
      jmp .detector_done
    .detector_eq:
      mov eax, 1
      clc ; no error
      jmp .detector_done
    .detector_err:
      mov eax, 0
      stc ; has error
    .detector_done:
  
  pop esi
  pop edi
  leave
  ret 4

_start:
  enter 0,0
  
  fgets buffer, 1000
  push DWORD buffer
  call palindrome
  jnc .print
  puts MSG_ERR
  leave 
  ret
  .print:
  i2a eax, buffer
  puts buffer

  leave
  ret

CRLF db `\n\0`
MSG_ERR db `error\n\0`
section .bss
  buffer resb 1000
