#Requires -RunAsAdministrator

param([Parameter(Mandatory)]$path)
$file = Get-ChildItem $path

Push-Location $PSScriptRoot\..\..

$job = Start-Job -FilePath $file.FullName `
    -InitializationScript ([scriptblock]::Create(
        @(
            "cd '$(Get-Location)'"
            '. .\deploy\scripts\__base__.ps1'
            'cd deploy'
        ) -join ';'
    ))

Receive-Job $job -Wait

.\lib\submitNewUserRegistry.ps1
Pop-Location
