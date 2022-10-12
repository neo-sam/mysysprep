# Enable clipboard history
Set-ItemProperty (
    Get-CurrentAndNewUserPaths "HKCU:\Software\Microsoft\Clipboard"
) EnableClipboardHistory 1

# HiDPI fix
$regkeys = Get-CurrentAndNewUserPaths "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
foreach ($path in @(
        'C:\Windows\System32\mmc.exe'
    )) {
    Set-ItemProperty $regkeys $path "~ HIGHDPIAWARE"
}

# Skip first screen
reg.exe add HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge /v PreventFirstRunPage /t REG_DWORD /f /d 0 >$null
reg.exe add HKLM\SOFTWARE\Policies\Microsoft\WindowsMediaPlayer /v GroupPrivacyAcceptance /t REG_DWORD /f /d 1 >$null

if ([Environment]::OSVersion.Version.Build -le 22000) {
    # Colorize Window Title
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths "HKCU:\SOFTWARE\Microsoft\Windows\DWM"
    ) ColorPrevalence 1
}

if (Get-Command -ea 0 Get-PhysicalDisk) {
    if ('SSD' -eq (Get-PhysicalDisk)[0].MediaType) {
        reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /f /d 0 >$null
    }
}
