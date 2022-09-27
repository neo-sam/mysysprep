$pkgfile = Get-PackageFile "Everything-*.x64.Lite-Setup.exe"
if (!$PSSenderInfo) { 
    if ($pkgfile) { 'Everything' }
    return 
}

Start-Process $pkgfile /S -PassThru | Wait-Process

Assert-Path "$env:ProgramFiles\Everything\Everything.exe"
