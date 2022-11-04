#Requires -RunAsAdministrator
param($cfg)

if ($cfg.hideCompatibilityHelper) {
    foreach ($item in 'exefile', 'Msi.Package', 'batfile', 'cmdfile') {
        Set-ItemProperty "HKLM:\Software\Classes\$item\shellex\ContextMenuHandlers\Compatibility" '(Default)' '""'
    }
}
