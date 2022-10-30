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

function New-DevbookShortcut(
    [string]$name, [string]$path, [switch]$Public = $false
) {
    $prefix = Get-Translation Config -cn 配置
    $desktopPath = & {
        if ($Public) { 'C:\Users\Public\Desktop' }
        else { [Environment]::GetFolderPath('Desktop') }
    }

    $shortcut = "$desktopPath\$prefix $name.url"

    $it = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcut)
    $it.TargetPath = switch ((Get-Culture).Name) {
        zh-CN { "https://devbook.littleboyharry.me/zh-CN/$path" }
        Default { "https://devbook.littleboyharry.me/$path" }
    }
    $it.Save()
    if (!$Public -and $isAdmin) {
        Copy-Item $shortcut 'C:\Users\Default\Desktop'
    }
}
