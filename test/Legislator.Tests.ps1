$ModuleManifestName = 'Legislator.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\src\$ModuleManifestName"

if (!$SuppressImportModule) {
    # -Scope Global is needed when running tests from inside of psake, otherwise
    # the module's functions cannot be found in the PSCache\ namespace
    Import-Module $ModuleManifestPath -Scope Global
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
