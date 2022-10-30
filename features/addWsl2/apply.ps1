#Requires -RunAsAdministrator

Dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart /quiet
Dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart /quiet

if ($features.addDevbookLinks) {
    New-DevbookShortcut WSL2 docs/setup-mswin/devenv/wsl2
    New-DevbookShortcut -Public (
        Get-Translation 'Boot Menu' -cn '启动菜单'
    ) 'docs/setup-mswin/personalize/bootcfg'
}
