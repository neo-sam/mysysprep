$pkgfile = Get-PackageFile "7z*-zstd-x64.exe"
if (!$PSSenderInfo) { 
    if ($pkgfile) { '7zip-zstd' }
    return 
}

Start-Process $pkgfile /S -PassThru | Wait-Process

Assert-Path "C:\Program Files\7-Zip-Zstandard\7z.exe"
Push-SystemPath "C:\Program Files\7-Zip-Zstandard"
