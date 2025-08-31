' DiskoBall.vbs
Option Explicit
Randomize

Dim ie, r, g, b, hexColor
Set ie = CreateObject("InternetExplorer.Application")

' Configure IE as a borderless, full-screen display
With ie
  .Toolbar = False
  .StatusBar = False
  .MenuBar = False
  .AddressBar = False
  .Resizable = False
  .FullScreen = True
  .Navigate "about:blank"
End With

' Wait for the blank page to load
Do While ie.Busy Or ie.ReadyState <> 4
  WScript.Sleep 100
Loop

' Flash random colors until the window is closed
Do
  r = Hex(Int(Rnd() * 256))
  g = Hex(Int(Rnd() * 256))
  b = Hex(Int(Rnd() * 256))

  ' Ensure two-digit hex values
  If Len(r) = 1 Then r = "0" & r
  If Len(g) = 1 Then g = "0" & g
  If Len(b) = 1 Then b = "0" & b

  hexColor = "#" & r & g & b
  ie.Document.Body.Style.BackgroundColor = hexColor

  ' Pause between flashes (adjust for speed)
  WScript.Sleep 100
Loop

' Cleanup (never reaches here unless you forcibly exit)
ie.Quit
Set ie = Nothing
