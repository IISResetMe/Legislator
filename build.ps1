mkdir $PSScriptRoot\publish -Force
Copy-Item $PSScriptRoot\src\* $PSScriptRoot\publish\ -Force -Recurse