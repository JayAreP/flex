function Get-FLEXClusterStats {
    param(
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )
    $results = Invoke-FLEXRestCall -method GET -API v1 -endpoint 'pages/dashboard' -flexContext $flexContext

    $results = $results.k2xs | Select-Object stats

    return $results.stats
}