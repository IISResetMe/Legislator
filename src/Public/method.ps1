using namespace System.Collections.Generic
using namespace System.Reflection
using namespace System.Reflection.Emit

function method {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$TypeName,

        [Parameter(Mandatory = $true, Position = 1)]
        [Alias('Name')]
        [string]$MethodName,

        [Parameter(Mandatory = $false, Position = 2)]
        [AllowEmptyCollection()]
        [Type[]]$ParameterTypes,

        [Parameter(DontShow)]
        [MethodAttributes]$Attributes,

        [Parameter(DontShow)]
        [switch]$PassThru
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

    $interfaceMethodAttributes = $interfaceMethodAttributes -bor $Attributes

    $method = $Legislator.DefineMethod($MethodName, $interfaceMethodAttributes, $ReturnType, $ParameterTypes)
    if($PassThru){
        return $method
    }
}
