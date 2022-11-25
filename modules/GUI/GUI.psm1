$guiAvailable = $true
if ($guiAvailable) {
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
}

$yesOrNoCliChoices = [System.Management.Automation.Host.ChoiceDescription[]](
    (New-Object System.Management.Automation.Host.ChoiceDescription '&Yes'),
    (New-Object System.Management.Automation.Host.ChoiceDescription '&No')
)

function askInformationDialog([string]$title, [string]$message) {
    if ($guiAvailable) {
        [System.Windows.MessageBox]::Show($message, $title, 'YesNo', 'Information') -eq 'Yes'
    }
    else {
        $host.ui.PromptForChoice($message, $title, $yesOrNoCliChoices, 0) -eq 0
    }
}

function askWarningDialog([string]$title, [string]$message) {
    if ($guiAvailable) {
        [System.Windows.MessageBox]::Show($message, $title, 'YesNo', 'Warning') -eq 'Yes'
    }
    else {
        $host.ui.PromptForChoice($message, $title, $yesOrNoCliChoices, 0) -eq 0
    }
}

function askQuestionDialog([string]$title, [string]$message) {
    if ($guiAvailable) {
        [System.Windows.MessageBox]::Show($message, $title, 'YesNo', 'Question') -eq 'Yes'
    }
    else {
        $host.ui.PromptForChoice($message, $title, $yesOrNoCliChoices, 0) -eq 0
    }
}

function showWarningDialog([string]$title, [string]$message) {
    if ($guiAvailable) {
        [System.Windows.MessageBox]::Show($message, $title, 'OK', 'Warning')
    }
    else {
        Write-Warning $title
        Write-Warning $message
        Pause
    }
}
