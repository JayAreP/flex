function Remove-FLEXEchoHost {
    param(
        [parameter(Mandatory)]
        [string] $hostID,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        $endpoint = 'hosts/' + $hostID
    }

    process {
        $results = Invoke-FLEXRestCall -API v1 -APIPrefix hostess -endpoint $endpoint -method DELETE -flexContext $flexContext
        return $results
    }

}

