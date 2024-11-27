@echo off
title Happy Xmas Wishes!
color 0A

:: Set up a simple menu
echo.
echo ----------------------------------------------
echo             🎄🎅 Happy Christmas! 🎅🎄
echo ----------------------------------------------
echo.
echo "Ho! Ho! Ho! Wishing you a joyful Christmas!"
echo.

:: Display a simple ASCII art tree
echo            *
echo           ***
echo          *****
echo         *******
echo        *********
echo       ***********
echo          Merry
echo        Christmas!
echo.
echo ----------------------------------------------
echo Press any key to hear a Christmas jingle!
pause >nul

:: Play a Christmas tune using system beeps
:: You can use the `echo` and `timeout` commands creatively.
echo 🎶 Playing Jingle Bells 🎶
(
    echo echo ^(800^)>nul
    timeout /T 1 >nul
    echo echo ^(900^)>nul
    timeout /T 1 >nul
) >nul

echo.
echo Spread the joy and share the wishes! 🎁
pause
exit
