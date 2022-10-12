$pkgfile = Get-PackageFile "Everything-*.x64.Lite-Setup.exe"
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name   = 'Everything'
        target = 'C:\Program Files\Everything\Everything.exe'
    }
}

Start-Process $pkgfile /S -PassThru | Wait-Process

reg.exe add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Program Files\Everything\Everything.exe" /t REG_SZ /f /d "~ HIGHDPIAWARE" >$null

if ($cfgfile = Get-ChildItem '.\pkgs-config\Everything.ini' -ea 0) {
    Copy-Item $cfgfile "$env:APPDATA\Everything"

    Copy-Item -Force $cfgfile (mkdir -f 'C:\Users\Default\AppData\Roaming\Everything')
}
