function New-FLEXEchoDBSnapShot {
    param(
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter()]
        [string] $hostID,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        $endpoint = 'db_snapshots'
    }

    process {
        $o = New-Object psobject
        $o | Add-Member -MemberType NoteProperty -Name 'database_ids' -Value @($id)
        $o | Add-Member -MemberType NoteProperty -Name 'source_host_id' -Value $hostID
        $o | Add-Member -MemberType NoteProperty -Name 'destinations' -Value @()

        $results = Invoke-FLEXRestCall -API v1 -APIPrefix ocie -endpoint $endpoint -method POST -body $o -flexContext $flexContext 
        return $results
    }

}
<#
api/ocie/v1/db_snapshots

{
  "database_ids": [
    "5"
  ],
  "source_host_id": "echo01",
  "destinations": []
}

#>
