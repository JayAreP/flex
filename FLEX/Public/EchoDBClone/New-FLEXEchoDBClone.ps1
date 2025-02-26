function New-FLEXEchoDBClone {
    param(
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter()]
        [string] $hostID,
        [parameter()]
        [array] $DestinationHostID,
        [parameter()]
        [string] $DestinationDatabaseName,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        $endpoint = 'clone'
    }

    process {

        $dbInfo = Get-FLexEchoDB -id $id -flexContext $flexContext

        if (!$DestinationDatabaseName) {
            $DestinationDatabaseName = $dbInfo.name
        }

        $destinationArray = @()

        foreach ($h in $DestinationHostID) {
            <#
            Maybe need to do the following:

            $destinationID = New-FLEXEchoDBID -flexContext $flexContext
            #>

            $destinationID = $id # placeholder

            $destination = New-Object psobject
            $destination | Add-Member -MemberType NoteProperty -Name host_id -Value $h
            $destination | Add-Member -MemberType NoteProperty -Name db_id -Value $destinationID # check this id formulation
            $destination | Add-Member -MemberType NoteProperty -Name db_name -Value $DestinationDatabaseName

            $destinationArray += $destination
        }

        $o = New-Object psobject
        $o | Add-Member -MemberType NoteProperty -Name 'database_ids' -Value @($id)
        $o | Add-Member -MemberType NoteProperty -Name 'destinations' -Value $destinationArray
        $o | Add-Member -MemberType NoteProperty -Name 'source_host_id' -Value $hostID

        $results = Invoke-FLEXRestCall -API v1 -APIPrefix ocie -endpoint $endpoint -method POST -body $o -flexContext $flexContext 
        return $results
    }

}


<#
https://4.227.137.180/api/ocie/v1/clone

{
  "database_ids": [
    "7"
  ],
  "destinations": [
    {
      "host_id": "echo02",
      "db_id": "7",
      "db_name": "AdventureWorks03"
    }
  ],
  "source_host_id": "echo01"
}


{
  "database_ids": [
    "6"
  ],
  "source_host_id": "echo01",
  "destinations": [
    {
      "host_id": "echo02",
      "db_id": "6",
      "db_name": "testdb01"
    }
  ]
}

#>