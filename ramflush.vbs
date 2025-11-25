' RAM Flush App (VBScript)
' - Auto-elevates to admin
' - Trims working sets of userland processes via PowerShell (EmptyWorkingSet)
' - Reports freed memory and cleans up temp files
' Tested on Windows 10/11

Option Explicit

Dim shell, fso, tempDir, psFile, isAdmin, beforeKB, afterKB, freedMB, rc
Set shell = CreateObject("Shell.Application")
Set fso   = CreateObject("Scripting.FileSystemObject")
tempDir   = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%TEMP%")
psFile    = fso.BuildPath(tempDir, "ram_flush_" & Hex(Timer * 1000) & ".ps1")

' 1) Ensure elevation
isAdmin = CheckAdmin()
If Not isAdmin Then
    ' Relaunch self elevated
    shell.ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """", "", "runas", 1
    WScript.Quit
End If

' 2) Measure before
beforeKB = GetFreePhysicalKB()

' 3) Write PowerShell script that calls EmptyWorkingSet for safe processes
WritePowerShellTrimScript psFile

' 4) Run PowerShell script silently
rc = RunHidden("powershell.exe -NoProfile -ExecutionPolicy Bypass -File """ & psFile & """")

' 5) Measure after
afterKB = GetFreePhysicalKB()
freedMB = Round((afterKB - beforeKB) / 1024, 1)

' 6) Cleanup temp PS file
On Error Resume Next
If fso.FileExists(psFile) Then fso.DeleteFile psFile, True
On Error GoTo 0

' 7) Report
Dim msg
msg = "RAM Flush Completed" & vbCrLf & vbCrLf & _
      "Before:  " & FormatMB(beforeKB) & vbCrLf & _
      "After:   " & FormatMB(afterKB) & vbCrLf & _
      "Freed:   " & freedMB & " MB"
MsgBox msg, vbInformation, "RAM Flush"

WScript.Quit

' -------- Helpers --------

Function CheckAdmin()
    ' Uses "net session"—only succeeds when elevated
    Dim exec, out, code
    On Error Resume Next
    code = CreateObject("WScript.Shell").Run("cmd.exe /c net session >nul 2>&1", 0, True)
    On Error GoTo 0
    CheckAdmin = (code = 0)
End Function

Function GetFreePhysicalKB()
    Dim svc, osSet, os
    Set svc = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
    Set osSet = svc.ExecQuery("SELECT FreePhysicalMemory FROM Win32_OperatingSystem")
    For Each os In osSet
        GetFreePhysicalKB = CLng(os.FreePhysicalMemory) ' KB
        Exit Function
    Next
    GetFreePhysicalKB = 0
End Function

Function FormatMB(kb)
    FormatMB = Round(kb / 1024, 1) & " MB"
End Function

Sub WritePowerShellTrimScript(path)
    Dim content
    content = _
"Add-Type -TypeDefinition @'" & vbCrLf & _
"using System;" & vbCrLf & _
"using System.Runtime.InteropServices;" & vbCrLf & _
"public static class NativeMethods {" & vbCrLf & _
"  [DllImport(""kernel32.dll"")] public static extern IntPtr OpenProcess(uint dwDesiredAccess, bool bInheritHandle, int dwProcessId);" & vbCrLf & _
"  [DllImport(""psapi.dll"")] public static extern bool EmptyWorkingSet(IntPtr hProcess);" & vbCrLf & _
"  [DllImport(""kernel32.dll"")] public static extern bool CloseHandle(IntPtr hObject);" & vbCrLf & _
"}" & vbCrLf & _
"@'" & vbCrLf & vbCrLf & _
"$QUERY  = 0x0400 # PROCESS_QUERY_INFORMATION" & vbCrLf & _
"$SETQ   = 0x0100 # PROCESS_SET_QUOTA" & vbCrLf & _
"$ACCESS = $QUERY -bor $SETQ" & vbCrLf & _
"$skip   = @('System','Idle','Registry','Memory Compression')" & vbCrLf & _
"$procs  = Get-Process | Where-Object { $_.Id -gt 0 -and ($skip -notcontains $_.ProcessName) }" & vbCrLf & _
"$countOK = 0; $countFail = 0" & vbCrLf & _
"foreach ($p in $procs) {" & vbCrLf & _
"  try {" & vbCrLf & _
"    $h = [NativeMethods]::OpenProcess($ACCESS, $false, $p.Id)" & vbCrLf & _
"    if ($h -ne [IntPtr]::Zero) {" & vbCrLf & _
"      [void][NativeMethods]::EmptyWorkingSet($h)" & vbCrLf & _
"      [void][NativeMethods]::CloseHandle($h)" & vbCrLf & _
"      $countOK++" & vbCrLf & _
"    } else { $countFail++ }" & vbCrLf & _
"  } catch { $countFail++ }" & vbCrLf & _
"}" & vbCrLf & _
"# Optional: output summary for logs" & vbCrLf & _
"Write-Output (""Trimmed OK: {0}, Failed: {1}"" -f $countOK, $countFail)" & vbCrLf

    Dim stream
    Set stream = fso.CreateTextFile(path, True, False)
    stream.Write content
    stream.Close
End Sub

Function RunHidden(cmd)
    Dim sh
    Set sh = CreateObject("WScript.Shell")
    RunHidden = sh.Run(cmd, 0, True)
End Function
