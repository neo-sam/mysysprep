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
