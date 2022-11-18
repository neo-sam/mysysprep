#Requires -RunAsAdministrator
param(
    [Parameter(Mandatory)]$path,
    [Parameter(ValueFromPipeline)]$InputObject
)

$name = (Get-Item $path).Name
Push-Location "$PSScriptRoot\.."

.\lib\loadModules.ps1
Import-Module ConfigLoader

$object = if ($null -eq $InputObject) {
    if ($flag = Get-FeatureConfig $name) { $flag }
    else { 1 }
}
elseif ($InputObject.GetType() -eq [string]) {
    ConvertFrom-Json $InputObject
}
else {
    $InputObject
}

try {
    Push-Location "$PSScriptRoot\$name"
    & .\apply.ps1 $object
}
finally {
    Pop-Location
}

.\lib\submitNewUserRegistry.ps1
Pop-Location
