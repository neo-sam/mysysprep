#Requires -RunAsAdministrator

param([Parameter(Mandatory)]$path)
$file = Get-ChildItem $path

Push-Location $PSScriptRoot\..\..

$job = Start-Job -FilePath $file.FullName `
    -InitializationScript ([scriptblock]::Create(
        @(
            ". $PSScriptRoot\..\..\lib\loadModules.ps1"
            'Import-Module ConfigLoader'
            "`$ErrorActionPreference = 'Stop'"
            "cd '$(Resolve-Path $PSScriptRoot\..)'"
        ) -join ';'
    ))

Receive-Job $job -Wait

.\lib\submitNewUserRegistry.ps1
Pop-Location
