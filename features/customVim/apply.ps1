#Requires -RunAsAdministrator

Copy-Item .vimrc C:\Users\Default\.vimrc
if (!(Test-Path ($thisUserProfile = "$env:USERPROFILE\.vimrc"))) {
    Copy-Item .vimrc $thisUserProfile
}
else {
    Write-MergeAdviceIfDifferent .vimrc $thisUserProfile
}

$gvimrcTempl = Get-Content -ea 0 -raw 'g.vimrc'
if ($gvimrcTempl) {
    $txt = $gvimrcTempl
    if ((Test-AppxSystemAvailable) -and (Get-AppxPackage Microsoft.WindowsTerminal)) {
        $txt = $txt -replace '" (?=set gfn)', ''
    }
    if ((Get-Culture).TwoLetterISOLanguageName -eq 'zh') {
        $txt = $txt -replace '" (?=set gfw)', ''
    }
    $txt | Out-FileUtf8NoBom ($newUserGvimrc = 'C:\Users\Default\_gvimrc')

    if (!(Test-Path ($thisUserGvimrc = "$env:USERPROFILE\_gvimrc"))) {
        Copy-Item $newUserGvimrc $thisUserGvimrc
    }
    else {
        Write-MergeAdviceIfDifferent $newUserGvimrc $thisUserGvimrc
    }
}
