$supportAppx = !!(Get-Command -ea 0 Get-AppxPackage)
function Test-AppxSystemAvailable { $supportAppx }

function Uninstall-BundledAppx([string]$names) {
    if (!$supportAppx) { return }
    if (($mutex = New-Object System.Threading.Mutex($false, 'WinSf-Appx')).WaitOne()) {
        $ProgressPreferenceBefore = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'

        foreach ($rawname in $names.Split("`n")) {
            if (($name = $rawname.Trim()) -eq '') { continue }
            $app = Get-AppxPackage -Name $name

            $splitToPrint = 0
            if ($null -ne $app) {
                $app | Remove-AppxPackage
                Write-Output "<X> Appx:`n    $name"
                $splitToPrint = 1
            }
            Wait-Process dism -ea 0
            $papp = Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $name
            if ($null -ne $app) {
                $papp | Remove-AppxProvisionedPackage -Online | Out-Null
                Write-Output "<X> Provisioned Appx:`n    $name"
                $splitToPrint = 1
            }
            if ( $splitToPrint) { Write-Host }
        }

        $ProgressPreference = $ProgressPreferenceBefore
        [void]$mutex.ReleaseMutex()
    }
}
