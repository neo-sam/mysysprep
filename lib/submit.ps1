. .\lib\load-config.ps1

& .\lib\postgen-unattend.ps1
& .\lib\postgen-taskbar.ps1

if (Test-Path 'C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1') {
    try { Set-ExecutionPolicy -Scope LocalMachine RemoteSigned -Force }
    catch [System.Security.SecurityException] {}
}

reg.exe unload HKLM\NewUser 2>&1 >$null

Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show(@'
Reboot to start sysprep!

Have a nice day ^_^ --LittleboyHarry
'@, "Finished!",
    "OK", "Information"
)
