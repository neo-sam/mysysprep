#Requires -RunAsAdministrator

Push-Location $PSScriptRoot\..\..
& .\lib\loadModules.ps1

$scriptBlock = {
    param($path)
    Set-Location "$Using:PSScriptRoot\..\.."
    .\lib\loadModules.ps1
    Import-Module ConfigLoader
    $ErrorActionPreference = 'Stop'
    $PSDefaultParameterValues.Add('Start-Process:WindowStyle', 'Hidden')
    Set-Location 'packages'
    & $path
}

$deployTasks = @()
$deployMutexTasks = @()

Set-Location "$PSScriptRoot\.."
mkdir -f .\logs > $null
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
if ($totalJobs = $deployTasks.Count) {
    $completedJobs = 0

    Write-Output '', '--> status:'

    foreach ($task in $deployTasks) {
        $name = $task.name
        Write-Output "(+) $name"
        Start-RSJob $scriptBlock -Name $name -ArgumentList $task.path | Out-Null
    }

    $activity = 'Adding packages ...'
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

        $completedJobs++
        Write-Progress $activity 0 `
            -status "$completedJobs / $totalJobs" `
            -PercentComplete ($completedJobs / $totalJobs * 100)
    }
    Write-Progress $activity 0 -Completed
}

if ($totalMutexJobs = $deployMutexTasks.Count) {
    $completedMutexJobs = 0

    Write-Output '', '--> add packges one by one:'

    $PSDefaultParameterValues.Add('Start-Process:WindowStyle', 'Hidden')

    $activity = 'Adding packages one by one ...'
    foreach ($task in $deployMutexTasks) {
        $name = $task.name
        Write-Output "(+) $name"
        try {
            & $task.path
            Write-Host -ForegroundColor Green `
                "[+] $name"
        }
        catch {
            Write-Host -ForegroundColor Red @"
[!] $name
    $($_.Exception.Message)

"@
        }

        $completedMutexJobs++
        Write-Progress $activity 0 `
            -status "$completedMutexJobs / $totalMutexJobs" `
            -PercentComplete ($completedMutexJobs / $totalMutexJobs * 100)
    }
    Write-Progress $activity 0 -Completed
}
Pop-Location
