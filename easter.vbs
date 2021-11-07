' Easter.vbs,  Version 2022 for WSH 1.0
' Calculate Easter Day for a specified year
' Written by PCTECHGREU Billman
 
' Check command line parameters
Select Case WScript.Arguments.Count
	Case 0
		ChkYear = Year(Date)
	Case 1
		strChkYear = Wscript.Arguments(0)
		On Error Resume Next
		ChkYear = CInt(strChkYear)
		If Err.Number <> 0 Then
			Syntax
			Wscript.Quit(1)
		End If
		If VarType(ChkYear) <> 2 Then
			Syntax
			Wscript.Quit(1)
		End If
		ChkYear = CInt(Wscript.Arguments(0))
		If ChkYear < 1752 Or ChkYear > 3000 Then
			Syntax
			Wscript.Quit(1)
		End If
	Case Else
		Syntax
		Wscript.Quit(1)
End Select
 
' Calculate Easter Day using  instructions found at
' Simon Kershaw's "KEEPING THE FEAST"
' http://www.oremus.org/liturgy/etc/ktf/app/easter.html
G   = ( ChkYear Mod 19 ) + 1
S   = (( ChkYear - 1600 ) \ 100 ) - (( ChkYear - 1600 ) \ 400 )
L   = ((( ChkYear - 1400 ) \ 100 ) * 8 ) \ 25
PP  = ( 30003 - 11 * G + S - L ) Mod 30
Select Case PP
	Case 28
		If G > 11 Then P = 27
	Case 29
		P = 28
	Case Else
		P = PP
End Select
D   = ( ChkYear + ( ChkYear \ 4 ) - ( ChkYear \ 100 ) + ( ChkYear \ 400 )) Mod 7
DD  = ( 8 - D ) Mod 7
PPP = ( 70003 + P ) Mod 7
X   = (( 70004 - D - P ) Mod 7 ) + 1
E   = P + X
If E < 11 Then
	ED = E + 21
	EM = "March"
Else
	ED = E - 10
	EM = "April"
End If
thisYear = Year(Date)
If ChkYear < thisYear Then
	strIS = "was"
ElseIf ChkYear = thisYear Then
	strIS = "is"
Else
	strIS = "will be"
End If
 
' Display the result
Wscript.Echo vbCrLf & "In " & ChkYear & " Easter Day " & strIS & " " & EM & " " & ED
 
' Done
Wscript.Quit(0)
 
 
 
Sub Syntax
msg = vbCrLf & "Easter.vbs,  Version 1.01 for WSH 1.0" & vbCrLf & _
      "Calculate the date of Easter Day for the specified year." & vbCrLf & _
      vbCrLf & "Usage:  CSCRIPT  EASTER.VBS  [ year ]" & vbCrLf & vbCrLf & _
      "Where:  year should be within the range of 1752 through 3000" & _
      vbCrLf & vbCrLf & _
      "Based on the instructions found at" & vbCrLf & _
      "Simon Kershaw's " & Chr(34) & "KEEPING THE FEAST" & Chr(34) & _
      vbCrLf & "http://www.oremus.org/liturgy/etc/ktf/app/easter.html"
Wscript.Echo(msg)
End Sub