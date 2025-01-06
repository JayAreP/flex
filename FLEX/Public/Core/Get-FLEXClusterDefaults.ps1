function Get-FLEXClusterDefaults {
    param(
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    $functionName = $MyInvocation.MyCommand.Name
    Write-Verbose "-> $functionName"

    $objId = (Get-FLEXCluster -flexContext $flexContext).id
    $results = Invoke-FLEXRestCall -method GET -API v1 -endpoint 'me/topology' -flexcontext $flexContext | Where-Object {$_._id -eq $objId}
    $results = $results._obj.defaults
    return $results
}