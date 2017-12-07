using namespace System.Collections.Generic
using namespace System.Reflection
using namespace System.Reflection.Emit

function event {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$TypeName,

        [Parameter(Mandatory = $true, Position = 1)]
        [Alias('Name')]
        [string]$EventName,

        [Parameter(Mandatory = $false, Position = 2)]
        [string]$Option
    )

    try{
        $handlerType = [Type]$TypeName
    }
    catch {
        throw [Exception]::new('Unrecognized type name', $_)
        return
    }

    $eventBuilder = $Legislator.DefineEvent($EventName, [EventAttributes]::None, $handlerType);

    $eventMethodAttributes = @(
        'Public', 'HideBySig', 'SpecialName', 'Abstract', 'Virtual', 'NewSlot'
    ) -as [MethodAttributes]

    $addMethod = . method -TypeName:'void' -Name:"add_$EventName" -Attributes:$eventMethodAttributes -ParameterTypes @( $HandlerType ) -PassThru:$true
    $addMethod.DefineParameter(1, [ParameterAttributes]::None, 'value')
    $eventBuilder.SetAddOnMethod($addMethod)

    $removeMethod = . method -TypeName:'void' -Name:"remove_$EventName" -Attributes:$eventMethodAttributes -ParameterTypes @( $HandlerType ) -PassThru:$true
    $removeMethod.DefineParameter(1, [ParameterAttributes]::None, 'value')
    $eventBuilder.SetRemoveOnMethod($removeMethod)
}
