function Get-FLEXCluster {
    param(
        [parameter()]
        [string] $id
    )
    $results = Invoke-FLEXRestCall -method GET -API v1 -endpoint 'pages/dashboard'
    if ($id) {
        $results = $results.clusters | Where-Object {$_.id -eq $id} | Select-Object id,name,site_id,cluster_type
    } else {
        $results = $results.clusters | Select-Object id,name,site_id,cluster_type
    }
    return $results
}