function Get-FLEXEchoDBSnapShot {
    param(
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )
    
    begin {
    }
    
    process {
        $echoDB = Get-FLexEchoDB -id $id -flexContext $flexContext
        return $echoDB.db_snapshots
    }
}