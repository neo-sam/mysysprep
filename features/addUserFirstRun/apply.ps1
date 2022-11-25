#Requires -RunAsAdministrator

param($cfg)

$firstrunPath = "$(Get-AppFolderPath -Scripts)\firstrun.ps1"

if ($text = Get-Content '.\script.ps1' -ea 0) {
    if ($cfg | Get-Member GetEnumerator) {
        $text += ''
        foreach ($pair in $cfg.GetEnumerator()) {
            if ($pair.Value) {
                $text += $pair.Name
            }
        }
    }
    if (((Get-FeatureConfig tweakTaskbar).w10noAd) -and (Test-Windows10)) {
        $text += 'hideWin10TaskbarAd'
    }
    $text | Out-File -Encoding unicode $firstrunPath
}

if (!$isAuditMode) {
    $it = New-Shortcut "C:\Users\Default\Desktop\Firstrun.lnk"
    $it.TargetPath = "powershell.exe"
    $it.Arguments = "-exec bypass -file `"$firstrunPath`""
    $it.IconLocation = "shell32.dll,99"
    $it.save()
}

& $firstrunPath
