@echo off
setlocal enabledelayedexpansion

:: Define the height of the tree
set height=10

:: Loop to create the tree
for /L %%i in (1,1,%height%) do (
    :: Calculate the number of spaces and stars
    set /a spaces=%height%-%%i
    set /a stars=2*%%i-1

    :: Print the spaces and stars
    set "line="
    for /L %%j in (1,1,!spaces!) do set "line=!line! "
    for /L %%j in (1,1,!stars!) do set "line=!line!*"

    :: Output the line
    echo !line!
)

:: Print the trunk
echo.
echo ^^^^^^^^
echo ^^^^^^^^

endlocal
pause
