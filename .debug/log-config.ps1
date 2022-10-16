. .\lib\load-env-with-cfg.ps1

ConvertTo-Json @{
    modules = $modules
    sysprep = $sysprep
} -Depth 4
