$script:sysprep = @{}

. .\lib\load-env-with-cfg.ps1
. .\lib\load-commonfn.ps1

Write-Output "==> Auto Sysprep Finished!"
if ($isAuditMode) {
    $firstrun = Get-Content '.\lib\assets\firstrun.ps1'
    $firstrun += "`n"
    foreach ($flag in $sysprep.firstrun) {
        $firstrun += "$flag`n"
    }
    $firstrun > 'C:\Users\Public\firstrun.ps1'

    $unattendDoc = Get-Content '.\lib\assets\unattend.xml'
    if ($script:sysprep.oobeSkipEula) {
        $unattendDoc = $unattendDoc -replace '(?<=<HideEULAPage>).*?(?=</HideEULAPage>)', 'true'
    }
    if ($script:sysprep.oobeSkipLoginMs) {
        $unattendDoc = $unattendDoc `
            -replace '(?<=<HideOnlineAccountScreens>).*?(?=</HideOnlineAccountScreens>)', 'true'`
            -replace '(?<=<HideWirelessSetupInOOBE>).*?(?=</HideWirelessSetupInOOBE>)', 'true'
    }
    $unattendDoc | Out-File -Force -Encoding utf8 C:\Windows\Panther\unattend.xml

    if ($Host.UI.PromptForChoice('', 'Reboot now?', @('&Yes', '&No'), 0) -eq 0) {
        Restart-Computer -Force
    }
}
else {
    reg.exe unload HKLM\NewUser 2>&1 >$null
    Read-Host 'Press Enter to Close ...'
}
