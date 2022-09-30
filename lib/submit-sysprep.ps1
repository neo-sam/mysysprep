$isAuditMode = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State' -ErrorAction Ignore).ImageState -eq 'IMAGE_STATE_SPECIALIZE_RESEAL_TO_AUDIT'

Write-Output "==> Auto Sysprep Finished!"
if ($isAuditMode) {
    Write-Output "==> Sysprep"
    Read-Host  'Ready to generlize by Sysprep (will shutdown for image capture)?'

    $unattendDoc = Get-Content .\lib\unattend.xml
    if ($oobeSkipEula) {
        $unattendDoc = $unattendDoc -replace '(?<=<HideEULAPage>).*?(?=</HideEULAPage>)', 'true'
    }
    if ($oobeSkipMsLogin) {
        $unattendDoc = $unattendDoc `
            -replace '(?<=<HideOnlineAccountScreens>).*?(?=</HideOnlineAccountScreens>)', 'true'`
            -replace '(?<=<HideWirelessSetupInOOBE>).*?(?=</HideWirelessSetupInOOBE>)', 'true'
    }
    $unattendDoc | Out-File -Force C:\Windows\Panther\unattend.xml

    & C:\Windows\System32\Sysprep\sysprep.exe /generalize /oobe /shutdown
}
else {
    Read-Host
}
