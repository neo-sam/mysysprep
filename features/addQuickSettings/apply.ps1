#Requires -RunAsAdministrator

param($cfg)

Set-Location (mkdir -f 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Quick Settings')
Remove-Item -Recurse -Force *

$names = switch ((Get-Culture).Name) {
    zh-CN {
        @{
            at_desktop         = '快速设置'
            enable_darkmode    = '激活 - 深色模式'
            disable_darkmode   = '禁用 - 深色模式'
            edit_hosts         = '编辑 - HOSTS'
            edit_desktopicon   = '调整桌面图标'
            flushdns           = '重置 DNS 解析'
            restartexp         = '重启文件资源管理器'
            enable_hyperv      = '激活 - HyperV (需重启)'
            disable_hyperv     = '禁用 - HyperV (需重启)'
            clear_pwshhist     = '清除 - PowerShell 历史记录'
            enable_w11ctxmenu  = '激活 - 新风格菜单 (需注销)'
            disable_w11ctxmenu = '禁用 - 新风格菜单 (需注销)'
        }
    }
    default {
        @{
            at_desktop         = 'Quick Settings'
            enable_darkmode    = 'Enable - Dark Mode'
            disable_darkmode   = 'Disable - Dark Mode'
            edit_hosts         = 'Edit - HOSTS'
            edit_desktopicon   = 'Edit - Desktop Icon'
            flushdns           = 'Flush DNS resolve'
            restartexp         = 'Restart Explorer'
            enable_hyperv      = 'Enable - HyperV (need Reboot)'
            disable_hyperv     = 'Disable - HyperV (need Reboot)'
            clear_pwshhist     = 'Clear - History of PowerShell'
            enable_w11ctxmenu  = 'Enable - New Design Context Menu (need Relogin)'
            disable_w11ctxmenu = 'Disable - New Design Context Menu (need Relogin)'
        }
    }
}

function New-Shortcut([String]$name) {
    return (Get-WscriptShell).CreateShortcut("$PWD\$name.lnk")
}

function Set-RunAsAdmin($shortcut) {
    $path = $shortcut.FullName
    $bytes = [System.IO.File]::ReadAllBytes($path)
    $bytes[0x15] = $bytes[0x15] -bor 0x20
    [System.IO.File]::WriteAllBytes($path, $bytes)
}

function Set-IconToEnable($shortcut) {
    $shortcut.IconLocation = switch ($null) {
        { Test-Windows7 } { 'imageres.dll,101'; break }
        { Test-Windows10 } { 'imageres.dll,232'; break }
        { Test-Windows11 } { 'imageres.dll,233' }
    }
}

function Set-IconToDisable($shortcut) {
    $shortcut.IconLocation = switch ($null) {
        { Test-Windows7 } { 'imageres.dll,100'; break }
        { Test-Windows10 } { 'imageres.dll,229'; break }
        { Test-Windows11 } { 'imageres.dll,230' }
    }
}

function Set-IconToEnableInAdmin($shortcut) {
    $shortcut.IconLocation = 'imageres.dll,101'
}

function Set-IconToDisableInAdmin($shortcut) {
    $shortcut.IconLocation = 'imageres.dll,100'
}

function Set-IconToEdit($shortcut) {
    $shortcut.IconLocation = if (Test-Windows7) { 'notepad.exe' } `
        else { 'shell32.dll,269' }
}

function Set-IconToRestart($shortcut) {
    $shortcut.IconLocation = 'imageres.dll,63'
}

function Set-IconToCleanFile($shortcut) {
    $shortcut.IconLocation = if (Test-Windows7) { 'shell32.dll,271' } `
        else { 'shell32.dll,152' }
}

function Set-IconToConfig($shortcut) {
    $shortcut.IconLocation = 'shell32.dll,21'
}

if ($cfg.createAll -or ((Get-OSVersionBuild) -ge 17763)) {
    $it = New-Shortcut $names.enable_darkmode
    $it.TargetPath = 'reg'
    $it.Arguments = 'add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 0 /f'
    Set-IconToEnable $it
    $it.Save()

    $it = New-Shortcut $names.disable_darkmode
    $it.TargetPath = 'reg'
    $it.Arguments = 'add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 1 /f'
    Set-IconToDisable $it
    $it.Save()
}

$it = New-Shortcut $names.edit_hosts
$it.TargetPath = 'notepad'
$it.Arguments = 'C:\Windows\system32\drivers\etc\hosts'
Set-IconToEdit $it
$it.Save()
Set-RunAsAdmin $it

$it = New-Shortcut $names.flushdns
$it.TargetPath = 'ipconfig'
$it.Arguments = '/flushdns'
Set-IconToRestart $it
$it.Save()
Set-RunAsAdmin $it

$it = New-Shortcut $names.restartexp
$it.TargetPath = 'powershell'
$it.Arguments = '-c kill -n explorer'
Set-IconToRestart $it
$it.Save()

$it = New-Shortcut $names.edit_desktopicon
$it.TargetPath = 'control'
$it.Arguments = 'desk.cpl,,0'
Set-IconToConfig $it
$it.Save()

$it = New-Shortcut $names.enable_hyperv
$it.TargetPath = 'bcdedit'
$it.Arguments = '/set {current} hypervisorlaunchtype auto'
Set-IconToEnableInAdmin $it
$it.Save()
Set-RunAsAdmin $it

$it = New-Shortcut $names.disable_hyperv
$it.TargetPath = 'bcdedit'
$it.Arguments = '/set {current} hypervisorlaunchtype off'
Set-IconToDisableInAdmin $it
$it.Save()
Set-RunAsAdmin $it

$it = New-Shortcut $names.clear_pwshhist
$it.TargetPath = 'powershell'
$it.Arguments = '-c cmd /c del %APPDATA%\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt'
Set-IconToCleanFile $it
$it.Save()

if ($cfg.createAll -or (Test-Windows11)) {
    $it = New-Shortcut $names.enable_w11ctxmenu
    $it.TargetPath = 'reg'
    $it.Arguments = 'add HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32 /f /ve'
    Set-IconToEnable $it
    $it.Save()

    $it = New-Shortcut $names.disable_w11ctxmenu
    $it.TargetPath = 'reg'
    $it.Arguments = 'delete HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32 /f /ve'
    Set-IconToDisable $it
    $it.Save()
}

$it = (Get-WscriptShell).CreateShortcut("C:\Users\Public\Desktop\$($names.at_desktop).lnk")
$it.TargetPath = "$PWD"
$it.IconLocation = 'control.exe'
$it.Save()
