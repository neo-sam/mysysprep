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
    $win11noWidgets,
    $win11noMsTeam
)

if ($optimize) {
    $Script:msg = Get-Translation optimzed `
        -base64cn 5bey5LyY5YyWCg==

    # show new window at first when clicked appicon
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    ) LastActiveClick 1

    # decrease hover delay time of the taskbar thumbnail
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
    ) ExtendedUIHoverTime 122

    logif1 -f
}

if ($biggerThumbnail) {
    $isWideScreen = ((Get-CimOrWimInstance Win32_VideoController).VideoModeDescription -split ' x ')[0] -ge 1680
    $totalMemoryInGb = (Get-CimOrWimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum / 1gb
    if ( $isWideScreen -and $totalMemoryInGb -gt 4 ) {
        $Script:msg = Get-Translation 'enabled bigger thumbnail' `
            -base64cn 5pS+5aSn5oKs5rWu57yp55Wl5Zu+Cg==

        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband'
        ) MinThumbSizePx 500
        logif1
    }
}

# Only Windows 11
if ([Environment]::OSVersion.Version.Build -ge 22000) {
    $Script:msg = Get-Translation 'optimized for win11' `
        -base64cn 5Li6IFdpbjExIOmAgumFjQo=

    Set-ItemProperty ( Get-CurrentAndNewUserPaths `
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    ) MMTaskbarMode 2
    Set-ItemProperty ( Get-CurrentAndNewUserPaths `
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    ) MultiTaskingAltTabFilter 3

    logif1 -f

    if ($win11alignLeft) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        ) TaskbarAl 0
    }
    if ($win11noWidgets) {
        $Script:msg = Get-Translation 'disabled win11 widgets' `
            -base64cn 56aB55SoIFdpbjExIOWwj+e7hOS7tgo=

        Set-ItemProperty (
            Get-CurrentAndNewUserPaths "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        ) TaskbarDa 0

        Set-ItemProperty (
            mkdir -f 'HKLM:\SOFTWARE\Policies\Microsoft\Dsh'
        ).PSPath AllowNewsAndInterests 0

        logif1 -f
    }
    if ($win11noMsTeam) {
        Set-ItemProperty (
            Get-CurrentAndNewUserPaths "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        ) TaskbarMn 2
    }
}
else {
    if ($groupWhenOverflow) {
        $Script:msg = Get-Translation  'will group tasks only overflow' `
            -base64cn 5LuF5b2T5Lu75Yqh5qCP5aGr5ruh5pe25ZCI5bm25ZCM57G76aG5Cg==

        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        ) TaskbarGlomLevel 1
        logif1
    }
    if ($win10noAd) {
        $Script:msg = Get-Translation 'disabled Ad' `
            -base64cn 56aB55So5bm/5ZGKCg==

        $regkeys = Get-CurrentAndNewUserPaths "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds"
        Set-ItemProperty $regkeys ShellFeedsTaskbarViewMode 2
        Set-ItemProperty $regkeys ShellFeedsTaskbarContentUpdateMode 1
        Set-ItemProperty $regkeys ShellFeedsTaskbarOpenOnHover 0
        logif1
    }
    if ($win10noPeople) {
        $Script:msg = Get-Translation 'disabled People icon' `
            -base64cn 5bGP6JS95Lq66ISJ5Zu+5qCHCg==

        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
        ) PeopleBand 0
        logif1
    }
    if ($win10noCortana) {
        $Script:msg = Get-Translation 'disabled Cortana icon' `
            -base64cn 5bGP6JS9IENvcnRhbmEg5Zu+5qCHCg==

        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        ) ShowCortanaButton 0
        logif1
    }
    if ($win10noSearchBar) {
        $Script:msg = Get-Translation 'folded the search bar' `
            -base64cn 5oqY5Y+g5pCc57Si5qCPCg==

        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search'
        ) SearchboxTaskbarMode 1
        logif1
    }
    if ($win10oldVolumeMixer) {
        $Script:msg = Get-Translation 'enabled win7 style volume mixer' `
            -base64cn 5L2/55SoIFdpbjcg6aOO5qC855qE6Z+z6YeP5re35ZCI5ZmoCg==

        Set-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\MTCUVC' EnableMtcUvc 0
        logif1
    }
}
