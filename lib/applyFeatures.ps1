Push-Location $PSScriptRoot\..
& .\lib\loadModules.ps1
Import-Module ConfigLoader

$scriptBlock = {
    param($name, $cfg)
    Set-Location "$Using:PSScriptRoot\.."
    & .\lib\loadModules.ps1
    Set-Location ".\features\$name"
    . .\apply.ps1 $cfg
}

foreach ($feature in Get-ChildItem .\features -Directory -Exclude _*) {
    if ($cfg = Get-FeatureConfig ($name = $feature.Name)) {
        Start-RSJob $scriptBlock -Name $name -ArgumentList $name, $cfg | Out-Null

        $formatted = switch ($cfg) {
            1 { 'true' }
            0 { 'false' }
            Default { ConvertTo-Json $cfg }
        }
        Write-Host "let $name", '=', ($formatted + ';')
    }
}

Write-Output '', '|-> submit changes ...', ''

function Get-RSJobOrWait {
    while (Get-RSJob) {
        if ($jobs = Get-RSJob -State Failed) { return $jobs[0] }
        if ($jobs = Get-RSJob -State Completed) { return $jobs[0] }
        Get-RSJob | Wait-RSJob -Timeout 1 | Out-Null
    }
}

while ($job = Get-RSJobOrWait) {
    $name = $job.Name
    try {
        Receive-RSJob $job -ErrorAction Stop
        Write-Host -ForegroundColor Green `
            "[+] $name"
    }
    catch {
        Write-Host -ForegroundColor Red @"
[!] $name
>E: $($_.Exception.Message)

"@
    }
    finally {
        Remove-RSJob $job
    }
}

Pop-Location
