$pkgfile = Get-PackageFile "Cyberduck-Installer-*.exe"
if (!$PSSenderInfo) { 
    if ($pkgfile) { 'Cyberduck' }
    return 
}

Start-Process $pkgfile /quiet -PassThru | Wait-Process

Assert-Path "$env:ProgramFiles\Cyberduck\Cyberduck.exe"
