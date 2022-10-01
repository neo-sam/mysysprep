param(
    [string]$deployMutexScriptsFolder,
    [string]$deployScriptsFolder,
    [string]$taskName
)

$envScript = (Get-ChildItem '.\lib\execute-deployment-initscript.ps1').FullName
$envScriptBlock = [scriptblock]::Create(". `"$envScript`";cd `"$(Get-Location)`"")

function Get-PackageFile() {
    [OutputType([IO.FileSystemInfo])] param($pattern)
    return Get-ChildItem "pkgs\$pattern" -ErrorAction SilentlyContinue
}

if ($deployScriptsFolder) {
    foreach ($runScript in Get-ChildItem "$deployScriptsFolder\*.ps1") {
        if ($name = & $runScript.FullName) {
            Write-Output "Start to ${taskName}: $name"
            Start-Job `
                -InitializationScript $envScriptBlock `
                -Name $name -FilePath $runScript | Out-Null
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
            Write-Output "Successfully ${taskName}: $name." ''
        }
        catch {
            Write-Output "Fail to ${taskName}: $name",
            "Reason: $($_.Exception.Message)", ''
        }
        finally {
            Remove-Job $job
        }
    }
}

if ($deployMutexScriptsFolder) {
    foreach ($runScript in  Get-ChildItem "$deployMutexScriptsFolder\*.ps1") {
        if ($name = & $runScript.FullName) {
            Write-Output "Running to ${taskName}: $name"
            try {
                $job = Start-Job `
                    -InitializationScript $envScriptBlock `
                    -Name $name -FilePath $runScript
                Wait-Job $job | Receive-Job
                Write-Output "Successfully ${taskName}: $name." ''
            }
            catch {
                Write-Output "Fail to ${taskName}: $name",
                "Reason: $($_.Exception.Message)", ''
            }
            finally {
                if ($job) { Remove-Job $job }
            }
        }
    }
}
