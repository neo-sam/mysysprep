$pkgfile = Get-PackageFile "SysinternalsSuite.zip"
$targetFolder = mkdir -f $env:SystemRoot\Sysinternals
if (!$PSSenderInfo) {
    if (-not $pkgfile) { return }
    return @{
        name   = 'Sysinternals'
        target = "$targetFolder"
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

Copy-Item -Force (Get-ChildItem 'tmp\sysinternals\*' -Exclude $excludeList) $targetFolder
Push-SystemPath $targetFolder
