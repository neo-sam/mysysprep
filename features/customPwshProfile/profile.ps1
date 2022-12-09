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
    $allCommands = (Get-Command -All).Name
    $allAppCommands = (Get-Command -CommandType Application).Name
    foreach ($name in (Get-Content -ea 0 'C:\Windows\System32\WindowsPowerShell\v1.0\git-aliases.txt')) {
        if ($allCommands -contains $name) {
            Write-Warning "$name is a command."
        }
        elseif ($allAppCommands -contains "$name.exe") {
            Write-Warning "$name is not located in git tools."
        }
        else {
            Set-Alias $name "C:\Program Files\Git\usr\bin\$name.exe"
        }
    }
    foreach ($name in @('vim', 'ssh', 'scp', 'sftp')) {
        if ($allAppCommands -notcontains "$name.exe") {
            Set-Alias $name "C:\Program Files\Git\usr\bin\$name.exe"
        }
    }
    foreach ($name in @('tar', 'du', 'xxd')) {
        if ($allAppCommands -contains "$name.exe") {
            Set-Alias $name "C:\Program Files\Git\usr\bin\$name.exe"
        }
    }
    Remove-Variable allCommands
    Remove-Variable allAppCommands

    function Get-AliasFromGit {
        (Get-Alias | Where-Object { $_.Definition -like 'C:\Program Files\Git\usr\bin\*' } ).ReferencedCommand -replace '.exe$', ''
    }
}
else {
    function touch([string]$filename) {
        New-Item $filename | Out-Null
    }
}
