#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-Item -ea 0 'workrave-win32-v*.exe'

if ($GetMetadata) {
    return @{
        name   = 'Workrave'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path 'C:\Program Files (x86)\Workrave\lib\Workrave.exe')
    }
}

Start-ProcessToInstall $match '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'

# CUSTOM:

$nextPauseMinutes = 25
$nextBreakMinutes = $nextPauseMinutes * 2

$postponePauseMinutes = 2
$postponeBreakMinutes = 5

$keepPauseSeconds = 15
$keepBreakSeconds = 6 * 60

$volume = 38

Set-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' Workrave 'C:\Program Files (x86)\Workrave\lib\Workrave.exe'
Remove-Item 'C:\Users\Public\Desktop\Workrave.lnk'

if (Test-Path ($it = 'config\workrave.reg')) {
    Import-RegFileForMeAndDefault $it
    $regpath = 'HKCU:\Software\Workrave\timers\micro_pause'
    Set-ItemPropertyWithDefaultUser $regpath limit "$($nextPauseMinutes*60)"
    Set-ItemPropertyWithDefaultUser $regpath snooze "$($postponePauseMinutes*60)"
    Set-ItemPropertyWithDefaultUser $regpath auto_reset "$keepPauseSeconds"
    $regpath = 'HKCU:\Software\Workrave\timers\rest_break'
    Set-ItemPropertyWithDefaultUser $regpath limit "$($nextBreakMinutes*60)"
    Set-ItemPropertyWithDefaultUser $regpath snooze "$($postponeBreakMinutes*60)"
    Set-ItemPropertyWithDefaultUser $regpath auto_reset "$keepBreakSeconds"
    $regpath = 'HKCU:\Software\Workrave\sound'
    Set-ItemPropertyWithDefaultUser $regpath volume "$volume"
}

Repair-HidpiCompatibility 'C:\Program Files (x86)\Workrave\lib\Workrave.exe'
