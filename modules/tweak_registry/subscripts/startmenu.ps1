param(
    $disableWebSearch,
    $disableFileSearch
)

if ($disableWebSearch) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
    ) DisableSearchBoxSuggestions 1
    logif1 'disabled online search results.'
}

if ($disableFileSearch) {
    sc.exe stop wsearch >$null
    sc.exe config wsearch start=disabled >$null
}
