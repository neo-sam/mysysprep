. .\lib\require-admin.ps1

if (!(Test-Path hklm:NewUser)) {
    reg.exe load HKLM\NewUser 'C:\Users\Default\NTUSER.DAT'
}

function Get-CurrentAndNewUserPaths {
    [OutputType([string[]])] param ( [string]$path )
    $newUserRegPath = $path -replace '^HKCU:', 'HKLM:\NewUser'
    mkdir -f $path, $newUserRegPath >$null
    return @($path, $newUserRegPath)
}

function applyRegfileForMeAndDefault([string]$path) {
    reg import $path 2>&1 | Out-Null

    $newRegpath = "$(mkdir -f tmp)\$((Get-ChildItem $path).BaseName)-newuser.reg"
    (Get-Content $file) -replace `
        '^[HKEY_CURRENT_USER', '[HKEY_LOCAL_MACHINE\NewUser' |`
        Out-File -Force $newRegpath
    reg import $newRegpath 2>&1 | Out-Null
}
