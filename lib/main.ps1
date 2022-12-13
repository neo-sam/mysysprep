$script:PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent

Stop-Process -ea 0 -Name sysprep

if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Host -ForegroundColor Yellow `
        'Unsupported PowerShell version, should update to PowerShell 5!'
    .\lib\doPowershellUpdate.ps1
    exit
}

. .\lib\loadModules.ps1

if (!(Test-RunAsAdmin)) {
    Write-Error 'Require to run as the Administrator.'
    Read-AnyKey
    exit
}

if (Test-AuditMode) {
    net user Administrator /active:yes >$null
}

if (Test-ShouldManuallyAddPkgs) {
    .\lib\tryToManuallyAddPkgs.ps1
    if ($LASTEXITCODE) { exit }
}

Write-Output '==> Apply features'
.\lib\applyFeatures.ps1
Write-Output '<== Applied features', '', ''

try {
    if ((Test-Path .\packages) -and !(Test-SkipAddPackages)) {
        Write-Output '==> Add packages'
        & .\packages\lib\main.ps1
        Write-Output '<== Added packages', '', ''
    }

    if (Test-Path 'C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1') {
        try {
            Set-ExecutionPolicy -Scope LocalMachine RemoteSigned -Force
        }
        catch [System.Security.SecurityException] {}
    }

    .\lib\submit.ps1
}
catch {
    Write-Error $_.Exception.Message
    pause
}
