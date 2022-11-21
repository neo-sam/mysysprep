Write-Output 'Please manually deploy and confirm...'

Start-Process "$PSScriptRoot\..\manual"

if ($host.ui.PromptForChoice(
                'Please manually deploy yourselft at first.',
                'Continue to deploy?',
                [System.Management.Automation.Host.ChoiceDescription[]](
                (New-Object System.Management.Automation.Host.ChoiceDescription '&Yes'),
                (New-Object System.Management.Automation.Host.ChoiceDescription '&No')
                ), 0) -eq 1
) {
        exit 1
}
