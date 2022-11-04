#Requires -RunAsAdministrator

$linksDir = "$(mkdir -f C:\SetupFw\UserGuide)"

if (!(Test-Path ($path = "C:\users\Public\Desktop\$(
    Get-Translation 'User Guide' -cn '使用说明'
).lnk"))) {
    $it = (New-Object -ComObject WScript.Shell).CreateShortcut($path)
    $it.TargetPath = $linksDir
    $it.IconLocation = 'imageres.dll,107'
    $it.save()
    Copy-Item -Force $path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs'
}
