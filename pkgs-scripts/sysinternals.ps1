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

$excludeList = @()

if ([Environment]::OSVersion.Version.Build -ge 10240) {
    $excludeList += 'desktops*'
}

$targetFolder = mkdir -f $env:SystemRoot\Sysinternals
Copy-Item -Force (Get-ChildItem 'tmp\sysinternals\*' -Exclude $excludeList) $targetFolder
Push-SystemPath $targetFolder
