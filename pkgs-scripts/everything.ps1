$pkgfile = Get-PackageFile "Everything-*.x64.Lite-Setup.exe"
if (!$PSSenderInfo) {
    if ($pkgfile) { 'Everything' }
    return
}

Start-Process $pkgfile /S -PassThru | Wait-Process

Assert-Path "C:\Program Files\Everything\Everything.exe"

if ($cfgfile = Get-ChildItem '.\pkgs-config\Everything.ini' -ErrorAction SilentlyContinue) {
    Copy-Item $cfgfile "$env:APPDATA\Everything"

    Copy-Item -Force $cfgfile (mkdir -f 'C:\Users\Default\AppData\Roaming\Everything')
}
