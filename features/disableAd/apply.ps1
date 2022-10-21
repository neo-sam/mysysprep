#Requires -RunAsAdministrator

Set-ItemProperty (
    Get-CurrentAndNewUserPaths    'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo'
) Enabled 0
Remove-ItemProperty -Force 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' Id -ea 0
