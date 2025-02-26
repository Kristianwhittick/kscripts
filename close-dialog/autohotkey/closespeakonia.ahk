#Persistent
SetTitleMatchMode, 2  ; Allows partial title matching
SetWinDelay, 0        ; Speed up execution

; Get the handle of the main application window (TfrmMain)
WinGet, hwndMain, ID, ahk_class TfrmMain
WinGetTitle, ProgTitle, ahk_class TfrmMain

if (ProgTitle != "Speakonia - CFS-Technologies") {
    ExitApp  ; Exit if TfrmMain is not found
}

Loop {
    ; Get the handle of the first found sub-dialog (#32770)
    WinGet, hwndDialog, ID, ahk_class #32770

    if (hwndDialog) {  ; If a dialog is found
        ; Get the owner (parent) of the dialog
        hwndOwner := DllCall("GetWindow", "UInt", hwndDialog, "UInt", 4)
        WinGetTitle, winTitle, ahk_id %hwndOwner%
	
        ; Check if the owner matches TfrmMain
        if (winTitle = "Speakonia - CFS-Technologies") {  
            WinActivate, ahk_id %hwndDialog%
            Sleep, 20
            ControlSend,, {Esc}, ahk_id %hwndDialog%  ; Send Esc to close it
        }
    } else {
        ExitApp  ; Exit when no more dialogs exist
    }

    Sleep, 50  ; Repeat every 0.05 seconds
}
