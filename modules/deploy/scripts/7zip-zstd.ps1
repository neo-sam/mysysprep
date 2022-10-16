$pkgfile = Get-PackageFile "7z*-zstd-x64.exe"
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name   = '7zip-zstd'
        target = 'C:\Program Files\7-Zip-Zstandard\7z.exe'
    }
}

Start-Process $pkgfile /S -PassThru | Wait-Process

Push-SystemPath "C:\Program Files\7-Zip-Zstandard"
