. .\lib\load-config.ps1

ConvertTo-Json @{
    features = $features
    unattend = $unattend
    deploy   = $deploy
} -Depth 4
