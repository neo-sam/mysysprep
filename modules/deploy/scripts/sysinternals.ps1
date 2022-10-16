$pkgfile = Get-PackageFile "SysinternalsSuite.zip"
$targetPath = "$env:SystemRoot\Sysinternals"
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name   = 'Sysinternals'
        target = "$targetPath"
    }
    return
}

Expand-Archive -Force $pkgfile $(mkdir -f tmp\sysinternals)
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

Copy-Item -Force 'tmp\sysinternals\*' -Exclude $excludeList (mkdir -f $targetPath)
Push-SystemPath $targetPath
