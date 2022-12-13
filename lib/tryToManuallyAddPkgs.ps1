Push-Location $PSScriptRoot\..

Start-Process 'packages\manual'
if ($host.ui.PromptForChoice(
        (
            Get-Translation 'Dectected packages which should be deploy manually.' `
                -cn '注意：检测到需手动安装的软件包。'
        ), (
            Get-Translation 'Continue to auto deploy?' `
                -cn '确认：是否继续全自动安装？'
        ),
        [System.Management.Automation.Host.ChoiceDescription[]](
            (New-Object System.Management.Automation.Host.ChoiceDescription '&Yes'),
            (New-Object System.Management.Automation.Host.ChoiceDescription '&No')
        ), 0
    ) -eq 1) { exit 1 }
Write-Host
