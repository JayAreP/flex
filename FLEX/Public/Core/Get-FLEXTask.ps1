function Get-FLEXTask {
    param(
        [parameter(ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter()]
        [switch] $steps,
        [parameter()]
        [switch] $latest,
        [parameter()]
        [switch] $inProgress,
        [parameter()]
        [string] $taskID,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        $endpoint = 'task4d'
        $API = 'v2'
    }

    process {
        if ($taskID) {
            $endpoint = $endpoint + '/' + $taskID
        }
    
        $results = Invoke-FLEXRestCall -method GET -API $api -endpoint $endpoint -flexContext $flexContext

        # Parsing this kinda stupid considering I could have written a class for this much more easily. Will do just that later. 

        $resultArray = @()
        if ($results.hits) {
            foreach ($r in $results.hits) {
                $o = New-Object psobject
                $o | Add-Member -MemberType NoteProperty -Name "taskid" -Value $r.id
                $propArray = ($r.obj | Get-Member -MemberType NoteProperty).name
                foreach ($n in $propArray) {
                    $o | Add-Member -MemberType NoteProperty -Name $n -Value $r.obj.$n
                }
                $resultArray += $o
            }
        } else {
            $r = $results
            $o = New-Object psobject
            $o | Add-Member -MemberType NoteProperty -Name "taskid" -Value $r.id
            $propArray = ($r.obj | Get-Member -MemberType NoteProperty).name
            foreach ($n in $propArray) {
                $o | Add-Member -MemberType NoteProperty -Name $n -Value $r.obj.$n
            }
            $resultArray += $o
        }

        $results = $resultArray | Sort-Object update_ts_millis

        if ($inProgress) {
            $results = $results | Where-Object {$_.state -eq 'running'}
        }
    
        if ($id) {
            $results = $results | Where-Object {$_.plot.node_id -eq $id}
        }
        
        if ($steps) {
            $results = $results.steps
        }

        if ($latest) {
            return $results[-1]
        } else {
            return $results
        }
    }
}