#Requires -RunAsAdministrator

. .\lib\loadModules.ps1

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
function Test-DeployPackagePath([string]$path) {
    return Test-Path "$PSScriptRoot\..\packages\$path"
}

if (
    (Test-Path ($it = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk')) -or
    (Test-DeployPackagePath 'Firefox Setup *.exe')
) { Add-Link $it }

if ($isWin10) { Add-Link 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Notepad.lnk' }
else { Add-App Microsoft.WindowsNotepad_8wekyb3d8bbwe }

if (
    (Test-Path ($it = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Tabby Terminal.lnk')) -or
    (Test-DeployPackagePath 'tabby-*-setup-*.exe')
) { Add-App Microsoft.WindowsTerminal_8wekyb3d8bbwe }
else {
    Add-Link $it
}

$parts[0], $lines.TrimEnd(), $parts[1] |`
    Out-File -Encoding utf8 (
    $target = "$(mkdir -f C:\Windows\OEM)\TaskbarLayoutModification.xml")

Set-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer LayoutXMLPath $target
