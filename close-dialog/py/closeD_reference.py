#-*-coding:utf-8-*-
import win32api,win32con,win32gui,time,requests,sys,re

from ctypes import *
from lxml import etree

#reload(sys)
#sys.setdefaultencoding("utf-8")
#hea = {'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36' ,"Connection": "close"}
#requests.adapters.DEFAULT_RETRIES = 5
#proxies = {'http': 'http://127.0.0.1:1080',                       'https': 'http://127.0.0.1:1080'}

fa=win32api.GetSystemMetrics(0)/2
fb=win32api.GetSystemMetrics(1)/2


def Ping():
    try:
        html=requests.get("https://www.google.com", proxies=proxies,headers = hea)
    except:
        return 0
    else:
        return 1



def GetServer():
    while 1:
        html=requests.get('http://www.feixunvpn.com/page/testss.html',headers = hea)
        html.encoding = 'utf-8'
        html=html.text
        node=re.findall('<b>(.*?)</b>',html)
        node1=node[0][5:7]
        node2=node[1][5:7]
        ip=re.findall('<span>(.*?)</span>',html)
        ip1=repr(ip[7])[2:-1]
        ip2=repr(ip[9])[2:-1]
        ip3=''
        port=re.findall('端口：(.*?)<'.decode('utf-8'),html,re.S)
        port1=repr(port[0])[2:-1]
        port2=repr(port[1])[2:-1]
        port3=''
        password=re.findall('密码：(.*?)<'.decode('utf-8'),html,re.S)
        password1=repr(password[0])[2:-1]
        password2=repr(password[1])[2:-1]
        password3=''
        ip=[ip1,ip2,ip3]
        port=[port1,port2,port3]
        password=[password1,password2,password3]
        if node1=="新加":   # Added
            return ip[0],port[0],password[0]
        if node2=="新加":   # Added
            return ip[1],port[1],password[1]

def GetPos():
    ht=win32gui.FindWindow("Shell_TrayWnd",None)   #Get tray handle
    ht=win32gui.FindWindowEx(ht,None,'TrayNotifyWnd',None)
    ht=win32gui.FindWindowEx(ht,None,'SysPager',None)
    ht=win32gui.FindWindowEx(ht,None,'ToolbarWindow32',None)
    size=win32gui.GetWindowRect(ht)
    y=(size[1]+size[3])/2  #shadow socks  coordinate y
    dify=int((size[3]-size[1])/2/1.58)
    x=size[2]-dify
    return x,y


def mouse_dclick(x=None,y=None):   #Simulate a mouse double click
    if not x is None and not y is None:
        windll.user32.SetCursorPos(x, y)
    win32api.mouse_event(win32con.MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
    win32api.mouse_event(win32con.MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)
    win32api.mouse_event(win32con.MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
    win32api.mouse_event(win32con.MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)
    windll.user32.SetCursorPos(fa, fb)


def SetServer(Edit,Param):
    win32gui.SendMessage(Edit[0],win32con.WM_SETTEXT,None,Param[0])
    win32gui.SendMessage(Edit[1],win32con.WM_SETTEXT,None,Param[1])
    win32gui.SendMessage(Edit[2],win32con.WM_SETTEXT,None,Param[2]) #Send password
    win32gui.PostMessage(Edit[3], win32con.WM_LBUTTONDOWN, 0, 0)
    win32gui.PostMessage(Edit[3], win32con.WM_LBUTTONUP, 0, 0)


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