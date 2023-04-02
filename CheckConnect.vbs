Option Explicit     
Dim WshShell
set WshShell = WScript.CreateObject("WScript.Shell")         

On Error Resume Next
   With WScript.CreateObject ("InternetExplorer.Application")     
      .Navigate "www.bing.com"
      .fullscreen = 1   
      .Visible    = 1
      WScript.Sleep 10000
   End With    
On Error Goto 0
