%include "util.asm"
%include "console.asm"
global _start

section .bss
  buffer resb 1000

section .code
_start:
	enter 4,0

; extern MessageBoxA 
; 	push dword 0
; 	push dword title
; 	push dword message
; 	push dword 0
; 	call MessageBoxA

regza
reglog
	
;   ; push 1500
; 	; push 1374
; 	; call console.beep
	
;   ; push    message.len
; 	; push    message
; 	; call    console.write
  
;   ;call    file.GetStdInHandle

;   ; push    1000
; 	; push    buffer
; 	; call    console.read
;   ; puts buffer
;   ; puts CRLF

  push DWORD FILE_OPEN_ALWAYS
  push DWORD filePath
  call file.open
  push EAX
reglog

;   push DWORD FILE_END
;   push DWORD 0
;   push DWORD EAX
;   call file.seek
; reglog

;   pop EAX
;   push EAX
;   push DWORD message.len
;   push DWORD message
;   push DWORD EAX
;   call file.write
; reglog

  pop EAX
  push EAX
  push DWORD 100
  push DWORD buffer
  push DWORD EAX
  call file.read
reglog

  puts buffer
reglog

leave
ret

  mov edx, 100
  mov ecx, 0
  beeper:
	push 500
	push edx
	call console.beep
  add edx, 100
  cmp edx, 1500
  jb beeper

leave
ret

filePath    db "D:\\test.txt", NULL
title     db 'Hossain', NULL
title.len EQU $-title-1
message     db 'Hello, World', CR, LF, 'How Are you?', CR, LF, NULL
message.len EQU $-message-1
