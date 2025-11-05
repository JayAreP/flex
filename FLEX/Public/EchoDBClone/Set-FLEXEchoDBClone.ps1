function Set-FLEXEchoDBClone {
    param(
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string] $echoDatabaseName,
        [parameter(Mandatory)]
        [string] $snapshotId,
        [parameter(Mandatory)]
        [string] $hostID,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
      $endpoint = "hosts/{0}/databases/_replace" -f $hostID
      $dbNamesArray = @()
    }

    process {
      $dbNamesArray += $echoDatabaseName
    }

    end {
      $o = New-Object psobject
      $o | Add-Member -MemberType NoteProperty -Name 'db_names' -Value @($dbNamesArray)
      $o | Add-Member -MemberType NoteProperty -Name 'keep_backup' -Value $false
      $o | Add-Member -MemberType NoteProperty -Name 'snapshot_id' -Value $snapshotId

      $results = Invoke-FLEXRestCall -API v1 -APIPrefix ocie -endpoint $endpoint -method POST -body $o -flexContext $flexContext
      return $results
    }
}

