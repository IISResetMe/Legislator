# Legislator
Legislator is a simple .NET interface authoring tool written in PowerShell

## Background

I've heard a number of powershell users ask for the ability to _define_ .NET interfaces at runtime, rather than just implementing them using the Classes feature introduced in PowerShell v5. I'm not sure how scalable this approach is for DSC, but other interesting use cases might exist.

## Installation

### From PowerShell Gallery

Legislator is listed on PowerShell Gallery

```powershell
Install-Module Legislator
```

### Manual installation

Copy the contents of `src` to a folder called `Legislator` in your module directory, e.g.:

```powershell
$modulePath = "C:\Program Files\WindowsPowerShell\Modules"
mkdir "$modulePath\Legislator"
Copy-Item .\src\* -Destination "$modulePath\Legislator\" -Recurse
```

Import using `Import-Module` as you would any other module:

```powershell
Import-Module Legislator
```

## Syntax 

The chosen syntax attempts to balance the simplicity of interface definitions found in C#, including the type signature layout found in that language and the need to easily parse the syntactical elements as PowerShell functions (hence the property/method prefix keywords).

### Commands

#### `interface`

A Legislator-generated interface starts with the `interface` command. It takes two positional mandatory parameters - a name and a scriptblock containing the interface declaration:

    interface IName {

    }


#### `property`
Property declarations in Legislator look like implicit properties in C#, prefixed with keyword `property`.
Thus, the following interface definition in Legislator:

    interface IPoint {
        property int X
        property int Y
    }

is equivalent to the following interface definition in C#:

    interface IPoint 
    {
        int X
        {
            get;
            set;
        }
        int Y
        {
            get;
            set;
        }
    }


#### `method`

This example:

```powershell
interface IWell {
    method void DropCoin([Coin])
}
```

is equivalent to the following in C#:

```csharp
interface IWell
{
    void DropCoin(Coin c);
}
```

#### `event`

The following event declaration in Legislator:

```powershell
interface ICar {
    event EventHandler[EventArgs] EngineStarted
}
```

is equivalent of C#:

```csharp
interface ICar
{
    event EventHandler<EventArgs> EngineStarted;
}
```

#### Multiple interface

Legislator also supports chaining multiple interfaces, via the `Implements` parameter.

The following interface declaration in Legislator:

```powershell
interface ICrappyCar {
    event EventHandler[EventArgs] EngineBroke
} -Implements IDisposable
```

is equivalent to the following in C#:

```csharp
interface ICrappyCar : IDisposable {
    event EventHandler<EventArgs> EngineBroke
}
```

### Syntax notes

Legislator currently supports `method`, `property` and `event` members. No plans to supporting index accessor syntax.

Due to limited usefulness, access modifiers are also not supported, all generated interfaces default to Public.

Parameter naming for methods is also not currently support.

The `property` definition supports a ReadOnly option that omits declaration of a property setter:

```powershell
interface ITest {
    property int MyProperty -Option ReadOnly
}
```

is equivalent to the following C# with an explicit getter but no setter:

```csharp
interface ITest {
    int MyProperty
    {
        get;
    }
}
```

## Example Usage

The following example defines a (_very_) rudimentary Calculator interface, and utilises it for flexible dependency injection

<script src="https://gist.github.com/IISResetMe/ce158e711ea0ed0d0fb4b69bf3701a41.js"></script>

See also: [IPasswordPolicy](https://github.com/IISResetMe/IPasswordPolicy), a strategy pattern example implementing a Legislator-defined interface

## Contributing

If you'd like to submit a bug or otherwise contribute to the development of Legislator (or just say hi) feel free to [raise an issue](https://github.com/IISResetMe/Legislator/issues/new) or [contact me on Twitter](https://twitter.com/IISResetMe) 
