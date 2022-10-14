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
        -cn '已优化'

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
            -cn '放大悬浮缩略图'

        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband'
        ) MinThumbSizePx 500
        logif1
    }
}

# Only Windows 11
if ([Environment]::OSVersion.Version.Build -ge 22000) {
    $Script:msg = Get-Translation 'optimized for win11' `
        -cn '为 Win11 适配'

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
            -cn '禁用 Win11 小组件'

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
            -cn '仅当任务栏填满时合并同类项'

        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        ) TaskbarGlomLevel 1
        logif1
    }
    if ($win10noAd) {
        $Script:msg = Get-Translation 'disabled Ad' `
            -cn '禁用广告'

        $regkeys = Get-CurrentAndNewUserPaths "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds"
        Set-ItemProperty $regkeys ShellFeedsTaskbarViewMode 2
        Set-ItemProperty $regkeys ShellFeedsTaskbarContentUpdateMode 1
        Set-ItemProperty $regkeys ShellFeedsTaskbarOpenOnHover 0
        logif1
    }
    if ($win10noPeople) {
        $Script:msg = Get-Translation 'disabled People icon' `
            -cn '屏蔽人脉图标'

        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
        ) PeopleBand 0
        logif1
    }
    if ($win10noCortana) {
        $Script:msg = Get-Translation 'disabled Cortana icon' `
            -cn '屏蔽 Cortana 图标'

        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        ) ShowCortanaButton 0
        logif1
    }
    if ($win10noSearchBar) {
        $Script:msg = Get-Translation 'folded the search bar' `
            -cn '折叠搜索栏'

        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search'
        ) SearchboxTaskbarMode 1
        logif1
    }
    if ($win10oldVolumeMixer) {
        $Script:msg = Get-Translation 'enabled win7 style volume mixer' `
            -cn '使用 Win7 风格的音量混合器'

        Set-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\MTCUVC' EnableMtcUvc 0
        logif1
    }
}
