. .\lib\loadModules.ps1
$checkpoints = Import-Csv "$PSScriptRoot\signatures.csv" -Encoding UTF8

$scriptBlock = {
    param ( $name, $fullname, $checkpoint )
    if ($checkpoint.Subject -eq $null) {
        ([PSCustomObject]@{
            Name     = $name
            Type     = $checkpoint.Type
            Verified = $null
        })
    }
    else {
        $signature = Get-AuthenticodeSignature $fullname
        ([PSCustomObject]@{
            Name     = $name
            Type     = $checkpoint.Type
            Verified = $signature.Status -eq 'Valid' -and $signature.SignerCertificate.Subject -eq $checkpoint.Subject
        })
    }
}

$unknownScriptBlock = {
    param ( $name )
    ([PSCustomObject]@{
        Name     = $name
        Type     = 'unknown'
        Verified = $false
    })
}

:nextfile foreach ($file in Get-ChildItem *.exe, *.msi, *.msu, *.ps1, *.msixbundle) {
    foreach ($checkpoint in $checkpoints) {
        if ($file.Name -like $checkpoint.Pattern) {
            Start-RSJob $scriptBlock -Args $file.Name, $file.FullName, $checkpoint | Out-Null
            continue nextfile
        }
    }
    Start-RSJob $unknownScriptBlock -Args $file.Name | Out-Null
}

Get-PSJob | Wait-PSJob
$result = Get-PSJob | Receive-RSJob | Select-Object Name, Type, Verified | Sort-Object Verified

if ($resultA = $result | Where-Object { $_.Verified -ne $null } | Format-Table) {
    Write-Output 'Signature Verification:' $resultA
}


if ($resultB = ($result | Where-Object { $_.Verified -eq $null }).Name) {
    Write-Output 'VirusTotal online CHECK:'

    Get-FileHash -Algorithm SHA256 $resultB | ForEach-Object {
        ([PSCustomObject]@{
            Name = (Get-ChildItem $_.Path).Name
            Link = 'https://www.virustotal.com/gui/file/' + $_.Hash
        })
    } | Format-List
}

if ($null -eq $resultA -and $null -eq $resultB) {
    Write-Output 'Nothing. Please add your packages into this folder'
}
