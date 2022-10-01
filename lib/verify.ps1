$checkpoints = Import-Csv $args[0] -Encoding UTF8

:nextfile foreach ($file in Get-ChildItem *.exe, *.msi) {
    foreach ($checkpoint in $checkpoints) {
        if ($file.Name -like $checkpoint.Pattern) {
            Start-Job -Args $file.Name, $file.FullName, $checkpoint {
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
            } | Out-Null
            continue nextfile
        }
    }
    Start-Job -Args $file.Name {
        param ( $name )
        ([PSCustomObject]@{
            Name     = $name
            Type     = 'unknown'
            Verified = $false
        })
    } | Out-Null
}

Get-Job | Wait-Job | Out-Null
$result = Get-Job | Receive-Job | Select-Object Name, Type, Verified | Sort-Object Verified

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
