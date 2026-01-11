@echo off
title Office Product Information
echo ==========================================
echo   OFFICE PRODUCT INFO (VERSION & KEY)
echo ==========================================
echo.

REM Έλεγχος 64-bit Office
IF EXIST "%ProgramFiles%\Microsoft Office\Office16\OSPP.VBS" (
    set OSPP="%ProgramFiles%\Microsoft Office\Office16\OSPP.VBS"
) ELSE (
    REM Έλεγχος 32-bit Office
    IF EXIST "%ProgramFiles(x86)%\Microsoft Office\Office16\OSPP.VBS" (
        set OSPP="%ProgramFiles(x86)%\Microsoft Office\Office16\OSPP.VBS"
    ) ELSE (
        echo Δεν βρέθηκε Office εγκατάσταση.
        pause
        exit /b
    )
)

cscript //nologo %OSPP% /dstatus
echo.
pause
