@echo off
setlocal enableextensions
title WLAN Optimizer - Admin-safe CMD

:: --- Require Administrator ---
whoami /groups | findstr /i "S-1-5-32-544" >nul
if errorlevel 1 (
  echo [!] Please run this script as Administrator.
  pause
  exit /b 1
)

:: --- Logging ---
set LOG=%~dp0wlan_optimizer.log
echo ==== WLAN Optimizer run at %date% %time% ====>> "%LOG%"

:: --- Confirm ---
echo This will:
echo  - Flush DNS and reset Winsock/IP
echo  - Set Wi-Fi adapter power to Maximum Performance (AC/DC)
echo  - Apply TCP stack tweaks for latency
echo  - Create rollback for TCP settings
echo.
choice /m "Proceed?" /c YN /n
if errorlevel 2 exit /b 0

:: --- Show Wi-Fi interfaces (informational) ---
echo.
echo [Info] Current WLAN interfaces:
netsh wlan show interfaces | tee.exe /a "%LOG%" 2>nul
echo.

:: --- TCP rollback capture ---
for /f "tokens=2 delims=:" %%A in ('netsh interface tcp show global ^| findstr /i "TCP Global Parameters"') do (rem noop)
netsh interface tcp show global > "%~dp0tcp_global_before.txt"
echo [Rollback] Saved current TCP globals to tcp_global_before.txt>> "%LOG%"

:: --- Flush DNS + reset stacks ---
echo [Step] Refreshing DNS and IP/Winsock...
ipconfig /flushdns   >> "%LOG%" 2>&1
netsh winsock reset  >> "%LOG%" 2>&1
netsh int ip reset "%~dp0ip_reset.log" >> "%LOG%" 2>&1
echo Done. A reboot is recommended after optimizations.>> "%LOG%"

:: --- Power plan: set Wi-Fi to Maximum Performance on AC/DC ---
echo [Step] Boosting Wi-Fi power policy (AC/DC) to Maximum Performance...
for /f "tokens=2 delims=:" %%S in ('powercfg /getactivescheme ^| findstr /i "Power Scheme GUID"') do set ACTIVE_SCHEME=%%S
set ACTIVE_SCHEME=%ACTIVE_SCHEME: =%
:: Subgroup: Wireless Adapter Settings (8ec4f0a5-3bbf-4a80-a7a9-1a0cbb8833c5)
:: Setting: Energy Saving Mode (12bbebe6-58d6-4636-95bb-3217ef867c1a)
powercfg -setacvalueindex %ACTIVE_SCHEME% 8ec4f0a5-3bbf-4a80-a7a9-1a0cbb8833c5 12bbebe6-58d6-4636-95bb-3217ef867c1a 0 >> "%LOG%" 2>&1
powercfg -setdcvalueindex %ACTIVE_SCHEME% 8ec4f0a5-3bbf-4a80-a7a9-1a0cbb8833c5 12bbebe6-58d6-4636-95bb-3217ef867c1a 0 >> "%LOG%" 2>&1
powercfg -S %ACTIVE_SCHEME% >> "%LOG%" 2>&1
echo Wi-Fi adapter power set to Maximum Performance.>> "%LOG%"

:: --- TCP low-latency tweaks (safe defaults) ---
echo [Step] Applying TCP global settings optimized for consistency...
netsh interface tcp set global autotuninglevel=highlyrestricted   >> "%LOG%" 2>&1
netsh interface tcp set global ecncapability=disabled             >> "%LOG%" 2>&1
netsh interface tcp set global rss=enabled                        >> "%LOG%" 2>&1
netsh interface tcp set global dca=disabled                       >> "%LOG%" 2>&1
netsh interface tcp set global chimney=disabled                   >> "%LOG%" 2>&1
netsh interface tcp set global rsc=disabled                       >> "%LOG%" 2>&1
netsh interface tcp set global timestamps=disabled                >> "%LOG%" 2>&1
netsh interface tcp set global pacingprofile=lowlatency           >> "%LOG%" 2>&1

:: --- Optional: show result summary ---
echo.
echo [Summary] TCP globals after changes:
netsh interface tcp show global | tee.exe /a "%LOG%" 2>nul

:: --- WLAN AutoConfig quick restart (optional to clear scans) ---
echo.
echo [Step] Briefly restarting WLAN AutoConfig service...
sc stop WlanSvc >nul 2>&1
timeout /t 3 >nul
sc start WlanSvc >nul 2>&1
echo WLAN service restarted.>> "%LOG%"

echo.
echo [Done] Optimizations complete. Please reboot for full effect.
echo A rollback script is generated below.

:: --- Generate rollback script ---
(
echo @echo off
echo echo Rolling back TCP globals to previous state...
echo netsh interface tcp set global autotuninglevel=normal
echo netsh interface tcp set global ecncapability=default
echo netsh interface tcp set global rss=default
echo netsh interface tcp set global dca=default
echo netsh interface tcp set global chimney=default
echo netsh interface tcp set global rsc=default
echo netsh interface tcp set global timestamps=default
echo netsh interface tcp set global pacingprofile=default
echo echo Restoring Wi-Fi power policy to Balanced (1 = Low Power Saving)
echo for /f "tokens^=2 delims^=:" %%%%S in ^('powercfg /getactivescheme ^| findstr /i "Power Scheme GUID"^)^ do set ACTIVE_SCHEME=%%%%S
echo set ACTIVE_SCHEME=%%ACTIVE_SCHEME: =%%
echo powercfg -setacvalueindex %%ACTIVE_SCHEME%% 8ec4f0a5-3bbf-4a80-a7a9-1a0cbb8833c5 12bbebe6-58d6-4636-95bb-3217ef867c1a 1
echo powercfg -setdcvalueindex %%ACTIVE_SCHEME%% 8ec4f0a5-3bbf-4a80-a7a9-1a0cbb8833c5 12bbebe6-58d6-4636-95bb-3217ef867c1a 1
echo powercfg -S %%ACTIVE_SCHEME%%
echo echo Rollback complete. Consider rebooting.
) > "%~dp0rollback_wlan_optimizer.cmd"

echo Rollback script created: "%~dp0rollback_wlan_optimizer.cmd"
echo Logs: "%LOG%"
echo.
pause

endlocal
