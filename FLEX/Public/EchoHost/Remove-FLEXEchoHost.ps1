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
        $results = Invoke-FLEXRestCall -flexAlias -API v1 -endpoint $endpoint -method DELETE -flexContext $flexContext
        return $results
    }
}

