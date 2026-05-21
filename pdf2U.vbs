' ============================
' XLSX → PDF Converter (VBS)
' ============================

If WScript.Arguments.Count < 2 Then
    WScript.Echo "Usage: cscript xlsx2pdf.vbs input.xlsx output.pdf"
    WScript.Quit 1
End If

inputXLSX = WScript.Arguments(0)
outputPDF = WScript.Arguments(1)

Set fso = CreateObject("Scripting.FileSystemObject")
If Not fso.FileExists(inputXLSX) Then
    WScript.Echo "Input file not found: " & inputXLSX
    WScript.Quit 1
End If

Set excel = CreateObject("Excel.Application")
excel.Visible = False
excel.DisplayAlerts = False

Set wb = excel.Workbooks.Open(inputXLSX)

' 0 = xlTypePDF
Const xlTypePDF = 0

wb.ExportAsFixedFormat xlTypePDF, outputPDF

wb.Close False
excel.Quit

Set wb = Nothing
Set excel = Nothing

WScript.Echo "PDF created: " & outputPDF
