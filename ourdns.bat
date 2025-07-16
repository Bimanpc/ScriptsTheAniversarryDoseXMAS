@echo off
title Simple DNS Viewer App
color 0A

:menu
cls
echo =======================================
echo       SIMPLE DNS VIEWER APP
echo =======================================
echo.
set /p domain=Enter domain name (e.g. google.com): 
if "%domain%"=="" goto menu

:options
cls
echo =======================================
echo     DNS Lookup for: %domain%
echo =======================================
echo 1. A Record (IPv4 Address)
echo 2. AAAA Record (IPv6 Address)
echo 3. MX Record (Mail Exchange)
echo 4. NS Record (Name Servers)
echo 5. CNAME Record (Canonical Name)
echo 6. ALL (Basic Full Lookup)
echo 7. Enter another domain
echo 0. Exit
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto ARecord
if "%choice%"=="2" goto AAAARecord
if "%choice%"=="3" goto MXRecord
if "%choice%"=="4" goto NSRecord
if "%choice%"=="5" goto CNAMERecord
if "%choice%"=="6" goto AllRecords
if "%choice%"=="7" goto menu
if "%choice%"=="0" exit

goto options

:ARecord
cls
echo [A Record - IPv4]
nslookup -type=A %domain%
pause
goto options

:AAAARecord
cls
echo [AAAA Record - IPv6]
nslookup -type=AAAA %domain%
pause
goto options

:MXRecord
cls
echo [MX Record - Mail Exchange]
nslookup -type=MX %domain%
pause
goto options

:NSRecord
cls
echo [NS Record - Name Servers]
nslookup -type=NS %domain%
pause
goto options

:CNAMERecord
cls
echo [CNAME Record - Canonical Name]
nslookup -type=CNAME %domain%
pause
goto options

:AllRecords
cls
echo [ALL - Basic Full DNS Lookup]
nslookup %domain%
pause
goto options
