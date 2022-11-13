$env:__COMPAT_LAYER = "RunAsInvoker"
Start-Process -Wait 'install-altsnap.exe' '/NCRC /S'

# Remove desktop shortcut

Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' AltSnap "`"$env:APPDATA\AltSnap\AltSnap.exe`""

@"
; config here
"@ > "$env:APPDATA\AltSnap\AltSnap.ini"

& "$env:APPDATA\AltSnap\AltSnap.exe"

Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show(
    'Hold Windows Key + Mouse Action on windows to take effect!',
    'AltSnap installed!',
    'OK', 'Information'
)
