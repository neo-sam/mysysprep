Push-Location $PSScriptRoot

$initSb = [scriptblock]::Create(@(
        "cd '$(Resolve-Path ..\..)'"
        '. lib\preload-for-all.ps1'
        '. lib\preload-for-reg.ps1'
        '. lib\load-config.ps1'
        "cd '$(Get-Location)'"
        ". '$((Get-ChildItem '_init.ps1').FullName)'"
        'cd ..'
    ) -join ';')

$deployTasks = @()
$deployMutexTasks = @()

Write-Output '==> Begin to deploy packages'

$tasks = Get-ChildItem "*.ps1" -Exclude '_*'
Set-Location ..
foreach ($fetchTask in $tasks) {
    $task = & $fetchTask
    $name = $task.name

    if ($null -eq $name) { continue }

    if (($null -ne $task.target) -and (Test-Path $task.target -ea 0)) {
        Write-Output "ignored installed: $name"
        continue
    }
    $task.path = $fetchTask
    if ( $task.mutex ) { $deployMutexTasks += $task }
    else { $deployTasks += $task }
}

mkdir -f .\log > $null

foreach ($task in $deployTasks) {
    $name = $task.name
    Write-Output "adding a package: $name"
    Start-Job `
        -InitializationScript $initSb `
        -Name $task.name -FilePath $task.path | Out-Null
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
            "succeeded to add the package: $name"
    }
    catch {
        Write-Host -ForegroundColor Red @"
failed to add the package: $name, reason:
$($_.Exception.Message)

"@
    }
    finally {
        Remove-Job $job
    }
}

foreach ($task in $deployMutexTasks) {
    $name = $task.name
    Write-Output "installing a package: $name"
    try {
        $job = Start-Job `
            -InitializationScript $initSb `
            -Name $task.name -FilePath $task.path
        Wait-Job $job | Receive-Job
        Write-Host -ForegroundColor Green `
            "succeeded to install: $name"
    }
    catch {
        Write-Host -ForegroundColor Red @"
failed to install: $name, reason:
$($_.Exception.Message)

"@
    }
    finally {
        if ($job) { Remove-Job $job }
    }
}

Write-Output '==> Finish package deployment'

Pop-Location
