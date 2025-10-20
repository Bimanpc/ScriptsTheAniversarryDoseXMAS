@echo off
setlocal EnableDelayedExpansion
title CPU Info Applet

:: Usage: cpuinfo.cmd [--watch] [--json]
:: - --watch : live refresh every 2s
:: - --json  : print JSON instead of human-readable

:: Detect WMIC availability (older Windows) and fallback to PowerShell
where wmic >nul 2>&1 && set "WMIC_OK=1" || set "WMIC_OK="

:: Collect CPU info using WMIC or PowerShell
call :Collect
if /i "%~1"=="--json" ( call :PrintJSON & goto :done )
call :PrintHuman

if /i "%~1"=="--watch" (
  echo(
  echo Press Ctrl+C to stop watching...
  :watch
  >nul timeout /t 2
  cls
  title CPU Info Applet [watching]
  call :Collect
  if /i "%~2"=="--json" ( call :PrintJSON ) else ( call :PrintHuman )
  goto :watch
)

:done
endlocal
exit /b 0

:: --------------------------
:Collect
set "CPU_Name="
set "CPU_Manufacturer="
set "CPU_SocketCount=0"
set "CPU_Cores=0"
set "CPU_Logical=0"
set "CPU_MaxMHz="
set "CPU_L2KB="
set "CPU_L3KB="
set "CPU_Arch="
set "CPU_Virtualization="
set "CPU_HyperThreading="

if defined WMIC_OK (
  for /f "skip=1 tokens=*" %%A in ('wmic cpu get Name ^| findstr /r /v "^$"') do if not defined CPU_Name set "CPU_Name=%%~A"
  for /f "skip=1 tokens=*" %%A in ('wmic cpu get Manufacturer ^| findstr /r /v "^$"') do if not defined CPU_Manufacturer set "CPU_Manufacturer=%%~A"
  for /f "skip=1 tokens=*" %%A in ('wmic cpu get NumberOfCores ^| findstr /r /v "^$"') do set /a CPU_Cores+=%%~A
  for /f "skip=1 tokens=*" %%A in ('wmic cpu get NumberOfLogicalProcessors ^| findstr /r /v "^$"') do set /a CPU_Logical+=%%~A
  for /f "skip=1 tokens=*" %%A in ('wmic cpu get MaxClockSpeed ^| findstr /r /v "^$"') do if not defined CPU_MaxMHz set "CPU_MaxMHz=%%~A"
  for /f "skip=1 tokens=*" %%A in ('wmic cpu get L2CacheSize ^| findstr /r /v "^$"') do if not defined CPU_L2KB set "CPU_L2KB=%%~A"
  for /f "skip=1 tokens=*" %%A in ('wmic cpu get L3CacheSize ^| findstr /r /v "^$"') do if not defined CPU_L3KB set "CPU_L3KB=%%~A"
  for /f "skip=1 tokens=*" %%A in ('wmic cpu get SocketDesignation ^| findstr /r /v "^$"') do set /a CPU_SocketCount+=1
  for /f "skip=1 tokens=2 delims==" %%A in ('wmic computersystem get HypervisorPresent /value ^| find "HypervisorPresent"') do set "CPU_Virtualization=%%~A"
) else (
  for /f "usebackq tokens=*" %%A in (`powershell -NoProfile -Command ^
    "$p=Get-CimInstance Win32_Processor; $cs=Get-CimInstance Win32_ComputerSystem; ^
     $name=$p[0].Name; $man=$p[0].Manufacturer; ^
     $cores=($p|Measure-Object NumberOfCores -Sum).Sum; ^
     $logical=($p|Measure-Object NumberOfLogicalProcessors -Sum).Sum; ^
     $max=$p[0].MaxClockSpeed; $l2=$p[0].L2CacheSize; $l3=$p[0].L3CacheSize; ^
     $sockets=$p.Count; $virt=$cs.HypervisorPresent; ^
     $arch=[Environment]::Is64BitOperatingSystem ? 'x64' : 'x86'; ^
     $ht=($logical -gt $cores); ^
     'Name='+$name,'Manufacturer='+$man,'Cores='+$cores,'Logical='+$logical,'MaxMHz='+$max,'L2KB='+$l2,'L3KB='+$l3,'Sockets='+$sockets,'Virtualization='+$virt,'Arch='+$arch,'HT='+$ht"`) do (
    for /f "tokens=1,2 delims==" %%K in ("%%A") do set "KV=%%K" & set "VV=%%L" & call :Assign
  )
)

:: Derive architecture on WMIC path (best-effort)
if defined WMIC_OK (
  set "CPU_Arch=x64"
  if "%PROCESSOR_ARCHITECTURE%"=="x86" set "CPU_Arch=x86"
)

:: Derive HT best-effort
set "CPU_HyperThreading=Unknown"
if defined CPU_Cores if defined CPU_Logical (
  set "CPU_HyperThreading=Disabled"
  if %CPU_Logical% GTR %CPU_Cores% set "CPU_HyperThreading=Enabled"
)

:: Normalize virtualization flag
if /i "%CPU_Virtualization%"=="TRUE" set "CPU_Virtualization=Present"
if /i "%CPU_Virtualization%"=="FALSE" set "CPU_Virtualization=Not present"
if not defined CPU_Virtualization set "CPU_Virtualization=Unknown"

exit /b 0

:Assign
if /i "%KV%"=="Name" set "CPU_Name=%VV%"
if /i "%KV%"=="Manufacturer" set "CPU_Manufacturer=%VV%"
if /i "%KV%"=="Cores" set "CPU_Cores=%VV%"
if /i "%KV%"=="Logical" set "CPU_Logical=%VV%"
if /i "%KV%"=="MaxMHz" set "CPU_MaxMHz=%VV%"
if /i "%KV%"=="L2KB" set "CPU_L2KB=%VV%"
if /i "%KV%"=="L3KB" set "CPU_L3KB=%VV%"
if /i "%KV%"=="Sockets" set "CPU_SocketCount=%VV%"
if /i "%KV%"=="Virtualization" set "CPU_Virtualization=%VV%"
if /i "%KV%"=="Arch" set "CPU_Arch=%VV%"
if /i "%KV%"=="HT" (
  if /i "%VV%"=="True" (set "CPU_HyperThreading=Enabled") else (set "CPU_HyperThreading=Disabled")
)
exit /b 0

:: --------------------------
:PrintHuman
echo ------------------------------------------
echo CPU summary
echo ------------------------------------------
echo Name:              %CPU_Name%
echo Manufacturer:      %CPU_Manufacturer%
echo Architecture:      %CPU_Arch%
echo Sockets:           %CPU_SocketCount%
echo Cores (total):     %CPU_Cores%
echo Logical processors: %CPU_Logical%
echo Max clock:         %CPU_MaxMHz% MHz
echo L2 cache:          %CPU_L2KB% KB
echo L3 cache:          %CPU_L3KB% KB
echo Hyper-Threading:   %CPU_HyperThreading%
echo Hypervisor:        %CPU_Virtualization%
exit /b 0

:PrintJSON
set "q="
for /f "tokens=1-2 delims==" %%A in ('set CPU_') do (
  set "k=%%A"
  set "v=%%B"
  set "v=!v:\=\\!"
  set "v=!v:"=\"!"
  set "v=!v:^=^^!"
  set "v=!v:!=^!!"
  set "v=!v:&=^&!"
  set "v=!v:|=^|!"
  set "v=!v:<=^<!"
  set "v=!v:>=^>!"
  set "v=!v:;=^;!"
  set "v=!v:,=\,!"
  if not defined q ( set "q={ " ) else ( set "q=!q!, " )
  set "q=!q!\"!k:~4!\": \"!v!\""
)
set "q=!q! }"
echo !q!
exit /b 0
