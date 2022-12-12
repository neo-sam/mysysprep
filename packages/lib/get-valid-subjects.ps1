Push-Location $PSScriptRoot\..
foreach ($file in Get-ChildItem *.exe, *.msi, *.msu, *.ps1, *.msixbundle) {
    $signature = Get-AuthenticodeSignature $file
    if ($signature.Status -ne 'Valid') { continue }

    Write-Output $file.Name "`"$($signature.SignerCertificate.Subject)`"" ''
}
Pop-Location
