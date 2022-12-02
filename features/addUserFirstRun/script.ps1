$names = switch ((Get-Culture).Name) {
    zh-CN { @{ userProfile = '用户主目录' } }
    Default { @{ userProfile = 'User Profile' } }
}

$osvb = [Environment]::OSVersion.Version.Build
$osvm = [Environment]::OSVersion.Version.Major

function Get-RegItemOrNew([string]$path) {
    if (Test-Path $path) { (Get-Item $path).PSPath }
    else { (mkdir -f $path).PSPath }
}

$showIcoRegkey = Get-RegItemOrNew 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel'
function Show-DesktopIcon([string]$guid) {
    Set-ItemProperty $showIcoRegkey "{$guid}" 0
}
function Hide-DesktopIcon([string]$guid) {
    Set-ItemProperty $showIcoRegkey "{$guid}" 1
}

function Add-ExplorerSidebar([string]$guid, [string]$order = $null) {
    $item = Get-RegItemOrNew "HKCU:\Software\Classes\CLSID\{$guid}"
    Set-ItemProperty $item System.IsPinnedToNameSpaceTree 1
    if ($order) {
        Set-ItemProperty $item SortOrderIndex $order
    }
}

function addDesktopIconConfigMenuItem {
    $regkey = Get-RegItemOrNew 'HKCU:\Software\Classes\DesktopBackground\Shell\DesktopIcon'
    Set-ItemProperty $regkey Position 'Bottom'
    Set-ItemProperty $regkey Icon 'imageres.dll,174'
    Set-ItemProperty $regkey MUIVerb '@desk.cpl,-112'
    Set-Item (
        Get-RegItemOrNew 'HKCU:\Software\Classes\DesktopBackground\Shell\DesktopIcon\Command'
    ) 'control desk.cpl,,0'
}

function showUserProfileIcon {
    $guid = '59031A47-3F72-44A7-89C5-5595FE6B30EE'

    Show-DesktopIcon $guid
    Add-ExplorerSidebar $guid

    Set-Item (
        Get-RegItemOrNew "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{$guid}"
    ) $names.userProfile
}

function showLibrariesIcon {
    $guid = '031E4825-7B94-4dc3-B131-E946B44C8DD5'

    Show-DesktopIcon $guid
    Add-ExplorerSidebar $guid -order 1
}

function showThisPcIcon {
    Show-DesktopIcon '20D04FE0-3AEA-1069-A2D8-08002B30309D'
    Add-ExplorerSidebar $guid
}

function showInterfacesIconAtDesktop {
    Set-Item (
        Get-RegItemOrNew 'HKCU:\Software\Classes\CLSID\{7007ACC7-3202-11D1-AAD2-00805FC1270E}\DefaultIcon'
    ) 'imageres.dll,114'

    Get-RegItemOrNew 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{7007ACC7-3202-11D1-AAD2-00805FC1270E}' >$null
}

function showRecyleBinIconAtExplorerSidebar {
    Add-ExplorerSidebar '645FF040-5081-101B-9F08-00AA002F954E'
}

function showRecentFoldersIconAtExplorerSidebar {
    $guid = '22877A6D-37A1-461A-91B0-DBDA5AAEBC99'
    Get-RegItemOrNew "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{$guid}" >$null

    Add-ExplorerSidebar $guid
    Hide-DesktopIcon $guid

    $icon = switch ($osvm) {
        6 { 'imageres.dll,112' }
        Default {
            if ($osvb -lt 22000) { 'shell32.dll,319' }
            else { 'shell32.dll,316' }
        }
    }
    Set-Item (
        Get-RegItemOrNew "HKCU:\Software\Classes\CLSID\{$guid}\DefaultIcon"
    ) $icon
}

function showThisPcAsDefault {
    Set-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' LaunchTo 1
}

Remove-Item -Force "$([Environment]::GetFolderPath('Desktop'))\Firstrun.lnk" -ea 0
