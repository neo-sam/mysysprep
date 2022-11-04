#Requires -RunAsAdministrator

$target = "$(mkdir -f C:\SetupFw)\New-IsolatedUser.ps1"
Copy-Item 'script.ps1' $target

$shortcut = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\New Isolated User.lnk"

$it = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcut)
$it.IconLocation = 'imageres.dll,73'
$it.TargetPath = "powershell.exe"
$it.Arguments = "-exec bypass -file $target"
$it.Save()

$bytes = [IO.File]::ReadAllBytes($shortcut)
$bytes[0x15] = $bytes[0x15] -bor 0x20
[IO.File]::WriteAllBytes($shortcut, $bytes)
