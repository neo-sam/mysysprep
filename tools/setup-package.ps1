#Requires -RunAsAdministrator

param([Parameter(Mandatory)]$path)

Push-Location $PSScriptRoot\..

$file = Get-ChildItem $path

$scriptBlock = {
    param($path)
    Set-Location "$Using:PSScriptRoot\.."
    .\lib\loadModules.ps1
    Import-Module ConfigLoader
    $ErrorActionPreference = 'Stop'
    $PSDefaultParameterValues = @{
        'Start-Process:WindowStyle' = 'Minimized'
    }
    Set-Location 'packages'
    & $path
}

Start-RSJob $scriptBlock -ArgumentList $file.FullName | Wait-RSJob | Receive-RSJob

.\lib\submitNewUserRegistry.ps1
Pop-Location
