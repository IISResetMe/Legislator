@{
    RootModule = 'Legislator.psm1'
    ModuleVersion = '0.0.5'
    GUID = '5331baea-66ef-4a5c-9168-bd0a85fdaec2'
    Author = 'Mathias R. Jessen (@IISResetMe)'
    CompanyName = 'IISResetMe'
    Copyright = '(c) 2020 IISResetMe. All rights reserved.'
    Description = 'Legislator is a simple .NET interface authoring tool written in PowerShell'
    PowerShellVersion = '5.0'
    FunctionsToExport = 'interface','method','property','event'
    PrivateData = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            # Tags = @()
    
            # A URL to the license for this module.
            LicenseUri = 'https://github.com/IISResetMe/Legislator/blob/trunk/LICENSE'
    
            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/IISResetMe/Legislator'
    
            # A URL to an icon representing this module.
            # IconUri = ''
    
            # ReleaseNotes of this module
            # ReleaseNotes = ''
        }
    }
}