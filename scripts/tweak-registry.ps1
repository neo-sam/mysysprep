.\_adminrequire.ps1

if ($protectMyUserData) {
    & {
        reg add HKLM\Software\Policies\Microsoft\Windows\AppCompat /f /t REG_DWORD /v DisableInventory /d 1

        reg add HKLM\Software\Policies\Microsoft\Windows\DataCollection /f /t REG_DWORD /v AllowTelemetry /d 0

        reg add HKLM\Software\Microsoft\PolicyManager\current\device\System /f /t REG_DWORD /v AllowExperimentation /d 0

        reg add HKLM\Software\Policies\Microsoft\Windows\AppCompat /f /t REG_DWORD /v AITEnable /d 0
        reg add HKLM\Software\Policies\Microsoft\SQMClient\Windows /f /t REG_DWORD /v CEIPEnable /d 0

        reg add HKLM\Software\Policies\Microsoft\Windows\System /f /t REG_DWORD /v UploadUserActivities /d 0
        reg add HKLM\Software\Policies\Microsoft\Windows\System /f /t REG_DWORD /v AllowCrossDeviceClipboard /d 0
        reg add HKLM\Software\Policies\Microsoft\Windows\System /f /t REG_DWORD /v EnableActivityFeed /d 0
        reg add HKLM\Software\Policies\Microsoft\Windows\System /f /t REG_DWORD /v PublishUserActivities /d 0

        reg add HKLM\Software\Policies\Microsoft\MRT /f /t REG_DWORD /v DontReportInfectionInformation /d 1
        reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Spynet" /f /t REG_DWORD /v SubmitSamplesConsent /d 2
    
        reg add HKLM\Software\Microsoft\PolicyManager\current\device\Bluetooth /f /t REG_DWORD /v AllowAdvertising /d 0
        reg add HKLM\Software\Policies\Microsoft\Windows\TabletPC /f /t REG_DWORD /v PreventHandwritingDataSharing /d 1
        reg add HKLM\Software\Policies\Microsoft\Windows\HandwritingErrorReports /f /t REG_DWORD /v PreventHandwritingErrorReports /d 1
    }>$null
}

if ($disableAd) {
    reg add HKLM\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo /f /t REG_DWORD /v Enabled /d 0 >$null
}

if ($optimzeExplorer) {
    reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer /v "Max Cached Icons" /t REG_SZ /d 16mb /f >$null
}
