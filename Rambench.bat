' Define the size of the array
Dim arraySize
arraySize = 10000000 ' 10 million elements

' Create a large array
Dim largeArray()
ReDim largeArray(arraySize)

' Fill the array with random numbers
Randomize
For i = 0 To arraySize
    largeArray(i) = Int((Rnd * 1000) + 1)
Next

' Perform operations on the array
Dim startTime, endTime
startTime = Timer

For i = 0 To arraySize
    largeArray(i) = largeArray(i) * 2
Next

endTime = Timer

' Calculate the time taken
Dim timeTaken
timeTaken = endTime - startTime

' Output the results
WScript.Echo "Time taken to process the array: " & timeTaken & " seconds"
