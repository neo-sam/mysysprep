#Requires -RunAsAdministrator

$docsFolderPath = Get-BasePath -Docs

$localizedFolderPath = switch ((Get-Culture).Name) {
    zh-CN { "$docsFolderPath\zh-CN" }
    Default { "$docsFolderPath\en" }
}

$linksFolderPath = "$docsFolderPath\links"
$linksFolderName = Get-Translation 'User Guide' -cn '使用说明'

Push-Location $docsFolderPath
Remove-Item -Recurse -Force *
Copy-Item -Recurse -Force "$proot\docs\*" .
mkdir -f $linksFolderPath >$null
Pop-Location

if (!(Test-Path ($path = "C:\users\Default\Desktop\$linksFolderName.lnk"))) {
    $it = (New-Object -ComObject WScript.Shell).CreateShortcut($path)
    $it.TargetPath = $linksFolderPath
    $it.IconLocation = 'imageres.dll,107'
    $it.save()
}
Copy-Item -Force $path ([Environment]::GetFolderPath('Desktop'))
Copy-Item -Force $path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs'

$ws = New-Object -ComObject WScript.Shell
function New-DocShortcut([string]$id, [string]$name, [string]$icon = $null) {
    $it = $ws.CreateShortcut("$linksFolderPath\$name.lnk")
    $it.TargetPath = "$localizedFolderPath\$id.html"
    if ($icon) { $it.IconLocation = $icon }
    $it.save()
}

$readmeIcon = if ($osver.Major -lt 7) { 'imageres.dll,203' } else { 'imageres.dll,204' }
New-DocShortcut readme (
    Get-Translation 'README' -cn '自述文件'
) $readmeIcon

New-DocShortcut input (
    Get-Translation 'Keyboard & Input' -cn '键盘与输入法'
) 'imageres.dll,173'

New-DocShortcut options (
    Get-Translation 'Options' -cn '选项'
) 'control.exe'

if (Get-Module -ListAvailable Appx) {
    if (Get-AppxPackage Microsoft.WindowsStore) {
        New-DocShortcut store (
            Get-Translation 'Store Apps for You' -cn '应用商店推荐应用'
        ) 'explorer.exe,17'
    }
}

if ($osbver -ge 18362) { New-DocShortcut wsl2 WSL2 'wsl.exe' }

$it = $ws.CreateShortcut("$linksFolderPath\$(
    Get-Translation 'GitHub Project Homepage' -cn 'GitHub 项目主页'
).url")
$it.TargetPath = "https://github.com/setupfw/win-sf"
$it.save()

if ($features.addNewIsolatedUserScript) {
    New-DocShortcut multiuser (
        Get-Translation 'Isolated Multi User Proctect' -cn '多用户安全隔离'
    ) 'imageres.dll,74'
}