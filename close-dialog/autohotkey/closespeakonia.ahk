#Persistent
SetTitleMatchMode, 2  ; Allows partial title matching
SetWinDelay, 0        ; Speed up execution

ProgramTitle=Speakonia - CFS-Technologies

WinGetTitle, TfrmMainTitle, ahk_class TfrmMain

if (TfrmMainTitle != ProgramTitle) {
    ExitApp
}

Loop {
    WinGet, hwndDialog, ID, ahk_class #32770

    if (!hwndDialog) {
        ExitApp
    }

    hwndOwner := DllCall("GetWindow", "UInt", hwndDialog, "UInt", 4)
    WinGetTitle, ownerWinTitle, ahk_id %hwndOwner%

    if (ownerWinTitle = ProgramTitle) {
        WinClose, ahk_id %hwndDialog%
    }
}
