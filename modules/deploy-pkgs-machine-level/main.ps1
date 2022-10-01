Write-Output '==> Deploy Packages'

& .\lib\execute-deployment.ps1 -taskName 'add package' `
    -deployScriptsFolder '.\pkgs-scripts\machine-level'`
    -deployMutexScriptsFolder '.\pkgs-scripts\machine-level-mutex'
