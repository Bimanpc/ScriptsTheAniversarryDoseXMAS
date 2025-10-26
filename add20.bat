@echo off
title Batch Calculator
:menu
cls
echo ==========================
echo        CALCULATOR2.0
echo ==========================
echo 1. Addition
echo 2. Subtraction
echo 3. Multiplication
echo 4. Division
echo 5. Exit
echo ==========================
set /p choice=Choose an option: 

if "%choice%"=="1" goto add
if "%choice%"=="2" goto sub
if "%choice%"=="3" goto mul
if "%choice%"=="4" goto div
if "%choice%"=="5" exit
goto menu

:add
set /p a=Enter first number: 
set /p b=Enter second number: 
set /a result=a+b
echo Result = %result%
pause
goto menu

:sub
set /p a=Enter first number: 
set /p b=Enter second number: 
set /a result=a-b
echo Result = %result%
pause
goto menu

:mul
set /p a=Enter first number: 
set /p b=Enter second number: 
set /a result=a*b
echo Result = %result%
pause
goto menu

:div
set /p a=Enter first number: 
set /p b=Enter second number: 
if %b%==0 (
    echo Division by zero not allowed!
) else (
    set /a result=a/b
    echo Result = %result%
)
pause
goto menu
