param(
    $candidates,
    $biggerFontSize
)

$regkeys = (
    Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\InputMethod\CandidateWindow\CHS\1'
)

if ($candidates.GetType() -eq [int] -and $candidates -ne 0) {
    Set-ItemProperty $regkeys EnableFixedCandidateCountMode 1
    Set-ItemProperty $regkeys MaxCandidates $candidates
    logif1 "candidates: $candidates"
}

if ($biggerFontSize) {
    Set-ItemProperty $regkeys FontStyleTSF3 '20.00pt;Regular;;Microsoft YaHei UI'
    logif1 'bigger font size'
}
