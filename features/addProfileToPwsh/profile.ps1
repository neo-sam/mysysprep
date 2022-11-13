Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Chord Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function NextWord
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
function Suspend-PSHistory { Set-PSReadLineOption -HistorySaveStyle SaveNothing }
