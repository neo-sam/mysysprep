#Requires -RunAsAdministrator

$scriptPath = 'C:\Users\Public\get-vscode.ps1'

$text = Get-Content 'script.ps1'
$lnkname = "$(Get-Translation 'Get' -cn '获取') VSCode"
New-SetupScriptShortcut -psspath $scriptPath -lnkname $lnkname

if ((Get-Culture).Name -eq "zh-CN") {
    $text = $text -replace '(?<=\$rewriteUrl = ).+', '"https://vscode.cdn.azure.cn$path"'
}
if ($features.addDevbookLinks) {
    $url = switch ((Get-Culture).Name) {
        zh-CN { 'https://devbook.littleboyharry.me/zh-CN/docs/devenv/vscode/settings' }
        Default { 'https://devbook.littleboyharry.me/docs/devenv/vscode/settings' }
    }
    $text += "start '$url'`n"
}
$text += "rm -fo `"`$([Environment]::GetFolderPath('Desktop'))\$lnkname.lnk`"`n"
$text | Out-File -Force $scriptPath
