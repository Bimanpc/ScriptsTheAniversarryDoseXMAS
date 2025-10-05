' File: RamMemoryCleaner.vbs
' Purpose: Trim process working sets to free physical RAM (safe, non-destructive).
' Requires: Windows with PowerShell. Run as Administrator for best results.

Option Explicit

Dim shell, fso, beforeMB, afterMB, tmpPs1, psCode, rc

Set shell = CreateObject("Shell.Application")
Set fso   = CreateObject("Scripting.FileSystemObject")

' Relaunch elevated if not admin
If Not shell.IsUserAnAdmin Then
  CreateObject("WScript.Shell").ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """", "", "runas", 1
  WScript.Quit
End If

beforeMB = GetFreePhysicalMB()

' Prepare temp PowerShell script
tmpPs1 = fso.BuildPath(CreateObject("WScript.Shell").ExpandEnvironmentStrings("%TEMP%"), "RamTrim.ps1")
psCode = GetPowerShellTrimCode()
WriteText tmpPs1, psCode

' Run PowerShell to trim working sets (hidden, wait for completion)
rc = CreateObject("WScript.Shell").Run("powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & tmpPs1 & """", 0, True)

afterMB = GetFreePhysicalMB()

' Clean up temp file
On Error Resume Next
If fso.FileExists(tmpPs1) Then fso.DeleteFile tmpPs1, True
On Error GoTo 0

' Report results
Dim freed
freed = afterMB - beforeMB
If freed < 0 Then freed = 0

MsgBox "RAM Memory Cleaner" & vbCrLf & vbCrLf & _
       "Free RAM before: " & beforeMB & " MB" & vbCrLf & _
       "Free RAM after:  " & afterMB & " MB" & vbCrLf & _
       "Freed:           " & freed & " MB", vbInformation, "RAM Cleaner"

' ------- Helpers -------

Function GetFreePhysicalMB()
  On Error Resume Next
  Dim svc, os, freeKB
  Set svc = GetObject("winmgmts:\\.\root\cimv2")
  For Each os In svc.ExecQuery("SELECT FreePhysicalMemory FROM Win32_OperatingSystem")
    freeKB = CLng(os.FreePhysicalMemory)
    Exit For
  Next
  GetFreePhysicalMB = CInt(freeKB \ 1024)
  On Error GoTo 0
End Function

Sub WriteText(path, text)
  Dim fh
  Set fh = fso.CreateTextFile(path, True, False)
  fh.Write text
  fh.Close
End Sub

Function GetPowerShellTrimCode()
  Dim s
  s = s & "$ErrorActionPreference = 'SilentlyContinue'" & vbCrLf
  s = s & "$signature = @'" & vbCrLf
  s = s & "[System.Runtime.InteropServices.DllImport(""psapi.dll"")] public static extern bool EmptyWorkingSet(System.IntPtr hProcess);" & vbCrLf
  s = s & "'@" & vbCrLf
  s = s & "Add-Type -MemberDefinition $signature -Name 'PsApi' -Namespace 'Win32' | Out-Null" & vbCrLf
  s = s & "$exclude = @('System','Registry','Idle','csrss','wininit','winlogon','services','lsass','smss')" & vbCrLf
  s = s & "Get-Process | Where-Object { $exclude -notcontains $_.Name } | ForEach-Object {" & vbCrLf
  s = s & "  try { [Win32.PsApi]::EmptyWorkingSet($_.Handle) | Out-Null } catch { }" & vbCrLf
  s = s & "}" & vbCrLf
  GetPowerShellTrimCode = s
End Function
