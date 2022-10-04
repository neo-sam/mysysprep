param(
    $candidates,
    $biggerFontSize
)

if ($candidates.GetType() -eq [int]) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\InputMethod\CandidateWindow\CHS\1'
    ) MaxCandidates $candidates
    logif1 "candidates: $candidates"
}

if (biggerFontSize) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\InputMethod\CandidateWindow\CHS\1'
    ) FontStyleTSF3 '22.00pt;Regular;;Microsoft YaHei UI'
    logif1 'bigger font size'
}
