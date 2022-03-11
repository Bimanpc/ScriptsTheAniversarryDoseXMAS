Set oFSO = CreateObject("Scripting.FileSystemObject")
sFile1 = "MyPCInfo.csv"
Set oFile1 = oFSO.CreateTextFile(sFile1, 1)
strQuery = "SELECT Family,Brand,NumberOfCores FROM Win32_Processor"
Set colResults = GetObject("winmgmts://./root/cimv2").ExecQuery( strQuery )
oFile1.WriteLine "Processor Information"
oFile1.WriteLine "------"
For Each objResult In colResults
  strResults = "Family:,"+CStr(objResult.Family)
  oFile1.WriteLine strResults
  strResults = "Brand:,"+CStr(objResult.Manufacturer)
  oFile1.WriteLine strResults
  strResults = "Number of Cores:,"+CStr(objResult.NumberOfCores)
  oFile1.WriteLine strResults
Next