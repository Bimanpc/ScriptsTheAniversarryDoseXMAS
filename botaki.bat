@echo off
REM This script runs a Telegram bot application.

REM Change to the directory where your bot script is located.
cd /d "C:\Path\To\Your\Bot\Script"

REM Optional: Set up virtual environment if using Python
REM call venv\Scripts\activate

REM Run your bot script. Assuming it's a Python script named 'bot.py'
python bot.py

REM Optional: Deactivate virtual environment if used
REM deactivate

REM Pause the script to view any output before the window closes
pause
