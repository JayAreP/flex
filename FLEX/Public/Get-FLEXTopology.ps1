function Get-FLEXTopology {
    param(
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    $results = Invoke-FLEXRestCall -method GET -API v1 -endpoint 'me/topology' -flexcontext $flexContext
    return $results
}