# Legislator
Legislator is a simple .NET interface authoring tool written in PowerShell

## Background

I've heard a number of powershell users ask for the ability to _define_ .NET interfaces at runtime, rather than just implementing them using the Classes feature introduced in PowerShell v5. I'm not sure how scalable this approach is for DSC, but other interesting use cases might exist.

## Installation

Copy the contents of `src` to a folder called `Legislator` in your module directory, e.g.:

    $modulePath = "C:\Program Files\WindowsPowerShell\Modules"
    mkdir "$modulePath\Legislator"
    Copy-Item .\src\* -Destination "$modulePath\Legislator\" -Recurse

Import using `Import-Module` as you would any other module:

    Import-Module Legislator

## Syntax 

The chosen syntax attempts to balance the simplicity of interface definitions found in C#, including the type signature layout found in that language and the need to easily parse the syntactical elements as PowerShell functions (hence the property/method prefix keywords).

Thus, the following interface definition in Legislator:

    interface IPoint {
        property int X
        property int Y
    }

is equivalent to the following interface definition in C#:

    interface IPoint 
    {
        int X;
        int Y;
    }

And this example:

    interface IWell {
        property IPoint Location
        
        method void DropCoin([Coin])
    }

is equivalent to the following in C#:

    interface IWell
    {
        IPoint Location;

        void DropCoin(Coin c);
    }

Legislator currently supports `method` and `property` members.

Due to limited usefulness, access modifiers are not supported, all generated interfaces default to Public.

Parameter naming for methods is also not currently support.

The `property` definition supports a ReadOnly option that omits declaration of a property setter:

    interface ITest {
        property int MyProperty -Option ReadOnly
    }

is equivalent to the following C# with an explicit getter but no setter:

    interface ITest {
        int MyProperty
        {
            get;
        }
    }

## Example Usage

The following example defines a (_very_) rudimentary Calculator interface, and utilises it for flexible dependency injection

    Import-Module .\src\Legislator.psd1
    
    # Define a calculator interface with two common arithmetic methods
    interface ICalculator {
        method int Add ([int],[int])
        method int Subtract ([int],[int])
    }
    
    # Define a MathStudent class
    class MathStudent 
    {
        # Any good student always carries a calculator around
        [ICalculator]$Calculator

        MathStudent([ICalculator]$Calculator)
        {
            $this.Calculator = $Calculator
        }
    }
    
    # This is the most basic calculator implementation
    class SimpleCalculator : ICalculator
    {
        [int]Add([int]$a, [int]$b)
        {
            return $a + $b
        }
        
        [int]Subtract([int]$a, [int]$b)
        {
            return $a - $b
        }
    }
    
    # This is a fancier version!!!
    class CalculatorPlusPlus : ICalculator
    {
        [int]Add([int]$a, [int]$b)
        {
            return $a + $b
        }
        
        [int]Subtract([int]$a, [int]$b)
        {
            return $a - $b
        }

        [int]Multiply([int]$a, [int]$b)
        {
            return $a * $b
        }
        
        [int]Divide([int]$a, [int]$b)
        {
            if($b -eq 0){
                return 0
            }
            return $a - $b
        }
    }
   
    # Jimmy comes from a poor family :-(
    $Jimmy = [MathStudent]::new([SimpleCalculator]::new())
    
    # Bobby comes from a long lineage of Ivy league snobs
    $Bobby = [MathStudent]::new([CalculatorPlusPlus])

## Contributing

If you'd like to submit a bug or otherwise contribute to the development of Legislator (or just say hi) feel free to [raise an issue](https://github.com/IISResetMe/Legislator/issues/new) or [contact me on Twitter](https://twitter.com/IISResetMe) 