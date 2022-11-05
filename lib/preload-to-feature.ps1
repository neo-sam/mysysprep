. .\lib\preload-for-all.ps1
. .\lib\preload-for-reg.ps1

function Disable-BundledService([String[]]$names) {
    $services = Get-Service $names | Where-Object { $_.StartType -ne 'Disabled' }
    $services | Stop-Service
    $services | Set-Service -StartupType Disabled
}

function Disable-BundledTask([String[]]$names) {
    Get-ScheduledTask -TaskName $names | Disable-ScheduledTask -ErrorAction SilentlyContinue | Out-Null
}

function Start-DismMutex([scriptblock]$sb) {
    Wait-Process dism -ea 0

    $mutex = New-Object System.Threading.Mutex($false, 'WinSf-Dism')
    if ($mutex.WaitOne()) {
        & $sb
        [void]$mutex.ReleaseMutex()
    }
}

function Uninstall-BundledAppx([string]$names) {
    $mutex = New-Object System.Threading.Mutex($false, 'WinSf-Appx')

    if ($mutex.WaitOne()) {
        $ProgressPreferenceBefore = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'

        foreach ($rawname in $names.Split("`n")) {
            if (($name = $rawname.Trim()) -eq '') { continue }
            $app = Get-AppxPackage -Name $name

            if ($null -ne $app) {
                $app | Remove-AppxPackage
                Write-Host
                Write-Output "Remove-AppxPackage $name`: succeeded."
            }
            Wait-Process dism -ea 0
            $papp = Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $name
            if ($null -ne $app) {
                $papp | Remove-AppxProvisionedPackage -Online | Out-Null
                Write-Output "Remove-AppxProvisionedPackage $name`: succeeded."
            }
        }

        $ProgressPreference = $ProgressPreferenceBefore
        [void]$mutex.ReleaseMutex()
    }
}

$Script:proot = "$(Get-Location)"
