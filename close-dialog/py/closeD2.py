import win32api, win32con,win32gui,time,sys,re

nonefound = False

def printwin( prefix, hwnd):
    if win32gui.IsWindowVisible( hwnd ):
        print ( prefix, '\t', hex( hwnd ), '\t', win32gui.GetWindowText( hwnd ) , '\t', win32gui.GetClassName(hwnd), '\t', win32gui.IsWindowVisible(hwnd))


def closeW(hwnd ):
   
    nonefound = False

    if not win32gui.IsWindowVisible( hwnd ):
        printwin ('Not Visable ' , hwnd)    
        return

    if not win32gui.IsWindowEnabled(hwnd):
        printwin ('Not Enabled ' , hwnd)    
        return

    # bring window to foreground
    win32gui.SetForegroundWindow(hwnd)

    # send click to "reconnect button"
    win32api.PostMessage(hwnd, win32con.WM_LBUTTONDOWN, 0, 0)
    win32api.PostMessage(hwnd, win32con.WM_LBUTTONUP, 0, 0)    

    printwin ('Closed ' , hwnd)


def processButtons(hwnd, ctx ):

    if  win32gui.GetWindowText( hwnd ) != 'OK':
        return

    closeW(hwnd)


def findButton(hwnd):
    nonefound = True
    try:            
        win32gui.CloseWindow(hwnd)
    except:
        # some error
        printwin('Just Close', hwnd) 

    if not win32gui.IsWindowVisible( hwnd ):
        printwin ('Not Visable parent' , hwnd)    
        return

    if not win32gui.IsWindowEnabled(hwnd):
        printwin ('Not Enabled parent' , hwnd)    
        return

    try:
        win32gui.EnumChildWindows(hwnd, processButtons , 'Button')
    except SystemError as syserr:
        print(type(inst))    # the exception instance
        print(inst.args)     # arguments stored in .args
        print(inst)          # __str__ allows args to be printed directly,
                            # but may be overridden in exception subclasses
        for x in inst.args:
            print(x)

    except Exception as inst:
        # some error
        printwin('Exception finding Button', hwnd) 

ERR_DIALOG = '#32770'

def findDialog():
    

    titleText='Speakonia - CFS-Technologies'
    hwnd = win32gui.FindWindow(ERR_DIALOG,  titleText)

    if hwnd == 0:
        return

    dclass = win32gui.GetClassName(hwnd)


    if dclass == 'TApplication':
        printwin('Program Window', hwnd)
        return

    if dclass == 'TfrmMain':
        printwin('Fram main Window', hwnd)
        return

    if dclass != ERR_DIALOG:
        return
        
    findButton(hwnd)


def winEnumHandler( hwnd, ctx ):
    printwin( 'All', hwnd)
   

def main():

    win32gui.EnumWindows( winEnumHandler, None )
    
    pass = 4

    while(pass > 0):
        findDialog();
        if nonefound:
            time.sleep(3) # Sleep for 10 seconds
            pass = pass - 1
        else:
            time.sleep(0.01) # Sleep for 1 second
    

if __name__ == "__main__":
    main()