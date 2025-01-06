function Get-FLEXCluster {
    param(
        [parameter()]
        [string] $id,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )
    $functionName = $MyInvocation.MyCommand.Name
    Write-Verbose "-> $functionName"
    
    $results = Invoke-FLEXRestCall -method GET -API v1 -endpoint 'pages/dashboard' -flexContext $flexContext
    if ($id) {
        $results = $results.clusters | Where-Object {$_.id -eq $id} | Select-Object id,name,site_id,cluster_type,status,enabled_checkpointing,timezone
    } else {
        $results = $results.clusters | Select-Object id,name,site_id,cluster_type,status,enabled_checkpointing,timezone
    }
    return $results
}