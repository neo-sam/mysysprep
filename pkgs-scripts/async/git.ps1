$pkgfile = Get-PackageFile "Git-*-64-bit.exe"
if (!$PSSenderInfo) {
    if ($pkgfile) { 'Git' }
    return
}

Start-Process $pkgfile '/LOADINF=pkgs-cfg/git.ini /SILENT /SUPPRESSMSGBOXES /NORESTART /SP-' -PassThru | Wait-Process

Assert-Path "C:\Program Files\Git\cmd\git.exe"
Push-SystemPath "C:\Program Files\Git\bin"
