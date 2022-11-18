#Requires -RunAsAdministrator
param($cfg)

if ($cfg.showFileExtension) {
    Set-ItemPropertyWithDefaultUser `
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'`
        HideFileExt 0
}

if ($cfg.useRecylebinForUdisk) {
    Set-ItemPropertyWithDefaultUser `
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'`
        RecycleBinDrives 0xffffffff
}

if ($cfg.showDevicesOnlyInThisPc) {
    Import-RegFile showDevicesOnlyInThisPc.reg
}

if ($cfg.optimizePerformance) {
    Set-ItemPropertyWithDefaultUser `
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'`
        SeparateProcess 1

    Set-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer 'Max Cached Icons' -Type String (16mb)

    foreach ($item in 'exefile', 'Msi.Package', 'batfile', 'cmdfile') {
        Set-Item "HKLM:\Software\Classes\$item\shellex\ContextMenuHandlers\Compatibility" '""'
    }
}

if ($cfg.optimize) {
    Set-ItemPropertyWithDefaultUser `
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'`
        link ([byte[]](0x00, 0x00, 0x00, 0x00))

    $regpath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    Set-ItemProperty $regpath NavPaneExpandToCurrentFolder 1
    Set-ItemProperty $regpath AutoCheckSelect 1
    Set-ItemProperty $regpath 'Append Completion' 'yes'

    Set-ItemPropertyWithDefaultUser `
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates'`
        'CopyNameTemplate' '%s'
}
