function Read-ToExit {
    [Console]::ReadKey()>$null
}

if ($PSVersionTable.PSVersion.Major -ge 5) {
    Write-Host -ForegroundColor Green 'New PowerShell is ready to use!'
    Read-ToExit
}

$dotnetInstaller = Get-ChildItem 'NDP4*.exe'
if ($Error) {
    Read-ToExit
}

Write-Host 'Installing .NET Framework ...'
if ((Start-Process -Wait $dotnetInstaller.FullName '/q /norestart').ExitCode) {
    Write-Error ".NET Framework failed installation code: $exitCode"
    Read-ToExit
}
Write-Host 'Succeed!', ''

Write-Host 'Installing WMF 5.1 ...'
if (Test-Path ($it = '.\Install-WMF5.1.ps1')) {
    & $it -AcceptEULA
}
else {
    foreach ($updatePkg in (Get-ChildItem *.msu)) {
        if ((Start-Process -Wait $updatePkg.FullName '/quiet /norestart').ExitCode) {
            Write-Error ".NET Framework failed installation code: $exitCode"
            Read-ToExit
        }
    }
}
Write-Host -ForegroundColor Green 'DONE!'
if ($host.ui.PromptForChoice(
        'Reboot now?',
        $null,
        [System.Management.Automation.Host.ChoiceDescription[]](
                (New-Object System.Management.Automation.Host.ChoiceDescription '&Yes'),
                (New-Object System.Management.Automation.Host.ChoiceDescription '&No')
        ), 0) -eq 0
) {
    Restart-Computer
}
