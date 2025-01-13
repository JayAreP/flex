function Get-FLEXClusterMNodes {
    param(
        [parameter(ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter()]
        [string] $name,
        [parameter()]
        [switch] $showAvailable,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    $results = Invoke-FLEXRestCall -method GET -API v1 -endpoint 'pages/nodes' -flexContext $flexContext
    if ($id) {
        $results = $results.clusters | Where-Object {$_.id -eq $id} | Select-Object mnodes
    } else {
        $results = $results.clusters | Select-Object mnodes
    }
    
    if ($showAvailable) {
        $results = $results.mnodes | Where-Object {$_.cluster_state -eq "FREE"}
    } else {
        $results = $results.mnodes
    }

    if ($name) {
        $results = $results | Where-Object {$_.name -eq $name}
    }

    return $results
}