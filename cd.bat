@echo off

if %4.==. for %%f in (0 1 2 3 4 5 6 7 8 9) do call %0 %1 %2 %3 %4 %%f
if %4.==. goto end

:ok
if exist %1%2%3%4.txt goto end
dir/s/a w:\ >%1%2%3%4.txt
echo Disc %1%2%3%4 complete;
echo hit ^C, or insert the next disk 
pause
goto end

:error
:end