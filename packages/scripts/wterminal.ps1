#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'Microsoft.WindowsTerminal_*_8wekyb3d8bbwe.msixbundle'
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name = 'Windows Terminal'
    }
}

if (Test-Windows10) {
    if ($it = Get-ChildItem -ea 0 'Microsoft.WindowsTerminal_Win10_*_8wekyb3d8bbwe.msixbundle') {
        Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath $it.FullName
        exit
    }
}

if (Test-Windows11) {
    if ($it = Get-ChildItem -ea 0 'Microsoft.WindowsTerminal_Win11_*_8wekyb3d8bbwe.msixbundle') {
        Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath $it.FullName
        exit
    }
}

if ($it = Get-ChildItem -ea 0 'Microsoft.WindowsTerminal_*_8wekyb3d8bbwe.msixbundle') {
    Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath $it
    exit
}
