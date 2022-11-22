#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'VSCodeSetup-*.exe'

if ($GetMetadata) {
    return @{
        name   = 'VSCode'
        match  = $match
        ignore = { Test-Path 'C:\Program Files\Microsoft VS Code\Code.exe' }
    }
}

Start-Process -Wait $match '/SILENT /tasks=addtopath,addcontextmenufiles,addcontextmenufolders,associatewithfiles,desktopicon'

# CUSTOM:

Add-SystemPath 'C:\Program Files\Microsoft VS Code\resources\app\node_modules.asar.unpacked\@vscode\ripgrep\bin'
