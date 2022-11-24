#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'AltSnap*-x64-inst.exe'

if ($GetMetadata) {
    return @{
        name   = 'AltSnap'
        match  = $match
        ignore = { Test-Path "$(Get-AppFolderPath -UserDeploy)\AltSnap*-x64-inst.exe" }
    }
}

$filename = $match.Name
Copy-Item $match "$(Get-AppFolderPath -UserDeploy)\$filename"
$scriptName = 'setupAltsnap'

$lnkname = "$(Get-Translation 'Setup' -cn '安装') AltSnap"

$parts = ((Get-Content 'config\setupAltsnap.ps1') -join "`n") -split '; config here'
$content = @(
    $parts[0],
    ((Get-Content 'config\altsnap.ini') -join "`n"),
    $parts[1]
) -join ''
if ((Get-Culture).Name -eq 'zh-CN') {
    $content = $content -replace '(?<=Language=)en-US', 'zh-CN'
}
$content | Out-File -Encoding unicode "$(Get-AppFolderPath -UserDeploy)\$scriptName.ps1"

New-UserDeployShortcut -ScriptName $scriptName -LinkName $lnkname
