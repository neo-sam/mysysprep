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
