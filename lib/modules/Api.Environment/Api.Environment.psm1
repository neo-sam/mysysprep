function Add-SystemPath([string]$path) {
    $abspath = (Resolve-Path $path).ToString()
    if ($env:path -like "*$abspath*") { return }
    [Environment]::SetEnvironmentVariable('PATH',
        [Environment]::GetEnvironmentVariable('PATH', 'Machine') +
        ";$abspath", 'Machine'
    )
}

function Disable-BundledService([String[]]$names) {
    $services = Get-Service -ea 0 $names | Where-Object { $_.StartType -ne 'Disabled' }
    $services | Stop-Service -ea 0
    $services | Set-Service -StartupType Disabled
}

function Disable-BundledTask([String[]]$names) {
    Get-ScheduledTask -TaskName $names | Disable-ScheduledTask -ErrorAction SilentlyContinue | Out-Null
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
