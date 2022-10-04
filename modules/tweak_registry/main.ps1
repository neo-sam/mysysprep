$modules = @{ tweak_registry = @{} }

. '.\lib\load-env-with-cfg.ps1'
. '.\lib\load-commonfn.ps1'
. '.\lib\load-reghelper.ps1'

$cfg = $modules.tweak_registry

if ($null -ne $PSScriptRoot) {
    $script:PSScriptRoot = Split-Path $script:MyInvocation.MyCommand.Path -Parent
}

. '.\lib\load-commonfn'

if ($cfg.optimze) {
    & "$PSScriptRoot\optimze"
    logif1 'optimzed'
}

if ($cfg.protectMyPrivacy) {
    & "$PSScriptRoot\protect-privacy"
    logif1 'disabled privacy collectors'
}

if ($cfg.disableAd) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths    'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo'
    ) Enabled 0
    Remove-ItemProperty -Force 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' Id -ea 0
    logif1 'disabled Ad'
}

if ($cfg.advancedRemapIcons) {
    & "$PSScriptRoot\remap_icons"
    logif1 'remapped icons'
}

if ($cfg.enableClassicPhotoViewer) {
    reg import "$PSScriptRoot\use-classic-photoviewer.reg" 2>&1 | Out-Null
}

if ($cfg.preferGestures) {
    applyRegfileForMeAndDefault "$PSScriptRoot\prefer-gestures.reg"
}

if ($cfg.scripts) {
    foreach ($scriptname in
        @(
            'explorer'
            'contextmenu'
            'taskbar'
            'startmenu'
            'inputmethod_cw'
        )
    ) {
        $props = $cfg.scripts[$scriptname]
        $path = "$PSScriptRoot\scripts\$scriptname.ps1"
        if ((Test-Path $path) -and ($null -ne $props)) { & $path @props }
    }
}
