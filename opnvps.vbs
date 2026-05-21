' Docx2Pdf_AI.vbs
' Local DOCX -> PDF converter with optional AI summary hook (via external CLI)
' No telemetry; all paths and commands are under your control.

Option Explicit

Dim fso, shell
Set fso   = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

Dim docxPath, pdfPath, askSummary, summaryText

If WScript.Arguments.Count = 0 Then
    WScript.Echo "Usage: cscript //nologo Docx2Pdf_AI.vbs ""input.docx"" [""output.pdf""]"
    WScript.Quit 1
End If

docxPath = WScript.Arguments(0)

If Not fso.FileExists(docxPath) Then
    WScript.Echo "ERROR: File not found: " & docxPath
    WScript.Quit 1
End If

If WScript.Arguments.Count >= 2 Then
    pdfPath = WScript.Arguments(1)
Else
    pdfPath = fso.BuildPath(fso.GetParentFolderName(docxPath), _
              fso.GetBaseName(docxPath) & ".pdf")
End If

If LCase(fso.GetExtensionName(docxPath)) <> "docx" Then
    WScript.Echo "WARNING: Input is not .docx, attempting anyway..."
End If

If ConvertDocxToPdf(docxPath, pdfPath) Then
    WScript.Echo "Converted:" & vbCrLf & "  " & docxPath & vbCrLf & "->" & vbCrLf & "  " & pdfPath
Else
    WScript.Echo "Conversion failed."
    WScript.Quit 1
End If

askSummary = MsgBox("Generate AI summary of this document (via local LLM CLI)?", _
                    vbYesNo + vbQuestion, "AI Summary")
If askSummary = vbYes Then
    summaryText = RunAISummary(docxPath)
    If Len(summaryText) > 0 Then
        WScript.Echo vbCrLf & "=== AI SUMMARY ===" & vbCrLf & summaryText
    Else
        WScript.Echo "AI summary failed or returned empty."
    End If
End If

WScript.Quit 0

'-----------------------------
' DOCX -> PDF via Word COM
'-----------------------------
Function ConvertDocxToPdf(srcPath, dstPath)
    On Error Resume Next

    Dim wordApp, doc
    ConvertDocxToPdf = False

    Set wordApp = CreateObject("Word.Application")
    If Err.Number <> 0 Or wordApp Is Nothing Then
        WScript.Echo "ERROR: Could not create Word.Application. Is Microsoft Word installed?"
        Exit Function
    End If

    wordApp.Visible = False
    Err.Clear

    Set doc = wordApp.Documents.Open(srcPath, False, True) ' Read-only
    If Err.Number <> 0 Or doc Is Nothing Then
        WScript.Echo "ERROR: Could not open document: " & srcPath
        wordApp.Quit False
        Exit Function
    End If

    Const wdExportFormatPDF = 17

    On Error Resume Next
    doc.ExportAsFixedFormat dstPath, wdExportFormatPDF, False, 0, 0, 0, 0, 0, True, True, 0, True, True, False
    If Err.Number = 0 Then
        ConvertDocxToPdf = True
    Else
        WScript.Echo "ERROR: ExportAsFixedFormat failed: " & Err.Description
    End If

    On Error Resume Next
    doc.Close False
    wordApp.Quit False
End Function

'-----------------------------
' AI summary hook (local LLM)
'-----------------------------
Function RunAISummary(srcPath)
    ' You control this completely.
    ' Example: call a local LLM CLI that reads the DOCX (or a pre-extracted TXT)
    ' and prints a short summary to stdout.
    '
    ' Replace LLM_CMD with your own command.
    ' Example ideas:
    '   - A Python script that uses python-docx to extract text and calls a local LLM
    '   - A local HTTP client that talks to your self-hosted LLM API
    '
    ' IMPORTANT: This script does NOT call the network by itself.
    ' You decide what LLM_CMD does.

    Dim cmd, execObj, line, output
    output = ""

    ' --- EDIT THIS TO YOUR LOCAL SETUP ---
    ' Example placeholder:
    '   LLM_CMD = "python llm_summary.py """ & srcPath & """"
    ' or
    '   LLM_CMD = "my_local_llm.exe --summarize """ & srcPath & """"
    '
    ' For now, we just echo a placeholder.
    ' Uncomment and adapt when you have a real command.

    'cmd = "python llm_summary.py """ & srcPath & """"
    cmd = "cmd /c echo [AI placeholder] Wire your local LLM CLI here for: """ & srcPath & """"

    On Error Resume Next
    Set execObj = shell.Exec(cmd)
    If Err.Number <> 0 Or execObj Is Nothing Then
        RunAISummary = ""
        Exit Function
    End If

    Do While Not execObj.StdOut.AtEndOfStream
        line = execObj.StdOut.ReadLine()
        If Len(output) > 0 Then
            output = output & vbCrLf & line
        Else
            output = line
        End If
    Loop

    RunAISummary = output
End Function
