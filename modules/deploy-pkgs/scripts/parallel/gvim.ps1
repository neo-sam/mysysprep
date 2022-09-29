$pkgfile = Get-PackageFile "gvim*.exe"
if (!$PSSenderInfo) { 
    if ($pkgfile) { 'gVim' }
    return 
}

Start-Process -PassThru $pkgfile /S | Wait-Process

Assert-Path "C:\Program Files (x86)\Vim\vim*\gvim.exe"