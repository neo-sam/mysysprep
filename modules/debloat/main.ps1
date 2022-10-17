. '.\lib\load-env-with-cfg.ps1'
. '.\lib\load-commonfn.ps1'

$cfg = $modules.debloat

if ($cfg.one_drive) {
    & "$PSScriptRoot\scripts\onedrive"
}

$props = $cfg.collectors
& "$PSScriptRoot\scripts\collectors" @props

$props = $cfg.capabilities
& "$PSScriptRoot\scripts\capabilities" @props

if ($null -ne (Get-Module Appx -All -ListAvailable)) {
    $ProgressPreferenceBefore = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    $props = $cfg.provisionAppx
    & "$PSScriptRoot\scripts\provision" @props

    $ProgressPreference = $ProgressPreferenceBefore
}
