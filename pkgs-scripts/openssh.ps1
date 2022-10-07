$pkgfile = Get-PackageFile "OpenSSH-Win64-v*.msi"
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name   = 'Upgraded OpenSSH'
        target = 'C:\Program Files\OpenSSH\sshd.exe'
        mutex  = $true
    }
}

Start-Process $pkgfile -PassThru '/qb /norestart',
'/l*v logs\openssh.log' | Wait-Process

if ($cfg.disableOpensshServer) {
    & {
        sc.exe stop sshd
        sc.exe config sshd start=disabled
    }>$null
}
