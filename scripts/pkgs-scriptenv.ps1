# Load this script if writing a .\scripts\pkgs installer script in vscode

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
param()

function Push-SystemPath {
    param([string]$path)
    if ($env:path -like "*$path*") { return }
    setx /m PATH "$env:path;$path" > $null
}

function Assert-Path {
    param([string]$path)
    Get-ChildItem $path -ea Stop > $null
}
