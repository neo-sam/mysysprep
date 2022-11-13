. lib\base.ps1
. lib\prepareForRegOfAllUsers.ps1

function Push-SystemPath([string]$path) {
    $abspath = (Resolve-Path $path).ToString()
    if ($env:path -like "*$abspath*") { return }
    [Environment]::SetEnvironmentVariable('PATH',
        [Environment]::GetEnvironmentVariable('PATH', 'Machine') +
        ";$abspath", 'Machine'
    )
}

function Assert-Path([string]$path) {
    Get-ChildItem $path -ea Stop > $null
}

function New-UserDeployShortcut(
    [string]$ScriptName,
    [string]$LinkName,
    [string]$icon = "C:\Windows\System32\msiexec.exe,0"
) {
    $shortcut = "$([Environment]::GetFolderPath('Desktop'))\$LinkName.lnk"
    $userDeployBasePath = Get-BasePath -UserDeploy

    $it = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcut)
    $it.IconLocation = $icon
    $it.WorkingDirectory = $userDeployBasePath
    $it.TargetPath = "powershell.exe"
    $it.Arguments = "-exec bypass -file `"$userDeployBasePath\$ScriptName`""
    $it.Save()
    Copy-Item $shortcut 'C:\Users\Default\Desktop'
}

. lib\loadAllConfig.ps1
