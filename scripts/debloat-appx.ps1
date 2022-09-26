. scripts/_adminrequire
if (-not (Get-Module Appx -ListAvailable)) { exit }

Write-Host '==> Debloat Appx'