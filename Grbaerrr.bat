@echo off
setlocal ENABLEDELAYEDEXPANSION
title GNU GRABBER APP

:: ---------------- CONFIG ----------------
set "LOGFILE=%~dp0gnu_grabber.log"
:: ---------------------------------------

:main
cls
echo ================================
echo        GNU GRABBER APP
echo ================================
echo.
echo  1. Download single file
echo  2. Batch download from list file
echo  3. View log
echo  4. Exit
echo.
set /p choice=Select option [1-4]: 

if "%choice%"=="1" goto single
if "%choice%"=="2" goto batch
if "%choice%"=="3" goto showlog
if "%choice%"=="4" goto end

goto main

:single
cls
echo --- Single file download ---
echo.
set "URL="
set /p URL=Enter file URL (e.g. https://ftp.gnu.org/...): 
if "%URL%"=="" goto main

set "OUTDIR="
set /p OUTDIR=Output folder (blank = current): 
if "%OUTDIR%"=="" set "OUTDIR=%cd%"

if not exist "%OUTDIR%" (
    echo Creating folder "%OUTDIR%"
    mkdir "%OUTDIR%" >nul 2>&1
)

call :download "%URL%" "%OUTDIR%"
pause
goto main

:batch
cls
echo --- Batch download from list ---
echo.
echo Each line in the list file must be a full URL.
echo.
set "LISTFILE="
set /p LISTFILE=Path to list file: 
if "%LISTFILE%"=="" goto main
if not exist "%LISTFILE%" (
    echo File not found: "%LISTFILE%"
    pause
    goto main
)

set "OUTDIR="
set /p OUTDIR=Output folder (blank = current): 
if "%OUTDIR%"=="" set "OUTDIR=%cd%"

if not exist "%OUTDIR%" (
    echo Creating folder "%OUTDIR%"
    mkdir "%OUTDIR%" >nul 2>&1
)

for /f "usebackq delims=" %%U in ("%LISTFILE%") do (
    if not "%%U"=="" (
        echo.
        echo Downloading: %%U
        call :download "%%U" "%OUTDIR%"
    )
)

echo.
echo Batch download complete.
pause
goto main

:download
:: %1 = URL, %2 = OUTDIR
set "DURL=%~1"
set "DOUT=%~2"

for %%F in ("%DURL%") do set "FNAME=%%~nxF"
if "%FNAME%"=="" (
    :: crude fallback: take everything after last /
    set "FNAME=%DURL%"
    set "FNAME=!FNAME:/= !"
    for %%X in (!FNAME!) do set "FNAME=%%X"
)

echo.
echo Target file: "%DOUT%\%FNAME%"
echo [%date% %time%] START  "%DURL%"  ^> "%DOUT%\%FNAME%" >> "%LOGFILE%"

:: Prefer curl if present
where curl >nul 2>&1
if %errorlevel%==0 (
    pushd "%DOUT%"
    curl -L -O "%DURL%"
    set "RC=%errorlevel%"
    popd
) else (
    :: Fallback to PowerShell
    powershell -NoLogo -NoProfile -Command ^
        "try { Invoke-WebRequest -Uri '%DURL%' -OutFile '%DOUT%\%FNAME%'; exit 0 } catch { exit 1 }"
    set "RC=%errorlevel%"
)

if "%RC%"=="0" (
    echo Download OK.
    echo [%date% %time%] OK     "%DURL%"  "%DOUT%\%FNAME%" >> "%LOGFILE%"
) else (
    echo Download FAILED (code %RC%).
    echo [%date% %time%] FAIL   "%DURL%"  code=%RC% >> "%LOGFILE%"
)

exit /b

:showlog
cls
echo --- GNU GRABBER LOG ---
echo.
if not exist "%LOGFILE%" (
    echo No log file yet: "%LOGFILE%"
) else (
    type "%LOGFILE%"
)
echo.
pause
goto main

:end
endlocal
exit /b
