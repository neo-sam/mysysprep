$pkgfile = Get-PackageFile "VSCodeUserSetup-x64-*.exe"
if (!$PSSenderInfo) {
    if ($pkgfile) { 'VSCode', 'userlevel' }
    return
}

Start-Process $pkgfile -PassThru '/silent',
'/tasks=addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath' |
Wait-Process

Assert-Path "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd"
