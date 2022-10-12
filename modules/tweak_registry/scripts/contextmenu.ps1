param(
    $disableWin11NewStyle
)

if ([Environment]::OSVersion.Version.Build -ge 22000) {
    if ($disableWin11NewStyle) {
        $Script:msg = Get-Translation 'disabled win11 new style'`
            -base64cn 56aB55SoIFdpbjExIOagt+W8jwo=

        reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve 2>&1 >$null
        logif1
    }
    else {
        $Script:msg = Get-Translation 'enabled win11 new style'`
            -base64cn 5r+A5rS7IFdpbjExIOagt+W8jwo=

        reg.exe delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /va /f 2>&1 >$null
        logif1
    }
}
