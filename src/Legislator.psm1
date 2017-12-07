$ErrorActionPreference = "Stop"

# Attempt to retrieve relevant script files
$Classes = Get-ChildItem (Join-Path $PSScriptRoot Classes) -ErrorAction SilentlyContinue -Filter *.class.ps1
$Public  = Get-ChildItem (Join-Path $PSScriptRoot Public)  -ErrorAction SilentlyContinue -Filter *.ps1
$Private = Get-ChildItem (Join-Path $PSScriptRoot Private) -ErrorAction SilentlyContinue -Filter *.ps1

# Classes on which other classes might depend, must be specified in order
$ClassDependees = @()

# Import classes on which others depend first
foreach($classDependee in $ClassDependees)
{
    Write-Verbose "Loading class '$classDependee'"
    try{
        . (Join-Path (Join-Path $PSScriptRoot .\Classes) "$classDependee.class.ps1")
    }
    catch{
        Write-Error -Message "Failed to import class $($classDependee): $_"
    }
}

# Import any remaining class files
foreach($class in $Classes|Where-Object {($_.Name -replace '\.class\.ps1') -notin $ClassDependees})
{
    Write-Verbose "Loading class '$class'"
    try{
        . $class.FullName
    }
    catch{
        Write-Error -Message "Failed to import dependant class $($class.FullName): $_"
    }
}

# dot source the functions
foreach($import in @($Public;$Private))
{
    Write-Verbose "Loading script '$import'"
    try{
        . $import.FullName
    }
    catch{
        Write-Error -Message "Failed to import function $($import.FullName): $_"
    }
}

# Export public functions
Write-Verbose "Exporting public functions: interface, method, property"
Export-ModuleMember -Function interface,method,property