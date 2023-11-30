<html>
<head>
<title>Geolocation Script</title>
<script type="text/vbscript">
Function GetLocation()
    Set locator = CreateObject("WScript.Geolocation")
    
    If locator.IsGeolocationAvailable Then
        Set position = locator.GetLocation()
        latitude = position.Latitude
        longitude = position.Longitude
        accuracy = position.Accuracy

        MsgBox "Latitude: " & latitude & vbCrLf & "Longitude: " & longitude & vbCrLf & "Accuracy: " & accuracy & " meters"
    Else
        MsgBox "Geolocation isnot available on this device."
    End If
End Function
</script>
</head>
<body>
<h1>Geolocation</h1>
<button onclick="GetLocation()">Get Location</button>
</body>
</html>
