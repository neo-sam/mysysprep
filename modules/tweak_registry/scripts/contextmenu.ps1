param(
    $disableWin11NewStyle
)

if ([Environment]::OSVersion.Version.Build -ge 22000) {
    if ($disableWin11NewStyle) {
        reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve 2>&1 >$null
        Write-Output '[contextmenu] disabled win11 new style'
    }
    else {
        reg.exe delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /va /f 2>&1 >$null
        Write-Output '[contextmenu] enabled win11 new style'
    }
}
