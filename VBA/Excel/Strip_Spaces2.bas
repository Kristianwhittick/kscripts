Attribute VB_Name = "StripSpaces"
Sub RemoveLeadingSpaces()

    Dim WorkRng As Range
    Dim WorkCell As Range
    Dim NewValue As String
    Dim counter As Integer

    On Error Resume Next

    counter = 0

    Set WorkRng = Selection

    For Each WorkCell In WorkRng
        If Not IsEmpty(WorkCell) Then
            NewValue = Trim(Application.Clean(WorkCell.Value))

            If Len(WorkCell.Value) > Len(NewValue) Then
                WorkCell.Value = NewValue
                counter = counter + 1
            End If
        End If
    Next

    MsgBox "The number of cells with text is " & counter

End Sub

