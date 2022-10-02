param(
    $noOnlineSearch,
    $disableFileSearchService
)

if ($noOnlineSearch) {
    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
    ) DisableSearchBoxSuggestions 1
    logif1 'disabled online search results.'
}

if ($disableFileSearchService) {
    sc.exe stop wsearch >$null
    sc.exe config wsearch start=disabled >$null
}
