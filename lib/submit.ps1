. .\lib\load-config.ps1

Write-Output "==> Auto Sysprep Finished!"
if ((Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State' -ErrorAction Ignore
    ).ImageState -eq 'IMAGE_STATE_SPECIALIZE_RESEAL_TO_AUDIT'
) {
    if ($text = Get-Content '.\lib\assets\firstrun.ps1' -ea 0) {
        $text += "`n"
        foreach ($fnName in $unattend.firstrunFnList) {
            $text += "$fnName`n"
        }
        $text > 'C:\Users\Public\firstrun.ps1'
    }

    if ($text = Get-Content '.\lib\assets\unattend.xml' -ea 0) {
        if ($unattend.oobeSkipEula) {
            $text = $text -replace '(?<=<HideEULAPage>).*?(?=</HideEULAPage>)', 'true'
        }
        if ($unattend.oobeSkipLoginMs) {
            $text = $text `
                -replace '(?<=<HideOnlineAccountScreens>).*?(?=</HideOnlineAccountScreens>)', 'true'`
                -replace '(?<=<HideWirelessSetupInOOBE>).*?(?=</HideWirelessSetupInOOBE>)', 'true'
        }
        $text | Out-File -Force -Encoding utf8 C:\Windows\Panther\unattend.xml
    }
}

reg.exe unload HKLM\NewUser 2>&1 >$null

Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show(@'
Reboot to start sysprep!

Have a nice day ^_^ --LittleboyHarry
'@, "Finished!",
    "OK", "Information"
)
