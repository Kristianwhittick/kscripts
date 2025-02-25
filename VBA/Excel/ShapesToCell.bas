Attribute VB_Name = "ShapesToCell"
Sub ShapesToCell()
'UpdatebyExtendoffice20160918
    Dim xRg As Range
    Dim xRow As Long
    Dim xCol As Long
    Dim xShape As Shape
     
    Set xRg = Application.InputBox("Select a cell):", "Kutools for Excel", _
                                    ActiveWindow.RangeSelection.AddressLocal, , , , , 8)
    xRow = xRg.Row
    xCol = xRg.Column
     
    For Each xShape In ActiveSheet.Shapes
        Cells(xRow, xCol).Value = xShape.TextFrame.Characters.Text
        xShape.Delete
        xRow = xRow + 1
    Next
     
End Sub

