function GET-FLEXEchoDBClone {
    param(
        [parameter()]
        [string] $name,
        [parameter()]
        [string] $id,
        [parameter()]
        [string] $sourceHostID,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    $FLEXEchoDBs = Get-FLexEchoDB -flexContext $flexContext | Where-Object {$_.parent}

    if ($name) {
        $FLEXEchoDBs = $FLEXEchoDBs | Where-Object {$_.name -eq $name}
    } 
    
    if ($id) {
        $FLEXEchoDBs = $FLEXEchoDBs | Where-Object {$_.id -eq $id}
    } 
    
    if ($sourceHostID) {
        $FLEXEchoDBs = $FLEXEchoDBs | Where-Object {$_.parent.src_host_id -eq $sourceHostID}
    }

    return $FLEXEchoDBs
}