@echo off
setlocal

set "SHARE_NAME=QuickShare"
set "BASE_DIR=%TEMP%\QuickShare"

:: Decide what to share
if "%~1"=="" (
    set "TARGET=%CD%"
) else (
    if exist "%~1\" (
        :: Argument is a folder
        set "TARGET=%~f1"
    ) else if exist "%~1" (
        :: Argument is a file – copy to temp share folder
        if not exist "%BASE_DIR%" mkdir "%BASE_DIR%"
        copy "%~1" "%BASE_DIR%" >nul
        set "TARGET=%BASE_DIR%"
    ) else (
        echo [!] File or folder not found: %~1
        exit /b 1
    )
)

:: Remove old share if it exists
net share %SHARE_NAME% /delete /y >nul 2>&1

:: Create new read-only share
net share %SHARE_NAME%="%TARGET%" /grant:Everyone,READ
if errorlevel 1 (
    echo [!] Failed to create share. Try running this script as Administrator.
    exit /b 1
)

echo.
echo Quick Share is ready:
echo   \\%COMPUTERNAME%\%SHARE_NAME%
echo.
echo Shared path:
echo   %TARGET%
echo.
echo To stop sharing later, run:
echo   net share %SHARE_NAME% /delete
echo.
pause

endlocal
