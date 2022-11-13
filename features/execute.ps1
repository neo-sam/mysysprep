#Requires -RunAsAdministrator
param(
    [Parameter(Mandatory)]$path,
    [Parameter(ValueFromPipeline)]$InputObject
)

$name = (Get-Item $path).Name
Push-Location "$PSScriptRoot\.."

. .\lib\loadAllConfig.ps1

$object = if ($null -eq $InputObject) {
    if ($flag = $features[$name]) { $flag }
    else { 1 }
}
elseif ($InputObject.GetType() -eq [string]) {
    ConvertFrom-Json $InputObject
}
else {
    $InputObject
}

. .\features\__base__.ps1
try {
    Push-Location "$PSScriptRoot\$name"
    & .\apply.ps1 $object
}
finally {
    Pop-Location
}

.\lib\submitNewUserRegistry.ps1
Pop-Location
