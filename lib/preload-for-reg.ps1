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

function applyRegfileForMeAndDefault {
    param([string]$path)

    $newRegpath = "$env:TEMP\$((Get-ChildItem $path).BaseName)-fornewuser.reg"
    (Get-Content $path) -replace `
        '^\[HKEY_CURRENT_USER', '[HKEY_LOCAL_MACHINE\NewUser' |`
        Out-File -Force $newRegpath

    try {
        reg.exe import $path
        reg.exe import $newRegpath
    }
    catch {}
}
