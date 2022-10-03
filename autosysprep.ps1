. .\lib\require-admin.ps1

foreach ($module in
    @(
        'tweak_registry'
        'debloat'
        'deploy_pkgs'
    )
) {
    if (Test-Path ".\modules\$module") {
        Write-Host "==> Running '$name' modules"
        & ".\modules\$module\main.ps1"
    }
}

& '.\lib\submit-sysprep.ps1'
