if (Get-Module PSReadLine) {
    Set-PSReadLineOption -EditMode Emacs
    Set-PSReadLineKeyHandler -Chord Ctrl+LeftArrow -Function BackwardWord
    Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function NextWord
    Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
    function Suspend-PSHistory { Set-PSReadLineOption -HistorySaveStyle SaveNothing }
}

function which([string]$command) {
    (Get-Command $command).Source
}

if (Test-Path 'C:\Program Files\Git\usr\bin') {
    Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
    Set-Alias touch "C:\Program Files\Git\usr\bin\touch.exe"
}
else {
    function touch([string]$filename) {
        New-Item $filename | Out-Null
    }
}
