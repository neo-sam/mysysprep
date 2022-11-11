#Requires -RunAsAdministrator

Set-ItemProperty (
    Get-CurrentAndNewUserPaths "HKCU:\Software\Microsoft\Clipboard"
) EnableClipboardHistory 1
