$names = switch ((Get-Culture).Name) {
    zh-CN { @{ userProfile = '用户主目录' } }
    Default { @{ userProfile = 'User Profile' } }
}

$osbver = [Environment]::OSVersion.Version.Build

function Get-RegItemOrNew([string]$path) {
    if (Test-Path $path) {
        return (Get-Item $path).PSPath
    }
    else {
        return (mkdir -f $path).PSPath
    }
}

$showIcoRegkey = Get-RegItemOrNew 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel'

function addDesktopIconConfigMenuItem {
    $regkey = Get-RegItemOrNew 'HKCU:\Software\Classes\DesktopBackground\Shell\DesktopIcon'
    Set-ItemProperty $regkey Position 'Bottom'
    Set-ItemProperty $regkey Icon 'imageres.dll,174'
    Set-ItemProperty $regkey MUIVerb '@desk.cpl,-112'
    Set-Item (
        Get-RegItemOrNew 'HKCU:\Software\Classes\DesktopBackground\Shell\DesktopIcon\Command'
    ) 'control desk.cpl,,0'
}

function showUserFolderAtDesktop {
    Set-ItemProperty $showIcoRegkey '{59031A47-3F72-44A7-89C5-5595FE6B30EE}' 0
    Set-Item (
        Get-RegItemOrNew 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{59031A47-3F72-44A7-89C5-5595FE6B30EE}'
    ) $names.userProfile
    Set-ItemProperty (
        Get-RegItemOrNew 'HKCU:\Software\Classes\CLSID\{59031a47-3f72-44a7-89c5-5595fe6b30ee}'
    ) System.IsPinnedToNameSpaceTree 1
}

function showLibrariesAtDesktop {
    Set-ItemProperty $showIcoRegkey '{031E4825-7B94-4dc3-B131-E946B44C8DD5}' 0
    Set-ItemProperty (
        Get-RegItemOrNew 'HKCU:\Software\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}'
    ) System.IsPinnedToNameSpaceTree 1
}

function showThisPcAtDesktop {
    Set-ItemProperty $showIcoRegkey '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' 0
}

function showNetworkInterfacesAtDesktop {
    Set-Item (
        Get-RegItemOrNew 'HKCU:\Software\Classes\CLSID\{7007ACC7-3202-11D1-AAD2-00805FC1270E}\DefaultIcon'
    ) "imageres.dll,114"

    Get-RegItemOrNew 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{7007ACC7-3202-11D1-AAD2-00805FC1270E}' >$null
}

function showRecentFoldersInExplorerSidebar {
    $icon = if ($osbver -lt 22000) { "shell32.dll,319" } else { "shell32.dll,316" }
    Set-Item (
        Get-RegItemOrNew 'HKCU:\Software\Classes\CLSID\{22877A6D-37A1-461A-91B0-DBDA5AAEBC99}\DefaultIcon'
    ) $icon
    Set-ItemProperty (
        Get-RegItemOrNew 'HKCU:\Software\Classes\CLSID\{22877A6D-37A1-461A-91B0-DBDA5AAEBC99}'
    ) System.IsPinnedToNamespaceTree 1
}

function showRecyleBinInExplorerSidebar {
    Set-ItemProperty (
        Get-RegItemOrNew 'HKCU:\Software\Classes\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}'
    ) System.IsPinnedToNameSpaceTree 1
}

Remove-Item -Force "$([Environment]::GetFolderPath('Desktop'))\Firstrun.lnk" -ea 0
