Option Explicit

Dim http, json, regEx, matches
Set http = CreateObject("MSXML2.XMLHTTP")
http.Open "GET", "https://api.ipify.org?format=json", False
http.Send

If http.Status = 200 Then
    json = http.responseText
    Set regEx = New RegExp
    regEx.Pattern = """ip""\s*:\s*""([^""]+)"""
    regEx.Global = False

    If regEx.Test(json) Then
        Set matches = regEx.Execute(json)
        WScript.Echo "Public IP: " & matches(0).SubMatches(0)
    Else
        WScript.Echo "Could not parse IP from: " & json
    End If
Else
    WScript.Echo "HTTP error: " & http.Status & " - " & http.statusText
End If
