#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-Item -ea 0 'VSCodeSetup-*.exe'
$appbin = 'C:\Program Files\Microsoft VS Code\Code.exe'

if ($GetMetadata) {
    return @{
        name   = 'VSCode'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path $appbin)
    }
}

Start-ProcessToInstall $match '/VERYSILENT /tasks=addtopath,addcontextmenufiles,addcontextmenufolders,associatewithfiles,desktopicon'
if (!(Test-Path $appbin)) { throw 'Installed Failed' }

# CUSTOM:

Move-DesktopIconFromPublicToDefaultAndCurrentUserIfAuditMode 'Visual Studio Code'

Add-SystemPath 'C:\Program Files\Microsoft VS Code\resources\app\node_modules.asar.unpacked\@vscode\ripgrep\bin'
