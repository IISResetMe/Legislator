using namespace System.Collections.Generic
using namespace System.Reflection
using namespace System.Reflection.Emit

function property {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$TypeName,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Name,

        [Parameter(Mandatory = $false, Position = 2)]
        [ValidateSet('ReadOnly')]
        [string]$Option
    )

    try{
        $Type = [Type]$TypeName
    }
    catch {
        throw [Exception]::new('Unrecognized type name', $_)
        return
    }

    $property = $Legislator.DefineProperty($Name, [PropertyAttributes]::HasDefault, [CallingConventions]::HasThis, $Type, $null)

    $propertyMethodAttributes = @(
        'Public', 'HideBySig', 'SpecialName', 'Abstract', 'Virtual', 'NewSlot'
    ) -as [MethodAttributes]

    $getMethod = $Legislator.DefineMethod("get_" + $Name, $propertyMethodAttributes, $Type, [Type]::EmptyTypes)

    $property.SetGetMethod($getMethod)

    if($Option -ne 'ReadOnly') {
        $setMethod = $Legislator.DefineMethod("set_" + $Name, $propertyMethodAttributes, $null, @( $Type ))
        $null = $setMethod.DefineParameter(1, [ParameterAttributes]::None, 'value');

        $property.SetSetMethod($setMethod)
    }
}
