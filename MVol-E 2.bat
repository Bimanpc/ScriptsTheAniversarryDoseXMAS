@ECHO OFF
CLS
REM  MVol-E 2.0
REM  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
REM
REM  This program remounts any PHYSICAL volume from the
REM  letter E: to the first available letter R:, T:, V: or X:
REM
REM *** Check if volume E is in use ***
SET DRVE=?
FOR %%a IN (E) DO (MOUNTVOL %%a: /L >NUL 2>&1 || SET DRVE=%%a:)
IF "%DRVE%"=="?" GOTO BEGIN
GOTO READY
:BEGIN
REM *** Read actual register DriveKey of volume E ***
SET DKEY=?
FOR /F "delims=" %%x IN ('MOUNTVOL E: /L') DO SET DKEY=%%x
REM *** Find the first available Free Drive letter ***
SET FDRV=?
FOR %%b IN (X V T R) DO (MOUNTVOL %%b: /L >NUL 2>&1 || SET FDRV=%%b:)
REM *** Check settings ***
IF "%DKEY%"=="?" GOTO READY
IF "%FDRV%"=="?" GOTO READY
REM *** Delete volume E and move it to a new volume ***
MOUNTVOL E: /D
MOUNTVOL %FDRV% %DKEY%
GOTO READY
:READY
CLS
EXIT