. .\_adminrequire.ps1

Write-Output '==> Deploy ".\pkgs"',
'If prompt installation dialogs, allow and confirm ...' ''

$projectRoot = Split-Path (Split-Path $MyInvocation.MyCommand.Path)
$runscriptInit = [scriptblock]::Create(". `"$projectRoot\scripts\pkgs-scriptenv.ps1`";cd `"$projectRoot`"")
$runscripts = Get-ChildItem .\pkgs\*.ps1
Set-Location $projectRoot

function Get-PackageFile() { 
    [OutputType([IO.FileSystemInfo])] param($pattern)
    return Get-ChildItem "pkgs\$pattern" -ErrorAction SilentlyContinue
}

foreach ($runscript in $runscripts) {
    if ($name = & $runscript.FullName) {
        Write-Host "Adding package: $name"
        Start-Job `
            -InitializationScript $runscriptInit `
            -Name $name -FilePath $runscript |
        Out-Null
    }
}

Write-Host

function Get-JobOrWait {
    [OutputType([Management.Automation.Job])] param()
    if ($job = Get-Job -State Failed | Select-Object -First 1) { return $job }
    if ($job = Get-Job -State Completed | Select-Object -First 1) { return $job }
    if ($job = Get-Job | Wait-Job -Any) { return $job }
}

while ($job = (Get-JobOrWait)) {
    try {
        Receive-Job $job -ErrorAction Stop
        Write-Output "Successfully added package: $($job.Name)." ''
    }
    catch {
        Write-Output "Fail to add package: $($job.Name)",
        "Reason: $($_.Exception.Message)", '' 
    }
    finally {
        Remove-Job $job
    }
}
