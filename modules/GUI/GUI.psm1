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

function askWarningDialog([string]$title, [string]$message) {
    'OK' -eq [System.Windows.MessageBox]::Show($message, $title, 'OKCancel', 'Warning')
}

function askQuestionDialog([string]$title, [string]$message) {
    'Yes' -eq [System.Windows.MessageBox]::Show($message, $title, 'YesNo', 'Question')
}

function showInformationDialog([string]$title, [string]$message) {
    [System.Windows.MessageBox]::Show( $message, $title, 'OK', 'Information') | Out-Null
}
