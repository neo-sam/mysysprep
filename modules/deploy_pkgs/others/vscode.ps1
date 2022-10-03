$rewriteUrl = $url = 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user'
if ((Get-Culture).Name -eq "zh-CN") {
    $rewriteUrl = 'https://vscode.cdn.azure.cn$path'
}

({
    $req = Invoke-WebRequest -useb '{{url}}' -method head
    if ($null -ne $req.BaseResponse.RequestMessage) { $path = $req.BaseResponse.RequestMessage.RequestUri.LocalPath }
    else { $path = $req.BaseResponse.ResponseUri.AbsolutePath }
    $name = ($path -split '/')[-1]
    Invoke-WebRequest "{{rewriteUrl}}" -o $name
    & (Get-ChildItem $name) '/silent' '/tasks=addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath'
}).ToString() `
    -split '\r?\n' -replace '^\s*' -join "`n" `
    -replace '{{url}}', $url -replace '{{rewriteUrl}}', $rewriteUrl |
Out-File -Force C:\Users\Public\get-vscode.ps1

$shortcut = "$([Environment]::GetFolderPath("Desktop"))\Get VSCode.lnk"
if (!(Test-Path $shortcut)) {
    $it = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcut)
    $it.IconLocation = "C:\Windows\System32\msiexec.exe,0"
    $it.TargetPath = "powershell.exe"
    $it.Arguments = '-exec bypass -file C:\Users\Public\get-vscode.ps1'
    $it.Save()
}
if ($isAdmin) { Copy-Item -Force $shortcut 'C:\Users\Default\Desktop' }
