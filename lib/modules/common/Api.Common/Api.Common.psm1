function Get-ProjectLocation {
    "$(Resolve-Path $PSScriptRoot\..\..\..)"
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

function Convert-ScriptBlockToText([scriptblock]$block) {
    ($block.ToString() -split "`n" -replace '^    ', '' -join "`n").Trim()
}

function Get-CimOrWimInstance([string]$className) {
    if ($PSVersionTable.PSVersion.Major -gt 5) {
        return Get-CimInstance $className
    }
    else {
        return Get-WmiObject $className
    }
}

function Write-MergeAdviceIfDifferent([string]$ref, [string]$to, [switch]$RunAsAdmin) {
    if ((Get-FileHash $ref).hash -ne (Get-FileHash $to).hash) {
        if ($RunAsAdmin) {
            Write-Output 'Please merge the file manually (use vimdiff, run as Admin):'
        }
        else {
            Write-Output 'Please merge the file manually (use vimdiff):'
        }
        Write-Output "`"C:\Program Files\Git\usr\bin\vimdiff.exe`" `"$(Resolve-Path $to)`" `"$(Resolve-Path $ref)`""
    }
}
