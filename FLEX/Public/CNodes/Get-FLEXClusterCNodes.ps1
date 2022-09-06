function Get-FLEXClusterCNodes {
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
        $results = $results.clusters | Where-Object {$_.id -eq $id} | Select-Object cnodes
    } else {
        $results = $results.clusters | Select-Object cnodes
    }
    
    if ($showAvailable) {
        $results = $results.cnodes | Where-Object {$_.cluster_state -eq "FREE"}
    } else {
        $results = $results.cnodes
    }

    if ($name) {
        $results = $results | Where-Object {$_.name -eq $name}
    }

    return $results
}