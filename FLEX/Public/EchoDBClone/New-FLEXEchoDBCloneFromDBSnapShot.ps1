function New-FLEXEchoDBCloneFromDBSnapShot {
    param(
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string] $snapshotId,
        [parameter(Mandatory)]
        [string] $DestinationHostID,
        [parameter()]
        [string] $DestinationDBSuffix,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
      $endpoint = "db_snapshots/{0}/clone" -f $snapshotId
      $destinationArray = @()
    }

    process {
      $dbInfo = Get-FLexEchoDB -flexContext $flexContext | Where-Object -FilterScript {$_.db_snapshots.id -eq $snapshotId}

      [string] $DestinationDatabaseName = $dbInfo.name

      if ($DestinationDBSuffix) {
        $DestinationDatabaseName = "{0}{1}" -f $dbInfo.name, $DestinationDBSuffix
      }

      $destination = New-Object psobject
      $destination | Add-Member -MemberType NoteProperty -Name host_id -Value $DestinationHostID
      $destination | Add-Member -MemberType NoteProperty -Name db_id -Value $dbInfo.id # check this id formulation
      $destination | Add-Member -MemberType NoteProperty -Name db_name -Value $DestinationDatabaseName

      $destinationArray += $destination

    }

    end {
      $o = New-Object psobject
      $o | Add-Member -MemberType NoteProperty -Name 'destinations' -Value $destinationArray
      $o | Add-Member -MemberType NoteProperty -Name 'db_snapshot_id' -Value $snapshotId

      $results = Invoke-FLEXRestCall -API v1 -APIPrefix ocie -endpoint $endpoint -method POST -body $o -flexContext $flexContext
      return $results
    }
}

