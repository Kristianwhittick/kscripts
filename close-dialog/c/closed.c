#include <windows.h>
#include <tlhelp32.h>
#include <stdio.h>

#define MAIN_CLASS_NAME "TfrmMain"
#define MAIN_WINDOW_TITLE "Speakonia - CFS-Technologies"
#define DIALOG_CLASS_NAME "#32770"

// Function to get a window handle by class name
HWND GetWindowByClass(const char *className)
{
    return FindWindowA(className, NULL);
}

// Function to get a window title
void GetWindowTitle(HWND hwnd, char *title, int size)
{
    GetWindowTextA(hwnd, title, size);
}

// Function to get the owner of a dialog
HWND GetDialogOwner(HWND hwndDialog)
{
    return GetWindow(hwndDialog, GW_OWNER);
}

// Function to send ESC key to a window
void SendEscapeKey(HWND hwnd)
{
    PostMessage(hwnd, WM_KEYDOWN, VK_ESCAPE, 0);
    PostMessage(hwnd, WM_KEYUP, VK_ESCAPE, 0);
}

int main()
{
    // Get the main window
    HWND hwndMain = GetWindowByClass(MAIN_CLASS_NAME);
    if (!hwndMain)
    {
        return 1; // Exit if main window not found
    }

    // Verify the main window title
    char mainTitle[256];
    GetWindowTitle(hwndMain, mainTitle, sizeof(mainTitle));
    if (strcmp(mainTitle, MAIN_WINDOW_TITLE) != 0)
    {
        return 1; // Exit if title does not match
    }

    while (1)
    {
        // Find the first dialog window
        HWND hwndDialog = GetWindowByClass(DIALOG_CLASS_NAME);
        if (!hwndDialog)
        {
            return 0; // Exit if no dialogs exist
        }

        // Get the owner of the dialog
        HWND hwndOwner = GetDialogOwner(hwndDialog);
        char ownerTitle[256];
        GetWindowTitle(hwndOwner, ownerTitle, sizeof(ownerTitle));

        // Check if the owner is the main application window
        if (strcmp(ownerTitle, MAIN_WINDOW_TITLE) == 0)
        {
            SetForegroundWindow(hwndDialog);
            Sleep(20);
            SendEscapeKey(hwndDialog); // Send ESC to close it
        }

        Sleep(50); // Wait 50ms before checking again
    }

    return 0;
}
