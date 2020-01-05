extern read,itoa,atoi,write

NULL EQU 0
CR EQU 0DH
LF EQU 0AH
TAB EQU '	'
SP EQU ' '

%macro fgets 2 
	push %2;length
	push %1;buffer
	call read
%endmacro

%macro i2a 2 
	push %1;value
	push %2;buffer
	call itoa
%endmacro

%macro a2i 2 ;stores res in eax
	push %1;length
	push %2;buffer
	call atoi
%endmacro

%macro puts 1
	pushad
	xor ecx,ecx
	mov esi,%1
	%%_get_length:
		inc ecx
		lodsb
		cmp al,0
	jne %%_get_length
	dec ecx
	putstr %1, ecx
	popad
%endmacro

%macro putstr 1
	push ECX
	push ESI
	mov ESI, %1
	cmp ESI, 0
	je %%_skip
	dec ESI
	mov ECX, -1
	%%_get_length:
		inc ecx
		inc ESI
		cmp BYTE [ESI], 0
		jne %%_get_length
	cmp ECX, 0
	jle %%_skip
	putstr %1, ECX
	%%_skip:
	pop ESI
	pop ECX
	; %%_end:
%endmacro

%macro putstr 2
	;; wish to use mov+sub insteadof push to preserve parameters order but mov cant opperate on mem2mem
	;mov DWORD [ESP-4], DWORD %2			; size
	;mov DWORD [ESP-8], DWORD %1			; buffer
	;sub ESP, 8											; allocate space
	
	push DWORD %2			; size
	push DWORD %1			; buffer
	
	call write
%endmacro