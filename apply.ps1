. .\lib\loadModules.ps1

Stop-Process -ea 0 -Name sysprep

if ($PSVersionTable.PSVersion.Major -lt 5) {
    .\lib\doPowershellUpdate.ps1
    exit
}

if (!(Test-RunAsAdmin)) {
    Write-Error 'Require to run as the Administrator.'
    Read-AnyKey
    exit
}

if (Test-Path -Exclude .gitkeep ".\packages\manual\*") {
    .\lib\tryToOpenManualInstallPackages.ps1
    if ($LASTEXITCODE) { exit }
}

if (Test-AuditMode) {
    net user Administrator /active:yes >$null
}

Write-Output '==> Start to apply features'
.\lib\applyFeatures.ps1

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
