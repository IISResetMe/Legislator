$ModuleManifestName = 'Legislator.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\src\$ModuleManifestName"

if (!$SuppressImportModule) {
    Import-Module $ModuleManifestPath -Scope Global -Force
}

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath
        $? | Should Be $true
    }
}

Describe 'interface' {
    It 'Accepts a name and a scriptblock' {
        {
            interface "ITest$((New-Guid) -replace '\W')" {
                method int IsEmpty ([string])
            }
        } |Should Not Throw
    }

    It 'Emits no output by default' {
        interface "ITest$((New-Guid) -replace '\W')" {

        } |Should BeNullOrEmpty
    }

    It 'Emits the resulting interface type when PassThru is present' {
        $iName = "ITest$((New-Guid) -replace '\W')"
        interface $iName {

        } -PassThru |Should BeOfType System.Type
    }
}
