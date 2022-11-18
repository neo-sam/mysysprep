#Requires -RunAsAdministrator

Set-ItemPropertyWithDefaultUser `
    'HKCU:\Software\Microsoft\Clipboard'`
    EnableClipboardHistory 1
