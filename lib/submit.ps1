. .\lib\loadModules.ps1
Import-Module ConfigLoader
$Error.Clear()

.\lib\submitNewTaskbarLayout.ps1

if (Test-AuditMode) {
    & .\lib\submitNewUnattendFile.ps1
}

.\lib\submitNewUserRegistry.ps1

Copy-Item 'C:\Users\Public\Desktop\*.lnk' 'C:\Users\Default\Desktop\'
Move-Item 'C:\Users\Public\Desktop\*.lnk' . -Force

Write-Output '!!! FINISHED ALL !!!'

& {
    Push-Location ([Environment]::GetFolderPath('Desktop'))
    $path = "$(mkdir -f (Get-Translation 'System Config' -cn '系统配置'))"
    Set-Location $path
    $icon = 'C:\windows\system32\SHELL32.dll,314'
    if (Test-Windows7) { $icon = 'C:\Windows\System32\control.exe,0' }
    if (Test-Windows10) { $icon = 'C:\windows\system32\SHELL32.dll,316' }
    Set-FolderIcon $path $icon

    $it = New-Shortcut -Lnk (Get-Translation 'Tweak desktop context for new user' -cn '调整桌面内容 (配给新用户)')
    $it.TargetPath = 'C:\Users\Default\Desktop'
    $it.IconLocation = 'imageres.dll,174'
    $it.Save()

    $it = New-Shortcut -Lnk (Get-Translation 'Tweak desktop context for all users' -cn '调整桌面内容 (配给全用户)')
    $it.TargetPath = 'C:\Users\Public\Desktop'
    $it.IconLocation = 'imageres.dll,174'
    $it.Save()

    $it = New-Shortcut -Lnk (Get-Translation 'Tweak start menu' -cn '调整开始菜单')
    $it.TargetPath = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs'
    $it.IconLocation = 'shell32.dll,19'
    $it.Save()

    $it = New-Shortcut -Lnk (Get-Translation 'Tweak startup items' -cn '调整自启动项')
    $it.TargetPath = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup'
    $it.IconLocation = 'shell32.dll,24'
    $it.Save()

    $it = New-Shortcut -Lnk (Get-Translation 'Restart explorer' -cn '重启文件资源管理器')
    $it.TargetPath = 'powershell'
    $it.Arguments = '-c kill -n explorer'
    $it.IconLocation = 'imageres.dll,63'
    $it.Save()

    if (Test-AuditMode) {
        $it = New-Shortcut -Lnk (Get-Translation 'Edit unattend.xml' -cn '编辑 unattend.xml')
        $it.TargetPath = 'notepad.exe'
        $it.Arguments = 'C:\Windows\Panther\unattend.xml'
        $it.Save()

        $it = New-Shortcut -Lnk (Get-Translation 'Shutdown & Generlize as a Image' -cn '关机并封装为镜像')
        $it.TargetPath = 'C:\Windows\System32\Sysprep\Sysprep.exe'
        $it.Arguments = '/oobe /generalize /shutdown'
        $it.IconLocation = 'shell32.dll,151'
        $it.Save()
    }
    else {
        $it = New-Shortcut -Lnk (Get-Translation 'Tweak start menu for current user' -cn '调整开始菜单 (当前用户)')
        $it.TargetPath = '%APPDATA%\Microsoft\Windows\Start Menu\Programs'
        $it.IconLocation = 'shell32.dll,19'
        $it.Save()

        $it = New-Shortcut -Lnk (Get-Translation 'Tweak startup items for current user' -cn '调整自启动项 (当前用户)')
        $it.TargetPath = '%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup'
        $it.IconLocation = 'shell32.dll,24'
        $it.Save()
    }

    Start-Process .
    Pop-Location

    Start-Sleep 1
}

showInformationDialog 'win-sf' @"
$(Get-Translation 'Repository: ' -cn '项目：')https://github.com/setupfw/win-sf
$(Get-Translation 'Author: ' -cn '作者：')LittleboyHarry
$(Get-Translation 'Status: OK' -cn '状态：已完成')
$(Get-Translation 'Blessing: have a nice day! ^_^' -cn '寄语：大吉大利，祝你鸿运当头！')
"@

if ($Error) { Pause }
