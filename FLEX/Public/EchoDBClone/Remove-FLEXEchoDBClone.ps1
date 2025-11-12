function Remove-FLEXEchoDBClone {
    param(
        [parameter(Mandatory)]
        [string] $hostID,
        [parameter(Mandatory)]
        [string] $id,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        $endpoint = 'clone'
    }

    process {

        $FLEXEchoDB = Get-FLEXEchoHostDB -hostID $hostID -flexContext $flexContext | ? id -eq $id

        $o = New-Object psobject
        $o | Add-Member -MemberType NoteProperty -Name 'host_id' -Value $hostID
        $o | Add-Member -MemberType NoteProperty -Name 'database_id' -Value $id

        $result = invoke-flEXRestCall -API v1 -APIPrefix ocie -endpoint $endpoint -method DELETE -body $o -flexContext $flexContext

        return $result
    }

}

