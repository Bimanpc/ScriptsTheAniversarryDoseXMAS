' Create a new instance of the XMLHTTP object
Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP.6.0")

' Set the URL of the geolocation service
url = "https://ipinfo.io/json"

' Open the request
objXMLHTTP.open "GET", url, False

' Send the request
objXMLHTTP.send

' Wait for the response
Do While objXMLHTTP.readyState <> 4
    WScript.Sleep 100
Loop

' Check the response status
If objXMLHTTP.status = 200 Then
    ' Parse the JSON response
    Set objJSON = CreateObject("ScriptControl")
    objJSON.Language = "JScript"
    jsonResponse = objXMLHTTP.responseText
    Set jsonParsed = objJSON.Eval("(" & jsonResponse & ")")
    
    ' Extract geolocation information
    city = jsonParsed("city")
    region = jsonParsed("region")
    country = jsonParsed("country")
    loc = jsonParsed("loc")
    
    ' Display the geolocation information
    WScript.Echo "City: " & city
    WScript.Echo "Region: " & region
    WScript.Echo "Country: " & country
    WScript.Echo "Coordinates: " & loc
Else
    ' Handle the error
    WScript.Echo "Failed to retrieve geolocation information. Status: " & objXMLHTTP.status
End If

' Clean up
Set objXMLHTTP = Nothing
Set objJSON = Nothing
Set jsonParsed = Nothing
