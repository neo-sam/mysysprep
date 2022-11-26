#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'PowerShell-*-win-x64.msi'

if ($GetMetadata) {
    return @{
        name   = 'PowerShell Core'
        match  = $match
        mutex  = $true
        ignore = Get-BooleanReturnFn (Test-Path 'C:\Program Files\PowerShell\*\pwsh.exe')
    }
}

Start-Process -Wait $match '/qb /norestart',
'ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1',
'ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1',
'/l*v logs\powershell.log'

# CUSTOM:

@"
if (Test-Path 'C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1') {
    . 'C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1'
}
Set-PSReadLineOption -PredictionSource History
"@ | Out-File -Encoding oem "$((Get-ChildItem 'C:\Program Files\PowerShell\*')[-1].FullName)\profile.ps1"
