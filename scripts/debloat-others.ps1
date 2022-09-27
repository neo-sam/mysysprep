. .\_adminrequire.ps1

Write-Host '==> Debloat Others'

if ($removePowershellISE) {
    dism /online /norestart /remove-capability /capabilityname:Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0 > $null
    if ($?) { Write-Host 'Removed PowerShell ISE.' }
}

if ($removeWordpad) {
    dism /online /norestart /remove-capability /capabilityname:Microsoft.Windows.WordPad~~~~0.0.1.0 > $null
    if ($?) { Write-Host 'Removed WordPad.' }
}
