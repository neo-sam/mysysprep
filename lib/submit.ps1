. .\lib\loadModules.ps1
Import-Module ConfigLoader

.\lib\submitNewTaskbarLayout.ps1

if (Test-AuditMode) {
    & .\lib\submitNewUnattendFile.ps1
    if (!((Get-Process -ea 0 notepad).MainWindowTitle -join '').contains('unattend.xml')) {
        Start-Process -WindowStyle Minimized notepad.exe C:\Windows\Panther\unattend.xml
    }
}

.\lib\submitNewUserRegistry.ps1

Write-Output '', '==> FINISHED!'

Add-Type -AssemblyName PresentationFramework

if (Test-AuditMode) {
    if ('OK' -eq ([System.Windows.MessageBox]::Show(@'
Repository: https://github.com/setupfw/win-sf
Author: littleboyharry
Status: prepared
Blessing: have a nice day! ^_^

Confirm: start to SYSPREP.EXE now?
'@,
                'sysprep-go.ps1 | FINISHED!',
                'OKCancel', 'Warning'))
    ) {
        Stop-Process -Name explorer
        & 'C:\Windows\System32\Sysprep\Sysprep.exe' /oobe /generalize /shutdown
        exit
    }
}

if ('OK' -eq (
        [System.Windows.MessageBox]::Show('Restart File Explorer to finish?', 'sysprep-go.ps1',
            'OKCancel', 'Warning')
    )) {
    Stop-Process -Name explorer
}

Pause
