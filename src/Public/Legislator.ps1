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

function interface {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidatePattern('^[\p{Lu}\p{Ll}\p{Lt}\p{Lm}\p{Lo}][\p{Lu}\p{Ll}\p{Lt}\p{Lm}\p{Lo}\p{Nl}\p{Mn}\p{Mc}\p{Nd}\p{Pc}\p{Cf}]*$')]
        [string]$Name,

        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateScript({
            -not (
                @($_.Ast.FindAll({
                    param($AST) 
                    $AST -is [System.Management.Automation.Language.CommandAst]
                },$true) |ForEach-Object GetCommandName) |Where-Object { $_ -notin 'property','method' }
            ) -or $(throw 'Only properties and methods can be defined in an interface')
        })]
        [scriptblock]$Definition,

        [Parameter()]
        [switch]$PassThru = $false
    )

    if($Name -cnotlike 'I*'){
        Write-Warning -Message "Naming rule violaion: Missing prefix: 'I'"
    }

    $interfaceAttributes = @(
        'Public','Interface','Abstract','AnsiClass','AutoLayout'
    ) -as [TypeAttributes]
    
    $runtimeGuid = $((New-Guid)-replace'\W')

    $assemblyName = [AssemblyName]::new("$Name$runtimeGuid")
    $assemblyBuilder = [AppDomain]::CurrentDomain.DefineDynamicAssembly($assemblyName, [AssemblyBuilderAccess]::Run)
    $moduleBuilder = $assemblyBuilder.DefineDynamicModule("__psinterfacemodule_$assemblyName")
    
    $Legislator = $moduleBuilder.DefineType($Name, $interfaceAttributes)

    $null = . $Definition

    $finalType = $Legislator.CreateType()
 
    if($PassThru){
        return $finalType
    }
}
