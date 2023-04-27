#include <windows.h>

#pragma comment(lib, "user32.lib")


int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
               PWSTR szCmdLine, int CmdShow) {

    static const char DIALOG_CLASS[] = "#32770";

    HWND FindWindowA(   LPCSTR(L"#32770"),    [in, optional] LPCSTR lpWindowName
    );

    MessageBoxW(NULL, szCmdLine, L"Title", MB_OK);

    return 0;
}