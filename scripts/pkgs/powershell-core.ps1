$pkgfile = Get-PackageFile "PowerShell-*-win-x64.msi"
if (!$PSSenderInfo) { 
    if ($pkgfile) { 'PowerShell Core' }
    return 
}

Start-Process $pkgfile '/q /norestart /l*v logs\powershell.log ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1' -PassThru | Wait-Process

Assert-Path "$env:ProgramFiles\PowerShell\*\pwsh.exe"