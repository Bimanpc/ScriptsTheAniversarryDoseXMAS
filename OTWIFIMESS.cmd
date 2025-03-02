@echo off
title Wi-Fi Messenger
:menu
cls
echo ==============================
echo        Wi-Fi Messenger
echo ==============================
echo 1. Send a Message
echo 2. Exit
set /p choice=Enter choice:

if "%choice%"=="1" goto send
if "%choice%"=="2" exit

:send
set /p user=Enter recipient's username or * for all: 
set /p message=Enter message: 
msg %user% %message%
echo Message sent!
pause
goto menu
