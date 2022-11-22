#Requires -RunAsAdministrator
param($cfg)

if ($cfg.optimize) {
    # show new window at first when clicked appicon
    Set-ItemPropertyWithDefaultUser `
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'`
        LastActiveClick 1

    # decrease hover delay time of the taskbar thumbnail
    Set-ItemPropertyWithDefaultUser `
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'`
        ExtendedUIHoverTime 122
}

if ($cfg.biggerThumbnail) {
    $isWideScreen = ((Get-CimOrWimInstance Win32_VideoController).VideoModeDescription -split ' x ')[0] -ge 1680
    $totalMemoryInGb = (Get-CimOrWimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum / 1gb
    if ($isWideScreen -and $totalMemoryInGb -gt 4) {
        Set-ItemPropertyWithDefaultUser `
            'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband'`
            MinThumbSizePx 500
    }
}

if (Test-Windows11) {
    if ($cfg.optimize) {
        $regkey = Get-RegItemOrNew 'HKLM:\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\4\1887869580'
        Set-ItemProperty $regkey EnabledState 2
        Set-ItemProperty $regkey EnabledStateOptions 0
    }

    Set-ItemPropertyWithDefaultUser `
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'`
        MMTaskbarMode 2
    Set-ItemPropertyWithDefaultUser `
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'`
        MultiTaskingAltTabFilter 3

    if ($cfg.w11setAlignLeft) {
        Set-ItemPropertyWithDefaultUser `
            'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'`
            TaskbarAl 0
    }
    if ($cfg.w11noWidgets) {
        Set-ItemPropertyWithDefaultUser `
            'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'`
            TaskbarDa 0

        Set-ItemProperty (
            Get-RegItemOrNew  'HKLM:\SOFTWARE\Policies\Microsoft\Dsh'
        ) AllowNewsAndInterests 0
    }
    if ($cfg.w11noMsTeamIcon) {
        Set-ItemPropertyWithDefaultUser `
            'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'`
            TaskbarMn 0
    }
}
else {
    if ($cfg.groupWhenOverflow) {
        Set-ItemPropertyWithDefaultUser `
            'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'`
            TaskbarGlomLevel 1
    }
    if (Test-Windows10) {
        if ($cfg.w10noAd) {
            $regpath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds'
            Set-ItemProperty $regpath ShellFeedsTaskbarViewMode 2
            Set-ItemProperty $regpath ShellFeedsTaskbarContentUpdateMode 1
            Set-ItemProperty $regpath ShellFeedsTaskbarOpenOnHover 0
        }
        if ($cfg.w10noContactIcon) {
            Set-ItemPropertyWithDefaultUser `
                'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'`
                PeopleBand 0
        }
        if ($cfg.w10noCortanaIcon) {
            Set-ItemPropertyWithDefaultUser `
                'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'`
                ShowCortanaButton 0
        }
        if ($cfg.w10setSearchBarIconOnly) {
            Set-ItemPropertyWithDefaultUser `
                'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search'`
                SearchboxTaskbarMode 1
        }
        if ($cfg.w10setVolumeMixerClassic) {
            Set-ItemProperty (
                Get-RegItemOrNew 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\MTCUVC'
            ) EnableMtcUvc 0
        }
    }
}
