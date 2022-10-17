reg.exe import "$PSScriptRoot\scripts\protect-privacy.reg" 2>&1 | Out-Null

# disable-user-data-collector
Set-ItemProperty (
    Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy'
) TailoredExperiencesWithDiagnosticDataEnabled 0
Set-ItemProperty (
    Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules'
) NumberOfSIUFInPeriod 0
Set-ItemProperty (
    Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules'
) PeriodInNanoSeconds 0

# disable-dynamic-lockscreen-pictures
Set-ItemProperty (
    Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
) RotatingLockScreenEnabled 0

# disable-cortana
Set-ItemProperty (
    Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Windows Search'
) CortanaConsent 0

# disable-input-features-collector
Set-ItemProperty (
    Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Input\TIPC'
) Enabled 0

# disable-msoffice-collector
Set-ItemProperty (
    Get-CurrentAndNewUserPaths 'HKCU:\Software\Policies\Microsoft\Office\Common\ClientTelemetry'
) SendTelemetry 3
Set-ItemProperty (
    Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Office\Common\ClientTelemetry'
) DisableTelemetry 1
