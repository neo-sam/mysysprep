$cfg = $script:debloatModuleCfg = @{
    oneDrive      = 0
    collectors    = @{}
    capabilities  = @{}
    provisionAppx = @{}
}


. .\lib\load-env-with-cfg.ps1

if ($cfg.oneDrive) {
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
