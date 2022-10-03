# Shortcuts map
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Chord Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function NextWord

# Enhancement
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
function Suspend-HistoryRecord { Set-PSReadLineOption -HistorySaveStyle SaveNothing }

# CDD to desktop
function Set-LocationToDesktop {
    Set-Location ([System.Environment]::GetFolderPath('desktop'))
}
Set-Alias cdd Set-LocationToDesktop

# Switch UTF8 mode
function Switch-Utf8 {
    $nowCoding = [Console]::OutputEncoding
    $newCoding = [Text.Encoding]::UTF8
    if ($nowCoding -ne $newCoding) {
        $global:beforeUtf8Coding = $nowCoding
        [Console]::OutputEncoding = $newCoding
    }
    else {
        [Console]::OutputEncoding = $global:beforeUtf8Coding
    }
}
Set-Alias su8 Switch-Utf8
