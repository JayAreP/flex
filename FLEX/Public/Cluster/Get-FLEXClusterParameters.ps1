function Get-FLEXClusterParameters {
    param(
        [parameter(ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )
    $results = Invoke-FLEXRestCall -method GET -API v1 -endpoint 'pages/dashboard' -flexContext $flexContext
    if ($id) {
        $results = $results.clusters | Where-Object {$_.id -eq $id} | Select-Object defaults
    } else {
        $results = $results.clusters | Select-Object defaults
    }
    return $results.defaults
}