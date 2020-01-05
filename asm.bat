@echo off

SET curdir=%CD%
SET file=%~1
set file=%file:/=\%
set file=%file:.asm=%

REM parse asm app to obj
"%~dp0\nasm.exe" -f win32 "%file%.asm" -o "%file%.obj"

IF EXIST "%file%.obj" (
	REM link dependecies to app
	"%~dp0\GoLink.exe" /console /entry _start /ni "%file%.obj" "%~dp0\libw.obj" kernel32.dll


	REM [UN]COMMENT TO delete .obj file
	DEL "%file%.obj"


	REM run the app
	"%file%.exe"
	
	REM SET ExitCode='"%ERRORLEVEL%"'
	REM REM print exit code
	REM echo; & echo|set /p=ExitCode is %ExitCode%


	REM [UN]COMMENT TO delete exe file
	DEL "%file%.exe"
)
