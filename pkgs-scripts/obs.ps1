$pkgfile = Get-PackageFile "OBS-Studio-*-Full-Installer-x64.exe"
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name   = 'OBS'
        target = 'C:\Program Files\obs-studio\bin\64bit\obs64.exe'
    }
}

Start-Process -PassThru $pkgfile /S | Wait-Process
