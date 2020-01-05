%include "lib.asm"
extern _start
section .bss
  resb 10
  buffer resb 1000
section .code
chdir:
  enter 0,0
  mov ebx, [ebp+8]
  mov eax, 12
  int 0x80
  leave
  ret
_start:
  enter 0,0
  puts MSG_ENTER
  fgets buffer, 1000
  push buffer
  call chdir
  cmp EAX, 0
  jne .error
  puts MSG_OK
  jmp .end
  .error:
  puts MSG_NOT
  .end:
  leave
  ret
MSG_ENTER db "directory exists", 0
MSG_OK db "directory exists", 0
MSG_NOT db "directory NOT exists", 0
