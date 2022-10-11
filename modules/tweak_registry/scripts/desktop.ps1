param(
    $addUserFolder,
    $addLibrariesFolder,
    $addThisPC,
    $addNetworkInterfacesFolder,
    $addIconsCfgMenuItem
)

if ($addIconsCfgMenuItem) {
    # add desktop icon config menu
    $regkeys = Get-CurrentAndNewUserPaths 'HKCU:\Software\Classes\DesktopBackground\Shell\DesktopIcon'
    Set-ItemProperty $regkeys Position 'Bottom'
    Set-ItemProperty $regkeys Icon 'imageres.dll,174'
    Set-ItemProperty $regkeys MUIVerb '@desk.cpl,-112'
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Classes\DesktopBackground\Shell\DesktopIcon\Command'
    ) '(Default)' 'control desk.cpl,,0'
    logif1 'show icon settings in menu.'
}

$hideIconRegKeys = Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel'
if ($addUserFolder) {
    Set-ItemProperty $hideIconRegKeys '{59031A47-3F72-44A7-89C5-5595FE6B30EE}' 0
    logif1 'show user folder.'
}
if ($addLibrariesFolder) {
    Set-ItemProperty $hideIconRegKeys '{031E4825-7B94-4dc3-B131-E946B44C8DD5}' 0
    logif1 'show libraries folder.'
}
if ($addThisPC) {
    Set-ItemProperty $hideIconRegKeys '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' 0
    logif1 'show this PC.'
}

if ($addNetworkInterfacesFolder) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Classes\CLSID\{7007ACC7-3202-11D1-AAD2-00805FC1270E}\DefaultIcon'
    ) '(Default)' "imageres.dll,114"
    logif1 'show network devices folder.'
}

if ( (Get-Culture).Name -eq 'zh-CN' ) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{59031A47-3F72-44A7-89C5-5595FE6B30EE}'
    ) '(Default)' '用户目录'
}
