. .\config

foreach ($cfgfile in Get-ChildItem '.\config-*.ps1') {
    . $cfgfile
}

$script:isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
$script:isAuditMode = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State' -ErrorAction Ignore).ImageState -eq 'IMAGE_STATE_SPECIALIZE_RESEAL_TO_AUDIT'

function Get-ScriptRoot() {
    if ($null -ne $PSScriptRoot) { return $PSScriptRoot }
    return Split-Path $script:MyInvocation.MyCommand.Path -Parent
}
