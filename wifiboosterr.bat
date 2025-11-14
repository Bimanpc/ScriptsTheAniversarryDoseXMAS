@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: WiFi Boost - Minimal, admin-aware, reversible optimizations
:: Run as Administrator. Creates logs and backups in %TEMP%\wifi-boost

set "WB_DIR=%TEMP%\wifi-boost"
set "WB_LOG=%WB_DIR%\wifi-boost.log"
set "WB_BAK=%WB_DIR%\backup"
if not exist "%WB_DIR%" mkdir "%WB_DIR%"
if not exist "%WB_BAK%" mkdir "%WB_BAK%"

:: Detect primary Wi-Fi adapter name (best-effort)
for /f "tokens=1,* delims=:" %%A in ('wmic nic where "NetEnabled=true AND (Name LIKE '%%Wi-Fi%%' OR Name LIKE '%%Wireless%%')" get Name /value ^| findstr "="') do (
  set "WIFI_ADAPTER=%%B"
)
if not defined WIFI_ADAPTER (
  for /f "tokens=2,* skip=1" %%A in ('netsh wlan show interfaces ^| findstr /i "Name"') do set "WIFI_ADAPTER=%%B"
)
set "WIFI_ADAPTER=%WIFI_ADAPTER:~0,64%"

call :log "Wi-Fi adapter detected: %WIFI_ADAPTER%"

:: Menu
cls
echo ===========================
echo   WiFi Boost Toolkit
echo ===========================
echo 1) Quick Boost (safe defaults)
echo 2) Deep Reset (TCP/IP + Winsock + DNS)
echo 3) Toggle TCP latency opts (on)
echo 4) Toggle TCP latency opts (off / revert)
echo 5) Renew IP + Flush DNS
echo 6) Restart Wi-Fi service (WLAN AutoConfig)
echo 7) Power-cycle Wi-Fi adapter (disable/enable)
echo 8) View log
echo 9) Exit
echo.
set /p "choice=Select option (1-9): "

if "%choice%"=="1" goto quick
if "%choice%"=="2" goto deepreset
if "%choice%"=="3" goto tcp_on
if "%choice%"=="4" goto tcp_off
if "%choice%"=="5" goto renew
if "%choice%"=="6" goto restart_wlan
if "%choice%"=="7" goto powercycle
if "%choice%"=="8" notepad "%WB_LOG" & goto end
goto end

:quick
call :log "--- Quick Boost start ---"
call :flushdns
call :winsock_reset
call :tcp_tune_on
call :restart_wlan
call :renew_ip
call :log "--- Quick Boost done ---"
echo Quick Boost complete.
goto end

:deepreset
call :log "--- Deep Reset start ---"
call :backup_tcp
call :flushdns
call :winsock_reset
call :tcp_reset
call :ip_reset
call :restart_wlan
call :renew_ip
call :log "--- Deep Reset done ---"
echo Deep Reset complete. A reboot may further stabilize the stack.
goto end

:tcp_on
call :log "--- Enable TCP latency opts ---"
call :tcp_tune_on
echo TCP options enabled.
goto end

:tcp_off
call :log "--- Disable TCP latency opts / revert ---"
call :tcp_tune_off
echo TCP options disabled.
goto end

:renew
call :log "--- Renew IP + Flush DNS ---"
call :flushdns
call :renew_ip
echo IP renewed and DNS flushed.
goto end

:restart_wlan
call :log "--- Restart WLAN AutoConfig ---"
net stop WlanSvc /y >> "%WB_LOG" 2>&1
timeout /t 2 >nul
net start WlanSvc >> "%WB_LOG" 2>&1
echo WLAN AutoConfig restarted.
goto end

:powercycle
if not defined WIFI_ADAPTER (
  echo Could not detect Wi-Fi adapter name. Skipping power-cycle.
  call :log "Power-cycle skipped: no adapter detected."
  goto end
)
call :log "--- Power-cycle Wi-Fi adapter ---"
wmic path win32_networkadapter where "NetEnabled=true AND Name like '%%%WIFI_ADAPTER%%%'" call disable >> "%WB_LOG" 2>&1
timeout /t 2 >nul
wmic path win32_networkadapter where "Name like '%%%WIFI_ADAPTER%%%'" call enable >> "%WB_LOG" 2>&1
echo Adapter toggled.
goto end

:: ----------------------
:: Helper routines below
:: ----------------------

:flushdns
ipconfig /flushdns >> "%WB_LOG" 2>&1
call :log "DNS cache flushed."
goto :eof

:winsock_reset
netsh winsock reset >> "%WB_LOG" 2>&1
call :log "Winsock reset."
goto :eof

:tcp_reset
netsh int ip reset "%WB_BAK%\ip-reset.log" >> "%WB_LOG" 2>&1
call :log "IP/TCP parameters reset to defaults."
goto :eof

:ip_reset
netsh interface ip reset >> "%WB_LOG" 2>&1
goto :eof

:backup_tcp
netsh int tcp show global > "%WB_BAK%\tcp-global.txt" 2>&1
netsh int tcp show heuristics > "%WB_BAK%\tcp-heuristics.txt" 2>&1
call :log "Backed up TCP global + heuristics."
goto :eof

:tcp_tune_on
:: Conservative latency-focused toggles (reversible)
netsh int tcp set heuristics disabled >> "%WB_LOG" 2>&1
netsh int tcp set global autotuninglevel=normal >> "%WB_LOG" 2>&1
netsh int tcp set global ecncapability=disabled >> "%WB_LOG" 2>&1
netsh int tcp set global rss=enabled >> "%WB_LOG" 2>&1
netsh int tcp set global dca=disabled >> "%WB_LOG" 2>&1
netsh int tcp set global chimney=disabled >> "%WB_LOG" 2>&1
netsh int tcp set global pacing=enabled >> "%WB_LOG" 2>&1
netsh int tcp set global timestamps=disabled >> "%WB_LOG" 2>&1
call :log "Applied TCP latency options (on)."
goto :eof

:tcp_tune_off
netsh int tcp set heuristics enabled >> "%WB_LOG" 2>&1
netsh int tcp set global autotuninglevel=normal >> "%WB_LOG" 2>&1
netsh int tcp set global ecncapability=default >> "%WB_LOG" 2>&1
netsh int tcp set global rss=enabled >> "%WB_LOG" 2>&1
netsh int tcp set global dca=default >> "%WB_LOG" 2>&1
netsh int tcp set global chimney=default >> "%WB_LOG" 2>&1
netsh int tcp set global pacing=default >> "%WB_LOG" 2>&1
netsh int tcp set global timestamps=default >> "%WB_LOG" 2>&1
call :log "Reverted TCP options to defaults."
goto :eof

:renew_ip
ipconfig /release >> "%WB_LOG" 2>&1
timeout /t 2 >nul
ipconfig /renew >> "%WB_LOG" 2>&1
call :log "IP renewed."
goto :eof

:log
set "ts="
for /f "tokens=1-3 delims=/:. " %%a in ("%date% %time%") do set "ts=%%a-%%b-%%c_%time%"
>> "%WB_LOG" echo [%date% %time%] %*
goto :eof

:end
echo.
echo Log: %WB_LOG%
echo Some changes take effect after a reboot. If speed is still poor, check router channel, 5GHz vs 2.4GHz, and signal quality.
echo.
pause
endlocal
