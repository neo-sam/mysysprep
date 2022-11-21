#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'Twinkle.Tray.v*.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'Twinkle Tray'
        target = "$(Get-AppFolderPath -UserDeploy)\Twinkle.Tray.v*.exe"
    }
}

Start-Process -Wait $pkg /S
Copy-Item $pkg (Get-AppFolderPath -UserDeploy)

$shortcut = "$([Environment]::GetFolderPath('Desktop'))\$(
    Get-Translation 'Setup' -cn '安装') AltSnap.lnk"
$it = (Get-WscriptShell).CreateShortcut($shortcut)
$it.IconLocation = 'msiexec.exe'
$it.TargetPath = (Get-ChildItem -ea 0 $target).FullName
$it.Save()
Copy-Item $shortcut 'C:\Users\Default\Desktop'
