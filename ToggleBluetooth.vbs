' ToggleBluetooth.vbs
' Calls PowerShell to toggle Bluetooth radio state

Set objShell = CreateObject("WScript.Shell")

' This PowerShell command disables Bluetooth adapter
psCmd = "powershell -command ""Get-PnpDevice -Class Bluetooth | Where-Object { $_.Status -eq 'OK' } | Disable-PnpDevice -Confirm:$false"""
objShell.Run psCmd, 0, True

' To enable instead, replace Disable-PnpDevice with Enable-PnpDevice
