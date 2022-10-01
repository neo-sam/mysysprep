Write-Output '==> Deploy User-Only Packages'

& .\lib\execute-deployment.ps1 -taskName 'add package' `
    -deployScriptsFolder '.\pkgs-scripts\user-level' `
    -deployMutexScriptsFolder '.\pkgs-scripts\user-level-mutex'
