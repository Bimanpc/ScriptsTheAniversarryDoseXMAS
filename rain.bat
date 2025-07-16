@echo off
color 0A
title THE AI MATRIX EFFECT

:loop
set /a "rand=%random% %% 10"
set "str=%RANDOM%%RANDOM%%RANDOM%%RANDOM%"
set "sp=                              "
echo %str%%sp%%str:~0,1%%sp%%str:~1,1%%sp%%str:~2,1%%sp%%str:~3,1%
ping -n 0.1 localhost >nul
goto loop
