$pkg = Get-ChildItem -ea 0 'PowerShell-*-win-x64.msi'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'PowerShell Core'
        target = 'C:\Program Files\PowerShell\*\pwsh.exe'
        mutex  = 1
    }
}

Start-Process $pkg -PassThru '/qb /norestart',
'ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1',
'ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1',
'/l*v log\powershell.log' |
Wait-Process

if (Test-Path ($it = 'config\profile.ps1')) {
    if (!(Test-Path ($that = "$(mkdir -f "$([Environment]::GetFolderPath("MyDocuments"))\PowerShell")\Microsoft.PowerShell_profile.ps1"))) {
        Copy-Item $it $that
    }
    Copy-Item $it "$(mkdir -f 'C:\Users\Default\Documents\PowerShell')\Microsoft.PowerShell_profile.ps1"
}
