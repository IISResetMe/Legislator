# Legislator
Legislator is a simple .NET interface authoring tool written in PowerShell

## Background

I've heard a number of powershell users ask for the ability to _define_ .NET interfaces at runtime, rather than just implementing them using the Classes feature introduced in PowerShell v5. I'm not sure how scalable this approach is for DSC, but other interesting use cases might exist.

## Usage

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
