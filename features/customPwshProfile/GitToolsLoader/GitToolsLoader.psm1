$appdir = 'C:\Program Files\Git\usr\bin'

if (!(Test-Path $appdir)) {
    exit
}

function touch([string]$filename) {
    New-Item $filename | Out-Null
}
Export-ModuleMember touch

$modname = (Get-Item $MyInvocation.MyCommand.Path).BaseName
$allAliasSet = [System.Collections.Generic.HashSet[String]] (Get-Alias).Name
$moduleAliasSet = [System.Collections.Generic.HashSet[String]] (Get-Command -CommandType Alias -Module $modname).Name
$appPathSet = [System.Collections.Generic.HashSet[String]] (Get-Command -CommandType Application).Path

foreach ($alias in (Get-Content -ea 0 "$PSScriptRoot\aliases.txt")) {
    $path = "$appdir\$alias.exe"
    if ($appPathSet.Contains($path)) {
        if (!"$((Get-Command -ea 0 $alias).path)".StartsWith($appdir)) {
            Write-Warning "$alias is not located in git tools."
        }
        continue
    }
    if ($allAliasSet.Contains($alias)) {
        if ($moduleAliasSet.Contains($alias)) {
            Set-Alias $alias $path
            Export-ModuleMember -Alias $alias
        }
        else {
            Write-Warning "$alias is already mapped as a alias by others."
        }
        continue
    }
    New-Alias $alias $path
    Export-ModuleMember -Alias $alias
}
foreach ($alias in @('vim', 'ssh', 'scp', 'sftp', 'openssl')) {
    $path = "$appdir\$alias.exe"
    if (!$appPathSet.Contains($path)) {
        New-Alias $alias $path
        Export-ModuleMember -Alias $alias
    }
}
foreach ($alias in @('tar', 'du', 'xxd')) {
    $path = "$appdir\$alias.exe"
    if ($appPathSet.Contains($path)) {
        New-Alias $alias $path
        Export-ModuleMember -Alias $alias
    }
}

function Get-AliasFromGit {
    (Get-Alias | Where-Object { $_.Definition -like 'C:\Program Files\Git\usr\bin\*' } ).ReferencedCommand -replace '.exe$', ''
}
Export-ModuleMember Get-AliasFromGit
