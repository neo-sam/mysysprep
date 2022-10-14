param(
    $disableWebSearch,
    $disableFileSearch
)

if ($disableWebSearch) {
    $Script:msg = Get-Translation 'disabled online search results' `
        -cn '屏蔽在线搜索结果'

    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
    ) DisableSearchBoxSuggestions 1
    logif1
}

if ($disableFileSearch) {
    $Script:msg = Get-Translation 'disabled file search results' `
        -cn '屏蔽本地文件搜索服务'

    sc.exe stop wsearch >$null
    sc.exe config wsearch start=disabled >$null
    logif1 -f
}
