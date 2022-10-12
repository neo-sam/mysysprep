$script:isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
$script:isAuditMode = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State' -ErrorAction Ignore).ImageState -eq 'IMAGE_STATE_SPECIALIZE_RESEAL_TO_AUDIT'

function logif1 {
    param(
        [Alias('f')]
        [switch]
        $force
    )
    if ($? -or $force) { Write-Host "[$((Get-ChildItem $MyInvocation.ScriptName).BaseName)]" $msg }
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

function Get-Translation {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$text,
        [string]$base64cn
    )

    switch ((Get-WinSystemLocale).Name) {
        zh-CN { $base64 = $base64cn }
    }

    if ($base64) {
        [System.Text.Encoding]::UTF8.GetString(
            [System.Convert]::FromBase64String($base64)
        ).TrimEnd()
    }
    else { $text }
}

function New-DevbookDocShortcut {
    param([string]$name, [string]$path)

    $prefix = Get-Translation Config -base64cn 6YWN572uCg==
    $shortcut = "$([Environment]::GetFolderPath('Desktop'))\$prefix - $name.url"

    if (!(Test-Path $shortcut)) {
        $it = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcut)
        $it.TargetPath = switch ((Get-WinSystemLocale).Name) {
            zh-CN { "https://devbook.littleboyharry.me/zh-CN/$path" }
            Default { "https://devbook.littleboyharry.me/$path" }
        }
        $it.Save()
    }
    if ($isAdmin) {
        Copy-Item -Force $shortcut 'C:\Users\Default\Desktop'
    }
}
