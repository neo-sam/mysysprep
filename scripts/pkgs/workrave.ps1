$pkgfile = Get-PackageFile "workrave-win32-v*.exe"
if (!$PSSenderInfo) { 
    if ($pkgfile) { 'Workrave' }
    return 
}

Start-Process $pkgfile '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' -PassThru | Wait-Process

Assert-Path "C:\Program Files (x86)\Workrave\lib\Workrave.exe"

reg add 'HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers' /f /t REG_SZ /v 'C:\Program Files (x86)\Workrave\lib\Workrave.exe' /d '~ HIGHDPIAWARE'>$null
