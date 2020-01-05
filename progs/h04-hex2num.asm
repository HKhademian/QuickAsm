%include "lib.asm"
extern ExitProcess  ; windows syscall to exit

section .text
  N equ 8           ; supports N*4 bit numbers
  CRLF db 10, 0

section .data
  buffer times N+2 db 0

section .code
  global _start

_start:
  fgets buffer, N+2  ; fill buffer with N(+2 is CRLF) character

  mov esi, 0         ; counter
endofbuffer:         ; mesure string len
  lea edx, [buffer+esi]
  inc esi            ; next room
  cmp BYTE [edx], 0
  jnz endofbuffer
  dec esi            ; ESI is boolean number length

  mov eax, 0         ; result number
  mov ebx, 1         ; digit value
hex2numer:
  sub esi, 1
  jl printer

  lea edx, [buffer+esi]
  mov cl, BYTE [edx]
  movzx ecx, cl
  
  sub cl, 'A'-10
  jae bit2numer_adder
  
  hex2numer_decimaler:
  sub cl, '0'-'A'+10

  bit2numer_adder:
    mov edx, ebx
    imul edx, ecx
    add eax, edx

  imul ebx, 16
  shl ecx, 4
  jmp hex2numer

printer:
  i2a eax, buffer
  puts buffer

end:
  push 0
  call ExitProcess
