' Based on code by Basiliy
'
' Enter two numbers from the user and add them up using Microsoft Excel 
' Shows How to open an MicroSoft Excel ActiveX service through VB
 
Option Explicit                ' force variable declarations

' Excel.Document - is a predefined name for "ActiveX" services provided by Excel
' (xlAppl is our "connection" to all functions MS Excell provides)
'
' "set" -  new VBScript for us (only can "set" non-VB types, i.e., "objects")
' For example, 
'     dim num
'     set num = 123    ' is an ERROR !!!)
'
' If you forget to use "set", e.g.,
'     xlAppl = CreateObject("Excel.Application")
' it will compile, but when it runs, we'll get a run-time error:
'     "Object Required: .... "
'
' Also note that if you encounter errors after Excel is opened,
' you have to manually close the excel application 
dim xlAppl
set xlAppl = CreateObject("Excel.Application")

' We do not need to let the user see what is going on, 
' can switch the visibility on/off
xlAppl.Application.Visible = false

' Now create a new excel document to work with,
' MS Excel refers to its documents (files) as "Workbook"
dim newDocument
set newDocument = xlAppl.Application.Workbooks.Add()

' Each excel document can have many work sheets, 
' we will activate the first one and work with it ...
dim activeSheet
set activeSheet = xlAppl.Worksheets("SheetNo1")

' we can use the value returned by MsgBox, to let user decide what to see
dim choice
choice = MsgBox("Do you want look at the Excel Page?", vbYesNo)
if choice = vbYes then
   xlAppl.Application.Visible = true
end if

' now we are ready, let's enter number and add the numbers up
' for the user
'
dim num1, num2
num1 = InputBox("Please enter a number: ")
num2 = InputBox("Please enter another number: ")

' put num values in first and second rows, put sum in third row, first column
activeSheet.Cells(1, 1).Value = num1
activeSheet.Cells(2, 1).Value = num2
activeSheet.Cells(3, 1).Value = "=Sum(A1:A2)"

dim answer
answer = activeSheet.Cells(3,1).Value

MsgBox num1 & "+" & num2 & " is: " & answer
	
' When I want to quit, let me quit, do not ask me if I want to save my work
xlAppl.Application.DisplayAlerts = true

' and quit
xlAppl.Application.Quit