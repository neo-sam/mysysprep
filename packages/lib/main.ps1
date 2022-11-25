#Requires -RunAsAdministrator

Push-Location $PSScriptRoot\..\..
& .\lib\loadModules.ps1

$scriptBlock = {
    param($path)
    Set-Location "$Using:PSScriptRoot\..\.."
    .\lib\loadModules.ps1
    Import-Module ConfigLoader
    $ErrorActionPreference = 'Stop'
    Set-Location 'packages'
    & $path
}

$deployTasks = @()
$deployMutexTasks = @()

function Get-RSJobOrWait {
    [OutputType([Management.Automation.Job])] param()
    while (Get-RSJob) {
        if ($job = Get-RSJob -State Failed | Select-Object -First 1) {
            Remove-RSJob $job
            return $job
        }
        if ($job = Get-RSJob -State Completed | Select-Object -First 1) {
            Remove-RSJob $job
            return $job
        }
        Get-RSJob | Wait-RSJob -Timeout 1 | Out-Null
    }
}

Write-Output '==> start to add packages'
mkdir -f .\log > $null

Set-Location "$PSScriptRoot\.."
$scripts = Get-ChildItem "scripts\*.ps1" -Exclude '__*__.ps1'
foreach ($scriptFile in $scripts) {
    $metadata = & $scriptFile -GetMetadata
    $name = $metadata.name

    if ($null -eq $metadata.match) { continue }
    if (!($metadata.variant) -and ($metadata.match.Count -ne 1)) {
        Write-Host -ForegroundColor Red 'Multiple Version Conflict:'
        foreach ($pkg in $metadata.match) {
            Write-Host -ForegroundColor Red $pkg
        }
        Write-Host
        continue
    }
    if ($metadata.ignore -and (& $metadata.ignore)) {
        Write-Output "(-) skip: $name"
        continue
    }

    $task = @{
        name = $name
        path = $scriptFile.FullName
    }
    if ( $metadata.mutex ) { $deployMutexTasks += $task }
    else { $deployTasks += $task }
}

foreach ($task in $deployTasks) {
    $name = $task.name
    Write-Output "(+): $name"
    Start-RSJob $scriptBlock -Name $name -ArgumentList $task.path | Out-Null
}

Write-Output '', '|-> Adding packages...', ''

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
}

Write-Output '|-> Adding packges one by one...', ''

foreach ($task in $deployMutexTasks) {
    $name = $task.name
    Write-Output "(+) $name"
    try {
        Start-RSJob $scriptBlock -Name $name -ArgumentList $task.path | Wait-RSJob | Receive-RSJob
        Write-Host -ForegroundColor Green `
            "[+] $name"
    }
    catch {
        Write-Host -ForegroundColor Red @"
[!] $name
>E: $($_.Exception.Message)

"@
    }
}

Write-Output '==> end to add packages'

Pop-Location
