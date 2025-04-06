@echo off
REM Simple Batch Script to Launch a VoIP Application

REM Set the path to your VoIP application
SET VOIP_APP_PATH="C:\Path\To\Your\VoIPApp.exe"

REM Check if the VoIP application exists
IF EXIST %VOIP_APP_PATH% (
    ECHO Starting VoIP Application...
    START %VOIP_APP_PATH%
) ELSE (
    ECHO VoIP Application not found at %VOIP_APP_PATH%
)

REM Pause to keep the command window open
PAUSE
