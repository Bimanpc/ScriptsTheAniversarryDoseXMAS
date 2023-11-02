' Clear the Windows pagefile
Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colPageFiles = objWMIService.ExecQuery("Select * from Win32_PageFile")
For Each objPageFile in colPageFiles
    objPageFile.Delete
Next
