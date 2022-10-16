[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
param()

$modules = @{ deploy = @{} }
. .\lib\load-commonfn.ps1
. .\lib\load-env-with-cfg.ps1
. .\lib\load-reghelper.ps1
$cfg = $modules.deploy

function Get-PackageFile() {
    [OutputType([IO.FileSystemInfo])] param($pattern)
    return Get-ChildItem "pkgs\$pattern" -ErrorAction SilentlyContinue
}

function Push-SystemPath {
    param([string]$path)
    if ($env:path -like "*$path*") { return }
    [Environment]::SetEnvironmentVariable("PATH",
        [Environment]::GetEnvironmentVariable("PATH", "Machine") +
        ";$path", "Machine")
}

function Assert-Path {
    param([string]$path)
    Get-ChildItem $path -ea Stop > $null
}
