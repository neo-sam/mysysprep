Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Chord Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function NextWord
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
function Suspend-HistoryRecord { Set-PSReadLineOption -HistorySaveStyle SaveNothing }
