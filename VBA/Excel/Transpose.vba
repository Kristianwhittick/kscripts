Sub TransposeRows_excelhow()
    Dim i As Long
    Dim j As Long
    Dim k As Long
    Dim LastRow As Long
    Dim NumCols As Long
    Dim DataRange As Range
    Dim DestRange As Range
    
    ' Set the number of rows to transpose into each column
    NumCols = Application.InputBox("Enter the number of rows to transpose into each column:")
    
    ' Select the range of cells to transpose
    On Error Resume Next
    Set DataRange = Application.InputBox("Select the range of cells to transpose:", Type:=8)
    On Error GoTo 0
    If DataRange Is Nothing Then Exit Sub
    
    ' Select the destination range for the transposed data
    On Error Resume Next
    Set DestRange = Application.InputBox("Select the destination range for the transposed data:", Type:=8)
    On Error GoTo 0
    If DestRange Is Nothing Then Exit Sub
    
    LastRow = DataRange.Rows.Count
    k = 0
    
    For i = 1 To LastRow Step NumCols
        k = k + 1
        For j = 0 To NumCols - 1
            DestRange.Offset(j, k - 1).Value = DataRange.Offset(i + j - 1, 0).Value
        Next j
    Next i
End Sub