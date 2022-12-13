#Requires -RunAsAdministrator
. .\lib\loadModules.ps1

Push-Location ([Environment]::GetFolderPath('Desktop'))
$path = "$(mkdir -f (Get-Translation 'System Config' -cn '系统配置'))"
Set-Location $path
Remove-Item -Recurse *
$icon = switch (1) {
    { Test-Windows7 } { 'C:\Windows\System32\SystemPropertiesAdvanced.exe,0' }
    { Test-Windows10 } { 'C:\windows\system32\SHELL32.dll,316' }
    Default { 'C:\windows\system32\SHELL32.dll,314' }
}
Set-FolderIcon $path $icon

$s = New-Shortcut -Lnk (Get-Translation 'Tweak desktop context for new user' -cn '调整桌面内容 - 新的用户')
$s.TargetPath = 'C:\Users\Default\Desktop'
$s.IconLocation = if (Test-Windows11) { 'imageres.dll,174' } else { 'shell32.dll,34' }
$s.Save()

$s = New-Shortcut -Lnk (Get-Translation 'Tweak desktop context for all users' -cn '调整桌面内容 - 全部用户')
$s.TargetPath = 'C:\Users\Public\Desktop'
$s.IconLocation = if (Test-Windows11) { 'imageres.dll,174' } else { 'shell32.dll,34' }
$s.Save()

$s = New-Shortcut -Lnk (Get-Translation 'Tweak start menu' -cn '调整开始菜单')
$s.TargetPath = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs'
$s.IconLocation = 'shell32.dll,39'
$s.Save()

$s = New-Shortcut -Lnk (Get-Translation 'Tweak startup items' -cn '调整自启动项')
$s.TargetPath = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup'
$s.IconLocation = 'shell32.dll,24'
$s.Save()

$s = New-Shortcut -Lnk (Get-Translation 'Restart explorer' -cn '重启文件资源管理器')
$s.TargetPath = 'powershell'
$s.Arguments = '-c kill -n explorer'
$s.IconLocation = 'imageres.dll,63'
$s.Save()

if (Test-AuditMode) {
    $s = New-Shortcut -Lnk (Get-Translation 'Shutdown & Generlize as a Image' -cn '关机并封装为镜像')
    $s.TargetPath = 'C:\Windows\System32\Sysprep\Sysprep.exe'
    $s.Arguments = '/oobe /generalize /shutdown'
    $s.IconLocation = 'shell32.dll,78'
    $s.Save()

    $s = New-Shortcut -Lnk (Get-Translation 'Edit unattend.xml' -cn '编辑 - unattend.xml')
    $s.TargetPath = 'notepad.exe'
    $s.Arguments = 'C:\Windows\Panther\unattend.xml'
    $s.Save()
}
else {
    $s = New-Shortcut -Lnk (Get-Translation 'Tweak start menu for current user' -cn '调整开始菜单 - 当前用户')
    $s.TargetPath = '%APPDATA%\Microsoft\Windows\Start Menu\Programs'
    $s.IconLocation = 'shell32.dll,39'
    $s.Save()

    $s = New-Shortcut -Lnk (Get-Translation 'Tweak startup items for current user' -cn '调整自启动项 - 当前用户')
    $s.TargetPath = '%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup'
    $s.IconLocation = 'shell32.dll,24'
    $s.Save()
}

explorer.exe $(Get-Location)
Pop-Location

Start-Sleep 1
