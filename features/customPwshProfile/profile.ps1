if (Get-Module PSReadLine) {
    Set-PSReadLineOption -EditMode Emacs
    Set-PSReadLineKeyHandler -Chord Ctrl+LeftArrow -Function BackwardWord
    Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function NextWord
    Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
    function Suspend-PSHistory { Set-PSReadLineOption -HistorySaveStyle SaveNothing }
}

if (Test-Path 'C:\Program Files\Git\usr\bin') {
    & {
        $appdir = 'C:\Program Files\Git\usr\bin'

        $allCommands = Get-Command -All
        $allApps = Get-Command -CommandType Application

        $commandNameSet = [System.Collections.Generic.HashSet[String]] $allCommands.Name
        $appNameSet = [System.Collections.Generic.HashSet[String]] $allApps.FileVersionInfo.InternalName

        foreach ($name in (Get-Content -ea 0 'C:\Windows\System32\WindowsPowerShell\v1.0\git-aliases.txt')) {
            if ($commandNameSet.Contains($name)) {
                Write-Warning "$name is a command."
            }
            elseif ($appNameSet.Contains($name)) {
                if (!"$((Get-Command -ea 0 $name).path)".StartsWith($appdir)) {
                    Write-Warning "$name is not located in git tools."
                }
            }
            else {
                Set-Alias -Scope Global $name "C:\Program Files\Git\usr\bin\$name.exe"
            }
        }
        foreach ($name in @('vim', 'ssh', 'scp', 'sftp', 'openssl')) {
            if (!$appNameSet.Contains($name)) {
                Set-Alias -Scope Global $name "C:\Program Files\Git\usr\bin\$name.exe"
            }
        }
        foreach ($name in @('tar', 'du', 'xxd')) {
            if ($appNameSet.Contains($name)) {
                Set-Alias -Scope Global $name "C:\Program Files\Git\usr\bin\$name.exe"
            }
        }
    }
    function Get-AliasFromGit {
    (Get-Alias | Where-Object { $_.Definition -like 'C:\Program Files\Git\usr\bin\*' } ).ReferencedCommand -replace '.exe$', ''
    }
}
else {
    function touch([string]$filename) {
        New-Item $filename | Out-Null
    }
}
