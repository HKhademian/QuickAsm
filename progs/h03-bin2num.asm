%include "lib.asm"
extern ExitProcess ; windows syscall to exit

section .text
  N equ 8           ; up to 32 bits

section .data
  buffer times N+2 db 0

section .code
  global _start

_start:
  fgets buffer, N+2  ; fill buffer with N (+2 is CR&LF) character

  mov esi, 0         ; counter
endofbuffer:         ; mesure string len
  lea edx, [buffer+esi]
  inc esi            ; next room
  cmp BYTE [edx], 0
  jnz endofbuffer
  dec esi            ; ESI is boolean number length

  mov eax, 0        ; result number
  mov ecx, 1        ; bit value
bin2numer:
  lea edx, [buffer+esi-1]
  cmp BYTE [edx], '1'
  jne bit2numer_skip
  add eax, ecx
  bit2numer_skip:
  shl ecx, 1
  sub esi, 1
  jge bin2numer

printer:
  i2a eax, buffer
  puts buffer

end:
  push 0
  call ExitProcess
