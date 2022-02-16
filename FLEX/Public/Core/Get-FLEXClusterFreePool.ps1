function Get-FLEXClusterFreePool {
    param(
        [parameter(ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    $results = Invoke-FLEXRestCall -method GET -API v1 -endpoint 'pages/dashboard' -flexContext $flexContext
    if ($id) {
        $results = $results.clusters | Where-Object {$_.id -eq $id} | Select-Object free_pool
        $results = $results.clusters | Select-Object free_pool
    }

    return $results.free_pool
}