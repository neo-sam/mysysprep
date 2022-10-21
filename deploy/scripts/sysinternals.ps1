#Requires -RunAsAdministrator

$pkg = Get-ChildItem -ea 0 'SysinternalsSuite.zip'
$targetPath = "$env:SystemRoot\Sysinternals"
if (!$PSSenderInfo) {
    if (-not $pkg) { return }
    return @{
        name   = 'Sysinternals'
        target = "$targetPath"
    }
    return
}

Expand-Archive -Force $pkg $(mkdir -f tmp\sysinternals)
<#
if ($null -eq $sysinternalsToolList) {
    $sysinternalsToolList = @(
        'autoruns*'
        'procexp*'
        'bginfo*'
        'procdump*'
        'handle*'
        # ...
        'ps*'
    )

}
 #>

$excludeList = @()

if ([Environment]::OSVersion.Version.Build -ge 10240) {
    $excludeList += 'desktops*'
}

Copy-Item 'tmp\sysinternals\*' -Exclude $excludeList (mkdir -f $targetPath)
Push-SystemPath $targetPath
