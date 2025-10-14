@echo off
:: XAMPP Service Status Checker
:: Checks Apache and MySQL services installed by XAMPP

echo ================================
echo   XAMPP Service Status
echo ================================
echo.

:: Check Apache
sc query Apache2.4 >nul 2>&1
if %errorlevel%==0 (
    for /f "tokens=3 delims=: " %%A in ('sc query Apache2.4 ^| findstr "STATE"') do (
        if "%%A"=="RUNNING" (
            echo Apache: RUNNING
        ) else (
            echo Apache: STOPPED
        )
    )
) else (
    echo Apache service not installed
)

:: Check MySQL
sc query MySQL >nul 2>&1
if %errorlevel%==0 (
    for /f "tokens=3 delims=: " %%A in ('sc query MySQL ^| findstr "STATE"') do (
        if "%%A"=="RUNNING" (
            echo MySQL: RUNNING
        ) else (
            echo MySQL: STOPPED
        )
    )
) else (
    echo MySQL service not installed
)

echo.
pause
