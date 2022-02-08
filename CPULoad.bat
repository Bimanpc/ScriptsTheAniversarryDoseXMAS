@ECHO OFF
:: It has been edited afterwards to show only the CPU load percentage

IF "%~1"=="" (
	SET Node=%ComputerName%
) ELSE (
	SET Node=%~1
)

FOR /F "tokens=2 delims==" %%A IN ('WMIC.EXE /Node:%Node% /Output:STDOUT Path Win32_Processor Get LoadPercentage /Format:LIST') DO SET CPULoad=%%A

SET CPULoad 2022