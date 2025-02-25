Attribute VB_Name = "TextboxToCell"
Sub TextboxesToCell()
'UpdatebyExtendoffice20160918
    Dim xRg As Range
    Dim xRow As Long
    Dim xCol As Long
    Dim xTxtBox As TextBox
     
    Set xRg = Application.InputBox("Select a cell):", "Kutools for Excel", _
                                    ActiveWindow.RangeSelection.AddressLocal, , , , , 8)
    xRow = xRg.Row
    xCol = xRg.Column
     
    For Each xTxtBox In ActiveSheet.TextBoxes
        Cells(xRow, xCol).Value = xTxtBox.Text
        xTxtBox.Delete
        xRow = xRow + 1
    Next
     
End Sub

