param(
    $disableWebSearch,
    $disableFileSearch
)

if ($disableWebSearch) {
    $Script:msg = Get-Translation 'disabled online search results' `
        -base64cn 5bGP6JS95Zyo57q/5pCc57Si57uT5p6cCg==

    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
    ) DisableSearchBoxSuggestions 1
    logif1
}

if ($disableFileSearch) {
    $Script:msg = Get-Translation 'disabled file search results' `
        -base64cn 5bGP6JS95pys5Zyw5paH5Lu25pCc57Si5pyN5YqhCg==

    sc.exe stop wsearch >$null
    sc.exe config wsearch start=disabled >$null
    logif1 -f
}
