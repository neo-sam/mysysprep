$pkg = Get-ChildItem -ea 0 'Git-*-64-bit.exe'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'Git'
        target = 'C:\Program Files\Git\cmd\git.exe'
    }
}

Start-Process $pkg "/LOADINF=config/git.ini /SILENT /SUPPRESSMSGBOXES /NORESTART /SP-" -PassThru | Wait-Process

Push-SystemPath "C:\Program Files\Git\bin"

if (Test-Path ($it = 'config\.minttyrc')) {
    if (!(Test-Path ($that = "$env:USERPROFILE\.minttyrc"))) {
        Copy-Item $it $that
    }
    Copy-Item $it 'C:\Users\Default'
}
