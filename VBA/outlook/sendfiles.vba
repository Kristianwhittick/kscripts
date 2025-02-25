Const SOURCE_FOLDER As String = "C:\Users\kristian.whittick\zip\"
Const RECIP_A As String = "kristian.whittick@consult.nordea.com"
Const EMAIL_BODY As String = "Please find attached file. Thanks and Regards, Kris"

Sub SendPDFs()

  On Error GoTo ErrorHandler

  Dim fileName As String

  fileName = Dir(SOURCE_FOLDER)

  Do While Len(fileName) > 0
    Call CreateEmail(SOURCE_FOLDER & fileName)

    fileName = Dir
  Loop

ProgramExit:
  Exit Sub
ErrorHandler:
  MsgBox Err.Number & " - " & Err.Description
  Resume ProgramExit
End Sub


Function CreateEmail(fileName As String)

  Dim olApp As Outlook.Application
  Dim msg As Outlook.MailItem

  ' create email
  Set olApp = Outlook.Application
  Set msg = olApp.CreateItem(olMailItem)

  ' set properties
  With msg
    .Body = EMAIL_BODY
    .Recipients.Add (RECIP_A)
    .Attachments.Add fileName
    .Send
  End With

End Function
