#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'workrave-win32-v*.exe'

if ($GetMetadata) {
    return @{
        name   = 'Workrave'
        match  = $match
        ignore = { Test-Path 'C:\Program Files (x86)\Workrave\lib\Workrave.exe' }
    }
}

Start-Process -Wait $match '/SILENT /SUPPRESSMSGBOXES /NORESTART /SP-'

# CUSTOM:

$nextPauseMinutes = 25
$nextBreakMinutes = $nextPauseMinutes * 2

$postponePauseMinutes = 2
$postponeBreakMinutes = 5

$keepPauseSeconds = 15
$keepBreakSeconds = 6 * 60

$volume = 38

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

Set-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' Workrave 'C:\Program Files (x86)\Workrave\lib\Workrave.exe'

Repair-HidpiCompatibility 'C:\Program Files (x86)\Workrave\lib\Workrave.exe'
