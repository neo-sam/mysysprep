#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'VeraCrypt_Setup_x64_*.msi'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'VeraCrypt'
        mutex  = $true
        target = 'C:\Program Files\VeraCrypt\VeraCrypt.exe'
    }
    return
}

Start-Process -Wait $match '/qb /norestart /l*v logs\veracrypt.log ACCEPTLICENSE=YES'
