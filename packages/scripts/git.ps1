#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'Git-*-64-bit.exe'
$appbin = 'C:\Program Files\Git\cmd\git.exe'

if ($GetMetadata) {
    return @{
        name   = 'Git'
        match  = $match
        ignore = Get-BooleanReturnFn (Test-Path $appbin)
    }
}

Start-Process -Wait $match "/LOADINF=config/git.ini /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"

# CUSTOM:

Add-SystemPath 'C:\Program Files\Git\bin'

if (Test-Path ($it = 'C:/Windows/System32/OpenSSH/ssh.exe')) {
    & 'C:\Program Files\Git\cmd\git.exe' config --system core.sshCommand $it
}
