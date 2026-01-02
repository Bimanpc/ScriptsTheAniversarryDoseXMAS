@echo off
REM =====================================
REM 5G SA LATENCY - STOP APP SCRIPT
REM =====================================

REM ----- CONFIGURE THESE NAMES -----
REM Process executables to kill
set PROC1=LatencyApp.exe
set PROC2=5GSAClient.exe

REM Windows services to stop (if any)
set SVC1=5GSA-Latency-Service
set SVC2=

REM Log file (optional)
set LOGFILE=%~dp0Latency_Stop_%DATE:/=-%_%TIME::=-%.log
REM =====================================

echo [%DATE% %TIME%] 5G SA Latency - STOP APP started. > "%LOGFILE%"

REM ----- STOP SERVICES -----
if not "%SVC1%"=="" (
  echo [%DATE% %TIME%] Stopping service %SVC1%... >> "%LOGFILE%"
  net stop "%SVC1%" /y >> "%LOGFILE%" 2>&1
)
if not "%SVC2%"=="" (
  echo [%DATE% %TIME%] Stopping service %SVC2%... >> "%LOGFILE%"
  net stop "%SVC2%" /y >> "%LOGFILE%" 2>&1
)

REM ----- KILL PROCESSES -----
if not "%PROC1%"=="" (
  echo [%DATE% %TIME%] Killing process %PROC1%... >> "%LOGFILE%"
  taskkill /IM "%PROC1%" /F >nul 2>&1
)

if not "%PROC2%"=="" (
  echo [%DATE% %TIME%] Killing process %PROC2%... >> "%LOGFILE%"
  taskkill /IM "%PROC2%" /F >nul 2>&1
)

echo [%DATE% %TIME%] 5G SA Latency - STOP APP finished. >> "%LOGFILE%"
echo Done.
exit /b 0
