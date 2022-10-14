. .\lib\require-admin.ps1

foreach ($name in
    @(
        'tweak_registry'
        'debloat'
        'deploy_pkgs'
    )
) {
    if (Test-Path ".\modules\$name") {
        Write-Host "==> Running Module: $name"
        & ".\modules\$name\main.ps1"
    }
}

& '.\lib\submit-sysprep.ps1'
