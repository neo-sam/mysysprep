param(
    $addUserFolder = 1,
    $addLibrariesFolder = 1,
    $addThisPC = 1,
    $addNetworkInterfacesFolder = 1,
    $addIconsCfgMenuItem = 1,
    $addRecentFoldersInSidebar = 1
)

switch ((Get-Culture).Name) {
    zh-CN { $userProfileFolderName = '用户主目录' }
    Default { $userProfileFolderName = 'User Profile' }
}

$showIcoRegkey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel'
if ($addUserFolder) {
    Set-ItemProperty $showIcoRegkey '{59031A47-3F72-44A7-89C5-5595FE6B30EE}' 0
    Set-ItemProperty (
        mkdir -f 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{59031A47-3F72-44A7-89C5-5595FE6B30EE}'
    ).PSPath '(Default)' $userProfileFolderName
    Set-ItemProperty (
        mkdir -f 'HKCU:\Software\Classes\CLSID\{59031a47-3f72-44a7-89c5-5595fe6b30ee}'
    ).PSPath System.IsPinnedToNameSpaceTree 1
}

if ($addLibrariesFolder) {
    Set-ItemProperty $showIcoRegkey '{031E4825-7B94-4dc3-B131-E946B44C8DD5}' 0
    Set-ItemProperty (
        mkdir -f 'HKCU:\Software\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}'
    ).PSPath System.IsPinnedToNameSpaceTree 1
}

if ($addThisPC) {
    Set-ItemProperty $showIcoRegkey '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' 0
}

if ($addNetworkInterfacesFolder) {
    Set-ItemProperty (
        mkdir -f 'HKCU:\Software\Classes\CLSID\{7007ACC7-3202-11D1-AAD2-00805FC1270E}\DefaultIcon'
    ).PSPath '(Default)' "imageres.dll,114"
    mkdir -f 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{7007ACC7-3202-11D1-AAD2-00805FC1270E}' >$null
}

if ($addIconsCfgMenuItem) {
    $regkey = (mkdir -f 'HKCU:\Software\Classes\DesktopBackground\Shell\DesktopIcon').PSPath
    Set-ItemProperty $regkey Position 'Bottom'
    Set-ItemProperty $regkey Icon 'imageres.dll,174'
    Set-ItemProperty $regkey MUIVerb '@desk.cpl,-112'
    Set-ItemProperty (
        mkdir -f 'HKCU:\Software\Classes\DesktopBackground\Shell\DesktopIcon\Command'
    ).PSPath '(Default)' 'control desk.cpl,,0'
}

if ($addRecentFoldersInSidebar) {
    $icon = if ($winver -lt 22000) { "shell32.dll,319" } else { "shell32.dll,316" }
    Set-ItemProperty (
        mkdir -f 'HKCU:\Software\Classes\CLSID\{22877A6D-37A1-461A-91B0-DBDA5AAEBC99}\DefaultIcon'
    ).PSPath '(Default)' $icon
    Set-ItemProperty (
        mkdir -f 'HKCU:\Software\Classes\CLSID\{22877A6D-37A1-461A-91B0-DBDA5AAEBC99}'
    ).PSPath System.IsPinnedToNamespaceTree 1
}
