. lib\preload-for-all.ps1
. lib\preload-for-reg.ps1

function Push-SystemPath([string]$path) {
    if ($env:path -like "*$path*") { return }
    [Environment]::SetEnvironmentVariable("PATH",
        [Environment]::GetEnvironmentVariable("PATH", "Machine") +
        ";$path", "Machine")
}

function Assert-Path([string]$path) {
    Get-ChildItem $path -ea Stop > $null
}

. lib\load-config.ps1
