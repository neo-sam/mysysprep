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
        ) -cn ('检查配置：',
            '- 桌面图标',
            '- 其它：软件和配置',
            '',
            '准备好系统封装了吗？(按 Enter 键确认，将会关机)' -join "`n"
        )
    )
    Read-Host

    Copy-Item -Force -Recurse "$([Environment]::GetFolderPath("Desktop"))\*" 'C:\Users\Default\Desktop'

    Copy-Item -Force (Get-Translation '.\lib\newdesktop\README.txt' `
            -cn '.\lib\newdesktop\注意事项.txt'
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
