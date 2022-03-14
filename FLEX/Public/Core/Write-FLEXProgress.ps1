function Write-FLEXProgress {
    param(
        [parameter()]
        [string] $taskId,
        [parameter()]
        [string] $message = "Please wait...",
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    
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
    

    while ($progress -lt 100) {
        $activity = $message
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
}

