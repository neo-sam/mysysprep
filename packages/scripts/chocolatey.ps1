#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'chocolatey.*.nupkg'
$ChocoInstallPath = "$($env:SystemDrive)\ProgramData\Chocolatey\bin"
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'Chocolatey'
        target = "$ChocoInstallPath\choco.exe"
    }
}

# - $env:ChocolateyEnvironmentDebug = 'true' # see output

Set-ExecutionPolicy Bypass -Scope Process -Force

# Reroute TEMP to a local location
New-Item $env:ALLUSERSPROFILE\choco-cache -ItemType Directory -Force >$null
$env:TEMP = "$env:ALLUSERSPROFILE\choco-cache"

$env:ChocolateyInstall = "$($env:SystemDrive)\ProgramData\Chocolatey"
$env:Path += ";$ChocoInstallPath"
$DebugPreference = 'Continue';

# Idempotence - do not install Chocolatey if it is already installed
if (Test-Path $ChocoInstallPath) { return }

# Attempt to set highest encryption available for SecurityProtocol.
# PowerShell will not set this by default (until maybe .NET 4.6.x). This
# will typically produce a message for PowerShell v2 (just an info
# message though)
try {
    # Set TLS 1.2 (3072), then TLS 1.1 (768), then TLS 1.0 (192), finally SSL 3.0 (48)
    # Use integers because the enumeration values for TLS 1.2 and TLS 1.1 won't
    # exist in .NET 4.0, even though they are addressable if .NET 4.5+ is
    # installed (.NET 4.5 is an in-place upgrade).
    [System.Net.ServicePointManager]::SecurityProtocol = 3072 -bor 768 -bor 192 -bor 48
}
catch {
    Write-Output "It's better to upgrade to .NET Framework 4.5+ and PowerShell v3+."
}

$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "chocInstall"
if (![System.IO.Directory]::Exists($tempDir)) { [System.IO.Directory]::CreateDirectory($tempDir) | Out-Null }
$file = Join-Path $tempDir "chocolatey.zip"

Copy-Item $pkg.FullName $file

# unzip the package
if ($PSVersionTable.PSVersion.Major -lt 5) {
    try {
        $shellApplication = New-Object -com shell.application
        $zipPackage = $shellApplication.NameSpace($file)
        $destinationFolder = $shellApplication.NameSpace($tempDir)
        $destinationFolder.CopyHere($zipPackage.Items(), 0x10)
    }
    catch {
        throw "Unable to unzip package using built-in compression. Set `$env:chocolateyUseWindowsCompression = 'false' and call install again to use 7zip to unzip. Error: `n $_"
    }
}
else {
    Expand-Archive -Force "$file" "$tempDir"
}

# Call Chocolatey install
$toolsFolder = Join-Path $tempDir "tools"
$chocInstallPS1 = Join-Path $toolsFolder "chocolateyInstall.ps1"

powershell -exec bypass -file $chocInstallPS1 > log\chocolatey.log

# Write-Output 'Ensuring chocolatey commands are on the path'
$chocInstallVariableName = 'ChocolateyInstall'
$chocoPath = [Environment]::GetEnvironmentVariable($chocInstallVariableName)
if ($chocoPath -eq $null -or $chocoPath -eq '') {
    $chocoPath = 'C:\ProgramData\Chocolatey'
}

$chocoExePath = Join-Path $chocoPath 'bin'

if ($($env:Path).ToLower().Contains($($chocoExePath).ToLower()) -eq $false) {
    $env:Path = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine);
}

# Write-Output 'Ensuring chocolatey.nupkg is in the lib folder'
$chocoPkgDir = Join-Path $chocoPath 'lib\chocolatey'
$nupkg = Join-Path $chocoPkgDir 'chocolatey.nupkg'
if (!(Test-Path $nupkg)) {
    # Write-Output 'Copying chocolatey.nupkg is in the lib folder'
    if (![System.IO.Directory]::Exists($chocoPkgDir)) { [System.IO.Directory]::CreateDirectory($chocoPkgDir) | Out-Null }
    Copy-Item "$file" "$nupkg" -ErrorAction SilentlyContinue
}

# Custom:
& 'C:\ProgramData\chocolatey\bin\choco.exe' feature enable -n allowGlobalConfirmation >$null
