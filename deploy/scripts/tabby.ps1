#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'tabby-*-setup-*.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'Tabby'
        target = 'C:\Program Files\Tabby\Tabby.exe'
    }
}

Start-Process -Wait $pkg '/allusers /S'
