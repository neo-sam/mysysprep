$pkgfile = Get-PackageFile "Git-*-64-bit.exe"
if (!$PSSenderInfo) {
    if ($pkgfile) { 'Git' }
    return
}

Start-Process $pkgfile '/LOADINF=pkgs-config/git.ini /SILENT /SUPPRESSMSGBOXES /NORESTART /SP-' -PassThru | Wait-Process

Assert-Path "C:\Program Files\Git\cmd\git.exe"
Push-SystemPath "C:\Program Files\Git\bin"

if (!(Test-Path "$env:USERPROFILE\.minttyrc")) {
    Copy-Item '.\pkgs-config\.minttyrc' $env:USERPROFILE
}
