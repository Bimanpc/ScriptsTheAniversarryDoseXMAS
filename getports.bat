@ECHO OFF
REM * GetPorts, Version 2022


REM * "Initialize" variables used
FOR %%A IN (1 2 3 4) DO SET COM%%A=
FOR %%A IN (1 2 3) DO SET LPT%%A=

REM * Create DEBUG script and use it to read port addresses
ECHO D 40:0 L E> GETPORTS.SCR
ECHO Q>> GETPORTS.SCR
DEBUG < GETPORTS.SCR | FIND "40:0" | FIND /V "-D " > GETPORTS.DAT

REM * All code following is used to parse the string
REM * that DEBUG returned into readable information

REM * NT only
VER | FIND "Windows NT" > NUL
IF ERRORLEVEL 1 GOTO DOS
FOR /F "TOKENS=2-16* DELIMS=- " %%A IN (GETPORTS.DAT) DO (
	SET COM1=%%B%%A
	SET COM2=%%D%%C
	SET COM3=%%F%%E
	SET COM4=%%H%%G
	SET LPT1=%%J%%I
	SET LPT2=%%L%%K
	SET LPT3=%%N%%M
)
GOTO DisplayAll

:DOS
REM * Use DATE to store the string in several variables, as
ECHO.>> GETPORTS.DAT
TYPE GETPORTS.DAT | DATE | FIND "40:0" > GETPORT$.BAT

REM * Different DOS versions and languages
REM * need different temporary batch files
VER | DATE | FIND /I "VOER" > NUL
IF NOT ERRORLEVEL 1 SET ENTER=VOER
VER | DATE | FIND /I "TYP" > NUL
IF NOT ERRORLEVEL 1 SET ENTER=TYP
VER | DATE | FIND /I "CURRENT" > NUL
IF NOT ERRORLEVEL 1 SET ENTER=ENTER
GOTO Make%ENTER%

:MakeENTER
REM * English DOS version
ECHO @ECHO OFF> %ENTER%.BAT
ECHO IF "%%1"=="Loop2" GOTO Loop2>> %ENTER%.BAT
ECHO FOR %%%%A IN (1 2 3 4 5) DO SHIFT>> %ENTER%.BAT
GOTO MakeAll

:MakeAll
REM * Common to all DOS versions
ECHO SET COM1=%%2%%1>> %ENTER%.BAT
ECHO SET COM2=%%4%%3>> %ENTER%.BAT
ECHO SET COM3=%%6%%5>> %ENTER%.BAT
ECHO SET COM4=%%7>> %ENTER%.BAT

REM * Get rid of the hyphen connecting two
REM * parameters, using Outsider's CHOICE trick
ECHO SET Loop2=>> %ENTER%.BAT
ECHO EXIT|%COMSPEC%/KPROMPT $_ECHO ]$BCHOICE/C:[;%%8;] %ENTER%.BAT Loop2 ;$G%ENTER%$$.BAT$_|FIND "Loop2">>%ENTER%.BAT

ECHO CALL %ENTER%$.BAT>> %ENTER%.BAT
ECHO FOR %%%%A IN (1 2 3 4 5 6 7) DO SHIFT>> %ENTER%.BAT
ECHO SET LPT1=%%2%%Loop2%%>> %ENTER%.BAT
ECHO SET LPT2=%%4%%3>> %ENTER%.BAT
ECHO SET LPT3=%%6%%5>> %ENTER%.BAT
ECHO GOTO End>> %ENTER%.BAT

REM * Part two of Outsider's CHOICE trick
ECHO :Loop2>> %ENTER%.BAT
ECHO IF "%%2"=="-" SET COM4=%%Loop2%%%%COM4%%>> %ENTER%.BAT
ECHO IF "%%2"=="-" SET Loop2=>> %ENTER%.BAT
ECHO IF "%%2"=="0" SET Loop2=%%Loop2%%0>> %ENTER%.BAT
ECHO IF "%%2"=="1" SET Loop2=%%Loop2%%1>> %ENTER%.BAT
ECHO IF "%%2"=="2" SET Loop2=%%Loop2%%2>> %ENTER%.BAT
ECHO IF "%%2"=="3" SET Loop2=%%Loop2%%3>> %ENTER%.BAT
ECHO IF "%%2"=="4" SET Loop2=%%Loop2%%4>> %ENTER%.BAT
ECHO IF "%%2"=="5" SET Loop2=%%Loop2%%5>> %ENTER%.BAT
ECHO IF "%%2"=="6" SET Loop2=%%Loop2%%6>> %ENTER%.BAT
ECHO IF "%%2"=="7" SET Loop2=%%Loop2%%7>> %ENTER%.BAT
ECHO IF "%%2"=="8" SET Loop2=%%Loop2%%8>> %ENTER%.BAT
ECHO IF "%%2"=="9" SET Loop2=%%Loop2%%9>> %ENTER%.BAT
ECHO IF "%%2"=="A" SET Loop2=%%Loop2%%A>> %ENTER%.BAT
ECHO IF "%%2"=="B" SET Loop2=%%Loop2%%B>> %ENTER%.BAT
ECHO IF "%%2"=="C" SET Loop2=%%Loop2%%C>> %ENTER%.BAT
ECHO IF "%%2"=="D" SET Loop2=%%Loop2%%D>> %ENTER%.BAT
ECHO IF "%%2"=="E" SET Loop2=%%Loop2%%E>> %ENTER%.BAT
ECHO IF "%%2"=="F" SET Loop2=%%Loop2%%F>> %ENTER%.BAT
ECHO SHIFT>> %ENTER%.BAT
ECHO IF NOT "%%2"=="" GOTO Loop2>> %ENTER%.BAT
ECHO :End>> %ENTER%.BAT

REM * Finally, let's USE all those batch files we just created
CALL GETPORT$.BAT

:DisplayAll
REM * Display the results (no FOR loop possible because of Win98)
ECHO.
ECHO COM1=%COM1%
ECHO COM2=%COM2%
ECHO COM3=%COM3%
ECHO COM4=%COM4%
ECHO LPT1=%LPT1%
ECHO LPT2=%LPT2%
ECHO LPT3=%LPT3%
ECHO.

REM * Clean up the mess
FOR %%A IN (%ENTER% %ENTER%$ GETPORT$) DO IF EXIST %%A.BAT DEL %%A.BAT
FOR %%A IN (DAT SCR) DO IF EXIST GETPORTS.%%A DEL GETPORTS.%%A
SET Loop2=

:End