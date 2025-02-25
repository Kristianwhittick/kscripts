Sub TrimTableCellWhitespace()
    Dim tbl As Table
    Dim cell As Cell
    Dim originalText As String
    Dim trimmedText As String
    Dim changedCellCount As Long ' Counter for trimmed cells
    
    changedCellCount = 0 ' Initialize the counter

    On Error Resume Next ' Ignore errors for problematic tables
    
    ' Loop through all tables in the document
    For Each tbl In ActiveDocument.Tables
        ' Reset error handling
        Err.Clear
        
        ' Try to loop through all cells
        On Error GoTo SkipTable ' Jump to skip problematic tables
        For Each cell In tbl.Range.Cells
            ' Get the text in the cell
            originalText = cell.Range.Text
            
            ' Check if length is greater than 2 before removing the end-of-cell marker
            If Len(originalText) > 2 Then
                originalText = Left(originalText, Len(originalText) - 2)
            End If
            
            ' Trim whitespace from the text
            trimmedText = Trim(originalText)
            
            ' Update the cell text if it has changed
            If originalText <> trimmedText Then
                cell.Range.Text = trimmedText
                changedCellCount = changedCellCount + 1 ' Increment the counter
            End If
        Next cell
        
        ' Skip to the next table if an error occurs
        On Error Resume Next
        GoTo ContinueLoop
        
SkipTable:
        Debug.Print "Skipped a table due to merged cells or other issues."
        
ContinueLoop:
    Next tbl

    On Error GoTo 0 ' Restore default error handling

    ' Display the count of trimmed cells
    MsgBox "Whitespace trimmed in " & changedCellCount & " cells.", vbInformation
End Sub
