@echo off

if "%~1" equ "" (
	echo usage:
	echo   %~n0 file.chm
	exit /b 1
)

if "%~x1" neq ".chm" (
	echo you need file with .chm extension
	exit /b 2
)

start ""  /b /wait hh -decompile ~~ %~sf1 

for /r "~~" %%h in (*.htm) do (
  rundll32.exe "%systemroot%\system32\mshtml.dll",PrintHTML "%%~fh"
)

rd "~~" /s /q >nul 2>nul