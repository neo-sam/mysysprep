BeforeAll {
    . "$PSScriptRoot\..\..\modules\common\import.ps1"

    function New-GeneratedXml() {
        return [xml](& $PSScriptRoot\generator.ps1)
    }

    function Get-TaskbarLayoutChildren($document) {
        return $document.LayoutModificationTemplate.CustomTaskbarLayoutCollection.TaskbarLayout
    }
}

Describe 'Generate TaskbarLayoutModification.xml' {
    It 'Windows 10' {
        Mock Test-Windows10 { 1 }
        Mock Test-Windows11 { 0 }

        $doc = New-GeneratedXml
        Get-TaskbarLayoutChildren $doc | Should -Not -BeNullOrEmpty
    }
    It 'Windows 11' {
        Mock Test-Windows10 { 1 }
        Mock Test-Windows11 { 0 }

        $doc = New-GeneratedXml
        Get-TaskbarLayoutChildren $doc | Should -Not -BeNullOrEmpty
    }
}
