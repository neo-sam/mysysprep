. .\lib\loadModules.ps1

Stop-Process -ea 0 -Name sysprep

if ($PSVersionTable.PSVersion.Major -lt 5) {
    .\lib\doPowershellUpdate.ps1
    exit
}

if (!(Test-RunAsAdmin)) {
    Write-Error 'Require to run as the Administrator.'
    Read-AnyKey
    exit
}

if (Test-Path -Exclude .gitkeep ".\packages\manual\*") {
    .\lib\tryToOpenManualInstallPackages.ps1
    if ($LASTEXITCODE) { exit }
}

if (Test-AuditMode) {
    net user Administrator /active:yes >$null
}

Write-Output '==> Start to apply features'

function getInitScript([string]$name) {
    return [scriptblock]::Create(
        @("cd '$(Get-Location)'"
            '.\lib\loadModules.ps1'
            'Import-Module ConfigLoader'
            "cd features\$name"
        ) -join ';'
    )
}

foreach ($feature in Get-ChildItem .\features -Directory -Exclude _*) {
    if ($cfg = Get-FeatureConfig ($name = $feature.Name)) {
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

Write-Output '', 'Runing ...', ''

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
            "Succeeded: $name $('({0:F2}s)' -f ($job.PsEndTime - $job.PsBeginTime).TotalSeconds)"
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

Write-Output 'OK!', ''

try {
    if ((Test-Path .\packages) -and !(Test-IgnorePackages)) {
        & .\packages\lib\main.ps1
    }

    if (Test-Path 'C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1') {
        try {
            Set-ExecutionPolicy -Scope LocalMachine RemoteSigned -Force
        }
        catch [System.Security.SecurityException] {}
    }

    .\lib\submit.ps1
}
catch {
    Write-Error $_.Exception.Message
    pause
}
