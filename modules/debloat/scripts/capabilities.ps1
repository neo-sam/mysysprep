param(
    $powershell_ise,
    $wordpad
)

if ($powershell_ise -and (
        Test-Path 'C:\windows\system32\WindowsPowerShell\v1.0\powershell_ise.exe'
    )
) {
    dism /online /norestart /remove-capability /quiet '/capabilityname:Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0'
    logif1 'removed capability PowerShell ISE.'
}

if ($wordpad -and (
        Test-Path 'C:\Program Files\Windows NT\Accessories\wordpad.exe'
    )
) {
    dism /online /norestart /remove-capability /quiet '/capabilityname:Microsoft.Windows.WordPad~~~~0.0.1.0'
    logif1 'removed capability WordPad.'
}
