.\lib\modules\common\import.ps1

foreach ($path in (Get-ChildItem .\lib\modules\*\*).FullName) {
    Import-Module -Force $path
}
