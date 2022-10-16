param(
    $showFileExtension,
    $showRecentFolders,
    $useRecylebinForUdisk,
    $optimizePerformance,
    $optimize
)

if ($showFileExtension) {
    $Script:msg = Get-Translation 'enabled show file extension.' `
        -cn '显示文件扩展名'

    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    ) HideFileExt 0
    logif1
}

if ($useRecylebinForUdisk) {
    $Script:msg = Get-Translation 'enabled recyle bin for U disk.' `
        -cn '激活U盘回收站机制'

    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
    ) RecycleBinDrives 0xffffffff
    logif1
}

if ($optimizePerformance) {
    $Script:msg = Get-Translation 'optimized performance.' `
        -cn '性能已优化'

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
        -cn '已优化'

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
