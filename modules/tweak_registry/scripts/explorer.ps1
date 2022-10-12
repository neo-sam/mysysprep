param(
    $showFileExtension,
    $showRecentFolders,
    $useLibraries,
    $useRecylebinForUdisk,
    $optimizePerformance,
    $optimize
)

if ($showFileExtension) {
    $Script:msg = Get-Translation 'enabled show file extension.' `
        -base64cn 5pi+56S65paH5Lu25omp5bGV5ZCNCg==

    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    ) HideFileExt 0
    logif1
}

if ($useLibraries) {
    $Script:msg = Get-Translation 'enabled show libraries.' `
        -base64cn 5pi+56S65bqTCg==

    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}'
    ) System.IsPinnedToNameSpaceTree 1
    logif1
}

if ($useRecylebinForUdisk) {
    $Script:msg = Get-Translation 'enabled recyle bin for U disk.' `
        -base64cn 5r+A5rS7VeebmOWbnuaUtuermeacuuWItgo=

    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
    ) RecycleBinDrives 0xffffffff
    logif1
}

if ($showRecentFolders) {
    $Script:msg = Get-Translation 'enabled show recent folders' `
        -base64cn 5pi+56S65pyA6L+R55qE5paH5Lu25aS5Cg==

    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Classes\CLSID\{22877A6D-37A1-461A-91B0-DBDA5AAEBC99}'
    ) System.IsPinnedToNamespaceTree 1

    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{22877A6D-37A1-461A-91B0-DBDA5AAEBC99}'
    ) '(Default)' ''

    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel'
    ) '{22877A6D-37A1-461A-91B0-DBDA5AAEBC99}' 1

    logif1 -f
}

if ($optimizePerformance) {
    $Script:msg = Get-Translation 'optimized performance.' `
        -base64cn 5oCn6IO95bey5LyY5YyWCg==

    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    ) SeparateProcess 1

    Set-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer 'Max Cached Icons' -Type String (16mb)

    foreach ($item in 'exefile', 'Msi.Package', 'batfile', 'cmdfile') {
        Set-ItemProperty "HKLM:\Software\Classes\$item\shellex\ContextMenuHandlers\Compatibility" '(Default)' '""'
    }

    logif1 -f
}

if ($optimize) {
    $Script:msg = Get-Translation 'optimized' `
        -base64cn 5bey5LyY5YyWCg==

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

    logif1 -f
}
