@echo off
setlocal enabledelayedexpansion

:: Usage: chat.bat <ROOM_FILE_PATH> <USERNAME>
if "%~1"=="" (
  echo Usage: %~nx0 ^<ROOM_FILE_PATH^> ^<USERNAME^>
  echo Example: %~nx0 \\PC\share\room.txt Vasilis
  exit /b 1
)
if "%~2"=="" (
  echo Username is required.
  exit /b 1
)

set "ROOM=%~1"
set "USER=%~2"

:: Ensure room file exists
if not exist "%ROOM%" (
  echo [INIT] Chat room created at %date% %time:~0,8% > "%ROOM%"
)

:: Start live viewer in a separate window (PowerShell tail)
start "Chat Viewer" powershell -NoLogo -NoProfile -Command ^
  "Get-Content -Path '%ROOM%' -Tail 20 -Wait | ForEach-Object {Write-Host $_}"

echo ---------------------------------------------
echo Chatting in: %ROOM%
echo User: %USER%
echo Type your message and press Enter.
echo Commands: /quit to exit, /who to show participants (best effort)
echo ---------------------------------------------

:loop
set /p "MSG=> "
if /i "!MSG!"=="/quit" goto :end

if /i "!MSG!"=="/who" (
  for /f "tokens=2 delims=]" %%A in ('findstr /R /C:"\[[0-9/:-][0-9/ :-]*\] .*:" "%ROOM%" ^| findstr /R /C:": "') do (
    echo Seen user: %%A
  )
  goto :loop
)

:: Sanitize newlines (Batch won't include them via set /p)
set "TS=%date% %time:~0,8%"
>> "%ROOM%" echo [%TS%] %USER%: !MSG!
goto :loop

:end
echo Bye.
endlocal
