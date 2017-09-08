Public Class image
    Private mstrName As NameOption
    Enum NameOption
        logotme
        logomass
    End Enum
    Public Sub New(ByVal Name As NameOption)
        mstrName = Name
    End Sub
    Public Function Path() As String
        Dim pth As String = ""
        Select Case mstrName
            Case NameOption.logotme, NameOption.logomass
                pth = mstrName.ToString & ".jpg"
        End Select
        Return "~/_images/" & pth
    End Function
End Class
