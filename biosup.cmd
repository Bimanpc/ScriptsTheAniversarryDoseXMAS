@echo off
setlocal enabledelayedexpansion

rem ==============================================
rem BIOS info dump (WMIC, fallback to PowerShell)
rem Saves to BIOS_Info_<HOSTNAME>_<YYYYMMDD_HHMMSS>.txt
rem ==============================================

set "TS=%DATE:~-4%%DATE:~3,2%%DATE:~0,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%"
set "TS=%TS: =0%"
set "OUT=BIOS_Info_%COMPUTERNAME%_%TS%.txt"

echo Collecting BIOS info... > "%OUT%"
echo. >> "%OUT%"

rem ---------- Try WMIC ----------
where wmic >nul 2>&1
if %errorlevel%==0 (
    echo [Source: WMIC] >> "%OUT%"
    echo --- Win32_BIOS --- >> "%OUT%"
    wmic bios get Name,Manufacturer,SMBIOSBIOSVersion,Version,SerialNumber,ReleaseDate /format:list >> "%OUT%"
    echo. >> "%OUT%"

    echo --- Win32_BaseBoard (Motherboard) --- >> "%OUT%"
    wmic baseboard get Product,Manufacturer,Version,SerialNumber /format:list >> "%OUT%"
    echo. >> "%OUT%"

    echo --- Win32_ComputerSystem --- >> "%OUT%"
    wmic computersystem get Model,Manufacturer,SystemFamily /format:list >> "%OUT%"
    echo. >> "%OUT%"

    echo --- Win32_Processor --- >> "%OUT%"
    wmic cpu get Name,Manufacturer,ProcessorId /format:list >> "%OUT%"
    echo. >> "%OUT%"

    echo --- Win32_BIOS Flags --- >> "%OUT%"
    wmic path Win32_BIOS get BIOSVersion,PrimaryBIOS /format:list >> "%OUT%"
    goto :done
)

rem ---------- Fallback to PowerShell (CIM/WMI2) ----------
where powershell >nul 2>&1
if %errorlevel%==0 (
    echo [Source: PowerShell CIM] >> "%OUT%"
    powershell -NoProfile -ExecutionPolicy Bypass ^
        "Set-StrictMode -Version Latest; \
        $o = New-Object System.Text.StringBuilder; \
        $fmt = { param($t) $o.AppendLine(('--- ' + $t + ' ---')) | Out-Null }; \
        $append = { param($x) $o.AppendLine($x) | Out-Null }; \
        $bios = Get-CimInstance Win32_BIOS; \
        & $fmt 'Win32_BIOS'; \
        & $append ('Name=' + $bios.Name); \
        & $append ('Manufacturer=' + $bios.Manufacturer); \
        & $append ('SMBIOSBIOSVersion=' + $bios.SMBIOSBIOSVersion); \
        & $append ('Version=' + $bios.Version); \
        & $append ('SerialNumber=' + $bios.SerialNumber); \
        & $append ('ReleaseDate=' + ($bios.ReleaseDate)); \
        $bb = Get-CimInstance Win32_BaseBoard; \
        & $fmt 'Win32_BaseBoard'; \
        & $append ('Product=' + $bb.Product); \
        & $append ('Manufacturer=' + $bb.Manufacturer); \
        & $append ('Version=' + $bb.Version); \
        & $append ('SerialNumber=' + $bb.SerialNumber); \
        $cs = Get-CimInstance Win32_ComputerSystem; \
        & $fmt 'Win32_ComputerSystem'; \
        & $append ('Model=' + $cs.Model); \
        & $append ('Manufacturer=' + $cs.Manufacturer); \
        & $append ('SystemFamily=' + $cs.SystemFamily); \
        $cpu = Get-CimInstance Win32_Processor; \
        & $fmt 'Win32_Processor'; \
        & $append ('Name=' + $cpu.Name); \
        & $append ('Manufacturer=' + $cpu.Manufacturer); \
        & $append ('ProcessorId=' + $cpu.ProcessorId); \
        $bios2 = Get-CimInstance Win32_BIOS; \
        & $fmt 'Win32_BIOS Flags'; \
        & $append ('BIOSVersion=' + ($bios2.BIOSVersion -join ';')); \
        & $append ('PrimaryBIOS=' + $bios2.PrimaryBIOS); \
        $o.ToString()" >> "%OUT%"
    goto :done
)

echo Could not find WMIC or PowerShell. Please run on a standard Windows host. >> "%OUT%"

:done
echo Output saved to "%OUT%"
endlocal
