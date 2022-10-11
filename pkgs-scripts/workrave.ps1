$pkgfile = Get-PackageFile "workrave-win32-v*.exe"
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name   = 'Workrave'
        target = 'C:\Program Files (x86)\Workrave\lib\Workrave.exe'
    }
}

Start-Process $pkgfile '/SILENT /SUPPRESSMSGBOXES /NORESTART /SP-' -PassThru | Wait-Process

Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' Workrave 'C:\Program Files (x86)\Workrave\lib\Workrave.exe'

reg add 'HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers' /f /t REG_SZ /v 'C:\Program Files (x86)\Workrave\lib\Workrave.exe' /d '~ HIGHDPIAWARE' >$null

if ($cfg.useWorkraveConfig) {
    applyRegfileForMeAndDefault ".\pkgs-config\prefer-workrave.reg"
}
