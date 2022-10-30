#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 '7z*-zstd-x64.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = '7zip-zstd'
        target = 'C:\Program Files\7-Zip-Zstandard\7z.exe'
    }
}

Start-Process -Wait $pkg /S

Push-SystemPath 'C:\Program Files\7-Zip-Zstandard'
