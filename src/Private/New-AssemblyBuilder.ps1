using namespace System.Reflection.Emit

function New-AssemblyBuilder
{
    param (
        [AllowEmptyString()]
        [string]$Name
    )

    $assemblyName   = [AssemblyName]::new("${Name}$((New-Guid)-replace'\W')")
    $assemblyAccess = [AssemblyBuilderAccess]::Run

    if($PSVersionTable['PSEdition'] -eq 'Core') {
        return [AssemblyBuilder]::DefineDynamicAssembly($assemblyName, $assemblyAccess)
    }

    return [AppDomain]::CurrentDomain.DefineDynamicAssembly($assemblyName, $assemblyAccess)
}