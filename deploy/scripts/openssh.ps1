$pkg = Get-ChildItem -ea 0 'OpenSSH-Win64-v*.msi'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'Upgraded OpenSSH'
        target = 'C:\Program Files\OpenSSH\sshd.exe'
        mutex  = 1
    }
}

Start-Process $pkg -PassThru '/qb /norestart',
'/l*v log\openssh.log' | Wait-Process

& {
    sc.exe stop sshd
    sc.exe config sshd start=disabled
}>$null
