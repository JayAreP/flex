function New-FLEXEchoHost {
    param(
        [parameter(Mandatory)]
        [string] $hostID,
        [parameter(Mandatory)]
        [ValidateSet('mssql', IgnoreCase = $false)]
        [string] $DBVendor,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    $o = New-Object psobject
    $o | Add-Member -MemberType NoteProperty -Name 'host_id' -Value $hostID
    $o | Add-Member -MemberType NoteProperty -Name 'db_vendor' -Value $DBVendor

    $endpoint = 'hosts/' + $hostID

    $results = Invoke-FLEXRestCall -API v1 -APIPrefix hostess -endpoint $endpoint -method PUT -body $o -flexContext $flexContext

    return $results

}

