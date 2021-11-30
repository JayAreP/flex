function Get-FLEXTask {
    param(
        [parameter(ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter()]
        [switch] $steps,
        [parameter()]
        [string] $taskID
    )

    begin {
        $endpoint = 'tasks'
        $API = 'v1'
    }

    process {
        if ($taskID) {
            $endpoint = $endpoint + '/' + $taskID
        }
    
        $results = Invoke-FLEXRestCall -method GET -API $api -endpoint $endpoint
        $results = $results.hits._obj
    
        if ($id) {
            $results = $results | Where-Object {$_.plot.node_id -eq $id}
        }
        
        if ($steps) {
            $results = $results.steps
        }

        $results = $results | Sort-Object update_ts_millis
        
        return $results
    }
}