Sub RemoveSpaces()

    Dim MyRange
    Dim MyCell
    Dim counter As Integer
    Dim len1 As Integer
    Dim len2 As Integer
    
    Set MyRange = Selection
    
    counter = 0
    
    For Each MyCell In MyRange
        If Not IsEmpty(MyCell) Then
            len1 = Len(MyCell.Value)
            MyCell.Value = Trim(MyCell.Value)
            len2 = Len(MyCell.Value)
            If len1 > len2 Then
                counter = counter + 1
            End If
        End If
    Next MyCell

    MsgBox "The number of cells with text is " & counter

End Sub

