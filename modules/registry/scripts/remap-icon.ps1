$winver = [Environment]::OSVersion.Version.Build
$icons = @{
    quickaccess = "shell32.dll,213";
    library     = "explorer.exe";
    netdevices  = if ($winver -lt 22000) { "shell32.dll,18" } else { "shell32.dll,164" };
}

if ($winver -lt 22621) {
    if ($icons.quickaccess) {
        $Script:msg = Get-Translation 'Changed quick access icon.' `
            -cn '已修改“快速访问”的图标'

        Set-ItemProperty (
            Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{679F85CB-0220-4080-B29B-5540CC05AAB6}\DefaultIcon'
        ) '(Default)' $icons.quickaccess
        logif1
    }
}

if ($icons.netdevices) {
    $Script:msg = Get-Translation 'Changed network devices icon.' `
        -cn '已修改“网络设备”的图标'

    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\DefaultIcon'
    ) '(Default)' $icons.netdevices
    logif1
}

if ($icons.library) {
    $Script:msg = Get-Translation 'Changed libraries icon.' `
        -cn '已修改“库”的图标'

    Set-ItemProperty (
        Get-CurrentAndNewUserPaths 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{031E4825-7B94-4DC3-B131-E946B44C8DD5}\DefaultIcon'
    ) '(Default)' $icons.library
    logif1
}
