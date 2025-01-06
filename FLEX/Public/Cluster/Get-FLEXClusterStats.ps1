function Get-FLEXClusterStats {
    param(
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )
    $functionName = $MyInvocation.MyCommand.Name
    Write-Verbose "-> $functionName"
    
    $results = Invoke-FLEXRestCall -method GET -API v1 -endpoint 'pages/dashboard' -flexContext $flexContext

    $results = $results.k2xs | Select-Object stats

    return $results.stats
}