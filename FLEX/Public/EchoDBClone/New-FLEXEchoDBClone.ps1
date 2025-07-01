function New-FLEXEchoDBClone {
    param(
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter(Mandatory)]
        [string] $hostID,
        [parameter(Mandatory)]
        [string] $DestinationHostID,
        [parameter()]
        [string] $DestinationDBSuffix,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
      $endpoint = 'clone'
      $idArray = @()
      $destinationArray = @()
    }

    process {
      $idArray += $id

      $dbInfo = Get-FLexEchoDB -id $id -flexContext $flexContext

      [string] $DestinationDatabaseName = $dbInfo.name

      if ($DestinationDBSuffix) {
        [string] $DestinationDatabaseName = $DestinationDatabaseName + $DestinationDBSuffix
      }

      $destinationID = $id # placeholder

      $destination = New-Object psobject
      $destination | Add-Member -MemberType NoteProperty -Name host_id -Value $DestinationHostID
      $destination | Add-Member -MemberType NoteProperty -Name db_id -Value $destinationID # check this id formulation
      $destination | Add-Member -MemberType NoteProperty -Name db_name -Value $DestinationDatabaseName

      $destinationArray += $destination
    
    } 

    end {
      $o = New-Object psobject
      $o | Add-Member -MemberType NoteProperty -Name 'database_ids' -Value @($idArray)
      $o | Add-Member -MemberType NoteProperty -Name 'destinations' -Value $destinationArray
      $o | Add-Member -MemberType NoteProperty -Name 'source_host_id' -Value $hostID

      $results = Invoke-FLEXRestCall -API v1 -APIPrefix ocie -endpoint $endpoint -method POST -body $o -flexContext $flexContext 
      return $results
    }
}

