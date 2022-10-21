#Requires -RunAsAdministrator

param([Parameter(Mandatory)]$path)

$file = Get-ChildItem $path
$sb = [scriptblock]::Create(@(
        "cd '$(Resolve-Path $PSScriptRoot\..\..)'"
        '. .\lib\preload-to-deploy.ps1'
        'cd deploy'
    ) -join ';'
)

Start-Job `
    -InitializationScript $sb -FilePath $file.FullName |`
    Receive-Job -Wait
