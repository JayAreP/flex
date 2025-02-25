function Get-FLEXEchoHost {
    param(
        [parameter()]
        [string] $hostID,
        [parameter()]
        [ValidateSet('mssql', IgnoreCase = $false)]
        [string] $DBVendor,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )
    
    if ($hostID) {
        $endpoint = 'hosts/' + $hostID
    } else {
        $endpoint = 'hosts'
    }

    # $results = Invoke-FLEXRestCall -API v1 -endpoint topology -method get -APIPrefix ocie 
    $results = Invoke-FLEXRestCall -API v1 -endpoint $endpoint -method get -APIPrefix hostess -flexContext $flexContext

    if ($DBVendor) {
        $results = $results | Where-Object {$_.db_vendor -eq $DBVendor}
    }

    return $results

}