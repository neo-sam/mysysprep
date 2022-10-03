$modules = @{ tweak_registry = @{} }

. .\lib\load-env-with-cfg.ps1
. '.\lib\mount-defaultregistry.ps1'

$cfg = $modules.tweak_registry

function logif1 {
    param([string[]]$content)
    if ($?) { Write-Host "[$((Get-ChildItem $MyInvocation.MyCommand).BaseName)]" @content }
}

function Get-CimOrWimInstance {
    param ( [string]$className)
    if ($PSVersionTable.PSVersion.Major -gt 5) {
        return Get-CimInstance $className
    }
    else {
        return Get-WmiObject Win32_PhysicalMemory
    }
}

reg add HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge /v PreventFirstRunPage /t REG_DWORD /f /d 0 >$null
reg add HKLM\SOFTWARE\Policies\Microsoft\WindowsMediaPlayer /v GroupPrivacyAcceptance /t REG_DWORD /f /d 1 >$null

if ($cfg.protectMyPrivacy) {
    & "$(Get-ScriptRoot)\protect-privacy"
    logif1 'disabled privacy collectors.'
}

if ($cfg.disableAd) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths    'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo'
    ) Enabled 0
    Remove-ItemProperty -Force 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' Id -ErrorAction SilentlyContinue
    logif1 'disabled Ad'
}

if ($cfg.advancedRemapIcons) {
    & "$(Get-ScriptRoot)\remap_icons"
    logif1 'Remapped icons.'
}

if ($cfg.enableClassicPhotoViewer) {
    reg import "$(Get-ScriptRoot)\subscripts\use-classic-photoviewer.reg" 2>&1 | Out-Null
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

if ([Environment]::OSVersion.Version.Build -le 22000) {
    # HiDPI fix
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
    ) 'C:\Windows\System32\dllhost.exe' "~ HIGHDPIAWARE"
    # Colorize Window Title
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths "HKCU:\SOFTWARE\Microsoft\Windows\DWM"
    ) ColorPrevalence 1
}
