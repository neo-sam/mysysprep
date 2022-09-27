.\_adminrequire.ps1
if ([Environment]::OSVersion.Version.Build -lt 22000) { exit }

if ($noTaskbarWidgets) {
    reg add HKLM\SOFTWARE\Policies\Microsoft\Dsh /v AllowNewsAndInterests /t REG_DWORD /f /d 0 >$null
}