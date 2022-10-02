$pkgfile = Get-PackageFile "OpenSSH-Win64-v*.msi"
if (!$PSSenderInfo) {
    if ($pkgfile) { 'Upgraded OpenSSH', 'mutex' }
    return
}

Start-Process $pkgfile -PassThru '/qb /norestart',
'/l*v logs\openssh.log' | Wait-Process

Assert-Path "C:\Program Files\OpenSSH\sshd.exe"

if ($pkgsCfg.disableOpensshServer) {
    & {
        sc.exe stop sshd
        sc.exe config sshd start=disabled
    }>$null
}
