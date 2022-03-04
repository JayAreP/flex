function Get-FLEXTaskLog {
    param(
        [parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string] $taskID,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        $api = 'v1'
    }

    Process {
        $endpoint = 'tasks/' + $taskID + '/logs'
        $results = Invoke-FLEXRestCall -method GET -API $api -endpoint $endpoint 
        return $results
    }
}