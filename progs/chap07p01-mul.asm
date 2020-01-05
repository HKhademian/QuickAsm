%include "lib.asm"
extern ExitProcess
global _start

section .bss
  buffer resb 25

section .code
_start:
  fgets buffer, 12
  a2i 12, buffer
  movzx DX, AL
  
  fgets buffer, 12
  a2i 12, buffer
  movzx AX, AL
  
  cmp AX, DX
  ja swap_done
  xchg AX, DX
  swap_done:
  
  ; BX = AL*BL
  mov EBX, 0        ; result holder
  mov CL, 8-1        ; itr counter
  looper:
    test DL, 01H
    jz looper_skip
    add BX, AX
    looper_skip:
    shr DL, 1
    shl AX, 1

    dec CL
    jnz looper
  
  i2a EBX, buffer
  puts buffer

_end:
  push 0
  call ExitProcess
