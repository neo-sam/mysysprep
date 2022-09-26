. scripts/_adminrequire

Set-Location installers
$files = Get-ChildItem

function Start-WaitToInstallJob {
    Start-Job -ArgumentList $args {
        param($name, $file, $params, $checkpath)
        Write-Host "Start to install $name ..."
        try {
            Start-Process -Wait $file.FullName $params
            if ($checkpath) { Get-ChildItem $checkpath -ErrorAction Stop | Out-Null }
        }
        catch {
            Write-Host "Failed to install ${name}:`n$Error`n"
            return
        }
        Write-Host "Successfully installed $name."
    } > $null
}

Write-Host "If prompt installation dialogs, allow and confirm ...`n"

foreach ($file in $files) {
    $filename = $file.Name
    switch -Wildcard ($filename) {
        'Firefox Setup *.exe' {
            Start-WaitToInstallJob 'Firefox' $file '/S' "$env:ProgramFiles\Mozilla Firefox\firefox.exe"
        }
        '7z*-zstd-x64.exe' {
            Start-WaitToInstallJob '7zip-zstd' $file '/S'
        }
    }
}

Get-Job | Receive-Job -Wait
