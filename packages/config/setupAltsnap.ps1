$env:__COMPAT_LAYER = "RunAsInvoker"
$it = Get-ChildItem -ea 0 "$PSScriptRoot\AltSnap*-x64-inst.exe"
if ($it.count -ne 1) {
    Write-Error 'Task Crash!'
    [System.Console]::ReadKey()>$null
    exit
}
Start-Process -Wait $it.FullName '/NCRC /S'

Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' AltSnap "`"$env:APPDATA\AltSnap\AltSnap.exe`""

@"
; config here
"@ > "$env:APPDATA\AltSnap\AltSnap.ini"

& "$env:APPDATA\AltSnap\AltSnap.exe"

if ($Error) { Pause }
else {
    Add-Type -AssemblyName PresentationFramework
    Add-Type -Name WinDPI -Namespace Native -MemberDefinition '
[DllImport("SHCore.dll", SetLastError = true)]
public static extern bool SetProcessDpiAwareness(PROCESS_DPI_AWARENESS awareness);

public enum PROCESS_DPI_AWARENESS
{
    Process_DPI_Unaware = 0,
    Process_System_DPI_Aware = 1,
    Process_Per_Monitor_DPI_Aware = 2
}
'
    [Native.WinDPI]::SetProcessDPIAwareness([Native.WinDPI+PROCESS_DPI_AWARENESS]::Process_Per_Monitor_DPI_Aware) | Out-Null

    [System.Windows.MessageBox]::Show(
        'Hold Windows Key + Mouse Action on windows to take effect!',
        'AltSnap installed!',
        'OK', 'Information'
    )
}
