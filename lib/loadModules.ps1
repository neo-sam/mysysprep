$modulesFolderPath = "$PSScriptRoot\..\modules"
if (-not $env:PSModulePath.Contains($modulesFolderPath)) {
    $env:PSModulePath = $modulesFolderPath + [IO.Path]::PathSeparator + $env:PSModulePath
}
