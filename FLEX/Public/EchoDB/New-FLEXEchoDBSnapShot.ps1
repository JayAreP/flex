function New-FLEXEchoDBSnapShot {
    param(
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [array] $id,
        [parameter()]
        [string] $hostID,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
      $idArray = @()
      $endpoint = 'db_snapshots'
    }

    process {
      $idArray += $id
    }

    end {
      $o = New-Object psobject
      $o | Add-Member -MemberType NoteProperty -Name 'database_ids' -Value @($idArray)
      $o | Add-Member -MemberType NoteProperty -Name 'source_host_id' -Value $hostID
      $o | Add-Member -MemberType NoteProperty -Name 'destinations' -Value @()
      $results = Invoke-FLEXRestCall -API v1 -APIPrefix ocie -endpoint $endpoint -method POST -body $o -flexContext $flexContext 
      return $results
    }
}

