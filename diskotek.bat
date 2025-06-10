@echo off
echo Set WshShell = WScript.CreateObject("WScript.Shell") > %temp%\keystrokes.vbs
echo WScript.Sleep 1000 >> %temp%\keystrokes.vbs
echo WshShell.SendKeys "Hello, World!" >> %temp%\keystrokes.vbs
cscript //nologo %temp%\keystrokes.vbs
del %temp%\keystrokes.vbs
