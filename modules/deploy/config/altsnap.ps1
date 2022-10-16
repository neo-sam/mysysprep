$env:__COMPAT_LAYER = "RunAsInvoker"
Start-Process 'C:\Users\Public\install-altsnap.exe' /S -PassThru | Wait-Process

Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' AltSnap "`"$env:APPDATA\AltSnap\AltSnap.exe`""

@"
; config here
"@ > "$env:APPDATA\AltSnap\AltSnap.ini"

& "$env:APPDATA\AltSnap\AltSnap.exe"
