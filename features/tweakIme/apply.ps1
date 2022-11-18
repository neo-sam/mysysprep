#Requires -RunAsAdministrator
param($cfg)

$regpath = 'HKCU:\Software\Microsoft\InputMethod\CandidateWindow\CHS\1'

if ($cfg.candidates -gt 0) {
    Set-ItemPropertyWithDefaultUser $regpath EnableFixedCandidateCountMode 1
    Set-ItemPropertyWithDefaultUser $regpath MaxCandidates $cfg.candidates
}

if ($cfg.biggerFontSize) {
    Set-ItemPropertyWithDefaultUser $regpath FontStyleTSF3 '20.00pt;Regular;;Microsoft YaHei UI'
}
