Add-Type -AssemblyName PresentationFramework

$reponse = [System.Windows.MessageBox]::Show(
    'Please update to PowerShell 5 on Windows 7!',
    'PowerShell Version is too old',
    'OK', 'Warning'
)

if ($reponse -eq 'OK') {
    if (!(Test-Path ($it = 'HKLM:\Software\Classes\.md'))) {
        Set-Item (mkdir -f $it).PSPath "md_auto_file"
        Set-Item (
            mkdir -f "HKLM:\Software\Classes\md_auto_file\shell\edit\command"
        ).PSPath "`"C:\Windows\system32\notepad.exe`" `"%1`""
    }
    Start-Process .\win7
}
