$pkgfile = Get-PackageFile "SysinternalsSuite.zip"
if (!$PSSenderInfo) {
    if ($pkgfile) { 'Sysinternals' }
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

$excludeList = @(
    '*.txt'
)

if ([Environment]::OSVersion.Version.Build -ge 10240) {
    $excludeList += 'desktops*'
}

Copy-Item -Force (Get-ChildItem 'tmp\sysinternals\*' -Exclude $excludeList) $env:SystemRoot
