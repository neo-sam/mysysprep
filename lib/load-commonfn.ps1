function logif1 {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]
        $content,

        [Alias('f')]
        [switch]
        $force
    )
    if ($? -or $force) { Write-Host "[$((Get-ChildItem $MyInvocation.ScriptName).BaseName)]" @content }
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

function New-SetupScriptShortcut {
    param(
        [string]$lnkname,
        [string]$psspath
    )
    $shortcut = "$([Environment]::GetFolderPath("Desktop"))\$lnkname.lnk"
    if (!(Test-Path $shortcut)) {
        $it = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcut)
        $it.IconLocation = "C:\Windows\System32\msiexec.exe,0"
        $it.TargetPath = "powershell.exe"
        $it.Arguments = "-exec bypass -file $psspath"
        $it.Save()
    }
    if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        Copy-Item -Force $shortcut 'C:\Users\Default\Desktop'
    }
}
