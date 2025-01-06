function Get-FLEXClusterNetwork {
    param(
        [parameter(ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )
    $functionName = $MyInvocation.MyCommand.Name
    Write-Verbose "-> $functionName"
    
    $results = Invoke-FLEXRestCall -method GET -API v1 -endpoint 'pages/dashboard' -flexContext $flexContext
    if ($id) {
        $results = $results.clusters | Where-Object {$_.id -eq $id} | Select-Object network
    } else {
        $results = $results.clusters | Select-Object network
    }
    $flexnetInfo = $results.network
    $vnetInfo = Get-FLEXClusterNetworkVnetInfo -flexContext $flexContext
    $flexnetInfo.vnet = $vnetInfo
    return $flexnetInfo
}