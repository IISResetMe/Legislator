function Assert-Legislator
{
    param (
        [string]$MemberType
    )

    if (-not $Legislator)
    {
        throw "$MemberType only allowed in interface declarations"
    }
}