function Get-FLEXClusterNetworkVnetInfo {
    param(
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    # $results = Invoke-FLEXRestCall -method GET -API v1 -endpoint 'pages/dashboard' -flexContext $flexContext
    $cluster = Get-FLEXCluster -flexContext $flexContext
    $endpoint = 'clusters/' + $cluster.id + '/conf'

    $results = (Invoke-FLEXRestCall -method GET -API v2 -endpoint $endpoint -flexContext $flexContext).conf.vnet

    return $results
}