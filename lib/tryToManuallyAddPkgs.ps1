$hasContent = Test-Path -Exclude .gitkeep "$PSScriptRoot\..\..\packages\manual\*"
if (!$hasContent -and !(Test-ShouldManuallyAddPkgs)) { exit }

Start-Process "$PSScriptRoot\..\packages\manual"
if ($host.ui.PromptForChoice(
        (
            Get-Translation 'Please manually deploy yourselft at first.' `
                -cn '请完成手动内容安装。'
        ), (
            Get-Translation 'Continue to deploy?' `
                -cn '是否开始自动安装？'
        ),
        [System.Management.Automation.Host.ChoiceDescription[]](
            (New-Object System.Management.Automation.Host.ChoiceDescription '&Yes'),
            (New-Object System.Management.Automation.Host.ChoiceDescription '&No')
        ), 0
    ) -eq 1) { exit 1 }
Write-Host
