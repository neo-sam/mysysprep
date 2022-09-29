$pkgfile = Get-PackageFile "virtualbox-Win-latest.exe"

Start-Process $pkgfile '-s -l -msiparams REBOOT=ReallySuppress' -PassThru | Wait-Process

Assert-Path "C:\Program Files\Oracle\VirtualBox\VirtualBox.exe"
