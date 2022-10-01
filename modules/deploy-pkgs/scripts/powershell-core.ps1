$pkgfile = Get-PackageFile "PowerShell-*-win-x64.msi"
if (!$PSSenderInfo) {
    if ($pkgfile) { 'PowerShell Core' }
    return
}

Start-Process $pkgfile -PassThru '/qb /norestart',
'ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1',
'ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1',
'/l*v logs\powershell.log' |
Wait-Process

Assert-Path "C:\Program Files\PowerShell\*\pwsh.exe"
