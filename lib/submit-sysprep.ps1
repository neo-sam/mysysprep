$script:sysprep = @{}

. .\lib\load-env-with-cfg.ps1
. .\lib\load-commonfn.ps1

Write-Output "==> Auto Sysprep Finished!"
if ($isAuditMode) {
    Write-Output (
        Get-Translation ('Migrate config:',
            '- Desktop Icons',
            '- Others: softwares and config already existed ...',
            '',
            'Ready to generlize by Sysprep? (will shutdown for image capture if press enter) ' -join "`n"
        ) -base64cn @'
        5qOA5p+l6YWN572u77yaCi0g5qGM6Z2i5Zu+5qCHCi0g5YW25a6D77ya6L2v5Lu25ZKM6YWN572u
        Cgrlh4blpIflpb3lsIHoo4Xns7vnu5/kuoblkJfvvJ8o5oyJ5LiLIEVudGVyIOmUruWFs+acuuWw
        geijhSkgCg==
'@
    )
    Read-Host

    Copy-Item -Force -Recurse "$([Environment]::GetFolderPath("Desktop"))\*" 'C:\Users\Default\Desktop'

    Copy-Item -Force (Get-Translation '.\lib\newdesktop\README.txt' `
            -base64cn LlxsaWJcbmV3ZGVza3RvcFzms6jmhI/kuovpobkudHh0Cg==
    ) 'C:\Users\Default\Desktop'

    $unattendDoc = Get-Content .\lib\unattend.xml

    if ($script:sysprep.oobeSkipEula) {
        $unattendDoc = $unattendDoc -replace '(?<=<HideEULAPage>).*?(?=</HideEULAPage>)', 'true'
    }
    if ($script:sysprep.oobeSkipLoginMs) {
        $unattendDoc = $unattendDoc `
            -replace '(?<=<HideOnlineAccountScreens>).*?(?=</HideOnlineAccountScreens>)', 'true'`
            -replace '(?<=<HideWirelessSetupInOOBE>).*?(?=</HideWirelessSetupInOOBE>)', 'true'
    }
    $unattendDoc | Out-File -Force -Encoding utf8 C:\Windows\Panther\unattend.xml

    Stop-Process -Name sysprep -ea 0
    & 'C:\Windows\System32\Sysprep\sysprep.exe' /generalize /oobe /shutdown
}
else {
    reg.exe unload HKLM\NewUser 2>&1 >$null
    Read-Host
}
