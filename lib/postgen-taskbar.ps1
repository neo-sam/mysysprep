#Requires -RunAsAdministrator

$isWin10 = [Environment]::OSVersion.Version.Build -lt 22000

if (!(Test-Path ($tmpl = '.\lib\assets\TaskbarLayoutModification.xml'))) { exit }

$parts = (Get-Content $tmpl) -join "`n" -split "`n                <!-- data -->`n"
$lines = ''

function Add-App([string]$id) {
    $Script:lines += "                <taskbar:UWA AppUserModelID =`"$id!App`"/>`n"
}
function Add-Link([string]$path) {
    $Script:lines += "                <taskbar:DesktopApp DesktopApplicationLinkPath =`"$path`"/>`n"
}

if ($it = Get-ChildItem 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk' -ea 0) {
    Add-Link $it.FullName
}
Add-App Microsoft.WindowsTerminal_8wekyb3d8bbwe
if ($isWin10) {
    Add-Link '%APPDATA%\Microsoft\Windows\Start Menu\Programs\Accessories\Notepad.lnk'
}
else {
    Add-App Microsoft.WindowsNotepad_8wekyb3d8bbwe
}

$result = $parts[0], $lines.TrimEnd(), $parts[1]
$target = "$(mkdir -f C:\Windows\OEM)\TaskbarLayoutModification.xml"
$result | Out-File -Encoding utf8 $target

Set-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer LayoutXMLPath $target
