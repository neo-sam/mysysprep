$pkg = Get-ChildItem -ea 0 'virtualbox-*win*.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'VirtualBox'
        target = 'C:\Program Files\Oracle\VirtualBox\VirtualBox.exe'
        mutex  = 1
    }
    return
}

Start-Process $pkg '--silent' -PassThru | Wait-Process

Push-SystemPath "C:\Program Files\Oracle\VirtualBox"
