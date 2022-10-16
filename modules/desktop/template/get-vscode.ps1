$url = 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user'
try {
    $req = Invoke-WebRequest -useb $url -method head
}
catch {
    Write-Error $_.Exception.Message
    Read-Host
    exit
}
if ($null -ne $req.BaseResponse.RequestMessage) { $path = $req.BaseResponse.RequestMessage.RequestUri.LocalPath }
else { $path = $req.BaseResponse.ResponseUri.AbsolutePath }
$name = ($path -split '/')[-1]
$rewriteUrl = $url # original address
if (!(Test-Path $name) -or ((Get-AuthenticodeSignature $name).Status -ne 'Valid')) {
    Invoke-WebRequest $rewriteUrl -o $name
}
Start-Process -PassThru (Get-ChildItem $name) '/silent /tasks=addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath' | Wait-Process

& "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd"
