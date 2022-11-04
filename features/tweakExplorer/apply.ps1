#Requires -RunAsAdministrator
param($cfg)

if ($cfg.showFileExtension) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    ) HideFileExt 0
}

if ($cfg.useRecylebinForUdisk) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
    ) RecycleBinDrives 0xffffffff
}

if ($cfg.optimizePerformance) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    ) SeparateProcess 1

    Set-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer 'Max Cached Icons' -Type String (16mb)

    foreach ($item in 'exefile', 'Msi.Package', 'batfile', 'cmdfile') {
        Set-ItemProperty "HKLM:\Software\Classes\$item\shellex\ContextMenuHandlers\Compatibility" '(Default)' '""'
    }
}

if ($cfg.optimize) {
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
}
