#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'AltSnap*-x64-inst.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'AltSnap'
        target = "$env:APPDATA\AltSnap\AltSnap.exe"
    }
}

$filename = $pkg.Name
Copy-Item $pkg "$(Get-AppFolderPath -UserDeploy)\$filename"
$scriptName = 'setupAltsnap'

$lnkname = "$(Get-Translation 'Setup' -cn '安装') AltSnap"

$parts = ((Get-Content 'config\setupAltsnap.ps1') -join "`n") -split '; config here'
$content = @(
    $parts[0],
    ((Get-Content 'config\altsnap.ini') -join "`n"),
    $parts[1]
) -join '' -replace '# Remove desktop shortcut', "rm -fo `"`$([Environment]::GetFolderPath('Desktop'))\$lnkname.lnk`""
if ((Get-Culture).Name -eq 'zh-CN') {
    $content = $content -replace '(?<=Language=)en-US', 'zh-CN'
}
$content | Out-File -Encoding unicode "$(Get-AppFolderPath -UserDeploy)\$scriptName"

New-UserDeployShortcut -ScriptName $scriptName -LinkName $lnkname
