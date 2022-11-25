#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'Twinkle.Tray.v*.exe'

if ($GetMetadata) {
    return @{
        name   = 'Twinkle Tray'
        match  = $match
        ignore = { Test-Path "$(Get-AppFolderPath -UserPkgs)\Twinkle.Tray.v*.exe" }
    }
}

Copy-Item $match (Get-AppFolderPath -UserPkgs)

$scriptName = 'setupTwinkleTray'
(Convert-ScriptBlockToText {
    $it = Get-ChildItem -ea 0 "$PSScriptRoot\..\userpkgs\Twinkle.Tray.v*.exe"
    if ($it.count -ne 1) {
        Write-Error 'Task Crash!'
        [System.Console]::ReadKey()>$null
        exit
    }
    Start-Process -Wait $it.FullName '/NCRC /S'
    if ($Error) { Pause }
    else {
        Start-Process "$env:LOCALAPPDATA\Programs\twinkle-tray\Twinkle Tray.exe"
    }
}) > "$(Get-AppFolderPath -Scripts)\$scriptName.ps1"
New-UserDeployShortcut $scriptName 'Twinkle Tray'

Start-Process -Wait $match '/NCRC /S'
