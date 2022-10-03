$modules = @{ debloat = @{} }
. .\lib\load-env-with-cfg.ps1

$cfg = $modules.debloat

if ($cfg.one_drive) {
    & "$(Get-ScriptRoot)\uninstall-onedrive"
}

$props = $cfg.collectors
& "$(Get-ScriptRoot)\disable-collectors" @props

$props = $cfg.capabilities
& "$(Get-ScriptRoot)\remove-capabilities" @props

if ($null -eq (Get-Module Appx -All -ListAvailable)) {
    $ProgressPreferenceBefore = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    $props = $cfg.provisionAppx
    & "$(Get-ScriptRoot)\remove-provision" @props

    $ProgressPreference = $ProgressPreferenceBefore
}
