#-*-coding:utf-8-*-
import win32con,win32gui,time,sys,re


def checkClose():
    window='Speakonia - CFT-Technologies'
    hn=win32gui.FindWindow(None, window) 
    errorbox=win32gui.FindWindowEx(window,None,'Speakonia - CFT-Technologies',None)
    win32gui.PostMessage(errorbox,win32con.WM_CLOSE,0,0)


def main():
    while(1==0):
        checkClose();
        time.sleep(37) # Sleep for 37 seconds


if __name__ == "__main__":
    main()