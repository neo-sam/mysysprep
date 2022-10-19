#Requires -RunAsAdministrator

Stop-Process -Name sysprep -ea 0

. .\lib\load-config.ps1

function getInitScript {
    param([string]$name)
    return [scriptblock]::Create(
        @("cd `"$(Get-Location)`"",
            '. lib\preload-to-feature.ps1',
            "cd features\$name"
        ) -join ';'
    )
}

Write-Output '==> Tweaking features'

foreach ($feature in Get-ChildItem .\features -Directory -Exclude _*) {
    $name = $feature.Name
    if ($cfg = $features[$name]) {
        Start-Job -Name $name -FilePath ".\features\$name\apply.ps1" -ArgumentList $cfg `
            -InitializationScript (getInitScript $name) | Out-Null

        $formatted = switch ($cfg) {
            1 { 'true' }
            0 { 'false' }
            Default { ConvertTo-Json $cfg }
        }
        Write-Host "let $name", '=', ($formatted + ';')
    }
}

Write-Host

function Get-JobOrWait {
    [OutputType([Management.Automation.Job])] param()
    while (Get-Job) {
        if ($job = Get-Job -State Failed | Select-Object -First 1) { return $job }
        if ($job = Get-Job -State Completed | Select-Object -First 1) { return $job }
        if ($job = Get-Job | Wait-Job -Any -Timeout 1) { return $job }
    }
}

while ($job = Get-JobOrWait) {
    $name = $job.Name
    try {
        Receive-Job $job -ErrorAction Stop
        Write-Host -ForegroundColor Green `
            "succeeded: $name"
    }
    catch {
        Write-Host -ForegroundColor Red @"
failed to add: $name, reason:
$($_.Exception.Message)

"@
    }
    finally {
        Remove-Job $job
    }
}

Write-Host

try {
    if ($deploy) {
        & .\deploy\scripts\_main.ps1
    }
    & .\lib\submit.ps1
}
catch {
    Write-Error $_.Exception.Message
    pause
}
