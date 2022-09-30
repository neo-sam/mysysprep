if ($removeCapabilityPowershellISE) {
    dism /online /norestart /remove-capability /capabilityname:Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0 > $null
    if ($?) { Write-Output 'Removed capability PowerShell ISE.' }
}

if ($removeCapabilityWordpad) {
    dism /online /norestart /remove-capability /capabilityname:Microsoft.Windows.WordPad~~~~0.0.1.0 > $null
    if ($?) { Write-Output 'Removed capability WordPad.' }
}
