# Load this script if writing a .\scripts\pkgs installer script in vscode

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
param()

$modules = @{ deploy_pkgs = @{} }
. .\lib\load-env-with-cfg.ps1
$cfg = $modules.deploy_pkgs

function Get-PackageFile() {
    [OutputType([IO.FileSystemInfo])] param($pattern)
    return Get-ChildItem "pkgs\$pattern" -ErrorAction SilentlyContinue
}

function Push-SystemPath {
    param([string]$path)
    if ($env:path -like "*$path*") { return }
    [Environment]::SetEnvironmentVariable("PATH",
        [Environment]::GetEnvironmentVariable("PATH", "Machine") +
        ";${value}", "Machine")
}

function Assert-Path {
    param([string]$path)
    Get-ChildItem $path -ea Stop > $null
}
