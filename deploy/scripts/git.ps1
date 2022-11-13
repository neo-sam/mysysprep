#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'Git-*-64-bit.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'Git'
        target = 'C:\Program Files\Git\cmd\git.exe'
    }
}

Start-Process -Wait $pkg "/LOADINF=config/git.ini /SILENT /SUPPRESSMSGBOXES /NORESTART /SP-"

# CUSTOM:

Push-SystemPath 'C:\Program Files\Git\bin'

if (Test-Path ($it = 'config\.minttyrc')) {
    if (!(Test-Path ($that = "$env:USERPROFILE\.minttyrc"))) {
        Copy-Item $it $that
    }
    Copy-Item $it 'C:\Users\Default'
}

if (Test-Path ($it = 'C:/Windows/System32/OpenSSH/ssh.exe')) {
    & 'C:\Program Files\Git\cmd\git.exe' config --system core.sshCommand $it
}
