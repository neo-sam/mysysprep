param(
    $candidates,
    $biggerFontSize
)

$regkeys = (
    Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\InputMethod\CandidateWindow\CHS\1'
)

if ($candidates.GetType() -eq [int] -and $candidates -ne 0) {
    $Script:msg = "$(Get-Translation candidates -base64cn 5YCZ6YCJ6K+N5pWwCg==): $candidates"

    Set-ItemProperty $regkeys EnableFixedCandidateCountMode 1
    Set-ItemProperty $regkeys MaxCandidates $candidates

    logif1
}

if ($biggerFontSize) {
    $Script:msg = Get-Translation 'bigger font size' `
        -base64cn 5pu05aSn55qE5a2X5L2TCg==

    Set-ItemProperty $regkeys FontStyleTSF3 '20.00pt;Regular;;Microsoft YaHei UI'

    logif1
}
