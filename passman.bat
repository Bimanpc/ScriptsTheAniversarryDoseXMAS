@echo off
setlocal enabledelayedexpansion

:: Set the password file
set "PASS_FILE=%USERPROFILE%\passwords.enc"

:: Menu
echo Password Manager
echo ----------------
echo 1. Save Password
echo 2. Retrieve Password
echo 3. Exit
set /p choice=Enter your choice: 

if "%choice%"=="1" goto save
if "%choice%"=="2" goto retrieve
if "%choice%"=="3" exit

echo Invalid choice.
goto end

:save
set /p site=Enter site name: 
set /p user=Enter username: 
set /p pass=Enter password: 

echo %site% | findstr /r "^[A-Za-z0-9_]*$" >nul || (echo Invalid site name. Only alphanumeric characters allowed. & goto end)

echo %site%:%user%:%pass% >> "%PASS_FILE%"
cipher /E "%PASS_FILE%"
echo Password saved successfully.
goto end

:retrieve
set /p site=Enter site name to retrieve: 
cipher /D "%PASS_FILE%"
findstr /i "^%site%:" "%PASS_FILE%" | more
cipher /E "%PASS_FILE%"
goto end

:end
endlocal
pause
