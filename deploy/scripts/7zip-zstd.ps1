#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 '7z*-zstd-*.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = '7zip-zstd'
        target = 'C:\Program Files\7-Zip-Zstandard\7z.exe'
    }
}

Start-Process -Wait $pkg /S

# CUSTOM:

Push-SystemPath 'C:\Program Files\7-Zip-Zstandard'

Import-RegFile config\7zip-zstd.reg
Set-ItemProperty (
    Get-CurrentAndNewUserPaths 'HKCU:\Software\7-Zip-Zstandard\Options'
) MenuIcons 1
