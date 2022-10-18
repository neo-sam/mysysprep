#Requires -RunAsAdministrator

New-DevbookShortcut 'Windows' 'docs/setup-mswin/firstrun'
New-DevbookShortcut 'Store Apps' 'docs/setup-mswin/personalize/apps-from-store'
New-DevbookShortcut (
    Get-Translation 'Input & Keymap' -cn '输入法与键盘'
) 'docs/setup-mswin/tweak/input'

if (Test-Path 'C:\Program Files\Mozilla Firefox\firefox.exe') {
    New-DevbookShortcut Firefox docs/goodsoft/firefox/setup
}
if (Test-Path "C:\Program Files (x86)\Vim\vim*\vim.exe") {
    New-DevbookShortcut gVim docs/devenv/vim
}
if ($features.addWsl2) {
    New-DevbookShortcut WSL2 docs/setup-mswin/devenv/wsl2
}
