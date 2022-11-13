#Requires -RunAsAdministrator
param($cfg)

if ($cfg.removeBmp) { Remove-Item HKLM:\SOFTWARE\Classes\.bmp\ShellNew -ea 0 }
if ($cfg.removeRtf) { Remove-Item HKLM:\SOFTWARE\Classes\.rtf\ShellNew -ea 0 }

if ($cfg.addMd) {
    if ($null -eq (Get-ItemProperty ($it = 'HKLM:\SOFTWARE\Classes\.md')).'(default)') {
        Set-Item (Get-RegItemOrNew $it) 'VSCode.md'
    }
    Set-ItemProperty (Get-RegItemOrNew "$it\ShellNew") NullFile ''
}

if ($cfg.addCmd) {
    Set-ItemProperty ( Get-RegItemOrNew `
            'HKLM:\SOFTWARE\Classes\.cmd\ShellNew') NullFile ''
}
if ($cfg.addPs1) {
    Set-ItemProperty ( Get-RegItemOrNew `
            'HKLM:\SOFTWARE\Classes\.ps1\ShellNew') NullFile ''
}
