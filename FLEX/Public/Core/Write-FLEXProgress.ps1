function Write-FLEXProgress {
    param(
        [parameter()]
        [string] $taskId,
        [parameter()]
        [string] $message,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    $functionName = $MyInvocation.MyCommand.Name
    Write-Verbose "-> $functionName"

    if ($taskId) {
        $flexTask = Get-FLEXTask -taskID $taskId
        if ($flexTask.state -eq "running") {
            $progress = $flexTask.progress_pct
            $taskMessage = $flexTask.type
        } else {
            $progress = 100
        }
        
    } else {
        $tasks = (Get-FLEXTask -flexContext $flexContext | Where-Object {$_.state -eq "running"} | Sort-Object progress_pct)
        if ($tasks) {
            $progress = $tasks[0].progress_pct
            $taskMessage = $tasks[0].type
        } else {
            $progress = 100
        }
    }
    
    while ($progress -lt 100) {
        if ($message) {
            $activity = $message
        } else {
            $activity = $taskMessage
        }
        
        Write-Progress -Activity $activity -PercentComplete $progress
        if ($taskId) {
            $flexTask = Get-FLEXTask -taskID $taskId
            if ($flexTask.state -eq "running") {
                $progress = $flexTask.progress_pct
            } else {
                $progress = 100
            }
        } else {
            $tasks = (Get-FLEXTask -flexContext $flexContext | Where-Object {$_.state -eq "running"} | Sort-Object progress_pct)
            if ($tasks) {
                $progress = $tasks[0].progress_pct
            } else {
                $progress = 100
            }
        }
        start-sleep 3
    }

    Write-Progress -Activity $activity -Completed
}

