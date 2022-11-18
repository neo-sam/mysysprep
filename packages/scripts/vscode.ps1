#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'VSCodeSetup-*.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'VSCode'
        target = 'C:\Program Files\Microsoft VS Code\Code.exe'
    }
}

Start-Process -Wait $pkg '/SILENT /tasks=addtopath,addcontextmenufiles,addcontextmenufolders,associatewithfiles,desktopicon'

# CUSTOM:

Add-SystemPath 'C:\Program Files\Microsoft VS Code\resources\app\node_modules.asar.unpacked\@vscode\ripgrep\bin'
