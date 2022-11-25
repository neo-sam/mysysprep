. .\lib\loadModules.ps1

Stop-Process -ea 0 -Name sysprep

.\lib\doPowershellUpdate.ps1
if ($LASTEXITCODE) { exit }

if (!(Test-RunAsAdmin)) {
    Write-Error 'Require to run as the Administrator.'
    Read-AnyKey
    exit
}

.\lib\tryToManuallyAddPkgs.ps1
if ($LASTEXITCODE) { exit }

if (Test-AuditMode) {
    net user Administrator /active:yes >$null
}

Write-Output '==> start to apply features'
.\lib\applyFeatures.ps1
Write-Output '==> end to apply features'

try {
    if ((Test-Path .\packages) -and !(Test-IgnorePackages)) {
        & .\packages\lib\main.ps1
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
