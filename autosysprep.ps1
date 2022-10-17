#Requires -RunAsAdministrator

foreach ($name in
    @(
        'registry'
        'debloat'
        'deploy'
        'desktop'
    )
) {
    if (Test-Path ".\modules\$name") {
        Write-Host "==> Running Module: $name"
        & ".\modules\$name\main.ps1"
    }
}

& '.\lib\submit-sysprep.ps1'
