function Get-FLEXTopology {
    param(
        [parameter()]
        [string] $objId,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )
    
    $functionName = $MyInvocation.MyCommand.Name
    Write-Verbose "-> $functionName"

    $results = Invoke-FLEXRestCall -method GET -API v1 -endpoint 'me/topology' -flexcontext $flexContext
    if ($objId) {
        $results = $results | Where-Object {$_._id -eq $objId}
    }
    return $results
}