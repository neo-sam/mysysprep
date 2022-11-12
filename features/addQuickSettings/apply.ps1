Set-Location (mkdir -f 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Quick Settings')
Remove-Item -Recurse -Force *

$names = switch ( (Get-WinSystemLocale).Name ) {
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
            clear_histpwsh     = '清除 - PowerShell 历史记录'
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
            clear_histpwsh     = 'Clear - History of PowerShell'
            enable_w11ctxmenu  = 'Enable - New Design Context Menu (need Relogin)'
            disable_w11ctxmenu = 'Disable - New Design Context Menu (need Relogin)'
        }
    }
}

$wshell = New-Object -comObject WScript.Shell

function New-Shortcut([String]$name) {
    return $wshell.CreateShortcut("$PWD\$name.lnk")
}

function Set-ShortcutRequireAdmin($shortcut) {
    $path = $shortcut.FullName
    $bytes = [System.IO.File]::ReadAllBytes($path)
    $bytes[0x15] = $bytes[0x15] -bor 0x20
    [System.IO.File]::WriteAllBytes($path, $bytes)
}

$iswin11 = [Environment]::OSVersion.Version.Build -ge 22000

function Set-ShortcutDisableIcon($shortcut) {
    $shortcut.IconLocation = if ($iswin11) { "imageres.dll,230" } else { "imageres.dll,229" }
}

function Set-ShortcutEnableIcon($shortcut) {
    $shortcut.IconLocation = if ($iswin11) { "imageres.dll,233" } else { "imageres.dll,232" }
}

function Set-ShortcutRestartIcon($shortcut) {
    $shortcut.IconLocation = if ($iswin11) { "imageres.dll,229" } else { "imageres.dll,228" }
}

function Set-ShortcutEditIcon($shortcut) {
    $shortcut.IconLocation = "shell32.dll,269"
}

function Set-ShortcutDeleteFileIcon($shortcut) {
    $shortcut.IconLocation = "shell32.dll,152"
}

function Set-ShortcutConfigIcon($shortcut) {
    $shortcut.IconLocation = "shell32.dll,314"
}

function Set-ShortcutDeleteFileIcon($shortcut) {
    $shortcut.IconLocation = "shell32.dll,152"
}

$it = New-Shortcut $names.enable_darkmode
$it.TargetPath = "reg"
$it.Arguments = "add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 0 /f"
Set-ShortcutEnableIcon $it
$it.Save()

$it = New-Shortcut $names.disable_darkmode
$it.TargetPath = "reg"
$it.Arguments = "add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 1 /f"
Set-ShortcutDisableIcon $it
$it.Save()

$it = New-Shortcut $names.edit_hosts
$it.TargetPath = "notepad"
$it.Arguments = "C:\Windows\system32\drivers\etc\hosts"
Set-ShortcutEditIcon $it
$it.Save()
Set-ShortcutRequireAdmin $it

$it = New-Shortcut $names.flushdns
$it.TargetPath = "ipconfig"
$it.Arguments = "/flushdns"
Set-ShortcutRestartIcon $it
$it.Save()
Set-ShortcutRequireAdmin $it

$it = New-Shortcut $names.restartexp
$it.TargetPath = "powershell"
$it.Arguments = "-c kill -n explorer"
Set-ShortcutRestartIcon $it
$it.Save()

$it = New-Shortcut $names.edit_desktopicon
$it.TargetPath = "control"
$it.Arguments = "desk.cpl,,0"
$it.Save()

$it = New-Shortcut $names.enable_hyperv
$it.TargetPath = "bcdedit"
$it.Arguments = "/set {current} hypervisorlaunchtype auto"
Set-ShortcutEnableIcon $it
$it.Save()
Set-ShortcutRequireAdmin $it

$it = New-Shortcut $names.disable_hyperv
$it.TargetPath = "bcdedit"
$it.Arguments = "/set {current} hypervisorlaunchtype off"
Set-ShortcutDisableIcon $it
$it.Save()
Set-ShortcutRequireAdmin $it

$it = New-Shortcut $names.clear_histpwsh
$it.TargetPath = "powershell"
$it.Arguments = "-c cmd /c del %APPDATA%\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
Set-ShortcutDeleteFileIcon $it
$it.Save()

if ($iswin11) {
    $it = New-Shortcut $names.enable_w11ctxmenu
    $it.TargetPath = "reg"
    $it.Arguments = "add HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32 /f /ve"
    Set-ShortcutEnableIcon $it
    $it.Save()

    $it = New-Shortcut $names.disable_w11ctxmenu
    $it.TargetPath = "reg"
    $it.Arguments = "delete HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32 /f /ve"
    Set-ShortcutDisableIcon $it
    $it.Save()
}

$it = $wshell.CreateShortcut("C:\Users\Public\Desktop\$($names.at_desktop).lnk")
$it.TargetPath = "$PWD"
Set-ShortcutConfigIcon $it
$it.Save()
