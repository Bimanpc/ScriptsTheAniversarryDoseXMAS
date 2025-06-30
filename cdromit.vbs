Option Explicit

Dim fso, startTime, endTime, filePath, cdDrive, file, sizeMB, elapsedSeconds, speedMBps

' Δηλώνουμε το drive του CD-ROM – άλλαξέ το ανάλογα
cdDrive = "D:\"
filePath = cdDrive & "testfile.iso"  ' Πρέπει να υπάρχει ένα αρκετά μεγάλο αρχείο στο CD

Set fso = CreateObject("Scripting.FileSystemObject")

If Not fso.FileExists(filePath) Then
    WScript.Echo "Το αρχείο δεν βρέθηκε στο CD: " & filePath
    WScript.Quit
End If

Set file = fso.GetFile(filePath)
sizeMB = file.Size / 1024 / 1024  ' μέγεθος σε MB

startTime = Timer

' Διαβάζουμε το αρχείο
Dim stream
Set stream = CreateObject("ADODB.Stream")
With stream
    .Type = 1  ' Binary
    .Open
    .LoadFromFile filePath
    .Close
End With

endTime = Timer

elapsedSeconds = endTime - startTime
If elapsedSeconds <= 0 Then elapsedSeconds = 0.01

speedMBps = sizeMB / elapsedSeconds

WScript.Echo "Μέγεθος αρχείου: " & Round(sizeMB, 2) & " MB"
WScript.Echo "Χρόνος ανάγνωσης: " & Round(elapsedSeconds, 2) & " δευτερόλεπτα"
WScript.Echo "Ταχύτητα CD-ROM: " & Round(speedMBps, 2) & " MB/sec"
