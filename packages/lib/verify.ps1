$Host.UI.RawUI.WindowTitle = 'Signature Verification'
& $PSScriptRoot\..\..\lib\loadModules.ps1
$checkpoints = Import-Csv "$PSScriptRoot\signatures.csv" -Encoding UTF8

$jobName = 'Verifying Packages'
$PSDefaultParameterValues = @{
    "Get-RSJob:Name"   = $jobName
    "Start-RSJob:Name" = $jobName
}

$scriptBlock = {
    param ( $name, $fullname, $checkpoint )
    if ($checkpoint.Subject -eq $null) {
        [PSCustomObject]@{
            Name     = $name
            Type     = $checkpoint.Type
            Verified = $null
        }
    }
    else {
        $signature = Get-AuthenticodeSignature $fullname
        [PSCustomObject]@{
            Name     = $name
            Type     = $checkpoint.Type
            Verified = $signature.Status -eq 'Valid' -and $signature.SignerCertificate.Subject -eq $checkpoint.Subject
        }
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

Push-Location $PSScriptRoot\..
:nextfile foreach ($file in Get-ChildItem *.exe, *.msi, *.msu, *.ps1, *.msixbundle) {
    foreach ($checkpoint in $checkpoints) {
        if ($file.Name -like $checkpoint.Pattern) {
            Start-RSJob $scriptBlock -ArgumentList $file.Name, $file.FullName, $checkpoint | Out-Null
            continue nextfile
        }
    }
    Start-RSJob $unknownScriptBlock -ArgumentList $file.Name | Out-Null
}
Pop-Location

$activity = 'Verifying Packages'
while (Get-RSJob -State Running) {
    Write-Progress $activity 0 `
        -status "$((Get-RSJob -State Completed).Count) / $((Get-RSJob).Count)" `
        -PercentComplete ((Get-RSJob -State Completed).Count / (Get-RSJob).Count * 100)
    Start-Sleep -Milliseconds 16
}
Write-Progress $activity 0 -Completed

Get-RSJob | Wait-RSJob | Out-Null
$result = Get-RSJob |  Receive-RSJob | Select-Object Name, Type, Verified | Sort-Object Verified

if ($resultA = $result | Where-Object { $_.Verified -ne $null } | Format-Table) {
    Write-Output $resultA
}

if ($manualVerifyList = ($result | Where-Object { $_.Verified -eq $null }).Name) {
    Write-Output 'VirusTotal online CHECK:'

    Push-Location $PSScriptRoot\..
    Get-FileHash -Algorithm SHA256 $manualVerifyList | ForEach-Object {
        Write-Output (Get-ChildItem $_.Path).Name
        Write-Output ('https://www.virustotal.com/gui/file/' + $_.Hash)
    }
    Pop-Location
}

Get-RSJob | Remove-RSJob

if ($null -eq $resultA -and $null -eq $manualVerifyList) {
    Write-Output 'NA', (Get-Translation 'Please add your packages into this folder, refer to README.md' -cn '请添加内容到当前目录，阅读 README_ZH.md 了解更多信息')
}
