function logif1 {
    param([string[]]$content)
    if ($?) { Write-Host "[$((Get-ChildItem $MyInvocation.ScriptName).BaseName)]" @content }
}

function Get-CimOrWimInstance {
    param ( [string]$className)
    if ($PSVersionTable.PSVersion.Major -gt 5) {
        return Get-CimInstance $className
    }
    else {
        return Get-WmiObject Win32_PhysicalMemory
    }
}
