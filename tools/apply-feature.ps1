#Requires -RunAsAdministrator
param(
    [Parameter(Mandatory)]$path,
    [Parameter(ValueFromPipeline)]$InputObject
)

Push-Location "$PSScriptRoot\.."
.\lib\loadModules.ps1

$names = (Get-Item $path).Name

$activity = 'Applying changes ...'
$totalJobs = 0
$totalCompletedJobs = 0

$jobScript = {
    param($name, $cfg)
    Set-Location "$Using:PSScriptRoot\.."
    & .\lib\loadModules.ps1
    Set-Location ".\features\$name"
    . .\apply.ps1 $cfg
}

Write-Host
foreach ($name in $names) {
    $cfg = if ($null -eq $InputObject) {
        if ($flag = Get-FeatureConfig $name) { $flag }
        else { 1 }
    }
    elseif ($InputObject.GetType() -eq [string]) {
        ConvertFrom-Json $InputObject
    }
    else {
        $InputObject
    }

    Start-RSJob $jobScript -Name $name -ArgumentList $name, $cfg | Out-Null

    $totalJobs++

    $formatted = switch ($cfg) {
        1 { 'true' }
        0 { 'false' }
        Default { ConvertTo-Json $cfg }
    }
    Write-Host "let $name", '=', ($formatted + ';')
}

Write-Host
if ($totalJobs -gt 1) {
    Write-Output '--> Submit changes:'
}

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
Write-Host

if (Test-RunAsAdmin) {
    .\lib\submitNewUserRegistry.ps1
}
Pop-Location
