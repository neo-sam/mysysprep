$cfg = $script:registryCfg = @{
    protectMyPrivacy         = 0
    disableAd                = 0
    explorer                 = @{}
    contextmenu              = @{}
    taskbar                  = @{}
    startmenu                = @{}
    inputmethod_cw           = @{}
    enableClassicPhotoViewer = 0
    remap_icons              = 0
}

. .\lib\load-env-with-cfg.ps1
. '.\lib\mount-defaultregistry.ps1'

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

if ($enableClassicPhotoViewer) {
    reg import "$(Get-ScriptRoot)\subscripts\use-classic-photoviewer.reg" 2>&1 | Out-Null
}

foreach ($scriptname in
    @(
        'explorer'
        'contextmenu'
        'taskbar'
        'startmenu'
        'inputmethod_cw'
        'remap_icons'
    )
) {
    $props = $cfg[$scriptname]
    $path = "$(Get-ScriptRoot)\subscripts\$scriptname"
    if (Test-Path $path -and $props) { & $path @props }
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
