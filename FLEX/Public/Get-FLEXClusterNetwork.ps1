function Get-FLEXClusterNetwork {
    param(
        [parameter(ValueFromPipelineByPropertyName)]
        [string] $id
    )
    $results = Invoke-FLEXRestCall -method GET -API v1 -endpoint 'pages/dashboard'
    if ($id) {
        $results = $results.clusters | Where-Object {$_.id -eq $id} | Select-Object network
    } else {
        $results = $results.clusters | Select-Object network
    }
    return $results.network
}