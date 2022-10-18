$files = Get-ChildItem -Recurse @(
    'log\*', 'tmp\*',
    '*.exe', '*.msi', '*.zip'
) -Exclude '.gitkeep' -File

Write-Output $files, '', 'Confirm to clean? (Press Enter to continue)...'
Read-Host
Remove-Item $files
