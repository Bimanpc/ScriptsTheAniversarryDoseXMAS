' VBScript to restart Apache service

Set objShell = CreateObject("WScript.Shell")

' Command to stop Apache service
stopCommand = "httpd -k stop"
objShell.Run stopCommand, 1, True

' Command to start Apache service
startCommand = "httpd -k start"
objShell.Run startCommand, 1, True

Set objShell = Nothing
