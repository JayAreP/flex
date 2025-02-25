function Get-FLEXEchoTopology {
    param(
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    $results = invoke-flEXRestCall -API v1 -endpoint topology -method get -APIPrefix ocie -flexContext $flexContext

    return $results
}