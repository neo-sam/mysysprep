if (
    (Test-Path ($it = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk')) -or
    (Test-DeployPackagePath 'Firefox Setup *.exe')
) { Add-Link $it }

if (Test-Windows10) { Add-Link 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Notepad.lnk' }
else { Add-App Microsoft.WindowsNotepad_8wekyb3d8bbwe }

if (
    (Test-Path ($it = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Tabby Terminal.lnk')) -or
    (Test-DeployPackagePath 'tabby-*-setup-*.exe')
) { Add-App Microsoft.WindowsTerminal_8wekyb3d8bbwe }
else {
    Add-Link $it
}
