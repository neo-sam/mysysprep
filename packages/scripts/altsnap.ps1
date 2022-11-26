#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'AltSnap*-x64-inst.exe'

if ($GetMetadata) {
    return @{
        name   = 'AltSnap'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path "$(Get-AppFolderPath -UserPkgs)\AltSnap*-x64-inst.exe")
    }
}

$filename = $match.Name
Copy-Item $match "$(Get-AppFolderPath -UserPkgs)\$filename"
$scriptName = 'setupAltsnap'
$scriptPath = "$(Get-AppFolderPath -Scripts)\$scriptName.ps1"

$parts = ((Get-Content 'config\setupAltsnap.ps1') -join "`n") -split '; config here'
$content = @(
    $parts[0],
    ((Get-Content 'config\altsnap.ini') -join "`n"),
    $parts[1]
) -join ''
if ((Get-Culture).Name -eq 'zh-CN') {
    $content = $content -replace '(?<=Language=)en-US', 'zh-CN'
}
$content >$scriptPath
New-UserDeployShortcut $scriptName 'AltSnap'

& $scriptPath -NoHint
