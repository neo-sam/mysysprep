BeforeAll {
    . "$PSScriptRoot\..\..\modules\common\import.ps1"

    function New-GeneratedXml() {
        return [xml](& $PSScriptRoot\generator.ps1)
    }
}

Describe 'Generate unattend.xml' {
    It 'Not Empty' {
        New-GeneratedXml
    }
}
