#Requires -RunAsAdministrator

Stop-Process -Name sysprep -ea 0

.\lib\checkToDeployManually.ps1

. .\lib\loadAllConfig.ps1

. .\lib\base.ps1
if ($isAuditMode) {
    net user Administrator /active:yes >$null
}

Write-Output '==> [features] start'

function getInitScript([string]$name) {
    return [scriptblock]::Create(
        @("cd (`$proot='$(Get-Location)')",
            '. features\__base__.ps1',
            "cd features\$name"
        ) -join ';'
    )
}

foreach ($feature in Get-ChildItem .\features -Directory -Exclude _*) {
    if ($cfg = $features[($name = $feature.Name)]) {
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

Write-Output '==> [features] doing...', ''

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
            "Succeeded: $name"
    }
    catch {
        Write-Host -ForegroundColor Red @"
Failed to add: $name, reason:
$($_.Exception.Message)

"@
    }
    finally {
        Remove-Job $job
    }
}

Write-Output '==> [features] end', ''

try {
    if (Test-Path .\deploy) {
        & .\deploy\scripts\__main__.ps1
    }
    & .\lib\submitAll.ps1
}
catch {
    Write-Error $_.Exception.Message
    pause
}
