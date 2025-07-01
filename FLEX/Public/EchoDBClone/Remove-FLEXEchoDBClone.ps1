function Remove-FLEXEchoDBClone {
    param(
        [parameter(Mandatory)]
        [string] $hostID,
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        $endpoint = 'clone'
    }

    process {

        $FLEXEchoDBs = GET-FLEXEchoDBClone -id $id -flexContext $flexContext

        $o = New-Object psobject
        $o | Add-Member -MemberType NoteProperty -Name 'host_id' -Value $hostID
        $o | Add-Member -MemberType NoteProperty -Name 'database_id' -Value $FLEXEchoDBs.id

        $result = invoke-flEXRestCall -API v1 -APIPrefix ocie -endpoint $endpoint -method DELETE -body $o -flexContext $flexContext

        return $result
    }

}

