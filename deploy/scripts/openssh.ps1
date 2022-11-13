#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'OpenSSH-Win64-v*.msi'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'Upgraded OpenSSH'
        target = 'C:\Program Files\OpenSSH\sshd.exe'
        mutex  = 1
    }
}

Start-Process -Wait $pkg '/qb /norestart',
'/l*v log\openssh.log'

# CUSTOM:

Stop-Service sshd
Set-Service sshd -StartupType Disabled
