#Requires -RunAsAdministrator

Push-Location $proot
Copy-Item -Recurse -Force docs $(mkdir -f C:\SetupFw)
.\lib\make-docfolder.ps1
Pop-Location

$ws = New-Object -ComObject WScript.Shell
function New-DocShortcut([string]$name, [string]$id) {
    $it = $ws.CreateShortcut("C:\SetupFw\UserGuide\$name.lnk")
    $it.TargetPath = "C:\SetupFw\docs\$(
        Get-Translation $id -cn "$id-cn"
    ).html"
    $it.save()
}

New-DocShortcut (Get-Translation 'README' -cn '自述文件') readme
New-DocShortcut (Get-Translation 'Input & Keyboard' -cn '键盘与输入法') input
New-DocShortcut (Get-Translation 'Options' -cn '选项') options
New-DocShortcut WSL wsl

if ($features.addNewIsolatedUserScript) {
    New-DocShortcut (Get-Translation 'Isolated Multi User Proctect' -cn '多用户安全隔离') multiuser
}
