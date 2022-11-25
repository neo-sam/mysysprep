Push-Location "$PSScriptRoot\..\.."

. .\config.ps1

foreach ($cfgfile in Get-ChildItem '.\specify*.ps1') {
    . $cfgfile
}

Pop-Location

if (Test-Path ($recfg = '.\config-override.ps1')) {
    . $recfg
}

if ($null -eq $appFolderPath) {
    $appFolderPath = 'C:\Program Files\win-sf'
}

function Get-AppFolderPath(
    [switch]$Scripts,
    [switch]$UserPkgs,
    [switch]$Docs
) {
    mkdir -f $appFolderPath >$null
    if ($Scripts) {
        return "$(mkdir -f "$appFolderPath\scripts")"
    }
    if ($UserPkgs) {
        return "$(mkdir -f "$appFolderPath\userpkgs")"
    }
    if ($Docs) {
        return "$(mkdir -f "$appFolderPath\docs")"
    }
    return $appFolderPath
}

if ($null -eq $unattend) { $unattend = @{} }

function Get-UnattendConfig([string]$key) {
    if ($key -eq '') { $unattend }
    else { $unattend[$key] }
}

if ($null -eq $features) { $features = @{} }

function Get-FeatureConfig([string]$key) {
    if ($key -eq '*') { $features }
    else { $features[$key] }
}

function Test-IgnorePackages { $ignorePackages }

function Test-ShouldManuallyAddPkgs {
    (Test-Path -Exclude .gitkeep ".\packages\manual\*") -and (!$ignoreManualPackages)
}
