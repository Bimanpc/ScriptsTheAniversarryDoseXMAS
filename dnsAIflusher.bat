@echo off
setlocal enabledelayedexpansion
title AI/LLM App - DNS & Network Cache Flusher

:: =========================
:: Admin check & elevation
:: =========================
>nul 2>&1 net session
if %errorlevel% neq 0 (
    echo [!] Admin required. Elevating...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: =========================
:: Config
:: =========================
set "LOG=%~dp0dns_flush_log.txt"
set "TS="
for /f "tokens=1-3 delims=/ " %%a in ("%date%") do set "DATE=%date%"
for /f "tokens=1-2 delims=:." %%a in ("%time%") do set "TIME=%%a:%%b"
set "TS=%DATE% %TIME%"

:: =========================
:: Helpers
:: =========================
:log
>>"%LOG%" echo [%TS%] %*
echo %*
goto :eof

:banner
cls
echo =====================================================
echo   AI/LLM App - DNS & Network Cache Flusher (Admin)
echo =====================================================
echo Log: %LOG%
echo.
goto :eof

:: =========================
:: Menu (if no args)
:: =========================
if "%~1"=="" (
    call :banner
    echo Choose an action:
    echo   1) Flush DNS cache (ipconfig /flushdns)
    echo   2) Reset Winsock (netsh winsock reset)
    echo   3) Reset IPv4/IPv6 TCP stack (netsh int ip reset)
    echo   4) Restart DNS Client service (Dnscache)
    echo   5) Clear ARP cache (arp -d *)
    echo   6) Quick full clean (1+2+3)
    echo   0) Exit
    echo.
    set /p "CHOICE=Enter selection: "
    if "%CHOICE%"=="1" goto :flushdns
    if "%CHOICE%"=="2" goto :winsock
    if "%CHOICE%"=="3" goto :tcpreset
    if "%CHOICE%"=="4" goto :dnscache_restart
    if "%CHOICE%"=="5" goto :clear_arp
    if "%CHOICE%"=="6" goto :fullclean
    goto :end
)

:: =========================
:: CLI arguments
:: =========================
:: Usage examples:
::   script.bat /flush
::   script.bat /winsock
::   script.bat /tcpreset
::   script.bat /dnscache
::   script.bat /arp
::   script.bat /full

if /i "%~1"=="/flush"    goto :flushdns
if /i "%~1"=="/winsock"  goto :winsock
if /i "%~1"=="/tcpreset" goto :tcpreset
if /i "%~1"=="/dnscache" goto :dnscache_restart
if /i "%~1"=="/arp"      goto :clear_arp
if /i "%~1"=="/full"     goto :fullclean
goto :end

:: =========================
:: Actions
:: =========================
:flushdns
call :banner
call :log Starting DNS flush...
ipconfig /displaydns >nul 2>&1
if %errorlevel% neq 0 (
    call :log [i] DNS display not available (service may be off). Proceeding.
)
ipconfig /flushdns
if %errorlevel% equ 0 (
    call :log [ok] DNS cache flushed.
) else (
    call :log [x] Failed to flush DNS.
)
echo.
pause
goto :end

:winsock
call :banner
call :log Resetting Winsock...
netsh winsock reset
if %errorlevel% equ 0 (
    call :log [ok] Winsock reset queued. A reboot is recommended.
) else (
    call :log [x] Winsock reset failed.
)
echo.
pause
goto :end

:tcpreset
call :banner
call :log Resetting TCP/IP stack (IPv4/IPv6)...
netsh int ip reset "%TEMP%\netsh-ip-reset.log"
netsh int ipv6 reset
if %errorlevel% equ 0 (
    call :log [ok] TCP/IP reset completed. A reboot may be required.
) else (
    call :log [x] TCP/IP reset encountered errors.
)
echo.
pause
goto :end

:dnscache_restart
call :banner
call :log Restarting DNS Client (Dnscache) service...
sc query Dnscache >nul 2>&1
if %errorlevel% neq 0 (
    call :log [i] DNS Client service not found or unavailable on this build.
    goto :dnscache_done
)
net stop Dnscache
net start Dnscache
if %errorlevel% equ 0 (
    call :log [ok] Dnscache service restarted.
) else (
    call :log [x] Failed to restart Dnscache.
)
:dnscache_done
echo.
pause
goto :end

:clear_arp
call :banner
call :log Clearing ARP cache...
arp -d *
if %errorlevel% equ 0 (
    call :log [ok] ARP cache cleared.
) else (
    call :log [x] Failed to clear ARP cache.
)
echo.
pause
goto :end

:fullclean
call :banner
call :log Running quick full clean: DNS flush + Winsock + TCP/IP reset...
call :flushdns_nopause
call :winsock_nopause
call :tcpreset_nopause
call :log [ok] Full clean completed. Reboot recommended.
echo.
pause
goto :end

:: =========================
:: No-pause variants
:: =========================
:flushdns_nopause
ipconfig /flushdns >nul 2>&1
goto :eof

:winsock_nopause
netsh winsock reset >nul 2>&1
goto :eof

:tcpreset_nopause
netsh int ip reset "%TEMP%\netsh-ip-reset.log" >nul 2>&1
netsh int ipv6 reset >nul 2>&1
goto :eof

:: =========================
:: Exit
:: =========================
:end
call :log Done.
endlocal
exit /b
