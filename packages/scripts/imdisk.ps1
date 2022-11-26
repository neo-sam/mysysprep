#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'ImDiskTk-x64.zip'

if ($GetMetadata) {
    return @{
        name   = 'imdisk'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path 'C:\Program Files\ImDisk\config.exe')
    }
}

$tmpdir = "$(mkdir -f "$env:TMP\win-sf\imdisk")"

Expand-Archive -Force $match $(mkdir -f $tmpdir)

Start-Process -Wait extrac32.exe "/e /y /l $tmpdir/imdisk_files $(Get-ChildItem "$tmpdir\ImDiskTk*\files.cab")"
Start-Process -Wait "$tmpdir\imdisk_files\config.exe" '/fullsilent', `
    '/discutils:1', '/ramdiskui:1', '/menu_entries:0', `
    '/shortcuts_desktop:0' , '/shortcuts_all:0'

Move-Item "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\ImDisk" 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs'
icacls.exe 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ImDisk' /reset >$null

foreach ($_ in @("config", "MountImg", "RamDiskUI")) {
    Repair-HidpiCompatibility "C:\Program Files\ImDisk\$_.exe"
}
