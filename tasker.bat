@echo off
setlocal enabledelayedexpansion

:: Define the file to store tasks
set "taskfile=tasks.txt"

:: Check if the task file exists, if not create it
if not exist "%taskfile%" (
    echo. > "%taskfile%"
)

:menu
cls
echo Task Management Application
echo ---------------------------
echo 1. Add Task
echo 2. View Tasks
echo 3. Delete Task
echo 4. Exit
echo.
set /p choice=Enter your choice:

if "%choice%"=="1" goto addtask
if "%choice%"=="2" goto viewtasks
if "%choice%"=="3" goto deletetask
if "%choice%"=="4" goto exit

echo Invalid choice. Please try again.
pause
goto menu

:addtask
cls
echo Add Task
echo ---------
set /p task=Enter the task:
echo %task% >> "%taskfile%"
echo Task added successfully!
pause
goto menu

:viewtasks
cls
echo View Tasks
echo -----------
if not exist "%taskfile%" (
    echo No tasks found.
) else (
    type "%taskfile%"
)
pause
goto menu

:deletetask
cls
echo Delete Task
echo -----------
set /p tasknum=Enter the task number to delete:

set count=0
for /f "tokens=*" %%a in (%taskfile%) do (
    set /a count+=1
    if !count!==%tasknum% (
        set "task=%%a"
        goto foundtask
    )
)

echo Task number not found.
pause
goto menu

:foundtask
echo %task%
set /p confirm=Are you sure you want to delete this task? (y/n):
if /i "%confirm%"=="y" (
    (for /f "tokens=*" %%a in (%taskfile%) do (
        set /a count+=1
        if !count! neq %tasknum% (
            echo %%a
        )
    )) > temp.txt
    move /y temp.txt "%taskfile%"
    echo Task deleted successfully!
) else (
    echo Task deletion cancelled.
)
pause
goto menu

:exit
cls
echo Exiting...
pause
exit
