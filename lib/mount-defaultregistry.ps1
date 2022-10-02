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
