$pkgfile = Get-PackageFile "OBS-Studio-*-Full-Installer-x64.exe"
if (!$PSSenderInfo) { 
    if ($pkgfile) { 'OBS' }
    return 
}

Start-Process -PassThru $pkgfile /S | Wait-Process

Assert-Path "C:\Program Files\obs-studio\bin\64bit\obs64.exe"