function Get-FLEXEchoTopology {
    param(
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    $results = invoke-flEXRestCall -APIPrefix ocie -API v1 -endpoint topology -method get -flexContext $flexContext

    return $results
}