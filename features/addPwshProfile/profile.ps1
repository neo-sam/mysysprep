Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Chord Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function NextWord
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
function Disable-PSHistory { Set-PSReadLineOption -HistorySaveStyle SaveNothing }
