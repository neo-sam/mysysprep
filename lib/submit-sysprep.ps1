$cfg = $script:sysprepCfg = @{
    oobe = @{
        skipEula    = 0
        skipMsLogin = 0
    }
}

. .\lib\load-env-with-cfg.ps1

Write-Output "==> Auto Sysprep Finished!"
if ($isAuditMode) {
    Read-Host  'Ready to generlize by Sysprep (will shutdown for image capture)?'

    $unattendDoc = Get-Content .\lib\unattend.xml
    if ($cfg.oobe.skipEula) {
        $unattendDoc = $unattendDoc -replace '(?<=<HideEULAPage>).*?(?=</HideEULAPage>)', 'true'
    }
    if ($cfg.oobe.skipMsLogin) {
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
