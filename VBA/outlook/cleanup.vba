Sub ManageOutlookFolders()

    ' Define Outlook objects
    Dim outlookApp As Outlook.Application
    Dim namespace As Outlook.Namespace
    Dim deletedItemsFolder As Outlook.Folder
    Dim sentItemsFolder As Outlook.Folder
    Dim archiveFolder As Outlook.Folder
    Dim unreadItems As Outlook.Items
    Dim item As Object ' Declare as Object to avoid type mismatch
    Dim mailItem As Outlook.MailItem
    Dim meetingItem As Outlook.MeetingItem
    Dim unreadItem As Object ' Declare as Object to avoid type mismatch
    Dim filter As String
    Dim i As Long

    ' Use the existing instance of Outlook
    Set outlookApp = Outlook.Application
    Set namespace = outlookApp.GetNamespace("MAPI")

    ' 1. Delete all items in the "Deleted Items" folder
    Set deletedItemsFolder = namespace.GetDefaultFolder(olFolderDeletedItems)
    For i = deletedItemsFolder.Items.Count To 1 Step -1
        deletedItemsFolder.Items(i).Delete
    Next i
    MsgBox "All items in 'Deleted Items' have been deleted.", vbInformation

    ' 2. Move all sent messages and meeting responses to the "Archive" folder
    Set sentItemsFolder = namespace.GetDefaultFolder(olFolderSentMail)

    ' Locate the "Archive" folder inside the default mailbox
    Set archiveFolder = namespace.GetDefaultFolder(olFolderInbox).Parent.Folders("Archive")
    ' Adjust the folder path if needed

    ' Loop through the items in the "Sent Items" folder
    For i = sentItemsFolder.Items.Count To 1 Step -1
        Set item = sentItemsFolder.Items(i)
        ' Check if the item is a MailItem or MeetingItem before moving
        If TypeOf item Is Outlook.MailItem Then
            Set mailItem = item
            mailItem.Move archiveFolder
        ElseIf TypeOf item Is Outlook.MeetingItem Then
            Set meetingItem = item
            meetingItem.Move archiveFolder
        End If
    Next i
    MsgBox "All sent items and meeting responses have been moved to 'Archive'.", vbInformation

    ' 3. Mark all unread messages in the "Archive" folder as read using Restrict
    filter = "[UnRead] = True"
    Set unreadItems = archiveFolder.Items.Restrict(filter)

    ' Loop through the filtered unread items
    For i = unreadItems.Count To 1 Step -1
        Set unreadItem = unreadItems(i)
        ' Check if the unread item is a MailItem before marking as read
        
        ' TODO also do for meeting items
        If TypeOf unreadItem Is Outlook.MailItem Then
            Set mailItem = unreadItem
            mailItem.UnRead = False
            mailItem.Save
        ElseIf TypeOf unreadItem Is Outlook.MeetingItem Then
            Set meetingItem = unreadItem
            meetingItem.UnRead = False
            meetingItem.Save         
        End If
    Next i
    MsgBox "All unread messages in 'Archive' have been marked as read.", vbInformation

End Sub
