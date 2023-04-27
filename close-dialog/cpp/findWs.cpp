#include <windows.h>
#include <string>
#define BTN_ENUMERATE 32001
 
/*  Declare Windows procedure  */
LRESULT CALLBACK WindowProcedure (HWND, UINT, WPARAM, LPARAM);
BOOL CALLBACK Enumerating(HWND hwnd,LPARAM lParam);
HWND controls[2];
std::string container;
 
/*  Make the class name into a global variable  */
char szClassName[ ] = "WindowsApp";
 
int WINAPI WinMain (HINSTANCE hThisInstance,
                    HINSTANCE hPrevInstance,
                    LPSTR lpszArgument,
                    int nFunsterStil)
 
{
    HWND hwnd;              /* This is the handle for our window */
    MSG messages;           /* Here messages to the application are saved */
    WNDCLASSEX wincl;       /* Data structure for the windowclass */
 
    /* The Window structure */
    wincl.hInstance = hThisInstance;
    wincl.lpszClassName = szClassName;
    wincl.lpfnWndProc = WindowProcedure;    /* This function is called by windows */
    wincl.style = CS_DBLCLKS;               /* Catch double-clicks */
    wincl.cbSize = sizeof (WNDCLASSEX);
 
    /* Use default icon and mouse-pointer */
    wincl.hIcon = LoadIcon (NULL, IDI_APPLICATION);
    wincl.hIconSm = LoadIcon (NULL, IDI_APPLICATION);
    wincl.hCursor = LoadCursor (NULL, IDC_ARROW);
    wincl.lpszMenuName = NULL;              /* No menu */
    wincl.cbClsExtra = 0;                   /* No extra bytes after the window class */
    wincl.cbWndExtra = 0;                   /* structure or the window instance */
    /* Use Windows's default color as the background of the window */
    wincl.hbrBackground = (HBRUSH) COLOR_BACKGROUND;
 
    /* Register the window class, and if it fails quit the program */
    if (!RegisterClassEx (&wincl))
        return 0;
 
    /* The class is registered, let's create the program*/
    hwnd = CreateWindowEx (
           0,                   /* Extended possibilites for variation */
           szClassName,         /* Classname */
           "Windows App",       /* Title Text */
           WS_OVERLAPPEDWINDOW, /* default window */
           CW_USEDEFAULT,       /* Windows decides the position */
           CW_USEDEFAULT,       /* where the window ends up on the screen */
           544,                 /* The programs width */
           375,                 /* and height in pixels */
           HWND_DESKTOP,        /* The window is a child-window to desktop */
           NULL,                /* No menu */
           hThisInstance,       /* Program Instance handler */
           NULL                 /* No Window Creation data */
           );
 
    /* Make the window visible on the screen */
    ShowWindow (hwnd, nFunsterStil);
 
    /* Run the message loop. It will run until GetMessage() returns 0 */
    while (GetMessage (&messages, NULL, 0, 0))
    {
        /* Translate virtual-key messages into character messages */
        TranslateMessage(&messages);
        /* Send message to WindowProcedure */
        DispatchMessage(&messages);
    }
 
    /* The program return-value is 0 - The value that PostQuitMessage() gave */
    return messages.wParam;
}
 
 
/*  This function is called by the Windows function DispatchMessage()  */
 
LRESULT CALLBACK WindowProcedure (HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
    switch (message)                    /* handle the messages */
    {
        case WM_CREATE:
            controls[0]=CreateWindowEx(0,"Button","Enumerate",WS_CHILD|WS_VISIBLE,3,3,100,23,
                hwnd,(HMENU)BTN_ENUMERATE,GetModuleHandle(NULL),NULL);
            controls[1]=CreateWindowEx(0,"Edit","",WS_CHILD|WS_VISIBLE|WS_BORDER|ES_MULTILINE|
                ES_AUTOVSCROLL|ES_AUTOHSCROLL,3,29,531,317,hwnd,NULL,GetModuleHandle(NULL),NULL);
            break;
        case WM_COMMAND:
            switch(wParam){
                case BTN_ENUMERATE:
                    container.clear();
                    EnumWindows(Enumerating,0);
                    SetWindowText(controls[1],container.c_str());
                    break;
            }
            break;
        case WM_DESTROY:
            PostQuitMessage (0);        /* send a WM_QUIT to the message queue */
            break;
        default:                        /* for messages that we don't deal with */
            return DefWindowProc (hwnd, message, wParam, lParam);
    }
 
    return 0;
}
 
BOOL CALLBACK Enumerating(HWND hwnd,LPARAM lParam){
    char temp[256];
    GetWindowText(hwnd,temp,256);
    container.insert(container.length(),"Caption: ");
    container.insert(container.length(),temp);
    container.insert(container.length(),"; Classname: ");
    GetClassName(hwnd,temp,256);
    container.insert(container.length(),temp);
    container.insert(container.length(),"\r\n");
    return true;
}