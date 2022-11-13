. .\lib\loadAllConfig.ps1

ConvertTo-Json ([ordered]@{
        features   = $features
        unattend   = $unattend
        skipDeploy = $skipDeploy
    }) -Depth 4
