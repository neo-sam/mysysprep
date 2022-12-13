.\lib\loadModules.ps1
foreach ($name in (Get-ChildItem .\lib\modules\*).Name) {
    Import-Module -Force $name
}
