@echo off
cd "C:\Program Files (x86)\DOSBox-0.74-3"
dosbox.exe -c "mount c C:\DOS" -c "c:" -c "dir"
