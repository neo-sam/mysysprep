Push-Location $PSScriptRoot\..
& .\lib\modules\master\import.ps1

$activity = 'Applying changes ...'
$totalJobs = 0
$totalCompletedJobs = 0

$jobScript = {
    param($name, $cfg)
    Set-Location "$Using:PSScriptRoot\.."
    & .\lib\modules\api\feature\import.ps1
    Set-Location ".\features\$name"
    . .\apply.ps1 $cfg
}

foreach ($feature in Get-ChildItem .\features -Directory -Exclude _*) {
    if ($cfg = Get-FeatureConfig ($name = $feature.Name)) {
        Start-RSJob $jobScript -Name $name -ArgumentList $name, $cfg | Out-Null

        $totalJobs++

        $formatted = switch ($cfg) {
            1 { 'true' }
            0 { 'false' }
            Default { ConvertTo-Json $cfg }
        }
        Write-Host "let $name", '=', ($formatted + ';')
    }
}

Write-Output '', '--> Submit changes:'

while ($job = Get-RSJobOrWait) {
    $name = $job.Name
    $result = Receive-RSJob $job
    if ($job.HasErrors) {
        Write-Host -ForegroundColor Red "[!] $name"
        if ($result) {
            Write-Host -ForegroundColor Red "    $result"
            Write-Host
        }
    }
    else {
        Write-Output $result
        Write-Host -ForegroundColor Green "[+] $name"
    }
    Remove-RSJob $job

    $totalCompletedJobs++
    Write-Progress $activity 0 `
        -status "$totalCompletedJobs / $totalJobs" `
        -PercentComplete ($totalCompletedJobs / $totalJobs * 100)
}
Write-Progress $activity 0 -Completed

Pop-Location
