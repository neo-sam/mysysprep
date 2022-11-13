#Requires -RunAsAdministrator

if ($skipDeploy) { exit }

Push-Location $PSScriptRoot

$initSb = [scriptblock]::Create(@(
        "cd '$(Resolve-Path $PSScriptRoot\..\..)'"
        '. .\deploy\scripts\__base__.ps1'
        'cd deploy'
        @'
$PSDefaultParameterValues = @{
'Start-Process:WindowStyle'='Minimized'
}
'@
    ) -join ';')

$deployTasks = @()
$deployMutexTasks = @()

function Get-JobOrWait {
    [OutputType([Management.Automation.Job])] param()
    while (Get-Job) {
        if ($job = Get-Job -State Failed | Select-Object -First 1) { return $job }
        if ($job = Get-Job -State Completed | Select-Object -First 1) { return $job }
        if ($job = Get-Job | Wait-Job -Any -Timeout 1) { return $job }
    }
}

Write-Output '==> [deploy] start'
mkdir -f .\log > $null

$tasks = Get-ChildItem "*.ps1" -Exclude '__*__.ps1'
Set-Location ..
foreach ($fetchTask in $tasks) {
    $task = & $fetchTask
    $name = $task.name

    if ($null -eq $name) { continue }

    if (($null -ne $task.target) -and (Test-Path $task.target -ea 0)) {
        Write-Output "Ignored installed: $name"
        continue
    }
    $task.path = $fetchTask
    if ( $task.mutex ) { $deployMutexTasks += $task }
    else { $deployTasks += $task }
}

foreach ($task in $deployTasks) {
    $name = $task.name
    Write-Output "Adding a package: $name"
    Start-Job `
        -InitializationScript $initSb `
        -Name $task.name -FilePath $task.path | Out-Null
}

Write-Output '==> [deploy] doing add...', ''

while ($job = Get-JobOrWait) {
    $name = $job.Name
    try {
        Receive-Job $job -ErrorAction Stop
        Write-Host -ForegroundColor Green `
            "Succeeded to add the package: $name"
    }
    catch {
        Write-Host -ForegroundColor Red @"
Failed to add the package: $name, reason:
$($_.Exception.Message)

"@
    }
    finally {
        Remove-Job $job
    }
}

Write-Output '==> [deploy] doing install...', ''

foreach ($task in $deployMutexTasks) {
    $name = $task.name
    Write-Output "Installing a package: $name"
    try {
        $job = Start-Job `
            -InitializationScript $initSb `
            -Name $task.name -FilePath $task.path
        Wait-Job $job | Receive-Job
        Write-Host -ForegroundColor Green `
            "Succeeded to install: $name"
    }
    catch {
        Write-Host -ForegroundColor Red @"
Failed to install: $name, reason:
$($_.Exception.Message)

"@
    }
    finally {
        if ($job) { Remove-Job $job }
    }
}

Write-Output '==> [deploy] end'

Pop-Location
