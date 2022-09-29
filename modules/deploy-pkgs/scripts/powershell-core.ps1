$pkgfile = Get-PackageFile "PowerShell-*-win-x64.msi"

Start-Process $pkgfile '/q /norestart /l*v logs\powershell.log ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1' -PassThru | Wait-Process

Assert-Path "C:\Program Files\PowerShell\*\pwsh.exe"
