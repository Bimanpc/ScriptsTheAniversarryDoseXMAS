@echo off
title SSD TRIMmer

:: --- Require admin ---
whoami /groups | find "S-1-5-32-544" >nul
if errorlevel 1 (
    echo This script must be run as Administrator.
    pause
    exit /b 1
)

echo.
echo === SSD TRIM status ===
fsutil behavior query DisableDeleteNotify
echo.
echo 0 = TRIM enabled, 1 = TRIM disabled
echo.

:: --- Optional: force-enable TRIM (uncomment if you want) ---
:: echo Enabling TRIM for NTFS and ReFS...
:: fsutil behavior set DisableDeleteNotify 0
:: echo.

echo Detecting volumes...
echo.

for /f "skip=1 tokens=1" %%D in ('wmic logicaldisk get deviceid') do (
    if not "%%D"=="" (
        echo Optimizing (TRIM where supported) on %%D ...
        defrag %%D /L /O
        echo.
    )
)

echo All volumes processed.
pause
