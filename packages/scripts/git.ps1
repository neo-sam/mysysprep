#Requires -RunAsAdministrator
param([switch]$GetMetadata)

$match = Get-ChildItem -ea 0 'Git-*-64-bit.exe'
$appbin = 'C:\Program Files\Git\cmd\git.exe'

if ($GetMetadata) {
    return @{
        name   = 'Git'
        match  = $match
        ignore = if (Test-Path $appbin) { { 1 } }else { { 0 } }
    }
}

Start-Process -Wait $match "/LOADINF=config/git.ini /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"

# CUSTOM:

Add-SystemPath 'C:\Program Files\Git\bin'

if ($template = Get-Content -ea 0 'config\.minttyrc') {
    if (!(Test-Path ($target = "$env:USERPROFILE\.minttyrc"))) {
        $result = $template
        if ((Get-Module Appx) -and (Get-AppxPackage Microsoft.WindowsTerminal)) {
            $result += 'Font=Cascadia Mono'
        }
        $result | Out-File -Encoding utf8 $target
    }
    Copy-Item $target 'C:\Users\Default'
}

if (Test-Path ($it = 'C:/Windows/System32/OpenSSH/ssh.exe')) {
    & 'C:\Program Files\Git\cmd\git.exe' config --system core.sshCommand $it
}
