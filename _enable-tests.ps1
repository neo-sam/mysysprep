foreach ($cfgsamplefile in Get-ChildItem .\samples\config-*.ps1) {
    New-Item -ItemType HardLink -Name $cfgsamplefile.Name -Value $cfgsamplefile.FullName -Force | Out-Null
}

$env:IGNORE_ADMINREQUIRE = 1
