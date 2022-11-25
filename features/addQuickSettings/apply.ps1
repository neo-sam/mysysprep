#Requires -RunAsAdministrator

param($cfg)

Set-Location (mkdir -f 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Quick Settings')
Remove-Item -Recurse -Force *

$names = switch ((Get-Culture).Name) {
    zh-CN {
        @{
            at_desktop         = '快速设置'
            clear_pwshhist     = '清除 - PowerShell 历史记录'
            darkmode_enable    = '激活 - 深色模式'
            darkmode_disable   = '禁用 - 深色模式'
            darkmode_desc      = '需重启文件管理器'
            edit_hosts         = '编辑 - HOSTS'
            edit_desktopicon   = '调整桌面图标'
            explorer_restart   = '重启文件资源管理器'
            dns_flush          = '重置 DNS 解析'
            hyperv_enable      = '激活 - HyperV'
            hyperv_disable     = '禁用 - HyperV'
            hyperv_desc        = '需重启'
            w11ctxmenu_enable  = '激活 - 新风格菜单'
            w11ctxmenu_disable = '禁用 - 新风格菜单'
            w11ctxmenu_desc    = '需注销'
        }
    }
    default {
        @{
            at_desktop         = 'Quick Settings'
            clear_pwshhist     = 'Clear - History of PowerShell'
            darkmode_enable    = 'Enable - Dark Mode'
            darkmode_disable   = 'Disable - Dark Mode'
            darkmode_desc      = 'Need restart explorer'
            edit_hosts         = 'Edit - HOSTS'
            edit_desktopicon   = 'Edit - Desktop Icon'
            explorer_restart   = 'Restart Explorer'
            dns_flush          = 'Flush DNS resolve'
            hyperv_enable      = 'Enable - HyperV'
            hyperv_disable     = 'Disable - HyperV'
            hyperv_desc        = 'Need reboot'
            w11ctxmenu_enable  = 'Enable - New Design Context Menu'
            w11ctxmenu_disable = 'Disable - New Design Context Menu'
            w11ctxmenu_desc    = 'Need relogin'
        }
    }
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
    $shortcut.IconLocation = 'control.exe'
}

if ($cfg.createAll -or ((Get-OSVersionBuild) -ge 17763)) {
    $it = New-Shortcut -Lnk $names.darkmode_enable
    $it.TargetPath = 'reg'
    $it.Arguments = 'add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 0 /f'
    $it.Description = $names.darkmode_desc
    Set-IconToEnable $it
    $it.Save()

    $it = New-Shortcut -Lnk $names.darkmode_disable
    $it.TargetPath = 'reg'
    $it.Arguments = 'add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 1 /f'
    $it.Description = $names.darkmode_desc
    Set-IconToDisable $it
    $it.Save()
}

$it = New-Shortcut -Lnk $names.edit_hosts
$it.TargetPath = 'notepad'
$it.Arguments = 'C:\Windows\system32\drivers\etc\hosts'
Set-IconToEdit $it
$it.Save()
Set-RunAsAdmin $it

$it = New-Shortcut -Lnk $names.dns_flush
$it.TargetPath = 'ipconfig'
$it.Arguments = '/dns_flush'
Set-IconToRestart $it
$it.Save()
Set-RunAsAdmin $it

$it = New-Shortcut -Lnk $names.explorer_restart
$it.TargetPath = 'powershell'
$it.Arguments = '-c kill -n explorer'
Set-IconToRestart $it
$it.Save()

$it = New-Shortcut -Lnk $names.edit_desktopicon
$it.TargetPath = 'control'
$it.Arguments = 'desk.cpl,,0'
Set-IconToConfig $it
$it.Save()

$it = New-Shortcut -Lnk $names.hyperv_enable
$it.TargetPath = 'bcdedit'
$it.Arguments = '/set {current} hypervisorlaunchtype auto'
$it.Description = $names.hyperv_desc
Set-IconToEnableInAdmin $it
$it.Save()
Set-RunAsAdmin $it

$it = New-Shortcut -Lnk $names.hyperv_disable
$it.TargetPath = 'bcdedit'
$it.Arguments = '/set {current} hypervisorlaunchtype off'
$it.Description = $names.hyperv_desc
Set-IconToDisableInAdmin $it
$it.Save()
Set-RunAsAdmin $it

$it = New-Shortcut -Lnk $names.clear_pwshhist
$it.TargetPath = 'powershell'
$it.Arguments = '-c cmd /c del %APPDATA%\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt'
Set-IconToCleanFile $it
$it.Save()

if ($cfg.createAll -or (Test-Windows11)) {
    $it = New-Shortcut -Lnk $names.w11ctxmenu_enable
    $it.TargetPath = 'reg'
    $it.Arguments = 'add HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32 /f /ve'
    $it.Description = $names.w11ctxmenu_desc
    Set-IconToEnable $it
    $it.Save()

    $it = New-Shortcut -Lnk $names.w11ctxmenu_disable
    $it.TargetPath = 'reg'
    $it.Arguments = 'delete HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32 /f /ve'
    $it.Description = $names.w11ctxmenu_desc
    Set-IconToDisable $it
    $it.Save()
}

$it = New-Shortcut -Lnk "C:\Users\Public\Desktop\$($names.at_desktop).lnk"
$it.TargetPath = "$PWD"
$it.IconLocation = 'shell32.dll,21'
$it.Save()
