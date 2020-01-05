%include "console.asm"

%ifndef PIANO_ASM
%define PIANO_ASM

section .text
	note_names:
		db 'A4', 0, 0, 0, 0, 0, 0;, 0, 0
		db 'B4', 0, 0, 0, 0, 0, 0;, 0, 0
		db 'C4', 0, 0, 0, 0, 0, 0;, 0, 0
		db 'D4', 0, 0, 0, 0, 0, 0;, 0, 0
		db 'E4', 0, 0, 0, 0, 0, 0;, 0, 0
		db 'F4', 0, 0, 0, 0, 0, 0;, 0, 0
		db 'G4', 0, 0, 0, 0, 0, 0;, 0, 0

	base_notes equ notes4
	base_dur equ 500 ; ms
	skip equ 100 ; ms
		
	dd 0			;-1: NO
	notes0:
		dd 27		; 0: A
		dd 31		; 1: B
		dd 16		; 2: C
		dd 18		; 3: D
		dd 21		; 4: E
		dd 22		; 5: F
		dd 24		; 6: G
		
	dd 0			;-1: NO
	notes1:
		dd 55		; 0: A
		dd 62		; 1: B
		dd 33		; 2: C
		dd 37		; 3: D
		dd 41		; 4: E
		dd 44		; 5: F
		dd 49		; 6: G
		
	dd 0			;-1: NO
	notes2:
		dd 110	; 0: A
		dd 123	; 1: B
		dd 65		; 2: C
		dd 73		; 3: D
		dd 82		; 4: E
		dd 87		; 5: F
		dd 99		; 6: G
		
	dd 0			;-1: NO
	notes3:
		dd 220	; 0: A3
		dd 247	; 1: B3
		dd 130	; 2: C3
		dd 147	; 3: D3
		dd 165	; 4: E3
		dd 177	; 5: F3
		dd 196	; 6: G3
			
	dd 0			;-1: NO
	notes4:
		dd 440	; 0: A4
		dd 494	; 1: B4
		dd 262	; 2: C4
		dd 294	; 3: D4
		dd 330	; 4: E4
		dd 349	; 5: F4
		dd 392	; 6: G4
	
	dd 0			;-1: NO
	notes5:
		dd 880	; 0: A5
		dd 988	; 1: B5
		dd 523	; 2: C5
		dd 587	; 3: D5
		dd 659	; 4: E5
		dd 698	; 5: F5
		dd 784	; 6: G5

	dd 0			;-1: NO
	notes6:
		dd 1760	; 0: A6
		dd 1976	; 1: B6
		dd 1047	; 2: C6
		dd 1175	; 3: D6
		dd 1319	; 4: E6
		dd 1397	; 5: F6
		dd 1568	; 6: G6

section .code

piano.play:
	enter 0,0
	pushad
	mov esi, eax
	
	mov EBX, base_dur
	mov EDI, base_notes
	jmp .reader_cond
	.reader:
		cmp al, 'x'
		je .reader_done
		
		cmp al, '|'
		je .reader_long
		cmp al, '-'
		je .reader_dlong
		cmp al, '@'
		je .reader_short
		
		cmp al, 0
		jl .reader_nums_skip
		cmp al, 9
		jb .reader_nums
		.reader_nums_skip:

		cmp al, 'A'
		jb .reader_hold
		
		cmp al, 'G'
		jna .reader_play
		
		.reader_nums:
			sub eax, '0'
			jmp .reader_cond

		.reader_hold:
			putcstr `--- Pause ---\n`
			sleep skip
			jmp .reader_cond
			; mov eax, 'A'-1
		
		.reader_play:
			sub eax, 'A'
			lea ecx, [note_names + eax*8]
			putstr ecx, 8
			putstr CRLF, 2
			; puti eax
			; putstr CTAB, 2
			; puti ebx
			; putstr CTAB, 2
			mov eax, [EDI + eax*4] ; now al is freq
			; puti eax
			; putstr CRLF, 2
			console.beep eax, ebx
			mov EBX, base_dur
			jmp .reader_cond

		.reader_long:
			putcstr `--- Double ---\n`
			;mov ebx, base_dur*2
			;imul ebx, ebx, 2
			shl ebx, 1
			jmp .reader_cond
		
		.reader_dlong:
			putcstr `--- Triple ---\n`
			imul ebx, ebx, 3
			;mov ebx, base_dur*3
			jmp .reader_cond
		
		.reader_short:
			putcstr `--- Half ---\n`
			shr ebx, 1
			;mov ebx, base_dur*3
			jmp .reader_cond

		.reader_cond:
		xor eax, eax
		mov al, [esi]
		inc esi
		cmp al, NULL
		jne .reader
		.reader_done:

	popad
	leave
	ret


%endif