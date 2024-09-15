@echo off
title Simple Notepad Clone
:menu
cls
echo Simple Notepad Clone
echo.
echo 1. Create a new file
echo 2. Open an existing file
echo 3. Exit
echo.
set /p choice=Choose an option: 
if %choice%==1 goto newfile
if %choice%==2 goto openfile
if %choice%==3 exit

:newfile
cls
echo Enter the name of the new file (with extension):
set /p filename=
echo Type your text below. Press Ctrl+Z and Enter to save.
copy con %filename%
echo File saved as %filename%
pause
goto menu

:openfile
cls
echo Enter the name of the file to open (with extension):
set /p filename=
if not exist %filename% (
    echo File not found!
    pause
    goto menu
)
type %filename%
echo.
echo Press any key to return to the menu.
pause
goto menu
