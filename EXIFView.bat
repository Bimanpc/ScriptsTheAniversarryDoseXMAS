@ECHO OFF
IF    NOT "%OS%"=="Windows_NT" GOTO Syntax
IF        "%~1"=="/?"   GOTO Syntax
IF        "%~2"==""     GOTO Syntax
IF    NOT "%~4"==""     GOTO Syntax
IF    NOT EXIST "%~1"   GOTO Syntax
IF /I     "%~2"=="/X"   GOTO XML
:: Because we cannot easily sort a FOR loop, we'll just call this same batch file
:: again with an additional /U switch (Unsorted) and use SORT on its unsorted output
IF /I "%~2"=="/L" IF "%~3"=="" (
	FOR %%A IN ("%~1") DO (
		ECHO "%%~fA"
		"%~f0" "%%~fA" /L /U | SORT
		ECHO.
	)
	GOTO:EOF
)
IF /I     "%~2"=="/L" IF /I     "%~3"=="/U" GOTO ListAll
IF /I     "%~2"=="/L" IF /I NOT "%~3"=="/U" GOTO Syntax
IF /I NOT "%~2"=="/L" IF    NOT "%~3"==""   GOTO Syntax
 
 
FOR %%A IN ("%~1") DO CALL :GetValue "%%~fA" "%~2"
GOTO:EOF
 
:GetValue
FOR /F "tokens=3,4 delims=<:>" %%A IN ('TYPE "%~f1" ^| FINDSTR /R /B /I /C:" *<[a-z/][^>]*:[^>]*>" ^| FIND /I ":%~2>"') DO ECHO "%~f1"	%%A=%%B
GOTO:EOF
 
:ListAll
FOR /F "tokens=3 delims=<:>" %%A IN ('TYPE "%~f1" ^| FINDSTR /R /B /I /C:" *<[a-z][^>]*:[^>]*>.*</[a-z][^>]*:[^>]*>"') DO (
	IF NOT "%%~A"=="li" IF NOT "%%~A"=="li xml" ECHO.%%A
)
ECHO.
GOTO:EOF
 
:XML
FOR %%A IN ("%~1") DO (
	ECHO "%%~fA"
	ECHO.
	TYPE "%%~fA" | FINDSTR /R /B /I /C:" *<[a-z/][^>]*:[^>]*>"
	ECHO.
)
GOTO:EOF
 
:Syntax
ECHO.
ECHO EXIFInfo.bat,  Version 2021-2022
ECHO Return the requested EXIF value for the specified file(s),
ECHO or list all available tag names and, optionally, values.
ECHO.
ECHO Usage:  EXIFINFO   imagefile  exiftag
ECHO    or:  EXIFINFO   imagefile  /L
ECHO    or:  EXIFINFO   imagefile  /X
ECHO.
ECHO Where:  imagefile  the image(s) to check (single filespec, wildcards allowed)
ECHO         exiftag    is a valid EXIF tag name (e.g. Model, ExposureTime)
ECHO         /L         list all valid EXIF tag names for imagefiles
ECHO         /X         list all EXIF metadata for imagefiles in XML format
ECHO.
ECHO Written by PCTECHGREU
 
IF "%OS%"=="Windows_NT" EXIT /B 1
