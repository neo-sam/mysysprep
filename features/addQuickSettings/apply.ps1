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
            edit_env           = '编辑 - 环境变量'
            explorer_restart   = '重启文件资源管理器'
            dns_flush          = '重置 DNS 解析'
            hyperv_enable      = '激活 - HyperV'
            hyperv_disable     = '禁用 - HyperV'
            hyperv_desc        = '需重启'
            w11ctxmenu_enable  = '激活 - 新风格菜单'
            w11ctxmenu_disable = '禁用 - 新风格菜单'
            w11ctxmenu_desc    = '需注销'
            tweak_desktopicon  = '调整 - 桌面图标'
            tweak_restorepoint = '调整 - 还原点'
            tweak_advanced     = '调整 - 高级系统设置'
            tweak_screensaver  = '调整 - 屏幕保护程序'
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
            edit_env           = 'Edit - Environment Variables'
            explorer_restart   = 'Restart Explorer'
            dns_flush          = 'Flush DNS resolve'
            hyperv_enable      = 'Enable - HyperV'
            hyperv_disable     = 'Disable - HyperV'
            hyperv_desc        = 'Need reboot'
            w11ctxmenu_enable  = 'Enable - New Design Context Menu'
            w11ctxmenu_disable = 'Disable - New Design Context Menu'
            w11ctxmenu_desc    = 'Need relogin'
            tweak_desktopicon  = 'Tweak - Desktop Icon'
            tweak_restorepoint = 'Tweak - Restore Points'
            tweak_advanced     = 'Tweak - Advanced System Properties'
            tweak_screensaver  = 'Tweak - Screensaver'
        }
    }
}

$s = New-Shortcut -Lnk "C:\Users\Public\Desktop\$($names.at_desktop)"
$s.TargetPath = "$PWD"
$s.IconLocation = 'shell32.dll,21'
$s.Save()

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

function Set-IconToConfigPanel($shortcut) {
    $shortcut.IconLocation = 'control.exe'
}

if ($cfg.createAll -or ((Get-OSVersionBuild) -ge 17763)) {
    $s = New-Shortcut -Lnk $names.darkmode_enable
    $s.TargetPath = 'reg'
    $s.Arguments = 'add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 0 /f'
    $s.Description = $names.darkmode_desc
    Set-IconToEnable $s
    $s.Save()

    $s = New-Shortcut -Lnk $names.darkmode_disable
    $s.TargetPath = 'reg'
    $s.Arguments = 'add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 1 /f'
    $s.Description = $names.darkmode_desc
    Set-IconToDisable $s
    $s.Save()
}

$s = New-Shortcut -Lnk $names.edit_hosts
$s.TargetPath = 'notepad'
$s.Arguments = 'C:\Windows\system32\drivers\etc\hosts'
Set-IconToEdit $s
$s.Save()
Set-RunAsAdmin $s

$s = New-Shortcut -Lnk $names.dns_flush
$s.TargetPath = 'ipconfig'
$s.Arguments = '/dns_flush'
Set-IconToRestart $s
$s.Save()
Set-RunAsAdmin $s

$s = New-Shortcut -Lnk $names.explorer_restart
$s.TargetPath = 'powershell'
$s.Arguments = '-c kill -n explorer'
Set-IconToRestart $s
$s.Save()

$s = New-Shortcut -Lnk $names.tweak_desktopicon
$s.TargetPath = 'control'
$s.Arguments = 'desk.cpl,,0'
Set-IconToConfigPanel $s
$s.Save()

$s = New-Shortcut -Lnk $names.hyperv_enable
$s.TargetPath = 'bcdedit'
$s.Arguments = '/set {current} hypervisorlaunchtype auto'
$s.Description = $names.hyperv_desc
Set-IconToEnableInAdmin $s
$s.Save()
Set-RunAsAdmin $s

$s = New-Shortcut -Lnk $names.hyperv_disable
$s.TargetPath = 'bcdedit'
$s.Arguments = '/set {current} hypervisorlaunchtype off'
$s.Description = $names.hyperv_desc
Set-IconToDisableInAdmin $s
$s.Save()
Set-RunAsAdmin $s

$s = New-Shortcut -Lnk $names.clear_pwshhist
$s.TargetPath = 'powershell'
$s.Arguments = '-c cmd /c del %APPDATA%\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt'
Set-IconToCleanFile $s
$s.Save()

if ($cfg.createAll -or (Test-Windows11)) {
    $s = New-Shortcut -Lnk $names.w11ctxmenu_enable
    $s.TargetPath = 'reg'
    $s.Arguments = 'add HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32 /f /ve'
    $s.Description = $names.w11ctxmenu_desc
    Set-IconToEnable $s
    $s.Save()

    $s = New-Shortcut -Lnk $names.w11ctxmenu_disable
    $s.TargetPath = 'reg'
    $s.Arguments = 'delete HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32 /f /ve'
    $s.Description = $names.w11ctxmenu_desc
    Set-IconToDisable $s
    $s.Save()
}

$s = New-Shortcut -Lnk $names.tweak_advanced
$s.TargetPath = 'SystemPropertiesAdvanced.exe'
$s.Save()

$s = New-Shortcut -Lnk $names.tweak_restorepoint
$s.TargetPath = 'SystemPropertiesProtection.exe'
Set-IconToConfigPanel $s
$s.Save()

$s = New-Shortcut -Lnk $names.edit_env
$s.TargetPath = 'rundll32.exe'
$s.Arguments = 'sysdm.cpl,EditEnvironmentVariables'
Set-IconToEdit $s
$s.Save()

$s = New-Shortcut -Lnk $names.tweak_screensaver
$s.TargetPath = 'rundll32.exe'
$s.Arguments = 'shell32.dll,Control_RunDLL desk.cpl,,1'
$s.IconLocation = 'shell32.dll,25'
$s.Save()
