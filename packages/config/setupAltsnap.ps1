param([switch]$NoHint)
$env:__COMPAT_LAYER = "RunAsInvoker"
$it = Get-ChildItem -ea 0 "$PSScriptRoot\..\userpkgs\AltSnap*-x64-inst.exe"
if ($it.count -ne 1) {
    Write-Error 'Task Crash!'
    [System.Console]::ReadKey()>$null
    exit
}

Start-Process -Wait $it.FullName '/NCRC /S'

Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' AltSnap "`"$env:APPDATA\AltSnap\AltSnap.exe`""

@"
; config here
"@ | Out-File -Encoding oem "$env:APPDATA\AltSnap\AltSnap.ini"

Copy-Item "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\AltSnap.lnk" ([Environment]::GetFolderPath('Desktop'))

if (!$NoHint) {
    Write-Host -ForegroundColor Green 'AltSnap installed!'
    Write-Output 'Launch it and hold `Windows Key + Mouse Action` on windows to use.'
    Pause
}