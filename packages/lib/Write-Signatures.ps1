Push-Location "$PSScriptRoot\.."
foreach ($file in Get-ChildItem *.exe, *.msi, *.msu, *.ps1, *.msixbundle) {
    $result = Get-AuthenticodeSignature $file
    ([PSCustomObject]@{
        Name    = $file.Name
        Status  = $result.Status
        Subject = $null
    }) | Format-List
    $result.SignerCertificate.Subject
}
Pop-Location
