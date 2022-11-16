#Requires -RunAsAdministrator
param($cfg)

function Remove-NewFileType([string]$ext) {
    Remove-Item -ea 0 "HKLM:\SOFTWARE\Classes\$ext\ShellNew"
}

function Add-NewFileType([string]$ext) {
    Set-ItemProperty ( Get-RegItemOrNew `
            "HKLM:\SOFTWARE\Classes\$ext\ShellNew") NullFile ''
}

if ($cfg.removeBmp) { Remove-NewFileType .bmp }
if ($cfg.removeRtf) { Remove-NewFileType .rtf }
# Windows 7:
if ($cfg.removeContact) { Remove-NewFileType .contact }
if ($cfg.removeJnt) {
    Remove-Item -ea 0 'HKLM:\SOFTWARE\Classes\.jnt\jntfile\ShellNew'
}

if ($cfg.addMd) {
    Add-NewFileType .md

    if ($null -eq (Get-ItemProperty -ea 0 ($it = 'HKLM:\SOFTWARE\Classes\.md')).'(default)') {
        Set-Item (Get-RegItemOrNew $it) 'VSCode.md'
    }
}

if ($cfg.addCmd) { Add-NewFileType .cmd }

if ($cfg.addPs1) { Add-NewFileType .ps1 }

if ($cfg.addIni) { Add-NewFileType .ini }

if ($cfg.addReg) { Add-NewFileType .reg }
