$pkg = Get-ChildItem -ea 0 'ImDiskTk-x64.zip'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'imdisk'
        target = 'C:\Program Files\ImDisk\config.exe'
    }
}

Expand-Archive -Force $pkg $(mkdir -f tmp)

Start-Process -PassThru extrac32.exe "/e /y /l tmp/imdisk_files $(Get-ChildItem 'tmp\ImDiskTk*\files.cab')" | Wait-Process
Start-Process -PassThru '.\tmp\imdisk_files\config.exe' '/fullsilent',
'/discutils:1', '/ramdiskui:1', '/menu_entries:0',
'/shortcuts_desktop:0' , '/shortcuts_all:0' |
Wait-Process

Move-Item "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\ImDisk" 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs'

foreach ($_ in @("config", "MountImg", "RamDiskUI")) {
    Set-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers' "C:\Program Files\ImDisk\$_.exe" '~ HIGHDPIAWARE'
}
