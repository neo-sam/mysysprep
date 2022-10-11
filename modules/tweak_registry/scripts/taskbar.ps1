param(
    $optimize,
    $biggerThumbnail,
    $groupWhenOverflow,
    $win10noAd,
    $win10noPeople,
    $win10noCortana,
    $win10noSearchBar,
    $win10oldVolumeMixer,
    $win11alignLeft,
    $win11showAllTray,
    $win11noWidgets,
    $win11noMsTeam
)

if ($optimize) {
    # show new window at first when clicked appicon
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    ) LastActiveClick 1

    # decrease hover delay time of the taskbar thumbnail
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
    ) ExtendedUIHoverTime 122

    logif1 'optimzed'
}

if ($biggerThumbnail) {
    $isWideScreen = ((Get-CimOrWimInstance Win32_VideoController).VideoModeDescription -split ' x ')[0] -ge 1680
    $totalMemoryInGb = (Get-CimOrWimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum / 1gb
    if ( $isWideScreen -and $totalMemoryInGb -gt 4 ) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband'
        ) MinThumbSizePx 500
        logif1 'enabled bigger thumbnail'
    }
}

# Only Windows 11
if ([Environment]::OSVersion.Version.Build -ge 22000) {
    Set-ItemProperty ( Get-CurrentAndNewUserPaths `
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    ) MMTaskbarMode 2
    Set-ItemProperty ( Get-CurrentAndNewUserPaths `
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    ) MultiTaskingAltTabFilter 3
    logif1 'optimized for win11'

    if ($win11alignLeft) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        ) TaskbarAl 0
    }
    if ($win11showAllTray) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
        ) EnableAutoTray  1
        logif1 'show all tray icon'
    }
    if ($win11noWidgets) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        ) TaskbarDa 0

        $regkey = 'HKLM:\SOFTWARE\Policies\Microsoft\Dsh'
        mkdir -f $regkey >$null
        Set-ItemProperty $regkey AllowNewsAndInterests 0
        logif1 'disabled win11 widgets'
    }
    if ($win11noMsTeam) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        ) TaskbarMn 2
    }
}
else {
    if ($groupWhenOverflow) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        ) TaskbarGlomLevel 1
        logif1 'group tasks only overflow'
    }
    if ($win10noAd) {
        $regkeys = Get-CurrentAndNewUserPaths "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds"
        Set-ItemProperty $regkeys ShellFeedsTaskbarViewMode 2
        Set-ItemProperty $regkeys ShellFeedsTaskbarContentUpdateMode 1
        Set-ItemProperty $regkeys ShellFeedsTaskbarOpenOnHover 0
        logif1 'disabled Ad'
    }
    if ($win10noPeople) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
        ) PeopleBand 0
        logif1 'disabled People icon'
    }
    if ($win10noCortana) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        ) ShowCortanaButton 0
        logif1 'disabled Cortana icon'
    }
    if ($win10noSearchBar) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search'
        ) SearchboxTaskbarMode 1
        logif1 'folded the search bar'
    }
    if ($win10oldVolumeMixer) {
        Set-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\MTCUVC' EnableMtcUvc 0
        logif1 'enabled win7 style volume mixer'
    }
}
