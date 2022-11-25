Push-Location $PSScriptRoot\..
& .\lib\loadModules.ps1
Import-Module ConfigLoader

$scriptBlock = {
    param($name, $cfg)
    Set-Location "$Using:PSScriptRoot\.."
    & .\lib\loadModules.ps1
    Set-Location ".\features\$name"
    . .\apply.ps1 $cfg
}

foreach ($feature in Get-ChildItem .\features -Directory -Exclude _*) {
    if ($cfg = Get-FeatureConfig ($name = $feature.Name)) {
        Start-RSJob $scriptBlock -Name $name -ArgumentList $name, $cfg | Out-Null

        $formatted = switch ($cfg) {
            1 { 'true' }
            0 { 'false' }
            Default { ConvertTo-Json $cfg }
        }
        Write-Host "let $name", '=', ($formatted + ';')
    }
}

Write-Output '', '--> submit changes ...'

while ($job = Get-RSJobOrWait) {
    $name = $job.Name
    $result = Receive-RSJob $job
    if ($job.HasErrors) {
        Write-Host -ForegroundColor Red "[!] $name"
        if ($result) {
            Write-Host -ForegroundColor Red "    $result"
            Write-Host
        }
    }
    else {
        Write-Output $result
        Write-Host -ForegroundColor Green "[+] $name"
    }
    Remove-RSJob $job
}

Pop-Location
