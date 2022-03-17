function Get-FLEXClusterSDP {
    param(
        [parameter()]
        [string] $name,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )
    $flexTopology = Get-FLEXDashboard -flexContext $flexContext
    $results = $flexTopology.k2xs
    if ($name) {
        $results = $results | where-object {$_.name -eq $name}
    }
    return $results
}