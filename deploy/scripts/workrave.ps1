#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'workrave-win32-v*.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'Workrave'
        target = 'C:\Program Files (x86)\Workrave\lib\Workrave.exe'
    }
}

Start-Process -Wait $pkg '/SILENT /SUPPRESSMSGBOXES /NORESTART /SP-'

# CUSTOM:

$nextPauseMinutes = 25
$nextBreakMinutes = $nextPauseMinutes * 2

$postponePauseMinutes = 2
$postponeBreakMinutes = 5

$keepPauseSeconds = 15
$keepBreakSeconds = 6 * 60

$volume = 38

if (Test-Path ($it = 'config\workrave.reg')) {
    applyRegForMeAndDefault $it
    $regkeys = Get-CurrentAndNewUserPaths 'HKCU:\Software\Workrave\timers\micro_pause'
    Set-ItemProperty $regkeys limit "$($nextPauseMinutes*60)"
    Set-ItemProperty $regkeys snooze "$($postponePauseMinutes*60)"
    Set-ItemProperty $regkeys auto_reset "$keepPauseSeconds"
    $regkeys = Get-CurrentAndNewUserPaths 'HKCU:\Software\Workrave\timers\rest_break'
    Set-ItemProperty $regkeys limit "$($nextBreakMinutes*60)"
    Set-ItemProperty $regkeys snooze "$($postponeBreakMinutes*60)"
    Set-ItemProperty $regkeys auto_reset "$keepBreakSeconds"
    $regkeys = Get-CurrentAndNewUserPaths 'HKCU:\Software\Workrave\sound'
    Set-ItemProperty $regkeys volume "$volume"
}

Set-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' Workrave 'C:\Program Files (x86)\Workrave\lib\Workrave.exe'

Repair-HidpiCompatibility 'C:\Program Files (x86)\Workrave\lib\Workrave.exe'
