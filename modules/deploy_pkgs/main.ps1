$modules = @{ deploy_pkgs = @{} }
$cfg = $modules.deploy_pkgs
. .\lib\load-env-with-cfg.ps1

$envScript = (Get-ChildItem "$(Get-ScriptRoot)\_init_.ps1").FullName
$envScriptBlock = [scriptblock]::Create("cd `"$(Get-Location)`";. `"$envScript`"")

[Collections.ArrayList]$deployScriptsWithName = @()
[Collections.ArrayList]$deployMutexScriptsWithName = @()

function Get-PackageFile() {
    [OutputType([IO.FileSystemInfo])] param($pattern)
    return Get-ChildItem "pkgs\$pattern" -ErrorAction SilentlyContinue
}

foreach ($deployScript in Get-ChildItem '.\pkgs-scripts\*.ps1') {
    $result = & $deployScript
    if ($null -eq $result) { continue }
    elseif ($result.GetType() -eq [string]) {
        if ($isAdmin) { $deployScriptsWithName.Add(@($deployScript, $result))>$null }
    }
    elseif ($result -notcontains 'userlevel') {
        if ($result -contains 'mutex') {
            if ($isAdmin) { $deployMutexScriptsWithName.Add(@($deployScript, $result[0]))>$null }
        }
    }
    else {
        if ($result -notcontains 'mutex') {
            $deployScriptsWithName.Add(@($deployScript, $result[0]))>$null
        }
        else { $deployMutexScriptsWithName.Add(@($deployScript, $result[0]))>$null }
    }
}

foreach ($tuple in $deployScriptsWithName) {
    $deployScript = $tuple[0]
    $name = $tuple[1]

    Write-Output "Adding package: $name"
    Start-Job `
        -InitializationScript $envScriptBlock `
        -Name $name -FilePath $deployScript | Out-Null
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
        Write-Output "Successfully add package: $name." ''
    }
    catch {
        Write-Output "Fail to add package: $name",
        "Reason: $($_.Exception.Message)", ''
    }
    finally {
        Remove-Job $job
    }
}

foreach ($tuple in $deployMutexScriptsWithName) {
    $deployScript = $tuple[0]
    $name = $tuple[1]

    Write-Output "Installing: $name"
    try {
        $job = Start-Job `
            -InitializationScript $envScriptBlock `
            -Name $name -FilePath $deployScript
        Wait-Job $job | Receive-Job
        Write-Output "Successfully installed package: $name."
    }
    catch {
        Write-Output "Fail to install package: $name",
        "Reason: $($_.Exception.Message)", ''
    }
    finally {
        if ($job) { Remove-Job $job }
    }
}

if ($cfg.createGetVscodeShortcut) {
    & "$(Get-ScriptRoot)\others\vscode"
}
