. .\lib\require-admin.ps1

if (!(Test-Path hklm:NewUser)) {
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

    reg import $path 2>&1 >$null

    $newRegpath = "$(mkdir -f tmp)\$((Get-ChildItem $path).BaseName)-newuser.reg"
    (Get-Content $path) -replace `
        '^\[HKEY_CURRENT_USER', '[HKEY_LOCAL_MACHINE\NewUser' |`
        Out-File -Force $newRegpath
    reg import $newRegpath 2>&1 >$null
}
