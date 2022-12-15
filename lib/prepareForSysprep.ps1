#Requires -RunAsAdministrator
. .\lib\loadModules.ps1

Import-Module ConfigLoader
$Error.Clear()

function Invoke-Task([string]$name) {
    $path = "lib\tasks\$name\apply.ps1"
    if (Test-Path $path) { & $path }
}

Invoke-Task submitNewUserRegistry
Invoke-Task setTaskbarLayout

if (Test-AuditMode) {
    Invoke-Task makeUnattendFile
}

Write-Output '!!! FINISHED ALL !!!'

.\lib\doMakeActionsFolder.ps1

showInformationDialog 'win-sf' @"
$(Get-Translation 'Repository: ' -cn '项目：')https://github.com/setupfw/win-sf
$(Get-Translation 'Author: ' -cn '作者：')LittleboyHarry
$(Get-Translation 'Status: OK' -cn '状态：已完成')

$(Get-Translation 'Blessing: have a nice day! ^_^' -cn '大吉大利，祝你鸿运当头！')
"@

if ($Error) { Pause }
