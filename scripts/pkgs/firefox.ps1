$pkgfile = Get-PackageFile "Firefox Setup *.exe"
if (!$PSSenderInfo) { 
    if ($pkgfile) { 'Firefox' }
    return 
}

Start-Process $pkgfile /S -PassThru | Wait-Process

Assert-Path "$env:ProgramFiles\Mozilla Firefox\firefox.exe"
