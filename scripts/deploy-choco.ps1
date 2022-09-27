
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')]
param()

$localChocolateyPackageFilePath = (Get-ChildItem ..\pkgs\chocolatey.*.nupkg).FullName
if ($null -eq $localChocolateyPackageFilePath) { exit }

# === ENVIRONMENT VARIABLES YOU CAN SET ===
# Prior to running this script, in a PowerShell session, you can set the
# following environment variables and it will affect the output

# - $env:ChocolateyEnvironmentDebug = 'true' # see output
# - $env:chocolateyIgnoreProxy = 'true' # ignore proxy
# - $env:chocolateyProxyLocation = '' # explicit proxy
# - $env:chocolateyProxyUser = '' # explicit proxy user name (optional)
# - $env:chocolateyProxyPassword = '' # explicit proxy password (optional)

# === NO NEED TO EDIT ANYTHING BELOW THIS LINE ===
# Ensure we can run everything
Set-ExecutionPolicy Bypass -Scope Process -Force;

# Reroute TEMP to a local location
New-Item $env:ALLUSERSPROFILE\choco-cache -ItemType Directory -Force >$null
$env:TEMP = "$env:ALLUSERSPROFILE\choco-cache"

$ChocoInstallPath = "$($env:SystemDrive)\ProgramData\Chocolatey\bin"
$env:ChocolateyInstall = "$($env:SystemDrive)\ProgramData\Chocolatey"
$env:Path += ";$ChocoInstallPath"
$DebugPreference = 'Continue';

# PowerShell v2/3 caches the output stream. Then it throws errors due
# to the FileStream not being what is expected. Fixes "The OS handle's
# position is not what FileStream expected. Do not use a handle
# simultaneously in one FileStream and in Win32 code or another
# FileStream."
function Fix-PowerShellOutputRedirectionBug {
    $poshMajorVerion = $PSVersionTable.PSVersion.Major

    if ($poshMajorVerion -lt 4) {
        try {
            # http://www.leeholmes.com/blog/2008/07/30/workaround-the-os-handles-position-is-not-what-filestream-expected/ plus comments
            $bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetField"
            $objectRef = $host.GetType().GetField("externalHostRef", $bindingFlags).GetValue($host)
            $bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetProperty"
            $consoleHost = $objectRef.GetType().GetProperty("Value", $bindingFlags).GetValue($objectRef, @())
            [void] $consoleHost.GetType().GetProperty("IsStandardOutputRedirected", $bindingFlags).GetValue($consoleHost, @())
            $bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetField"
            $field = $consoleHost.GetType().GetField("standardOutputWriter", $bindingFlags)
            $field.SetValue($consoleHost, [Console]::Out)
            [void] $consoleHost.GetType().GetProperty("IsStandardErrorRedirected", $bindingFlags).GetValue($consoleHost, @())
            $field2 = $consoleHost.GetType().GetField("standardErrorWriter", $bindingFlags)
            $field2.SetValue($consoleHost, [Console]::Error)
        }
        catch {
            Write-Output 'Unable to apply redirection fix.'
        }
    }
}

Fix-PowerShellOutputRedirectionBug

function Install-ChocolateyFromPackage {
    param (
        [string]$chocolateyPackageFilePath = ''
    )

    if ($chocolateyPackageFilePath -eq $null -or $chocolateyPackageFilePath -eq '') {
        throw "You must specify a local package to run the local install."
    }

    if (!(Test-Path($chocolateyPackageFilePath))) {
        throw "No file exists at $chocolateyPackageFilePath"
    }

    $chocTempDir = Join-Path $env:TEMP "chocolatey"
    $tempDir = Join-Path $chocTempDir "chocInstall"
    if (![System.IO.Directory]::Exists($tempDir)) { [System.IO.Directory]::CreateDirectory($tempDir) | Out-Null }
    $file = Join-Path $tempDir "chocolatey.zip"
    Copy-Item $chocolateyPackageFilePath $file -Force

    # unzip the package
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        try {
            $shellApplication = new-object -com shell.application
            $zipPackage = $shellApplication.NameSpace($file)
            $destinationFolder = $shellApplication.NameSpace($tempDir)
            $destinationFolder.CopyHere($zipPackage.Items(), 0x10)
        }
        catch {
            throw "Unable to unzip package using built-in compression. Set `$env:chocolateyUseWindowsCompression = 'false' and call install again to use 7zip to unzip. Error: `n $_"
        }
    }
    else {
        Expand-Archive -Path "$file" -DestinationPath "$tempDir" -Force
    }

    # Call Chocolatey install
    $toolsFolder = Join-Path $tempDir "tools"
    $chocInstallPS1 = Join-Path $toolsFolder "chocolateyInstall.ps1"

    powershell -exec bypass -file $chocInstallPS1 > ..\logs\chocolatey.log

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
        Copy-Item "$file" "$nupkg" -Force -ErrorAction SilentlyContinue
    }
}

# Idempotence - do not install Chocolatey if it is already installed
if (!(Test-Path $ChocoInstallPath)) {
    Write-Host 'Installing Chocolatey ...'
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
    
    New-Item -ItemType File $profile -ea 0 >$null
    Install-ChocolateyFromPackage $localChocolateyPackageFilePath
    if (Test-Path "$ChocoInstallPath\choco.exe") {
        Write-Host 'Installed Chocolatey.'
    }
    else {
        Write-Host 'Failed to install Chocolatey.'
    }
}