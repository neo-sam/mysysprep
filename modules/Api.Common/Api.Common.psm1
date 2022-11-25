$wshell = New-Object -ComObject WScript.Shell
function New-Shortcut([string]$path, [switch]$Lnk, [switch]$Url ) {
    if ($Lnk) { $path += '.lnk' }
    elseif ($Url) { $path += '.url' }

    if ((Split-Path $path) -eq '') { $path = "$pwd\$path" }

    $wshell.CreateShortcut($path)
}

function Add-SystemPath([string]$path) {
    $abspath = (Resolve-Path $path).ToString()
    if ($env:path -like "*$abspath*") { return }
    [Environment]::SetEnvironmentVariable('PATH',
        [Environment]::GetEnvironmentVariable('PATH', 'Machine') +
        ";$abspath", 'Machine'
    )
}

function Copy-ToCurrentDesktop([string]$path) {
    Copy-Item -Force $path ([Environment]::GetFolderPath('Desktop'))
}

function New-UserDeployShortcut(
    [string]$ScriptName,
    [string]$LinkName,
    [string]$icon = 'msiexec.exe'
) {
    $it = New-Shortcut -Lnk "C:\Users\Default\Desktop\$(Get-Translation 'Setup' -cn '安装') $LinkName"
    $it.TargetPath = "powershell.exe"
    $it.Arguments = "-exec bypass -file `"$(Get-AppFolderPath -Scripts)\$ScriptName.ps1`""
    $it.IconLocation = $icon
    $it.Save()
}

function Disable-BundledService([String[]]$names) {
    $services = Get-Service -ea 0 $names | Where-Object { $_.StartType -ne 'Disabled' }
    $services | Stop-Service -ea 0
    $services | Set-Service -StartupType Disabled
}

function Disable-BundledTask([String[]]$names) {
    Get-ScheduledTask -TaskName $names | Disable-ScheduledTask -ErrorAction SilentlyContinue | Out-Null
}

function Uninstall-BundledAppx([string]$names) {
    if (!(Get-Module -ListAvailable Appx)) { return }
    if (($mutex = New-Object System.Threading.Mutex($false, 'WinSf-Appx')).WaitOne()) {
        $ProgressPreferenceBefore = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'

        foreach ($rawname in $names.Split("`n")) {
            if (($name = $rawname.Trim()) -eq '') { continue }
            $app = Get-AppxPackage -Name $name

            $splitToPrint = 0
            if ($null -ne $app) {
                $app | Remove-AppxPackage
                Write-Output "[-] Appx:`n    $name"
                $splitToPrint = 1
            }
            Wait-Process dism -ea 0
            $papp = Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $name
            if ($null -ne $app) {
                $papp | Remove-AppxProvisionedPackage -Online | Out-Null
                Write-Output "[-] Provisioned Appx:`n    $name"
                $splitToPrint = 1
            }
            if ( $splitToPrint) { Write-Host }
        }

        $ProgressPreference = $ProgressPreferenceBefore
        [void]$mutex.ReleaseMutex()
    }
}

function Get-Translation(
    [Parameter(Mandatory, ValueFromPipeline)]
    [string]$text,
    [string]$cn
) {
    switch ((Get-Culture).Name) {
        zh-CN { if ($cn) { return $cn } }
    }
    return $text
}

function Get-ProjectLocation {
    "$(Resolve-Path $PSScriptRoot\..\..\)"
}

function Get-CimOrWimInstance([string]$className) {
    if ($PSVersionTable.PSVersion.Major -gt 5) {
        return Get-CimInstance $className
    }
    else {
        return Get-WmiObject $className
    }
}

function Repair-HidpiCompatibility([string[]]$paths = @()) {
    process {
        if ($_ -ne $null) { $paths += ([IO.FileInfo]$_).FullName }
    }end {
        foreach ($path in $paths) {
            if (!(Test-Path ($it = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers'))) {
                mkdir -f $it >$null
            }
            Set-ItemProperty $it $path '~ HIGHDPIAWARE'
        }
    }
}

function Convert-ScriptBlockToText([scriptblock]$block) {
    ($block.ToString() -split "`n" -replace '^    ', '' -join "`n").Trim()
}
