#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'Thunderbird Setup *.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'Thunderbird'
        target = 'C:\Program Files\Mozilla Thunderbird\thunderbird.exe'
    }
    return
}

Start-Process -PassThru $pkg /S | Wait-Process
