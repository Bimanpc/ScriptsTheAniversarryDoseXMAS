' VBScript to clear the printer queue
Set objShell = CreateObject("WScript.Shell")
objShell.Run "cmd /c net stop spooler", 0, True
objShell.Run "cmd /c del %systemroot%\System32\spool\printers\* /Q", 0, True
objShell.Run "cmd /c net start spooler", 0, True
Set objShell = Nothing
