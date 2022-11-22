#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'Microsoft.WindowsTerminal_*_8wekyb3d8bbwe.msixbundle'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name = 'Windows Terminal'
    }
}

function Add-AppxProvisionedPackageAndExit([string]$path) {
    Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath $path | Out-Null
    exit
}

if (Test-Windows10) {
    if ($it = Get-ChildItem -ea 0 'Microsoft.WindowsTerminal_Win10_*_8wekyb3d8bbwe.msixbundle') {
        Add-AppxProvisionedPackageAndExit $it.FullName
    }
}

if (Test-Windows11) {
    if ($it = Get-ChildItem -ea 0 'Microsoft.WindowsTerminal_Win11_*_8wekyb3d8bbwe.msixbundle') {
        Add-AppxProvisionedPackageAndExit $it.FullName
    }
}

if ($it = Get-ChildItem -ea 0 'Microsoft.WindowsTerminal_*_8wekyb3d8bbwe.msixbundle') {
    Add-AppxProvisionedPackageAndExit $it.FullName
}
