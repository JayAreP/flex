function Write-FLEXProgress {
    param(
        [parameter(Mandatory)]
        [string] $taskId,
        [parameter()]
        [string] $message = "Please wait..."
    )

    $progress = (Get-FLEXTask | Where-Object {$_.ref_id -eq $taskId})._obj.progress_pct

    while ($progress -lt 100) {
        $activity = $message
        Write-Progress -Activity $activity -PercentComplete $progress
        $progress = (Get-FLEXTask | Where-Object {$_.ref_id -eq $taskId})._obj.progress_pct
        start-sleep 3
    }
}

