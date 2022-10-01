Write-Output '==> Deploy Packages',
'If prompt installation dialogs, allow and confirm ...' ''

& .\lib\execute-deployment.ps1 -taskName 'add package' `
    -deployScriptsFolder '.\pkgs-scripts' `
    -deployAsyncScriptsFolder '.\pkgs-scripts\async'
