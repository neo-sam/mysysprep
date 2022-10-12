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
    $Script:msg = Get-Translation Optimzed. `
        -base64cn 5bey5LyY5YyWCg==

    & "$PSScriptRoot\optimze"
    logif1
}

if ($cfg.protectMyPrivacy) {
    $Script:msg = Get-Translation 'Disabled privacy collectors.' `
        -base64cn 5bey5bGP6JS96ZqQ56eB5pS26ZuG5ZmoCg==

    & "$PSScriptRoot\protect-privacy"
    logif1
}

if ($cfg.disableAd) {
    $Script:msg = Get-Translation 'Disabled Ad.' `
        -base64cn 5bey5bGP6JS95bm/5ZGK57O757ufCg==

    Set-ItemProperty (
        Get-CurrentAndNewUserPaths    'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo'
    ) Enabled 0
    Remove-ItemProperty -Force 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' Id -ea 0

    logif1 -f
}

if ($cfg.enableClassicPhotoViewer) {
    $Script:msg = Get-Translation 'Enabled classic photoviewer.' `
        -base64cn 5r+A5rS757uP5YW45Zu+54mH5p+l55yL5ZmoCg==

    reg.exe import "$PSScriptRoot\use-classic-photoviewer.reg" 2>&1 | Out-Null

    logif1 -f
}

if ($cfg.preferTouchpadGestures) {
    $Script:msg = Get-Translation 'Changed touchpad gestures schema.' `
        -base64cn 5bey5pS55Y+Y6Kem5pG45p2/5omL5Yq/5pa55qGICg==

    applyRegfileForMeAndDefault "$PSScriptRoot\touchpad-gestures.reg"
    logif1
}

if ($cfg.advancedRemapIcons) {
    & "$PSScriptRoot\remap_icons"
}

if ($cfg.scripts) {
    foreach ($scriptfile in Get-ChildItem .\modules\tweak_registry\scripts\*.ps1) {
        $scriptname = $scriptfile.BaseName
        $props = $cfg.scripts[$scriptname]
        $path = "$PSScriptRoot\scripts\$scriptname.ps1"
        if ((Test-Path $path) -and ($null -ne $props)) { & $path @props }
    }
}
