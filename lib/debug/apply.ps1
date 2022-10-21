param(
    [Parameter(Mandatory)]$path,
    [Parameter(ValueFromPipeline)][string]$InputObject
)

$json = ConvertFrom-Json $InputObject
if ($null -eq $json) { $json = 1 }

. .\lib\preload-to-feature.ps1
Push-Location $path
& .\apply.ps1 $json
Pop-Location
