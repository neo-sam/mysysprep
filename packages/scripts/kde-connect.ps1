#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-Item -ea 0 'kdeconnect-kde-*-windows-*.exe'

if ($GetMetadata) {
    return @{
        name   = 'KDE Connect'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path 'C:\Program Files\KDE Connect\bin\kdeconnect-app.exe')
    }
}

Start-ProcessToInstall $match '/NCRC /S'

# CUSTOM:

Move-DesktopIconFromPublicToDefaultAndCurrentUserIfAuditMode 'KDE Connect'
Remove-Item 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\KDE Connect.lnk'
