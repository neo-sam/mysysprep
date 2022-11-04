if (
    !(Test-Path hklm:NewUser) -and
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
) {
    reg.exe load HKLM\NewUser 'C:\Users\Default\NTUSER.DAT' 2>&1 >$null
}

function Get-CurrentAndNewUserPaths {
    [OutputType([string[]])] param ( [string]$path )
    $newUserRegPath = $path -replace '^HKCU:', 'HKLM:\NewUser'
    if (!(Test-Path $path)) {
        mkdir -f $path >$null
    }
    if (!(Test-Path $newUserRegPath)) {
        mkdir -f $newUserRegPath >$null
    }
    return @($path, $newUserRegPath)
}

function Set-HidpiMode([string[]]$paths = @()) {
    process {
        if ($_ -ne $null) { $paths += ([IO.FileInfo]$_).FullName }
    }end {
        foreach ($path in $paths) {
            Set-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers' $path '~ HIGHDPIAWARE'
        }
    }
}

function Import-RegFile([string[]]$paths) {
    try {
        foreach ($path in $paths) {
            reg.exe import $path 2>&1 | Out-Null
        }
    }
    catch {}
}

function applyRegForMeAndDefault([string]$path) {
    $newRegpath = "$env:TEMP\$((Get-ChildItem $path).BaseName)-fornewuser.reg"
    (Get-Content $path) -replace `
        '^\[HKEY_CURRENT_USER', '[HKEY_LOCAL_MACHINE\NewUser' |`
        Out-File -Force $newRegpath

    Import-RegFile $path, $newRegpath
}
