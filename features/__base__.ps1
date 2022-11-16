. .\lib\base.ps1
. .\lib\prepareForRegOfAllUsers.ps1

$Script:osver = [Environment]::OSVersion.Version
$Script:osbver = [Environment]::OSVersion.Version.Build

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
                Write-Output "Remove-AppxPackage $name`: succeeded."
                $splitToPrint = 1
            }
            Wait-Process dism -ea 0
            $papp = Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $name
            if ($null -ne $app) {
                $papp | Remove-AppxProvisionedPackage -Online | Out-Null
                Write-Output "Remove-AppxProvisionedPackage $name`: succeeded."
                $splitToPrint = 1
            }
            if ( $splitToPrint) { Write-Host }
        }

        $ProgressPreference = $ProgressPreferenceBefore
        [void]$mutex.ReleaseMutex()
    }
}
