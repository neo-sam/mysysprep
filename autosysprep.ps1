. .\lib\require-admin.ps1

function Invoke-MyModule {
    param([string[]]$modules)
    foreach ($module in $modules) {
        if (Test-Path ".\modules\$module") {
            Write-Host "==> Running '$name' modules"
            & ".\modules\$module\main.ps1"
        }
    }
}

Invoke-MyModule 'tweak-registry', 'debloat', 'deploy-pkgs'

& '.\lib\submit-sysprep.ps1'
