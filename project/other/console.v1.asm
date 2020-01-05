%include "file.asm"
global console.write

extern  _Beep@8

section .code
console.write:
	;;; console.write(str, len)
	;;; writes len(arg1:DWORD) char str(arg1:DWORD) in console
	enter 0,0
	;push eax
	push ecx
	push edx

	call file.GetStdOutHandle		; eax = std_out_hand
	push DWORD [EBP+12]					; len
	push DWORD [EBP+8]					; str
	push DWORD eax							; std_out_hand
	call file.write							; eax = writed characters

	pop edx
	pop ecx
	;pop eax
	leave
	ret 8

console.read:
	;;; console.read( buffer, maxLen )
	;;; reads max len(arg1:DWORD) char to str(arg1:DWORD) from console
	enter 0,0
	;push eax
	push ecx
	push edx

	call file.GetStdInHandle		; eax = std_in_hand
	push DWORD [EBP+12]					; maxLen
	push DWORD [EBP+8]					; buffer
	push DWORD eax							; std_in_hand
	call file.read							; eax = readed characters

	pop edx
	pop ecx
	;pop eax
	leave
	ret 8

console.beep:
	;;; console.beep(freq, dur)
	;;; beeps in freq(arg0:DWORD) for dur(arg1:DWORD) mili-secs
	enter 0,0
	push eax
	push ecx
	push edx

	push DWORD [EBP+12]		; dur
	push DWORD [EBP+8]		; freq
	call _Beep@8					; eax = if err

	pop edx
	pop ecx
	pop eax
	leave
	ret 8
