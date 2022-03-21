@ECHO OFF
IF NOT "%~2"=="" GOTO Syntax
IF NOT "%~1"=="" IF /I NOT "%~1"=="/R" GOTO Syntax
:: Version 6.1.* for Windows 7, 6.2.* for Windows 8
:: VER | FINDSTR.EXE /R /C:" 6\.[12]\." >NUL || GOTO Syntax
VER | FIND.EXE " 6.1." >NUL || GOTO Syntax

SETLOCAL

:: Enable or Disable the scheduled tasks, depending on optional command line switch /R
IF /I "%~1"=="/R" (
    SET Action=Enable
) ELSE (
    SET Action=Disable
)

ECHO.
ECHO.========
ECHO AitAgent
ECHO.========
ECHO.
CALL :ModifyTask "AitAgent"
ECHO.
ECHO.=================================________________________________________________
ECHO Microsoft Compatibility Appraiser OPA
ECHO.=================================________________________________________________
ECHO.
CALL :ModifyTask "Microsoft Compatibility Appraiser"
ECHO.
ECHO.==================
ECHO ProgramDataUpdater
ECHO.==================
ECHO.
CALL :ModifyTask "ProgramDataUpdater"
ECHO.

ENDLOCAL
GOTO:EOF


:ModifyTask
:: Test current "before" status
ECHO Before:
ECHO.-------
SCHTASKS.EXE /Query  /TN "Microsoft\Windows\Application Experience\%~1"
SET Test=
:: Variable "Test" will be set to "Disabled" ONLY if the scheduled task is already disabled AND the requested action is disabling the tasks
IF "%Action%"=="Disable" (
    FOR /F "tokens=*" %%A IN ('SCHTASKS.EXE /Query  /TN "Microsoft\Windows\Application Experience\%~1"') DO (
        FOR %%B IN (%%A) DO (
            SET Test=%%B
        )
    )
)
:: If task is already disabled, do not try to disable it again
IF "%Test%"=="Disabled" (
	ECHO.
	ECHO Scheduled task "Microsoft\Windows\Application Experience\%~1" has already been disabled.
) ELSE (
	ECHO.
	ECHO Changing:
	ECHO.---------
	SCHTASKS.EXE /Change /TN "Microsoft\Windows\Application Experience\%~1" /%Action%
	ECHO.
	ECHO After:
	ECHO.------
	SCHTASKS.EXE /Query  /TN "Microsoft\Windows\Application Experience\%~1"
)
GOTO:EOF


:Syntax
ECHO.
:: ECHO DisableCompatTelRunner.bat,  Version 1.00 for Windows 7 or 8
ECHO DisableCompatTelRunner.bat,  Version 1.00 for Windows 7
ECHO Disable scheduled Application Experience tasks to speed up Windows startup
ECHO.
ECHO Usage:  DisableCompatTelRunner  [ /R ]
ECHO.
ECHO Where:  /R  will Reenable the scheduled tasks
ECHO.
:: ECHO Notes:  This script disables/reenables CompatTelRunner.exe on Windows 7 or 8.
ECHO Notes:  This batch file disables or reenables CompatTelRunner.exe on Windows 7.
ECHO         Run it without any command line argument to disable the scheduled tasks
ECHO         AitAgent, Microsoft Compatibility Appraiser, and ProgramDataUpdater,
ECHO         all located in "Microsoft\Windows\Application Experience"; or run it
ECHO         again with the /R switch to reenable the tasks.
ECHO.
ECHO         Performance improved tremendously on the computers I tested this on:
ECHO         before I disabled the tasks, the computers would be unusable for
ECHO         about 20 minutes after logging in, regularly freezing; now I can
ECHO         start using them right away.
ECHO.
ECHO         RUNNING THIS BATCH FILE MAY NEGATIVELY AFFECT SYSTEM PERFORMANCE
ECHO         OR FUTURE WINDOWS UPGRADES. MAKE SURE YOU HAVE A VALIDATED BACKUP
ECHO         AVAILABLE BEFORE RUNNING THIS BATCH FILE.
ECHO         USE THIS BATCH FILE ENTIRELY AT YOUR OWN RISK.
ECHO.
EXIT /B 1