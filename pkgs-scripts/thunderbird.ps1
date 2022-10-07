$pkgfile = Get-PackageFile "Thunderbird Setup *.exe"
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name   = 'Thunderbird'
        target = 'C:\Program Files\Mozilla Thunderbird\thunderbird.exe'
    }
    return
}

Start-Process -PassThru $pkgfile /S | Wait-Process
