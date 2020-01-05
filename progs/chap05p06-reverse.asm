%include "lib.asm"
extern ExitProcess
global _start

section .bss
  MAX EQU 1000
  NULL EQU 0
  text1 resb MAX
  buffer resb 25

section .code
reverse:
  %define str1 DWORD [EBP+8]
  enter 0,0
  push ESI
  push EDI
  push EAX
  
  mov ESI, str1
  mov EDI, str1
  
  dec EDI
  reverse_edi_end:
    inc EDI
	cmp BYTE [EDI], NULL
	jne reverse_edi_end

  dec ESI
  reverse_loop:
    inc ESI
	dec EDI
	cmp ESI, EDI
	jae reverse_loop_done
	mov AL, [ESI]
	mov AH, [EDI]
	mov [ESI], AH
	mov [EDI], AL
	jmp reverse_loop
	reverse_loop_done:
  
  pop EAX
  pop EDI
  pop ESI
  leave
  ret 4

_start:
  fgets text1, MAX
  push text1  
  call reverse
  puts text1

_end:
	push DWORD 0
	call ExitProcess
