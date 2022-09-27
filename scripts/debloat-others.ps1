.\_adminrequire.ps1

Write-Host '==> Debloat Others'

if ($removePowershellISE) {
    dism /online /norestart /remove-capability /capabilityname:Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0 > $null
    if ($?) { Write-Host 'removed PowerShell ISE' }
}

if ($removeWordpad) {
    dism /online /norestart /remove-capability /capabilityname:Microsoft.Windows.WordPad~~~~0.0.1.0
    if ($?) { Write-Host 'removed WordPad' }
}

if ($removeOneDrive) {
    if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") { 
        & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall 
        $removingOneDrive = 1
    }
    if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
        & "$env:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall 
        $removingOneDrive = 1
    }
    if ($removingOneDrive) {
        Wait-Process OneDriveSetup
        Write-Host 'removed OneDrive'
    }
}