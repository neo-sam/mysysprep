param(
    $disableWin11NewStyle
)

if ([Environment]::OSVersion.Version.Build -ge 22000) {
    if ($disableWin11NewStyle) {
        reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >$null
        logif1 'disabled Win11 new style.'
    }
    else {
        reg.exe delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /va /f >$null
        logif1 'enabled Win11 new style.'
    }
}
