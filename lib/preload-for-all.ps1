$ErrorActionPreference = 'Stop'

$script:isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')

function Get-CimOrWimInstance {
    param ( [string]$className)
    if ($PSVersionTable.PSVersion.Major -gt 5) {
        return Get-CimInstance $className
    }
    else {
        return Get-WmiObject $className
    }
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

function New-SetupScriptShortcut(
    [string]$lnkname,
    [string]$psspath,
    [string]$icon = "C:\Windows\System32\msiexec.exe,0"
) {
    $shortcut = "$([Environment]::GetFolderPath("Desktop"))\$lnkname.lnk"

    $it = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcut)
    $it.IconLocation = $icon
    $it.TargetPath = "powershell.exe"
    $it.Arguments = "-exec bypass -file $psspath"
    $it.Save()
    Copy-Item $shortcut 'C:\Users\Default\Desktop'
}
