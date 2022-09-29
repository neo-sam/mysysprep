Write-Output '==> Deploy Packages',
'If prompt installation dialogs, allow and confirm ...' ''

$repoRoot = (Get-Location).path
$initScript = (Get-ChildItem .\modules\deploy-pkgs\_init.ps1).FullName
$initScriptBlock = [scriptblock]::Create(". `"$initScript`";cd `"$repoRoot`"")
$runParallelScripts = Get-ChildItem '.\modules\deploy-pkgs\scripts\parallel\*.ps1'
$runScripts = Get-ChildItem '.\modules\deploy-pkgs\scripts\*.ps1'

. .\modules\deploy-pkgs\_init.ps1

Push-Location $repoRoot

foreach ($runScript in $runParallelScripts) {
    if ($name = & $runScript.FullName) {
        Write-Host "Adding package: $name"
        Start-Job `
            -InitializationScript $initScriptBlock `
            -Name $name -FilePath $runScript |
        Out-Null
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

while ($job = (Get-JobOrWait)) {
    $name = $job.Name
    try {
        Receive-Job $job -ErrorAction Stop
        Write-Output "Successfully added package: $name." ''
    }
    catch {
        Write-Output "Fail to add package: $name",
        "Reason: $($_.Exception.Message)", ''
    }
    finally {
        Remove-Job $job
    }
}

Pop-Location

foreach ($runScript in $runScripts) {
    $name = $runScript.BaseName
    Write-Host "Installing package: $name"
    try {
        & $runScript
        Write-Output "Successfully added package: $name." ''
    }
    catch {
        Write-Output "Fail to add package: $name",
        "Reason: $($_.Exception.Message)", ''
    }
}
