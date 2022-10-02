param(
    $showFileExtension,
    $showRecentFolders,
    $useLibraries,
    $useRecylebinForUdisk,
    $optimizePerformance,
    $optimize
)

if ($showFileExtension) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    ) HideFileExt 0
    logif1 'show file extension.'
}

if ($useLibraries) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}'
    ) System.IsPinnedToNameSpaceTree 1
    logif1 'enabled libraries.'
}

if ($useRecylebinForUdisk) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
    ) RecycleBinDrives 0xffffffff
    logif1 'use recyle bin for U disk.'
}

if ($showRecentFolders) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Classes\CLSID\{22877A6D-37A1-461A-91B0-DBDA5AAEBC99}'
    ) System.IsPinnedToNamespaceTree 1

    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{22877A6D-37A1-461A-91B0-DBDA5AAEBC99}'
    ) '(Default)' ''

    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel'
    ) '{22877A6D-37A1-461A-91B0-DBDA5AAEBC99}' 1

    logif1 'show recent folders.'
}

if ($optimizePerformance) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    ) SeparateProcess 1

    Set-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer 'Max Cached Icons' -Type String (16mb)

    foreach ($item in 'exefile', 'Msi.Package', 'batfile', 'cmdfile') {
        Set-ItemProperty "HKLM:\Software\Classes\$item\shellex\ContextMenuHandlers\Compatibility" '(Default)' '""'
    }

    logif1 'optimized performance.'
}

if ($optimize) {
    Set-ItemProperty -Type Binary (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
    ) link ([byte[]](0x00, 0x00, 0x00, 0x00))

    $advancedkeys = Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    Set-ItemProperty $advancedkeys NavPaneExpandToCurrentFolder 1
    Set-ItemProperty $advancedkeys AutoCheckSelect 1
    Set-ItemProperty $advancedkeys 'Append Completion' 'yes'

    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates'
    ) 'CopyNameTemplate' '%s'

    $0 = 'HKCU:\Software\Microsoft\Windows\Shell\Bags\1\Desktop'
    Set-ItemProperty $0 -Name 'IconSize' -Value 32 -Type DWord
    Set-ItemProperty $0 -Name 'Mode' -Value 1 -Type DWord
    Set-ItemProperty $0 -Name 'LogicalViewMode' -Value 3 -Type DWord

    logif1 'optimized.'
}
