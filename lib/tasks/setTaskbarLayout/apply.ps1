#Requires -RunAsAdministrator

. "$PSScriptRoot\..\..\modules\common\import.ps1"

if (Test-Windows7) {
    # todo
    exit
}

if (!(Test-Path "$PSScriptRoot\TaskbarLayoutModification.xml")) { exit }

$target = "$(mkdir -f C:\Windows\OEM)\TaskbarLayoutModification.xml"

& "$PSScriptRoot\generator.ps1" | `
    Out-File -Encoding utf8 $target

Set-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer LayoutXMLPath $target
