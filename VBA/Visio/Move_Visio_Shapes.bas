Attribute VB_Name = "Module1"
Public Sub FindOffPageShapes()
    Dim shp As Visio.Shape
    Dim pagShape As Visio.Shape
    
    Set pagShape = Visio.ActivePage.PageSheet
    
    For Each shp In Visio.ActivePage.Shapes
        
        If "GUARD" <> Left(shp.Cells("width").FormulaU, 5) Then
            shp.Cells("width").Result("mm") = Round(shp.Cells("width").Result("mm") + 0.499)
        End If
    
        If "GUARD" <> Left(shp.Cells("height").FormulaU, 5) Then
            shp.Cells("height").Result("mm") = Round(shp.Cells("height").Result("mm") + 0.499)
        End If
        
        If "GUARD" <> Left(shp.Cells("PinX").FormulaU, 5) Then
            shp.Cells("PinX").Result("mm") = Round(shp.Cells("PinX").Result("mm"))
        End If
        
        If "GUARD" <> Left(shp.Cells("PinY").FormulaU, 5) Then
            shp.Cells("PinY").Result("mm") = Round(shp.Cells("PinY").Result("mm"))
        End If
    
    Next shp
    
End Sub

