$pkgfile = Get-PackageFile "workrave-win32-v*.exe"
if (!$PSSenderInfo) {
    if ($pkgfile) { 'Workrave' }
    return
}

Start-Process $pkgfile '/SILENT /SUPPRESSMSGBOXES /NORESTART /SP-' -PassThru | Wait-Process

Assert-Path "C:\Program Files (x86)\Workrave\lib\Workrave.exe"

reg add 'HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers' /f /t REG_SZ /v 'C:\Program Files (x86)\Workrave\lib\Workrave.exe' /d '~ HIGHDPIAWARE'>$null

if ($cfg.useWorkraveConfig) {
    reg import '.\pkgs-config\prefer-workrave.reg' 2>&1 | Out-Null
    . .\lib\mount-defaultregistry.ps1

    $newUserRegCfg = "$(mkdir -f tmp)\prefer-workrave-newuser.reg"
    (Get-Content '.\pkgs-config\prefer-workrave.reg') -replace
    '(?<=^\[)HKEY_CURRENT_USER(?=.*\]$)', 'HKEY_LOCAL_MACHINE\NewUser' |
    Out-File -Force $newUserRegCfg
    reg import $newUserRegCfg 2>&1 | Out-Null
}
