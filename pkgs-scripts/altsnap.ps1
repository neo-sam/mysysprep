$pkgfile = Get-PackageFile "AltSnap*-x64-inst.exe"
if (!$PSSenderInfo) {
    if ($pkgfile) { 'AltSnap', 'userlevel' }
    return
}

$env:__COMPAT_LAYER = 'RunAsInvoker'
Start-Process $pkgfile /S -PassThru | Wait-Process

Assert-Path "$env:APPDATA\AltSnap\AltSnap.exe"

. .\lib\mount-defaultregistry.ps1

foreach ($regkey in @('HKCU', 'HKLM\NewUser')) {
    reg add $regkey\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /f /t REG_SZ /v AltSnap /d "`"`"`"$env:APPDATA\AltSnap\AltSnap.exe`"`"`"" >$null
}

if ($cfg.useAltsnapConfig) {
    $cfgfile = "$env:APPDATA\AltSnap\AltSnap.ini"
    $cfgtext = (Get-cfgtext $cfgfile) `
        -replace '(?<=AutoFocus=)0$', '1'  `
        -replace '(?<=MDI=)1$', '0' `
        -replace '(?<=ResizeAll=)1$', '0' `
        -replace '(?<=MoveTrans=)255$', '222' `
        -replace '(?<=FullScreen=)1$', '0' `
        -replace '(?<=Hotkeys=)A5 A4$', '5B' `
        -replace '(?<=ModKey=)$', 'A0' `
        -replace '(?<=TTBActions=)0$', '2' `
        -replace '(?<=MMBT=)Lower$', 'Close' `
        -replace '(?<=ScrollT=)Roll$', 'Nothing' `
        -replace '(?<=Processes=.+)$', ',mstsc.exe'
    if ((Get-WinSystemLocale).Name -eq 'zh-CN') {
        $cfgtext = $cfgtext -replace '(?<=Language=)en-US$', 'zh-CN'
    }
    $cfgtext > $cfgfile
    Copy-Item -Force $cfgfile (mkdir -f 'C:\Users\Default\AppData\Roaming\AltSnap')
}
