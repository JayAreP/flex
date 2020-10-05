function Get-FLEXClusterMNodes {
    param(
        [parameter(ValueFromPipelineByPropertyName)]
        [string] $id
    )
    $results = Invoke-FLEXRestCall -method GET -API v1 -endpoint 'pages/nodes'
    if ($id) {
        $results = $results.clusters | Where-Object {$_.id -eq $id} | Select-Object mnodes
    } else {
        $results = $results.clusters | Select-Object mnodes
    }
    return $results.mnodes
}