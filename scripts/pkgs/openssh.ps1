$pkgfile = Get-PackageFile "OpenSSH-Win64-v*.msi"
if (!$PSSenderInfo) { 
    if ($pkgfile) { 'newest OpenSSH' }
    return 
}

Start-Process $pkgfile '/q /norestart /l*v logs\openssh.log' -PassThru | Wait-Process

Assert-Path "C:\Program Files\OpenSSH\sshd.exe"

. .\config.ps1
if (0 -ne $disableSshdServer) {
    & {
        sc.exe stop sshd
        sc.exe config sshd start=disabled
    }>$null
}
