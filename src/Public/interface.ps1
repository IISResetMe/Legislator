using namespace System.Collections.Generic
using namespace System.Reflection
using namespace System.Reflection.Emit

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
                },$true) |ForEach-Object GetCommandName) |Where-Object { $_ -notin 'property','method','event' }
            ) -or $(throw 'Only properties and methods can be defined in an interface')
        })]
        [scriptblock]$Definition,

        [Parameter()]
        [ValidateScript({-not($_ |Where-Object{-not $_.IsInterface})})]
        [type[]]$Implements,

        [Parameter()]
        [switch]$PassThru = $false
    )

    if($Name -cnotlike 'I*'){
        Write-Warning -Message "Naming rule violaion: Missing prefix: 'I'"
    }

    $interfaceAttributes = @(
        'Public','Interface','Abstract','AnsiClass','AutoLayout'
    ) -as [TypeAttributes]

    $assemblyBuilder = New-AssemblyBuilder -Name $Name
    $moduleBuilder = $assemblyBuilder.DefineDynamicModule("__psinterfacemodule_$assemblyName")

    $Legislator = $moduleBuilder.DefineType($Name, $interfaceAttributes)

    if($PSBoundParameters.ContainsKey('Implements')){
        foreach($interfaceImpl in $Implements |Sort-Object -Property FullName -Unique){
            try{
                $Legislator.AddInterfaceImplementation($interfaceImpl)
            }
            catch{
                throw
                return
            }
        }
    }

    try{
        $null = . $Definition
        $finalType = $Legislator.CreateType()
        
        if($PassThru){
            return $finalType
        }
    }
    catch{
        throw
    }
}
