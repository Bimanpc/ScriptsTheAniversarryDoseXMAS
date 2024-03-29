@ECHO OFF
ECHO.
ECHO Display BIOS date
ECHO.
ECHO Usage:  %0
ECHO.
ECHO BillYS PS

:: Check if running in true DOS mode
ECHO.%COMSPEC%| FIND /I "COMMAND.COM" >NUL
IF ERRORLEVEL 1 GOTO Error

:: Create temporary DEBUG script to read BIOS date
>  BIOSDATE.DBG ECHO D FFFF:0005 L 8
>> BIOSDATE.DBG ECHO Q

:: Create temporary batch file to display 8th "word" in a line
>  FFFF.BAT ECHO @ECHO OFF
>> FFFF.BAT ECHO SET BIOSDATE=%%8

:: Read BIOS date and store in temporary batch file
ECHO @ECHO OFF> BIOSTEMP.BAT
DEBUG < BIOSDATE.DBG | FIND "/" >> BIOSTEMP.BAT

:: Use temporary batch files to parse output from DEBUG script
CALL BIOSTEMP.BAT

:: Display the result
ECHO.
ECHO BIOS date: %BIOSDATE%

:: Remove temporary files
DEL BIOSTEMP.BAT
DEL BIOSDATE.DBG
DEL FFFF.BAT
GOTO End

:Error
ECHO ERROR: This batch file is meant for DOS !
ECHO.

:End