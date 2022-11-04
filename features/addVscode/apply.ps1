#Requires -RunAsAdministrator

$scriptPath = "$(mkdir -f C:\SetupFw)\get-vscode.ps1"

$text = Get-Content 'script.ps1'
$lnkname = "$(Get-Translation 'Get' -cn '获取') VSCode"
New-SetupScriptShortcut -psspath $scriptPath -lnkname $lnkname

if ((Get-Culture).Name -eq "zh-CN") {
    $text = $text -replace '(?<=\$rewriteUrl = ).+', '"https://vscode.cdn.azure.cn$path"'
}

$text += "rm -fo `"`$([Environment]::GetFolderPath('Desktop'))\$lnkname.lnk`"`n"
$text | Out-File -Force $scriptPath
