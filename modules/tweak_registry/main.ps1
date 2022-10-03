$modules = @{ tweak_registry = @{} }

. .\lib\load-env-with-cfg.ps1
. '.\lib\load-reghelper.ps1'

$cfg = $modules.tweak_registry

. "$(Get-ScriptRoot)\commonfn"

if ($cfg.optimze) {
    & "$(Get-ScriptRoot)\optimze"
    logif1 'apply optimze'
}

if ($cfg.protectMyPrivacy) {
    & "$(Get-ScriptRoot)\protect-privacy"
    logif1 'disabled privacy collectors.'
}

if ($cfg.disableAd) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths    'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo'
    ) Enabled 0
    Remove-ItemProperty -Force 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' Id -ea 0
    logif1 'disabled Ad'
}

if ($cfg.advancedRemapIcons) {
    & "$(Get-ScriptRoot)\remap_icons"
    logif1 'Remapped icons.'
}

if ($cfg.enableClassicPhotoViewer) {
    reg import "$(Get-ScriptRoot)\use-classic-photoviewer.reg" 2>&1 | Out-Null
}

if ($cfg.preferGestures) {
    applyRegfileForMeAndDefault "$(Get-ScriptRoot)\prefer-gestures.reg"
}

if ($cfg.subscripts) {
    foreach ($scriptname in
        @(
            'explorer'
            'contextmenu'
            'taskbar'
            'startmenu'
            'inputmethod_cw'
        )
    ) {
        $props = $cfg.subscripts[$scriptname]
        $path = "$(Get-ScriptRoot)\subscripts\$scriptname"
        if (Test-Path $path -and $props) { & $path @props }
    }
}
