if ($isAdmin -and !(Test-Path hklm:NewUser)) {
    reg.exe load HKLM\NewUser 'C:\Users\Default\NTUSER.DAT' 2>&1 >$null
}

function Get-CurrentAndNewUserPaths([string]$path) {
    [OutputType([string[]])]
    $newUserRegPath = $path -replace '^HKCU:', 'HKLM:\NewUser'
    if (!(Test-Path $path)) {
        mkdir -f $path >$null
    }
    if (!(Test-Path $newUserRegPath)) {
        mkdir -f $newUserRegPath >$null
    }
    return @($path, $newUserRegPath)
}

function applyRegForMeAndDefault([string]$path) {
    $newRegpath = "$env:TEMP\$((Get-ChildItem $path).BaseName)-fornewuser.reg"
    (Get-Content $path) -replace `
        '^\[HKEY_CURRENT_USER', '[HKEY_LOCAL_MACHINE\NewUser' |`
        Out-File -Force $newRegpath

    Import-RegFile $path, $newRegpath
}
