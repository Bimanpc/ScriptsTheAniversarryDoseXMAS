Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile("testfile.txt", True)

' Generate a test file of specified size
Const fileSizeInMB = 100  ' Size of the test file in megabytes
fileSizeInBytes = fileSizeInMB * 1024 * 1024

' Write random data to the test file
Randomize
For i = 1 To fileSizeInBytes
    randomByte = Int((255 - 0 + 1) * Rnd + 0)
    objFile.Write Chr(randomByte)
Next

objFile.Close

' Read the test file to measure read speed
Set objFile = objFSO.OpenTextFile("testfileZ.txt", 1)
Dim startTime, endTime
startTime = Timer

Do Until objFile.AtEndOfStream
    objFile.ReadLine
Loop

endTime = Timer
objFile.Close

' Calculate read speed
readTime = endTime - startTime
readSpeedMBps = fileSizeInMB / readTime
WScript.Echo "Read speed: " & readSpeedMBps & " MB/s"

' Write to the test file to measure write speed
Set objFile = objFSO.OpenTextFile("testfileZ.txt", 2)
startTime = Timer

For i = 1 To fileSizeInBytes
    randomByte = Int((255 - 0 + 1) * Rnd + 0)
    objFile.Write Chr(randomByte)
Next

endTime = Timer
objFile.Close

' Calculate write speed
writeTime = endTime - startTime
writeSpeedMBps = fileSizeInMB / writeTime
WScript.Echo "Write speed: " & writeSpeedMBps & " MB/s"

' Delete the test file
objFSO.DeleteFile("testfile.txt")
