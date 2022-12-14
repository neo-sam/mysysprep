Import-Module Api.Common
Import-Module ConfigLoader

$wshell = New-Object -ComObject WScript.Shell
function New-Shortcut([string]$path, [switch]$Lnk, [switch]$Url ) {
    if ($Lnk) { $path += '.lnk' }
    elseif ($Url) { $path += '.url' }

    if ((Split-Path $path) -eq '') { $path = "$pwd\$path" }

    $wshell.CreateShortcut($path)
}

function New-UserDeployShortcut(
    [string]$ScriptName,
    [string]$LinkName,
    [string]$icon = 'msiexec.exe'
) {
    $it = New-Shortcut -Lnk "C:\Users\Default\Desktop\$(Get-Translation 'Setup' -cn '安装') $LinkName"
    $it.TargetPath = "powershell.exe"
    $it.Arguments = "-exec bypass -file `"$(Get-AppFolderPath -Scripts)\$ScriptName.ps1`""
    $it.IconLocation = $icon
    $it.Save()
}

function Set-ShortcutRunAsAdmin([string]$path) {
    $bytes = [IO.File]::ReadAllBytes($path)
    $bytes[0x15] = $bytes[0x15] -bor 0x20
    [IO.File]::WriteAllBytes($path, $bytes)
}

function New-StartMenuShortcut([string]$target , [string]$name, [string]$dirname ) {
    $basepath = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs'
    if ($dirname) {
        mkdir -f ($basepath = "$basepath\$dirname") | Out-Null
    }
    $s = $wshell.CreateShortcut("$basepath\$name.lnk")
    $s.TargetPath = $target
    return $s
}
