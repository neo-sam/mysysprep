$pkgfile = Get-PackageFile "PowerShell-*-win-x64.msi"
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name   = 'PowerShell Core'
        target = 'C:\Program Files\PowerShell\*\pwsh.exe'
        mutex  = 1
    }
}

Start-Process $pkgfile -PassThru '/qb /norestart',
'ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1',
'ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1',
'/l*v logs\powershell.log' |
Wait-Process

$target = "$(mkdir -f "$([Environment]::GetFolderPath("MyDocuments"))\PowerShell")\Microsoft.PowerShell_profile.ps1"
if (!(Test-Path $target)) {
    Copy-Item "$pkgCfgFolder\profile.ps1" $target
}

if ($isAdmin) {
    Copy-Item $target "$(mkdir -f 'C:\Users\Default\Documents\PowerShell')\Microsoft.PowerShell_profile.ps1"
}
