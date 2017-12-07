using namespace System.Collections.Generic
using namespace System.Reflection
using namespace System.Reflection.Emit

function method {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$TypeName,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Name,

        [Parameter(Mandatory = $false, Position = 2)]
        [AllowEmptyCollection()]
        [Type[]]$ParameterTypes
    )

    try{
        $ReturnType = [Type]$TypeName
    }
    catch {
        throw [Exception]::new('Unrecognized type name', $_)
        return
    }

    $interfaceMethodAttributes = @(
        'Public', 'HideBySig', 'Abstract', 'Virtual', 'NewSlot'
    ) -as [MethodAttributes]

    $null = $Legislator.DefineMethod($Name, $interfaceMethodAttributes, $ReturnType, $ParameterTypes)
}
