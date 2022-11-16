. .\lib\base.ps1

& .\lib\applyNewPinnedTaskbar.ps1
if ($isAuditMode) { & .\lib\makeUnattendXmlFile.ps1 }

if (Test-Path 'C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1') {
    try { Set-ExecutionPolicy -Scope LocalMachine RemoteSigned -Force }
    catch [System.Security.SecurityException] {}
}

.\lib\submitNewUserRegistry.ps1

Write-Output '', '==> [win-sf] FINISHED!'

Add-Type -AssemblyName PresentationFramework
if ($isAuditMode) {
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

[Console]::ReadKey()>$null
