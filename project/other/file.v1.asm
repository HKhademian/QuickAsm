global file.open
global file.read
global file.write
global file.GetConsoleHandle

extern _GetStdHandle@4, GetStdHandle
extern _WriteFile@20, WriteFile
extern _ReadFile@20, ReadFile
extern CreateFileA
extern SetFilePointer

FILE_GENERIC_READ 		EQU 1<<30
FILE_GENERIC_WRITE 		EQU 1<<29
FILE_GENERIC_RW 			EQU (FILE_GENERIC_READ | FILE_GENERIC_WRITE)

;;; https://stackoverflow.com/a/14469641/1803735
;;;	if file											+Exists			-NotExists
FILE_CREATE_NEW					EQU 1 ; +Fails			-Creates
FILE_CREATE_ALWAYS			EQU 2 ; +Truncates	-Creates
FILE_OPEN_ALWAYS				EQU 4 ; +Opens			-Creates
FILE_OPEN_EXISTING			EQU 3 ; +Opens			-Fails
FILE_TRUNCATE_EXISTING	EQU 5 ; +Truncates	-Fails

FILE_BEGIN		EQU 0
FILE_CURRENT	EQU 1
FILE_END			EQU 2

section .code

file.open:
	;;; DEP: https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-openfile
	;;; https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea
	;;; https://docs.microsoft.com/en-us/windows/win32/fileio/creating-and-opening-files
	;;; file.open( path, mode )
	;;; opens existing or create new file at path(arg0:DWORD) with mode(arg1:DWORD)
	;;; return file handle in eax
	enter 0,0
	push ecx ; changed in CreateFileA
	push edx ; changed in CreateFileA

	; CreateFileA( path, GENERIC_RW, 0, NULL, mode, FILE_ATTRIBUTE_NORMAL, NULL );
	push	DWORD NULL						; NULL									: hTemplateFile
	push	DWORD 128							; FILE_ATTRIBUTE_NORMAL	: dwFlagsAndAttributes
	push	DWORD [EBP+12]				; mode									: dwCreationDisposition
	push	DWORD NULL						; NULL									: lpSecurityAttributes
	push	DWORD 0								; 0											: dwShareMode
	push	DWORD FILE_GENERIC_RW	; GENERIC_RW						: dwDesiredAccess
	push	DWORD [EBP+8]					; path									: lpFileName
	call	CreateFileA
	
	pop edx
	pop ecx
	leave
	ret 8

file.write:
	;;; https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-writefile
	;;; file.write( hFile, buffer, len )
	;;; writes len(arg2:DWORD) bytes buffer(arg1:DWORD) in file(arg0:DWORD)
	;;; return writed bytes in eax
	enter 4,0
	push ecx ; changed in CreateFileA
	push edx ; changed in CreateFileA

	lea		eax, [ebp-4]
	; WriteFile( hFile, buffer, len, &bytes, 0);
	push	NULL						; NULL
	push	eax							; &bytes
	push	DWORD [EBP+16]	; len
	push	DWORD [EBP+12]	; buffer
	push	DWORD [EBP+8]		; hFile
	;call	_WriteFile@20
	call	WriteFile
	mov		eax, [ebp-4]

	pop edx
	pop ecx
	leave
	ret 12

file.read:
	;;; file.read( hFile, buffer, maxLen )
	;;; reads maxLen(arg2:DWORD) bytes to buffer(arg1:DWORD) from file(arg0:DWORD)
	;;; return readed bytes in eax
	enter 4,0
	push ecx ; changed in ReadFile
	push edx ; changed in ReadFile

	lea		eax, [ebp-4]
	; ReadFile( hFile, buffer, maxLen, &bytes, NULL );
	push	NULL						; NULL
	push	eax							; &bytes
	push	DWORD [EBP+16]	; maxLen
	push	DWORD [EBP+12]	; buffer
	push	DWORD [EBP+8]		; hFile
	;call	_ReadFile@20
	call	ReadFile
	mov		eax, [ebp-4]

	pop edx
	pop ecx
	leave
	ret 12

file.seek:
	;;; file.seek( hFile, dist, mode )
	;;; return readed bytes in eax
	enter 0,0
	push ecx ; changed in CreateFileA
	push edx ; changed in CreateFileA

	lea		eax, [ebp-4]
	; SetFilePointer( hFile, dist, NULL, mode );
	push	DWORD [EBP+16]	; mode
	push	DWORD NULL			; NULL
	push	DWORD [EBP+12]	; dist
	push	DWORD [EBP+8]		; hFile
	call	SetFilePointer

	pop edx
	pop ecx
	leave
	ret 12

file.GetStdInHandle:
	;;; file.GetStdInHandle()
	;;; return handler in eax
	; hStdOut = GetStdHandle( STD_INPUT_HANDLE )
	push	-10
	;call	_GetStdHandle@4
	call	GetStdHandle
	ret 0

file.GetStdOutHandle:
	;;; file.GetStdOutHandle()
	;;; return handler in eax
	; hStdOut = GetStdHandle( STD_OUTPUT_HANDLE )
	push	-11
	;call	_GetStdHandle@4
	call	GetStdHandle
	ret 0

file.GetStdErrHandle:
	;;; file.GetStdErrHandle()
	;;; return handler in eax
	; hStdOut = GetStdHandle( STD_ERROR_HANDLE )
	push	-12
	;call	_GetStdHandle@4
	call	GetStdHandle
	ret 0
