$pkgfile = Get-PackageFile "Git-*-64-bit.exe"
if (!$PSSenderInfo) { 
    if ($pkgfile) { 'Git' }
    return 
}

Start-Process $pkgfile '/LOADINF=appcfg/git.ini /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' -PassThru | Wait-Process

Assert-Path "C:\Program Files\Git\cmd\git.exe"
