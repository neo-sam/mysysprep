#Requires -RunAsAdministrator
$pkg = Get-ChildItem -ea 0 'PowerShell-*-win-x64.msi'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'PowerShell Core'
        target = 'C:\Program Files\PowerShell\*\pwsh.exe'
        mutex  = 1
    }
}

Start-Process -Wait $pkg '/qb /norestart',
'ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1',
'ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1',
'/l*v log\powershell.log'

# CUSTOM:

@"
if (Test-Path 'C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1') {
    . 'C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1'
}
Set-PSReadLineOption -PredictionSource History
"@ > "$((Get-ChildItem 'C:\Program Files\PowerShell\*')[-1].FullName)\profile.ps1"
