Set WshShell = CreateObject("WScript.Shell")

' Speed in milliseconds (lower = faster)
speed = 100

Do
    ' Toggle CapsLock
    WshShell.SendKeys "{CAPSLOCK}"
    WScript.Sleep speed

    ' Toggle NumLock
    WshShell.SendKeys "{NUMLOCK}"
    WScript.Sleep speed

    ' Toggle ScrollLock
    WshShell.SendKeys "{SCROLLLOCK}"
    WScript.Sleep speed
Loop
