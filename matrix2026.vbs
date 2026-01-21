Dim A(1,1), B(1,1), C(1,1)
Dim i, j, k

A(0,0)=1: A(0,1)=2
A(1,0)=3: A(1,1)=4

B(0,0)=2: B(0,1)=0
B(1,0)=1: B(1,1)=2

For i = 0 To 1
    For j = 0 To 1
        C(i,j) = 0
        For k = 0 To 1
            C(i,j) = C(i,j) + A(i,k) * B(k,j)
        Next
    Next
Next

For i = 0 To 1
    For j = 0 To 1
        WScript.Echo C(i,j)
    Next
Next
