function Write-FLEXProgress {
    param(
        [parameter()]
        [string] $taskId,
        [parameter()]
        [string] $message = "Please wait..."
    )

    
    if ($taskId) {
        $progress = (Get-FLEXTask | Where-Object {$_.ref_id -eq $taskId})._obj.progress_pct
    } else {
        $tasks = (Get-FLEXTask | Where-Object {$_.state -eq "running"} | Sort-Object progress_pct)
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
            $progress = (Get-FLEXTask | Where-Object {$_.ref_id -eq $taskId})._obj.progress_pct
        } else {
            $tasks = (Get-FLEXTask | Where-Object {$_.state -eq "running"} | Sort-Object progress_pct)
            if ($tasks) {
                $progress = $tasks[0].progress_pct
            } else {
                $progress = 100
            }
        }
        start-sleep 3
    }
}

