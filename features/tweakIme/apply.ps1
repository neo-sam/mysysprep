param($cfg)

$regkeys = Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\InputMethod\CandidateWindow\CHS\1'

if ($cfg.candidates -gt 0) {
    Set-ItemProperty $regkeys EnableFixedCandidateCountMode 1
    Set-ItemProperty $regkeys MaxCandidates $candidates
}

if ($cfg.biggerFontSize) {
    Set-ItemProperty $regkeys FontStyleTSF3 '20.00pt;Regular;;Microsoft YaHei UI'
}
