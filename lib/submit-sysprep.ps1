$cfg = $script:sysprep = @{}

. .\lib\load-env-with-cfg.ps1

Write-Output "==> Auto Sysprep Finished!"
if ($isAuditMode) {
    Write-Output 'Migrate config:',
    '- Desktop Icons',
    '- Others: softwares and config already existed ...'
    ''
    Read-Host  'Ready to generlize by Sysprep (will shutdown for image capture)?'

    Copy-Item -Force -Recurse "$([Environment]::GetFolderPath("Desktop"))\*" 'C:\Users\Default\Desktop'

    $unattendDoc = Get-Content .\lib\unattend.xml
    if ($cfg.oobeSkipEula) {
        $unattendDoc = $unattendDoc -replace '(?<=<HideEULAPage>).*?(?=</HideEULAPage>)', 'true'
    }
    if ($cfg.oobeSkipLoginMs) {
        $unattendDoc = $unattendDoc `
            -replace '(?<=<HideOnlineAccountScreens>).*?(?=</HideOnlineAccountScreens>)', 'true'`
            -replace '(?<=<HideWirelessSetupInOOBE>).*?(?=</HideWirelessSetupInOOBE>)', 'true'
    }
    $unattendDoc | Out-File -Force -Encoding utf8 C:\Windows\Panther\unattend.xml

    Stop-Process -Name sysprep -ea 0
    & C:\Windows\System32\Sysprep\sysprep.exe /generalize /oobe /shutdown
}
else {
    Read-Host
}
