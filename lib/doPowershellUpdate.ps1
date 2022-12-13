$script:PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
Push-Location "$PSScriptRoot/../packages"

if ($PSVersionTable.PSVersion.Major -ge 5) {
    Write-Host -ForegroundColor Green 'Already updated PowerShell.'
    Read-AnyKey
}

if (!(Test-Path ($it = 'HKLM:\Software\Classes\.md'))) {
    Set-Item (mkdir -f $it).PSPath "md_auto_file"
    Set-Item (
        mkdir -f "HKLM:\Software\Classes\md_auto_file\shell\edit\command"
    ).PSPath "`"C:\Windows\system32\notepad.exe`" `"%1`""
}

function Test-NetFrameworkNotSupport {
    return !(Test-Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\')
}

if (Test-NetFrameworkNotSupport) {
    if ($dotnetInstaller = Get-ChildItem -ea 0 'NDP4*.exe') {
        Write-Host 'Installing .NET Framework ...'
        if ($exitCode = (Start-Process -Wait $dotnetInstaller.FullName '/q /norestart').ExitCode) {
            Write-Error ".NET Framework failed installation code: $exitCode"
            Read-AnyKey
            exit
        }
        Write-Host 'Succeed!', ''
    }
    else {
        $downloadUrl = 'https://www.microsoft.com/en-us/download/confirmation.aspx?id=42642'
        if ($host.ui.PromptForChoice(
                'Please install .NET Framework 4.5.2 or higher version!',
                $downloadUrl,
                [System.Management.Automation.Host.ChoiceDescription[]](
                (New-Object System.Management.Automation.Host.ChoiceDescription '&Download it'),
                (New-Object System.Management.Automation.Host.ChoiceDescription '&Exit')
                ), 0
            ) -eq 0
        ) { Start-Process $downloadUrl }
        else { exit }

        while (Test-NetFrameworkNotSupport) {
            Read-Host 'Waiting for installing ..., press Enter to continue'
        }
    }
}

if (!($script = Get-Item -ea 0 '.\Install-WMF5.1.ps1')) {
    @'
Please get Windows Management Framework 5.1 at first, steps:

1. Focus on the download page
2. Select `Win7AndW2K8R2-KB3191566-x64.zip` to download
3. Extract the archive into the `./packages` folder
'@
    $downloadUrl = 'https://www.microsoft.com/en-us/download/details.aspx?id=54616'
    if ($host.ui.PromptForChoice(
            'Get Windows Management Framework 5.1?',
            $downloadUrl,
            [System.Management.Automation.Host.ChoiceDescription[]](
                (New-Object System.Management.Automation.Host.ChoiceDescription '&Download it'),
                (New-Object System.Management.Automation.Host.ChoiceDescription '&Exit')
            ), 0
        ) -eq 0
    ) { Start-Process $downloadUrl }
    else { exit }

    while (!($script = Get-Item -ea 0 '.\Install-WMF5.1.ps1')) {
        Read-Host 'Waiting for the required content ..., press Enter to continue'
    }
}

Write-Host 'Installing WMF 5.1 ...'
& $script.FullName -AcceptEULA

Write-Host -ForegroundColor Green 'DONE!'
if ($host.ui.PromptForChoice(
        'Reboot now?',
        $null,
        [System.Management.Automation.Host.ChoiceDescription[]](
                (New-Object System.Management.Automation.Host.ChoiceDescription '&Yes'),
                (New-Object System.Management.Automation.Host.ChoiceDescription '&No')
        ), 0
    ) -eq 0
) {
    Restart-Computer
}

Pop-Location
