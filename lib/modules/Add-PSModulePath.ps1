function Add-PSModulePath([string]$FilePath) {
    $abspath = (Resolve-Path $FilePath).ToString()
    if (-not $env:PSModulePath.Contains($abspath)) {
        $env:PSModulePath = $abspath + [IO.Path]::PathSeparator + $env:PSModulePath
    }
}
