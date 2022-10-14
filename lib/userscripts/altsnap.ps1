$env:__COMPAT_LAYER = "RunAsInvoker"
Start-Process 'C:\Users\Public\install-altsnap.exe' /S -PassThru | Wait-Process

Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' AltSnap "`"$env:APPDATA\AltSnap\AltSnap.exe`""

@"
[General]
AutoFocus=1
MDI=0
MoveTrans=222
Language=en-US
[Advanced]
ResizeAll=0
FullScreen=0
[Input]
LMB=Move
LMBB=Resize
RMB=Resize
RMBB=Menu
MMB=Menu
MMBB=Close
MMBT=Close
Hotkeys=5B
ModKey=A0
TTBActions=2
ScrollT=Nothing
[Blacklist]
Processes=Virtual PC.exe,StartMenuExperienceHost.exe,SearchApp.exe,osk.exe,mstsc.exe
"@ > "$env:APPDATA\AltSnap\AltSnap.ini"

& "$env:APPDATA\AltSnap\AltSnap.exe"
