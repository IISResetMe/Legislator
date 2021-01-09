using namespace System.Collections.Generic
using namespace System.Reflection
using namespace System.Reflection.Emit

function property {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$TypeName,

        [Parameter(Mandatory = $true, Position = 1)]
        [Alias('Name')]
        [string]$PropertyName,

        [Parameter(Mandatory = $false, Position = 2)]
        [ValidateSet('ReadOnly')]
        [string]$Option
    )

    Assert-Legislator -MemberType property

    try{
        $Type = [Type]$TypeName
    }
    catch {
        throw [Exception]::new('Unrecognized type name', $_.Exception)
        return
    }

    $property = $Legislator.DefineProperty($PropertyName, [PropertyAttributes]::HasDefault, [CallingConventions]::HasThis, $Type, $null)

    $propertyMethodAttributes = @(
        'Public', 'HideBySig', 'SpecialName', 'Abstract', 'Virtual', 'NewSlot'
    ) -as [MethodAttributes]

    $getMethod = . method -TypeName:$Type.FullName -Name:"get_$PropertyName" -Attributes:$propertyMethodAttributes -PassThru:$true
    $property.SetGetMethod($getMethod)

    if($Option -ne 'ReadOnly') {
        $setMethod = . method -TypeName:"void" -Name:"set_$PropertyName" -Attributes:$propertyMethodAttributes -ParameterTypes @( $Type ) -PassThru:$true
        $null = $setMethod.DefineParameter(1, [ParameterAttributes]::None, 'value');

        $property.SetSetMethod($setMethod)
    }
}
