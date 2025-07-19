@echo off
color 0A
title Matrix AI LLM Launcher

:: "Matrix-style" animation before starting the AI
:matrix
setlocal ENABLEDELAYEDEXPANSION
cls
for /L %%n in (1,1,100) do (
    set /a "rand1=!random! %% 80"
    set /a "rand2=!random! %% 80"
    set /a "rand3=!random! %% 80"
    echo.
    for /L %%i in (1,1,80) do (
        set /a "val=!random! %% 2"
        <nul set /p=!val!
    )
    timeout /nobreak /delay 0.05 >nul
)
endlocal

echo.
echo.
echo ====================================
echo   Starting Matrix AI LLM Script...
echo ====================================
timeout /t 2 >nul

:: Activate virtual environment if needed
:: call path\to\venv\Scripts\activate.bat

:: Start the AI script
python path\to\your_llm_script.py

pause
