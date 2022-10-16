param(
    $candidates,
    $biggerFontSize
)

$regkeys = (
    Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\InputMethod\CandidateWindow\CHS\1'
)

if ($candidates.GetType() -eq [int] -and $candidates -ne 0) {
    $Script:msg = "$(Get-Translation candidates -cn '候选词数'): $candidates"

    Set-ItemProperty $regkeys EnableFixedCandidateCountMode 1
    Set-ItemProperty $regkeys MaxCandidates $candidates

    logif1
}

if ($biggerFontSize) {
    $Script:msg = Get-Translation 'bigger font size' `
        -cn '更大的字体'

    Set-ItemProperty $regkeys FontStyleTSF3 '20.00pt;Regular;;Microsoft YaHei UI'

    logif1
}
