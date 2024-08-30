Dim xmlhttp
Set xmlhttp = CreateObject("MSXML2.ServerXMLHTTP")

' Replace with your SMS gateway URL and parameters
url = "https://api.yoursmsgateway.com/send?api_key=YOUR_API_KEY&to=RECIPIENT_NUMBER&message=YOUR_MESSAGE"

xmlhttp.open "GET", url, False
xmlhttp.send

If xmlhttp.Status = 200 Then
    MsgBox "SMS sent successfully!"
Else
    MsgBox "Failed to send SMS. Status: " & xmlhttp.Status
End If

Set xmlhttp = Nothing
