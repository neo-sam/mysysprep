$ErrorActionPreference = 'Stop'

$script:isAdmin = (
    [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')

$Script:isAuditMode = (
    Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State' -ErrorAction Ignore
).ImageState -eq 'IMAGE_STATE_SPECIALIZE_RESEAL_TO_AUDIT'

function Get-BasePath(
    [switch]$Scripts,
    [switch]$UserDeploy,
    [switch]$Docs
) {
    $basedir = "$(mkdir -f 'C:\Program Files\win-sf')"
    if ($Scripts) {
        return "$(mkdir -f "$basedir\scripts")"
    }
    if ($UserDeploy) {
        return "$(mkdir -f "$basedir\userdeploy")"
    }
    if ($Docs) {
        return "$(mkdir -f "$basedir\docs")"
    }
    return $basedir
}

function Get-Translation(
    [Parameter(Mandatory, ValueFromPipeline)]
    [string]$text,
    [string]$cn
) {
    switch ((Get-Culture).Name) {
        zh-CN { if ($cn) { return $cn } }
    }
    return $text
}

function Get-RegItemOrNew([string]$path) {
    if (Test-Path $path) {
        return (Get-Item $path).PSPath
    }
    else {
        return (mkdir -f $path).PSPath
    }
}

function Import-RegFile([string[]]$paths) {
    foreach ($path in $paths) {
        try { reg.exe import $path 2>&1 | Out-Null }
        catch {}
    }
}

function Get-CimOrWimInstance {
    param ( [string]$className)
    if ($PSVersionTable.PSVersion.Major -gt 5) {
        return Get-CimInstance $className
    }
    else {
        return Get-WmiObject $className
    }
}

function Repair-HidpiCompatibility([string[]]$paths = @()) {
    process {
        if ($_ -ne $null) { $paths += ([IO.FileInfo]$_).FullName }
    }end {
        foreach ($path in $paths) {
            if (!( Test-Path ($it = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers')
                )) { mkdir -f $it >$null }
            Set-ItemProperty $it $path '~ HIGHDPIAWARE'
        }
    }
}
