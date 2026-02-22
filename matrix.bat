@echo off
color 0a
mode 100,40

:loop
set "str="
for /L %%i in (1,1,100) do (
    set /A rnd=%random% %% 2
    if !rnd! == 1 (
        set "str=!str!!random:~-1!"
    ) else (
        set "str=!str! "
    )
)
echo !str!
timeout /t 0 >nul
goto loop
