.\lib\loadModules.ps1
Import-Module ConfigLoader

ConvertTo-Json ([ordered]@{
        features       = Get-FeatureConfig *
        unattend       = Get-UnattendConfig
        ignorePackages = Test-IgnorePackages
    }) -Depth 4
