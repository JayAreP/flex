function Remove-FLEXEchoDBSnapShot {
    param(
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
      $endpoint = 'db_snapshots'
    }

    process {
        $endpointURI = $endpoint + '/' + $id

        $result = Invoke-FLEXRestCall -API v1 -endpoint $endpointURI -method DELETE -APIPrefix ocie -flexContext $flexContext 

        return $result
    }
}
