#Requires -RunAsAdministrator
param($cfg)

if ($cfg.optimize) {
    # show new window at first when clicked appicon
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    ) LastActiveClick 1

    # decrease hover delay time of the taskbar thumbnail
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
    ) ExtendedUIHoverTime 122
}

if ($cfg.biggerThumbnail) {
    $isWideScreen = ((Get-CimOrWimInstance Win32_VideoController).VideoModeDescription -split ' x ')[0] -ge 1680
    $totalMemoryInGb = (Get-CimOrWimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum / 1gb
    if ($isWideScreen -and $totalMemoryInGb -gt 4) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband'
        ) MinThumbSizePx 500
    }
}

# Only Windows 11
if ([Environment]::OSVersion.Version.Build -ge 22000) {
    if ($cfg.optimize) {
        $regkey = (mkdir -f 'HKLM:\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\4\1887869580').PSPath
        Set-ItemProperty $regkey EnabledState 2
        Set-ItemProperty $regkey EnabledStateOptions 0
    }

    Set-ItemProperty ( Get-CurrentAndNewUserPaths `
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    ) MMTaskbarMode 2
    Set-ItemProperty ( Get-CurrentAndNewUserPaths `
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    ) MultiTaskingAltTabFilter 3

    if ($cfg.win11alignLeft) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        ) TaskbarAl 0
    }
    if ($cfg.win11noWidgets) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        ) TaskbarDa 0
        Set-ItemProperty (
            mkdir -f 'HKLM:\SOFTWARE\Policies\Microsoft\Dsh'
        ).PSPath AllowNewsAndInterests 0
    }
    if ($cfg.win11noMsTeam) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        ) TaskbarMn 2
    }
}
else {
    if ($cfg.groupWhenOverflow) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        ) TaskbarGlomLevel 1
    }
    if ($cfg.win10noAd) {
        $regkeys = Get-CurrentAndNewUserPaths "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds"
        Set-ItemProperty $regkeys ShellFeedsTaskbarViewMode 2
        Set-ItemProperty $regkeys ShellFeedsTaskbarContentUpdateMode 1
        Set-ItemProperty $regkeys ShellFeedsTaskbarOpenOnHover 0
    }
    if ($cfg.win10noPeople) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
        ) PeopleBand 0
    }
    if ($cfg.win10noCortana) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        ) ShowCortanaButton 0
    }
    if ($cfg.win10noSearchBar) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search'
        ) SearchboxTaskbarMode 1
    }
    if ($cfg.win10oldVolumeMixer) {
        Set-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\MTCUVC' EnableMtcUvc 0
    }
}
