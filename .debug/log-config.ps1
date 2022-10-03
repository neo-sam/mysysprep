$modules = @{
    debloat        = -1
    deploy_pkgs    = -1
    tweak_registry = -1
}
$sysprep = -1

. .\lib\load-env-with-cfg.ps1

ConvertTo-Json @{
    modules = $modules
    sysprep = $sysprep
} -Depth 4
