.\_adminrequire.ps1

Write-Output '==> Deploy ".\pkgs"',
'If prompt installation dialogs, allow and confirm ...' ''

$projectRoot = Split-Path (Split-Path $MyInvocation.MyCommand.Path)
$runscriptInit = [scriptblock]::Create(". `"$projectRoot\scripts\pkgs-scriptenv.ps1`";cd `"$projectRoot`"")
$runscripts = Get-ChildItem .\pkgs\*.ps1
Set-Location $projectRoot

foreach ($runscript in $runscripts) {
    if ($name = & $runscript.FullName) {
        Write-Host "Adding package: $name"
        Start-Job `
            -InitializationScript $runscriptInit `
            -Name $name -FilePath $runscript |
        Out-Null
    }
}

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

exit

Push-Location ..\pkgs

function Start-InstallJob {
    param($name, $path, $params)
    Write-Host "Start to install $name ..."
    Start-Job -ArgumentList @($path, $params) -Name $name {
        Start-Process -Wait $args[0] $args[1]
    } > $null
}

$7zipZstd = '7zip-zstd'
$powershell = 'PowerShell'
$firefox = 'Firefox'
$thunderbird = 'Thunderbird'
$cyberduck = 'Cyberduck'

foreach ($file in Get-ChildItem) {
    $filename = $file.Name
    $path = $file.FullName
    switch -Wildcard ($filename) {
        '7z*-zstd-x64.exe' {
            Start-InstallJob $7zipZstd $path '/S'
        }
        'PowerShell-*-win-x64.msi' {
            Start-InstallJob $powershell $path "/q /norestart /l*v $projectRoot\logs\powershell.log ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1"
        }
        'Firefox Setup *.exe' {
            Start-InstallJob $firefox $path '/S'
        }
        'Thunderbird Setup *.exe' {
            Start-InstallJob $thunderbird $path '/S'
        }
        'Cyberduck-Installer-*.exe' {
            Start-InstallJob $cyberduck $path '/quiet'
        }
        'SourceHanSerif-VF.ttf.ttc' {
            Add-Font $path
        }
    }
}

Write-Host

While ($job = Get-JobOrWait) {
    try {
        Receive-Job $job 2>$null
        if ($job.State -eq 'Failed') { 
            throw 
        }
        switch ($job.Name) {
            $7zipZstd {
                Assert-Path "$env:ProgramFiles\7-Zip-Zstandard\7zFM.exe"
                Push-SystemPath "$env:ProgramFiles\7-Zip-Zstandard"
            }
            $powershell {
                Assert-Path "$env:ProgramFiles\PowerShell\*\pwsh.exe"
            }
            $firefox { 
                Assert-Path "$env:ProgramFiles\Mozilla Firefox\firefox.exe"
            }
            $thunderbird {
                Assert-Path "$env:ProgramFiles\Mozilla Thunderbird\thunderbird.exe"
            }
            $cyberduck {
                Assert-Path "$env:ProgramFiles\Cyberduck\Cyberduck.exe"
            }
        }
    }
    catch {
        Write-Host "Failed to add the package: $($job.Name):"
        Write-Host $_.Exception.Message
        continue
    }
    finally {
        Remove-Job $job
    }
    Write-Host "Added the package: $($job.Name)."
}

Pop-Location