Remove-Item -Force '.\config-*.ps1'
foreach ($cfgsamplefile in Get-ChildItem .\samples\config-*.ps1) {
    New-Item -ItemType HardLink -Name $cfgsamplefile.Name -Value $cfgsamplefile.FullName -Force -ea 0 | Out-Null
    if (!$?) { Copy-Item $cfgsamplefile.FullName $cfgsamplefile.Name }
}
