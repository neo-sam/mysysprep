param(
    $powershell_ise,
    $wordpad
)

$verb = Get-Translation 'removed capability' `
    -base64cn 5Yig6Zmk5Yqf6IO9Cg==

if ($powershell_ise -and (
        Test-Path 'C:\windows\system32\WindowsPowerShell\v1.0\powershell_ise.exe'
    )
) {
    $Script:msg = "$verb PowerShell ISE"

    dism /online /norestart /remove-capability /quiet '/capabilityname:Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0'
    logif1
}

if ($wordpad -and (
        Test-Path 'C:\Program Files\Windows NT\Accessories\wordpad.exe'
    )) {
    $Script:msg = "$verb WordPad"

    dism /online /norestart /remove-capability /quiet '/capabilityname:Microsoft.Windows.WordPad~~~~0.0.1.0'
    logif1
}
