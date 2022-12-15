Import-Module Api.Common

Push-Location (Get-ProjectLocation)
. .\configuration.ps1
foreach ($sampleScript in Get-ChildItem '.\sample-*.ps1') {
    . $sampleScript
}
if (Test-Path ($reconfigScript = '.\reconfig.ps1')) {
    . $reconfigScript
}
Pop-Location

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

function Test-SkipAddPackages { $ignorePackages }

function Test-ShouldManuallyAddPkgs {
    $hasContent = Test-Path -Exclude .gitkeep "$(Get-ProjectLocation)\packages\manual\*"
    return $hasContent -and !$ignoreManualPackages
}
