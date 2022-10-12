$pkgfile = Get-PackageFile "Firefox Setup *.exe"
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name   = 'Firefox'
        target = 'C:\Program Files\Mozilla Firefox\firefox.exe'
    }
}

Start-Process $pkgfile /S -PassThru | Wait-Process

if ($cfg.devbookDocLink) {
    New-DevbookDocShortcut Firefox docs/goodsoft/firefox/setup
}
